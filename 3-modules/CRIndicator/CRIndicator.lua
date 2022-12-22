------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'CRIndicator', "Cooldown Tracker";
local moduleAlert = M .. moduleName2 .. ": |r";
local module = A:GetModule(moduleName1, true);
local aprint = Arch_print
local mprint = function(msg)
    print(moduleAlert .. msg)
end
if module == nil then
    return
end

-----------------------------------------------------------------------------------------------------------------------
--------- Notes
-----------------------------------------------------------------------------------------------------------------------

-- data structure ----------------------------------------------------------------------------------------------------------
--[[

    group > spells >
                    name,               -- unique identifier 
                    class,              -- color picker for visual identification
                    availableAt,        -- availability tracker
                    alive               -- if dead not available

]]

-- how to ---------------------------------------------------------------------------------------------------------------
--[[
    - to add new spells 
        - add spell to 2-data/data_spells
        - in here: add trackClass

    - add new spell
        - event icin yeni spell eklendiginde ayni spell in data_spells e de eklenmesi gerekiyor cooldowna erisemediginde buga giriyor
]]

-- todo ---------------------------------------------------------------------------------------------------------------
--[[


    ]]

-- use case -----------------------------------------------------------------------------------------------------------
--[[
    
        ]]

--------------------------------------------------------------------------------------------------------------------------     
-- ==== Variables
local inquiryCD = true
local closestAvailable = 0
local spells = Arch_spells
local classColors = Arch_classColors
--
local isFrameOpen
local isInit = true
local frameRecursive = false
--
local subFrame = {}
local subIconFrame = {}
local subFrameName = {}
local subFrameCD = {}
local guiFrames
--
local group = {}
local rcFramePos
local rcFrameLock = false
local trackClass = {
    ["Druid"] = {false, {"Innervate", "Rebirth"}},
    ["Hunter"] = {false, {"Misdirection"}},
    ["Shaman"] = {false, {"Reincarnation"}},
    ["Warlock"] = {false, {"Soulstone Resurrection"}}
    -- --test
    -- ["Mage"] = {false, {"Cone of Cold"}}
    -- --test
}

--
local UpdateInterval = 0.9;
local timeSinceLastUpdate = 0;

-- ==== GUI
--
if showIcons then
    headerPosition = "LEFT"
end
--
local frame = CreateFrame("frame", nil, UIParent, 'BackdropTemplate')
local frameWidth = 240
local frameHeight = 12
local fontSize = frameHeight
local rowHeight = frameHeight
local iconDimension = frameHeight
local rowSizeMultiplier = 1.5
--
local showIcons = false
local headerPosition = "CENTER"

local baseFrameText = "|cff464646 Cooldown Tracker |r"
--
local backdropInfo = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileEdge = true,
    tileSize = 1,
    edgeSize = 1,
    insets = {
        left = -4,
        right = -4,
        top = -4,
        bottom = -4
    }
}
frame:SetBackdrop(backdropInfo)
frame:SetBackdropColor(0, 0, 0, 0.8)
frame:SetBackdropBorderColor(0, 0, 0, 0)
frame:SetSize(frameWidth, frameHeight) -- 180 50
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local a, _, c, x, y = frame:GetPoint();
    rcFramePos = {a, c, x, y}
    A.global.gui.groupCooldown.position = rcFramePos
end)
frame:SetFrameStrata("MEDIUM")
--
-- :: Acilis ekrani koy
local frameTextName = frame:CreateFontString(nil, "ARTWORK")
frameTextName:SetFont("Fonts\\FRIZQT__.ttf", fontSize, "OUTLINE")
frameTextName:SetPoint("CENTER")
frameTextName:SetText(baseFrameText)

-- :: Frame i yerlestir ve sakla
frame:SetSize(frameWidth, frameHeight)
frame:Hide()

-- :: time color picker
local function raidCooldowns_calcTime(time)
    local cd = tonumber(time) - tonumber(GetTime())
    if cd > 1 then
        local min = math.floor(cd / 60)
        local sec = math.floor(cd % 60)
        --
        if 10 > sec then
            sec = "0" .. sec
        end
        if 10 > min then
            min = "0" .. min
        end
        --
        if tonumber(min) > 0 then
            return ("|cff999999" .. min .. ":" .. sec .. "|r")
        end
        if tonumber(sec) < 30 then
            return ("|cffe3d005" .. min .. ":" .. sec .. "|r")
        end
        if tonumber(min) < 1 then
            return ("|cff999999" .. min .. ":" .. sec .. "|r")
        end
        return (min .. ":" .. sec)
    else
        return "|cff08cf3dReady|r"
    end
end

-- :: subframe ekleme
local function updateGUI()
    local tab = 0
    local fH = frameHeight
    local headerCount = 0
    if guiFrames == nil then
        guiFrames = group
    end
    for spell in pairs(group) do
        headerCount = headerCount + 1
        --
        if group[spell] then
            if not subFrame[spell] then
                subFrame[spell] = CreateFrame("frame", spell .. "_subFrame", frame)
            end
            subFrame[spell]:ClearAllPoints()
            subFrame[spell]:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, tab)
            subFrame[spell]:SetSize(frameWidth, rowHeight)
            subFrame[spell]:SetFrameStrata("Medium")
            --
            if not subIconFrame[spell] and showIcons then
                subIconFrame[spell] = CreateFrame("Frame", spell .. "_icon", subFrame[spell])
                -- :: Set Position
                subIconFrame[spell]:ClearAllPoints()
                subIconFrame[spell]:SetPoint("RIGHT", 0, 0)
                -- :: Frame strata ("Background", "Low", "Medium", "High", "Dialog", "Fullscreen", "Fullscreen_Dialog", "Tooltip")
                subIconFrame[spell]:SetFrameStrata("Medium")
                -- :: Frame strata level (0 - 20)
                subIconFrame[spell]:SetFrameLevel(0)
                local texture = subIconFrame[spell]:CreateTexture("Texture", "Background")
                texture:SetTexture('Interface\\ICONS\\' .. spells[spell][4])
                texture:SetWidth(iconDimension)
                texture:SetHeight(iconDimension)
                texture:SetBlendMode("Disable")
                texture:SetDrawLayer("Border", 0)
                local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
                subIconFrame[spell]:SetWidth(sqrt(2) * texture:GetWidth())
                subIconFrame[spell]:SetHeight(sqrt(2) * texture:GetHeight())
                texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy) -- Normal
                -- Put the texture on the frame
                texture:SetAllPoints(subIconFrame[spell])
                subIconFrame[spell]:Show()
            end
            --
            if not subFrameName[spell] then
                subFrameName[spell] = subFrame[spell]:CreateFontString(nil, "ARTWORK")
                subFrameName[spell]:SetFont("Fonts\\FRIZQT__.ttf", fontSize, "OUTLINE")
            end
            -- :: spell name header yerlestirme
            subFrameName[spell]:ClearAllPoints()
            subFrameName[spell]:SetPoint(headerPosition)
            subFrameName[spell]:SetText(spell)
            -- :: cd yerlestirme
            if not subFrameCD[spell] then
                subFrameCD[spell] = subFrame[spell]:CreateFontString(nil, "ARTWORK")
                -- "Interface\\Icons\\INV_Misc_Rune_01"
                subFrameCD[spell]:SetFont("Fonts\\FRIZQT__.ttf", fontSize, "OUTLINE")
                subFrameCD[spell]:SetPoint("RIGHT")
            end
            --
            tab = tab - (rowHeight * rowSizeMultiplier)
            fH = fH + (rowHeight * rowSizeMultiplier)
            --
            -- :: spell e sahip kisileri yerlestirme
            for name in pairs(group[spell]) do
                if group[spell][name] then
                    local uniqueName = name .. spell
                    -- print(tostring(group[ii].trackSpell) .. " " .. tostring(trackClass[kk][3][yy]))
                    if not subFrame[uniqueName] then
                        subFrame[uniqueName] = CreateFrame("frame", uniqueName .. "subFrame", subFrame[spell])
                    end
                    -- TextureBasics_CreateTexture(subIconFrame[name], false)
                    subFrame[uniqueName]:ClearAllPoints()
                    subFrame[uniqueName]:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, tab)
                    subFrame[uniqueName]:SetSize(frameWidth, rowHeight)
                    -- subFrame[name]:SetFrameStrata("BACKGROUND")
                    --
                    if subIconFrame[uniqueName] then
                        subIconFrame[uniqueName]:Hide()
                    end
                    --
                    if not subFrameName[uniqueName] then
                        subFrameName[uniqueName] = subFrame[uniqueName]:CreateFontString(nil, "ARTWORK")
                        subFrameName[uniqueName]:SetFont("Fonts\\FRIZQT__.ttf", fontSize, "OUTLINE")
                    end
                    subFrameName[uniqueName]:ClearAllPoints()
                    subFrameName[uniqueName]:SetPoint("LEFT")
                    subFrameName[uniqueName]:SetText(classColors[group[spell][name].class] .. name .. "|r") -- classColors[group[spell][name].class]
                    --
                    if not subFrameCD[uniqueName] then
                        subFrameCD[uniqueName] = subFrame[uniqueName]:CreateFontString(nil, "ARTWORK")
                        subFrameCD[uniqueName]:SetFont("Fonts\\FRIZQT__.ttf", fontSize, "OUTLINE")
                        subFrameCD[uniqueName]:SetPoint("RIGHT")
                    end
                    if group[spell][name].alive then
                        subFrameCD[uniqueName]:SetText(raidCooldowns_calcTime(group[spell][name].availableAt))
                    else
                        subFrameCD[uniqueName]:SetText("|cffE32B04 Dead |r")
                    end
                    --
                    subFrameCD[uniqueName]:Show()
                    tab = tab - (rowHeight * rowSizeMultiplier)
                    fH = fH + (rowHeight * rowSizeMultiplier)
                end
            end
        end
    end

    -- :: Artik varolmayan isimleri temizle
    for spell in pairs(guiFrames) do
        -- :: kisi ismi
        for name in pairs(guiFrames[spell]) do
            local uniqueName = name .. spell
            if group[spell] == nil then
                -- :: kisi cdsi
                subFrameName[uniqueName]:SetText("")
                subFrameCD[uniqueName]:SetText("")
            else
                if group[spell][name] == nil then
                    -- :: kisi cdsi
                    subFrameName[uniqueName]:SetText("")
                    subFrameCD[uniqueName]:SetText("")
                end
            end
        end
        if group[spell] == nil or (not A.global.assist.groupCooldown.spells[spell]) then
            if subFrame[spell] then
                subFrameName[spell]:SetText("")
            end
        end

    end

    -- :: grupta kac spell var?
    local size = 0
    for keys in pairs(group) do
        size = size + 1
    end

    -- :: frame boyutu 1 den kucukse base e cek
    if size < 1 then
        fH = frameHeight
        frameTextName:SetText(baseFrameText)
    else
        frameTextName:SetText("")
        fH = fH - (((rowHeight * rowSizeMultiplier) / 2) * (3 / 2))
    end

    frame:SetSize(frameWidth, fH)
    -- :: bu gruptan cikarilan itemlari gui uzerinden silmek icin lazim. gu
    guiFrames = group
end

-- ==== Methods
local function getSpellCooldown(spellName)
    if spells[spellName] then
        return spells[spellName][2]
    end
end

local function deadCheck()
    for spell in pairs(group) do
        for name in pairs(group[spell]) do
            if group[spell][name].alive == false then
                if not UnitIsDeadOrGhost(name) then
                    group[spell][name].alive = true
                end
            end
        end
    end
end

local function addPerson(name, playerClass, spell)
    -- :: spell listede yoksa ekle
    if group[spell] == nil then
        group[spell] = {}
    end
    -- :: ismi yoksa ekle
    if group[spell][name] == nil or group[spell][name] == {} then
        group[spell][name] = {
            class = playerClass, -- :: class color icin
            isAvailable = true, -- :: kullanim musait mi
            availableAt = tonumber(GetTime()), -- :: ne zaman musait olacak
            alive = true
        }
        A.global.assist.groupCooldown.group = group
        return
    end
end

local function addSelfOnly()
    group = {}
    for class, skills in pairs(trackClass) do
        if UnitClass('player') == class then
            for ii = 1, #skills[2] do
                local spell = skills[2][ii]
                if spells[spell] then
                    local spellName = skills[2][ii]
                    local name = UnitName('player')
                    local class = UnitClass('player')
                    addPerson(name, class, spell)
                    return
                end
            end
        end
    end
end

local function scanGroup()
    if group == nil or group == {} then
        group = A.global.assist.groupCooldown.group
    end
    -- :: not in raid
    if not (UnitInRaid('player') or UnitInParty('player')) then
        addSelfOnly()
        -- :: gruptaysa
    else
        for ii = 1, GetNumGroupMembers() do

            local druidName, rank, subgroup, level, vclass
            if UnitInRaid('player') then
                druidName, _, _, level, vclass = GetRaidRosterInfo(ii)
            else
                druidName = UnitName('party' .. ii)
                level = UnitLevel('party' .. ii)
                vclass = UnitClass('party' .. ii)
                if druidName == nil then
                    druidName = UnitName('player')
                    level = UnitLevel('player')
                    vclass = UnitClass('player')
                end
            end
            for class, param in pairs(trackClass) do
                if tostring(vclass) == tostring(class) then
                    -- :: check if already exists to avoid duplicate
                    local isExists = false
                    for spell in pairs(group) do
                        for name in pairs(group[spell]) do
                            if name == druidName then
                                isExists = true
                                break
                            end
                        end
                        if isExists then
                            break
                        end
                    end
                    -- :: if not exists add
                    if isExists == false then
                        for kk = 1, #param[2] do
                            local spell = param[2][kk]
                            -- :: takip edilen spell mi
                            if A.global.assist.groupCooldown.spells[spell] then
                                addPerson(druidName, vclass, spell)
                            end
                        end
                    end
                    isExists = false
                end
            end
        end
    end

    -- :: Artik raidde olmayanlari cikar
    local stillIn = false
    for yy = 1, GetNumGroupMembers() do
        local druidName
        if UnitInRaid('player') then
            druidName = GetRaidRosterInfo(yy)
        elseif UnitInParty('player') then
            druidName = UnitName('party' .. yy)
        else
            druidName = UnitName('player')
        end
        -- :: var mi kontrol et
        for spell in pairs(group) do
            for name in pairs(group[spell]) do
                if name == druidName then
                    stillIn = true
                end
            end
        end
        -- :: yoksa adami bul cikar
        if not stillIn then
            for spell in pairs(group) do
                for name in pairs(group[spell]) do
                    if druidName == name then
                        group[spell][name] = nil
                    end
                end
            end
        end
    end
    -- :: spell deaktivasyon
    for spell in pairs(group) do
        if not A.global.assist.groupCooldown.spells[spell] then
            group[spell] = nil
        end
    end
    -- group["Misdirection"]["Soyut"] = false
    --
    A.global.assist.groupCooldown.group = group
    updateGUI()
end

local function handleCommand(msg)
    -- if firstTimeOpen == 0 then
    --     firstTimeOpen = 1
    -- else
    --     firstTimeOpen = -1
    -- end
    -- :: Indikatoru ayarla
    scanGroup()

    -- :: Announce
    if UnitName('target') and (UnitAffectingCombat("player") or UnitIsDeadOrGhost('player')) then

        if msg ~= '' then
            local que = tonumber(msg)
            local queCounter = 1
            for ii = 1, #group do
                if group[ii] then
                    if group[ii].spell and group[ii].alive and group[ii].trackSpell == "Rebirth" then
                        if queCounter == que then
                            if UnitName('target') then
                                SendChatMessage(
                                    '{triangle} ' .. group[ii].name .. ' combat res ' .. UnitName('target') ..
                                        ' {triangle}', "raid_warning", nil, nil)
                            else
                                SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "you don't have a target")
                            end
                            return
                        end
                        queCounter = queCounter + 1
                    end
                end
            end
        end
    end

    -- :: gui interactions
    if msg == '' then
        if not isInit and isFrameOpen then
            frame:Hide()
        else
            frame:Show()
        end
        if not isInit then
            isFrameOpen = not isFrameOpen
        else
            isInit = false
        end
        A.global.gui.groupCooldown.isOpen = isFrameOpen

    elseif msg == 'lock' then
        frame:SetMovable(false)
        frame:EnableMouse(false)
        A.global.gui.groupCooldown.frameLock = false

    elseif msg == 'move' then
        frame:SetMovable(true)
        frame:EnableMouse(true)
        A.global.gui.groupCooldown.frameLock = true

    elseif msg == 'reset' then
        A.global.gui.groupCooldown.position = {0, 0}
        rcFramePos = {0, 0}
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", rcFramePos[1], rcFramePos[2])
    elseif msg == 'scan' then
        A.global.assist.groupCooldown.spells["Cone of Cold"] = not A.global.assist.groupCooldown.spells["Cone of Cold"]
        print(moduleAlert .. "scanning the group")
        scanGroup()
    end
end

-- :: sets closest cd arrival for cooldowned rebirth
local function setClosestAvailable()
    if group ~= {} then
        closestAvailable = 0
        for spell in pairs(group) do
            for name in pairs(group[spell]) do
                if closestAvailable == 0 and group[spell][name].availableAt ~= nil then
                    closestAvailable = group[spell][name].availableAt
                elseif closestAvailable <= group[spell][name].availableAt and group[spell][name].availableAt ~= nil then
                    group[spell][name].availableAt = closestAvailable
                end
            end
        end
        --
        if closestAvailable > GetTime() then
            inquiryCD = true
            return
        end
    end
    inquiryCD = false
end

-- :: set dead
local function setAlive(playerName, state)
    for spell in pairs(group) do
        for name in pairs(group[spell]) do
            if name == playerName then
                group[spell][name].alive = state
            end
        end
    end
end

-- :: This function activates rebirth cooldown and turns rebirth availability false for given druid
local function startCooldown(srcName, spellID, spellName)
    for spell in pairs(group) do
        local break2 = false
        for name in pairs(group[spell]) do
            if name == srcName then
                if group[spell][name].isAvailable ~= nil then
                    group[spell][name].isAvailable = false
                end
                if group[spell][name].availableAt ~= nil then --and getSpellCooldown(spellName)
                    -- print(GetTime(), getSpellCooldown(spellName))
                    group[spell][name].availableAt = tonumber(GetTime()) + tonumber(getSpellCooldown(spellName))
                    -- print(group[spell][name].availableAt)
                else
                    aprint("cannot update interface")
                end
                break2 = true
                break
            end
        end
        if break2 then
            break
        end
    end
    setClosestAvailable()
end

-- :: disable for bear
-- local function removeBear(srcName)
--     for ii = 1, #group do
--         if srcName == group[ii].name then
--             table.remove(group, ii)
--         end
--     end
--     deadCheck()
-- end

-- :: controls with random combat logs if rebirth is available
local function endCooldown()
    if group == nil then
        group = A.global.assist.groupCooldown.group
    end
    for spell in pairs(group) do
        for name in pairs(group[spell]) do
            if group[spell][name].availableAt >= closestAvailable then
                group[spell][name].isAvailable = true
            end
        end
    end
    setClosestAvailable()
end

local function TextureBasics_CreateTexture(iconFrame, show)

    if show == true then
        iconFrame:Show()
    else
        iconFrame:Hide()
    end
end

-- ==== Start
function module:scanGroup()
    scanGroup()
end

function module:Initialize()
    self.initialized = true
    --
    if A.global.gui == nil then
        A.global.gui = {}
    end
    if A.global.gui.groupCooldown == nil then
        A.global.gui.groupCooldown = {}
    end
    -- :: initialize frame lock
    if A.global.gui.groupCooldown.frameLock == nil then
        A.global.gui.groupCooldown.frameLock = true
    else
        rcFrameLock = A.global.gui.groupCooldown.frameLock
    end
    -- :: initialize gui position
    if A.global.gui.groupCooldown.position == nil then
        A.global.gui.groupCooldown.position = {"CENTER", "CENTER", 0, 0}
    end
    -- :: initialize gui isOpen
    if A.global.gui.groupCooldown.isOpen == nil then
        A.global.gui.groupCooldown.isOpen = false
    end
    isFrameOpen = A.global.gui.groupCooldown.isOpen
    --
    if A.global.assist.groupCooldown.group == nil then
        group = {}
        A.global.assist.groupCooldown.group = {}
    end
    -- == skills
    if A.global.assist == nil then
        A.global.assist = {}
    end
    if A.global.assist.groupCooldown == nil then
        A.global.assist.groupCooldown = {}
    end
    if A.global.assist.groupCooldown.spells == nil then
        A.global.assist.groupCooldown.spells = {}
        --
    end
    for key in pairs(spells) do
        if A.global.assist.groupCooldown.spells[key] == nil then
            A.global.assist.groupCooldown.spells[key] = true
        end
    end

    --
    rcFramePos = A.global.gui.groupCooldown.position
    frame:ClearAllPoints()
    frame:SetPoint(rcFramePos[1], nil, rcFramePos[2], rcFramePos[3], rcFramePos[4])
    frame:SetMovable(rcFrameLock)
    frame:EnableMouse(rcFrameLock)
    if not UnitInRaid('player') or not UnitInParty('Party') then
        group = {}
        A.global.assist.groupCooldown.group = {}
    end
    if isFrameOpen then
        handleCommand('')
    else
        scanGroup()
    end
end

-- ==== Event Handlers
-- function module:COMBAT_LOG_EVENT_UNFILTERED(timestamp, eventType, _, _, srcName, isDead, _, _, dstName, _, _, spellId, spellName,
--     _, ...) -- https://wow.gamepedia.com/COMBAT_LOG_EVENT

function module:COMBAT_LOG_EVENT_UNFILTERED() -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 =
        CombatLogGetCurrentEventInfo()
    local timestamp, eventType, srcName, dstName, spellId, spellName = arg1, arg2, arg5, arg9, arg12, arg13
    -- :: Print event names
    -- print(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    -- print(timestamp, eventType, srcName, dstName, spellId, spellName)
    -- if eventType == nil then
    -- :: stop macro
    -- do
    --     return
    -- end
    -- end
    -- :: Raidde degilse rebirth listesini sifirliyor
    -- if not UnitInRaid('player') then group = {} deadCheck() return end
    -- :: Dead
    if eventType == "UNIT_RESURRECT" then
        setAlive(dstName, true)
    end
    -- print(arg2) --,arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13)
    -- if eventType == "UNIT_DIED" then
    -- setAlive(dstName, false)
    -- end
    -- :: Rebirth cast edilmis ise
    if spellName == "Rebirth" and eventType == "SPELL_RESURRECT" then -- 48477(rebirth)
        setAlive(dstName, true)
        startCooldown(srcName, spellId, spellName)
    end
    -- :: Innervate
    if spellName == "Innervate" and eventType == "SPELL_CAST_SUCCESS" then
        setAlive(dstName, true)
        startCooldown(srcName, spellId, spellName)
    end
    -- :: Hunter Misdirection
    if spellName == "Misdirection" and eventType == "SPELL_CAST_SUCCESS" then
        setAlive(dstName, true)
        startCooldown(srcName, spellId, spellName)
    end 
    -- :: Soulstone Resurrection
    if spellName == "Soulstone Resurrection" then
        setAlive(dstName, true)
        startCooldown(srcName, spellId, spellName)
    end

    -- test shaman
    -- if spellName == "Lesser Healing Wave" and eventType == "SPELL_HEAL" then -- shaman lesser healing wave
    --     startCooldown(srcName, spellId, spellName)
    -- end
    -- test shaman end

    -- test mage
    -- if spellName == "Cone of Cold" then -- shaman lesser healing wave
    --     -- todo: testten sonra scan group u cikar
    --     scanGroup()
    --     setAlive(srcName, true)
    --     startCooldown(srcName, spellId, spellName)
    -- end
    -- test mage end

    -- -- :: Checktime if some cd exists
    if inquiryCD then
        if closestAvailable <= GetTime() then
            endCooldown()
            deadCheck()
        end
    end
end

-- ==== Scan on group changes
function module:CHAT_MSG_SYSTEM(_, arg1)
    if string.find(arg1, "You leave the group") then
        scanGroup()
    elseif string.find(arg1, "leaves the") then
        scanGroup()
    elseif string.find(arg1, "joins the") then
        scanGroup()
    elseif string.find(arg1, "has been disbanded") then
        scanGroup()
    elseif string.find(arg1, "Party converted to Raid") then
        scanGroup()
    end
end
function module:PLAYER_REGEN_ENABLED()
    scanGroup()
end
function module:PLAYER_REGEN_DISABLED()
    scanGroup()
end
function module:PARTY_MEMBERS_CHANGED() -- bu calismiyor
    scanGroup()
end
function module:RAID_ROSTER_UPDATE()
    scanGroup()
end
function module:PLAYER_ENTERING_BATTLEGROUND()
    scanGroup()
end
function module:PLAYER_ENTERING_WORLD()
    scanGroup()
end
function module:PLAYER_DIFFICULTY_CHANGED()
    scanGroup()
end
function module:GROUP_JOINED()
    scanGroup()
end
function module:GROUP_LEFT()
    scanGroup()
end
function module:CHAT_MSG_BG_SYSTEM_NEUTRAL()
    scanGroup()
end

-- ==== GUI Update
frame:SetScript("OnUpdate", function(_, elapsed)
    if isFrameOpen then
        timeSinceLastUpdate = timeSinceLastUpdate + elapsed;
        if inquiryCD and (timeSinceLastUpdate > UpdateInterval) then
            timeSinceLastUpdate = 0;
            deadCheck()
            updateGUI()
        end
    end
end)

-- ==== Slash Handlersd
SLASH_cr1 = "/cr"
SlashCmdList["cr"] = function(msg)
    handleCommand(msg)
end

-- SLASH_app1 = "/app"
-- SlashCmdList["app"] = function(msg)
--     ('asdf')
-- end

-- -- ==== End
local function InitializeCallback()
    module:Initialize()
    -- :: Register some events
    module:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
    module:RegisterEvent("PLAYER_REGEN_DISABLED")
    module:RegisterEvent("PLAYER_REGEN_ENABLED")
    module:RegisterEvent("CHAT_MSG_SYSTEM")
    module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --
    -- module:RegisterEvent("PARTY_MEMBERS_CHANGED")
    module:RegisterEvent("RAID_ROSTER_UPDATE")
    module:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
    module:RegisterEvent("PLAYER_ENTERING_WORLD")
    module:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
    module:RegisterEvent("GROUP_JOINED")
    module:RegisterEvent("GROUP_LEFT")

end
A:RegisterModule(module:GetName(), InitializeCallback)
