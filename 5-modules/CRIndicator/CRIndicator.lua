------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'CRIndicator';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local inquiryCD = true
local closestAvailable = 0
local spells = Arch_spells
local classColors = Arch_classColors
--
local isFrameOpen = false
local frameRecursive = false
--
local subFrame = {}
local subIconFrame = {}
local subFrameName = {}
local subFrameCD = {}
--
local raidPeople = {}
local rcFramePos
local rcFrameLock
local trackClass = {
    ["Druid"] = {false, {"Rebirth", "Innervate"}},
    ["Hunter"] = {false, {"Misdirection"}},
    ["Shaman"] = {false, {"Reincarnation"}},
    ["Warlock"] = {false, {"Soulstone Resurrection"}},
    -- --test
    -- ["Mage"] = {false, {"Cone of Cold"}},
    -- --test
}

--
local showIcons = true
local iconDimension = 8
local headerPosition = "CENTER"
local iconPaths = {
    -- :: Druid
    ["Innervate"] = "spell_nature_lightning",
    ["Rebirth"] = "spell_nature_reincarnation",
    -- :: Hunter
    ["Misdirection"] = "ability_hunter_misdirection",
    -- :: Shaman
    ["Reincarnation"] = "spell_nature_reincarnation",
    -- :: Warlock
    ["Soulstone Resurrection"] = "spell_shadow_soulgem",
    -- :: Mage
    ["Cone of Cold"] = "spell_frost_glacier",
}
--
local UpdateInterval = 0.8;
local timeSinceLastUpdate = 0;

-- ==== GUI
--
if showIcons then
    headerPosition = "LEFT"
end
--
local frame = CreateFrame("frame", nil, nil, 'BackdropTemplate')
local frameWidth = 120
local frameHeight = 12
local rowHeight = frameHeight
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
-- frame:SetTexture()
-- frame:SetBackdrop({
--     bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
--     --   edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", 
--     tile = 1,
--     tileSize = 20,
--     edgeSize = 0,
--     insets = {
--         left = -6,
--         right = -6,
--         top = 12,
--         bottom = 12
--     }
-- })
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
    A.global.rcFramePos = rcFramePos
end)
frame:SetFrameStrata("MEDIUM")
--
-- :: Acilis ekrani koy
local frameTextName = frame:CreateFontString(nil, "ARTWORK")
frameTextName:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
frameTextName:SetPoint("CENTER")
frameTextName:SetText("|cff464646Cooldown Tracker|r")

local function raidCooldowns_calcTime(time)
    local cd = time - GetTime()
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

-- -- :: subframe ekleme
local function updateGUI()
    local tab = 0
    local fH = frameHeight
    local lastSub = 0
    local headerCount = 0
    --
    for class, param in pairs(trackClass) do
        if param[1] ~= nil and param[1] then
            for yy = 1, #param[2] do
                headerCount = headerCount + 1
                lastSub = lastSub + 1
                if not subFrame[lastSub] then
                    subFrame[lastSub] = CreateFrame("frame", "subFrame", frame)
                end
                subFrame[lastSub]:ClearAllPoints()
                subFrame[lastSub]:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, tab)
                subFrame[lastSub]:SetSize(frameWidth, rowHeight)
                -- subFrame[lastSub]:SetFrameStrata("BACKGROUND")
                --
                if not subIconFrame[lastSub] and showIcons then
                    subIconFrame[lastSub] = CreateFrame("Frame", "potato", subFrame[lastSub])
                    -- :: Set Position
                    subIconFrame[lastSub]:ClearAllPoints()
                    subIconFrame[lastSub]:SetPoint("RIGHT", 0, 0)
                    -- :: Frame strata ("Background", "Low", "Medium", "High", "Dialog", "Fullscreen", "Fullscreen_Dialog", "Tooltip")
                    subIconFrame[lastSub]:SetFrameStrata("Medium")
                    -- :: Frame strata level (0 - 20)
                    subIconFrame[lastSub]:SetFrameLevel(0)
                    local texture = subIconFrame[lastSub]:CreateTexture("Texture", "Background")
                    texture:SetTexture('Interface\\ICONS\\' .. iconPaths[param[2][yy]])
                    texture:SetWidth(iconDimension)
                    texture:SetHeight(iconDimension)
                    texture:SetBlendMode("Disable")
                    texture:SetDrawLayer("Border", 0)
                    local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
                    subIconFrame[lastSub]:SetWidth(sqrt(2) * texture:GetWidth())
                    subIconFrame[lastSub]:SetHeight(sqrt(2) * texture:GetHeight())
                    texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy) -- Normal
                    -- Put the texture on the frame
                    texture:SetAllPoints(subIconFrame[lastSub])
                    subIconFrame[lastSub]:Show()
                end
                --
                if not subFrameName[lastSub] then
                    subFrameName[lastSub] = subFrame[lastSub]:CreateFontString(nil, "ARTWORK")
                    subFrameName[lastSub]:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
                end
                subFrameName[lastSub]:ClearAllPoints()
                subFrameName[lastSub]:SetPoint(headerPosition)
                subFrameName[lastSub]:SetText(param[2][yy])
                --
                if not subFrameCD[lastSub] then
                    subFrameCD[lastSub] = subFrame[lastSub]:CreateFontString(nil, "ARTWORK")
                    -- "Interface\\Icons\\INV_Misc_Rune_01"
                    subFrameCD[lastSub]:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
                    subFrameCD[lastSub]:SetPoint("RIGHT")
                end
                -- subFrameCD[lastSub]:SetTexture("Interface\\ICONS\\Spell_Nature_Reincarnation")
                subFrameCD[lastSub]:SetText("")
                --
                tab = tab - (rowHeight)
                fH = fH + (rowHeight)
                --
                -- print(#raidPeople)
                for ii = 1, #raidPeople do
                    -- print(tostring(raidPeople[ii].trackSpell) .. " " .. tostring(trackClass[kk][3][yy]))
                    if tostring(raidPeople[ii].trackSpell) == tostring(param[2][yy]) then
                        lastSub = lastSub + 1
                        if not subFrame[lastSub] then
                            subFrame[lastSub] = CreateFrame("frame", "subFrame", frame)
                        end
                        -- TextureBasics_CreateTexture(subIconFrame[lastSub], false)
                        subFrame[lastSub]:ClearAllPoints()
                        subFrame[lastSub]:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, tab)
                        subFrame[lastSub]:SetSize(frameWidth, rowHeight)
                        -- subFrame[lastSub]:SetFrameStrata("BACKGROUND")
                        --
                        if subIconFrame[lastSub] then
                            subIconFrame[lastSub]:Hide()
                        end
                        --
                        if not subFrameName[lastSub] then
                            subFrameName[lastSub] = subFrame[lastSub]:CreateFontString(nil, "ARTWORK")
                            subFrameName[lastSub]:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
                        end
                        subFrameName[lastSub]:ClearAllPoints()
                        subFrameName[lastSub]:SetPoint("LEFT")
                        subFrameName[lastSub]:SetText(classColors[raidPeople[ii].class] .. raidPeople[ii].name .. "|r")
                        --
                        if not subFrameCD[lastSub] then
                            subFrameCD[lastSub] = subFrame[lastSub]:CreateFontString(nil, "ARTWORK")
                            subFrameCD[lastSub]:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
                            subFrameCD[lastSub]:SetPoint("RIGHT")
                        end
                        if raidPeople[ii].alive then
                            subFrameCD[lastSub]:SetText(raidCooldowns_calcTime(raidPeople[ii].availableAt))
                        else
                            subFrameCD[lastSub]:SetText("|cffE32B04Dead|r")
                        end
                        --
                        tab = tab - 16
                        fH = fH + 16
                    end
                end
            end
        end
    end

    -- :: yeni frame icin yukseklik ayarla
    if fH == frameHeight then
        frameTextName:SetText("|cff464646Cooldown Tracker|r")
    else
        frameTextName:SetText("")
    end

    frame:SetSize(frameWidth, fH) -- 180 50

    -- :: Artik varolmayan isimleri temizle
    for ii = #raidPeople + headerCount + 1 or 1, #subFrame do
        subFrameName[ii]:SetText("")
        subFrameCD[ii]:SetText("")
    end
end

-- :: Frame i yerlestir ve sakla
frame:SetSize(frameWidth, frameHeight)
frame:Hide()

-- ==== Methods
local function getSpellCooldown(spellName)
    if spells[spellName] then
        return spells[spellName][2]
    end
end

local function deadCheck()
    for ii = 1, #raidPeople do
        if raidPeople[ii].alive == false then
            if not UnitIsDeadOrGhost(raidPeople[ii].name) then
                raidPeople[ii].alive = true
            end
        end
    end
end

local function scanGroup()
    if raidPeople == nil or raidPeople == {} then
        raidPeople = A.global.raidCds
    end
    -- :: not in raid
    if not (UnitInRaid('player') or UnitInParty('player')) then
        for class, param in pairs(trackClass) do
            if class ~= UnitClass('player') then
                param[1] = false
            end
        end
        if #raidPeople > 1 and raidPeople[1].name ~= UnitName('player') then
            raidPeople = {}
        end
        -- return
    end
    -- test 
    -- if not (UnitInRaid('player') or UnitInParty('player')) and #raidPeople < 1 then
    --     if raidPeople[1] == nil then
    --         for class, param in pairs(trackClass) do
    --             if UnitClass('player') == class then
    --                 param[1] = true
    --                 for ii = 1, #param[2] do
    --                     table.insert(raidPeople, {
    --                         name = UnitName('player'),
    --                         class = UnitClass('player'),
    --                         availableAt = GetTime(),
    --                         spell = true,
    --                         alive = true,
    --                         trackSpell = tostring(param[2][ii])
    --                     })
    --                 end
    --             end
    --         end
    --     end
    -- end
    -- test end

    if UnitInParty('player') or UnitInRaid('player') then
        local isExists = false
        for ii = 1, GetNumGroupMembers() do

            local druidName, rank, subgroup, level, vclass
            if UnitInRaid('party') then
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
            -- SELECTED_CHAT_FRAME:AddMessage(vclass)
            for class, param in pairs(trackClass) do
                if tostring(vclass) == tostring(class) then
                    param[1] = true
                    -- :: check if already exists to avoid duplicate
                    for kk = 1, #raidPeople do
                        if raidPeople[kk].name == druidName then
                            isExists = true
                            break
                        end
                    end
                    -- :: if not exists add
                    if isExists == false then
                        for kk = 1, #param[2] do
                            table.insert(raidPeople, {
                                name = druidName,
                                class = vclass,
                                availableAt = GetTime(),
                                spell = true,
                                alive = true,
                                trackSpell = tostring(param[2][kk])
                            })
                            -- SELECTED_CHAT_FRAME:AddMessage(#raidPeople)
                        end
                    end
                    isExists = false
                end
            end
            -- for class, parameters in pairs(trackClass) do
            -- end
        end

        -- :: Artik raidde olmayanlari cikar
        for ii = 1, #raidPeople do
            if UnitInRaid("player") or UnitInParty('player') then
                local stillIn = false
                for yy = 1, GetNumGroupMembers() do
                    local druidName
                    if UnitInRaid('player') then
                        druidName = GetRaidRosterInfo(yy)
                    else
                        do
                            return
                        end
                    end

                    if raidPeople[ii] then
                        if druidName == raidPeople[ii].name then
                            stillIn = true
                        end
                    end
                end
                if not stillIn then
                    if raidPeople[ii] then
                        local class = raidPeople[ii].class
                        local isAny = 0
                        table.remove(raidPeople, ii)
                        for yy = 1, #raidPeople do
                            if raidPeople[yy].class == class then
                                isAny = 1
                                break
                            end
                        end
                        if isAny == 0 then
                            -- trackClass[class][2] = false
                            trackClass[class][1] = false
                        end
                    end
                end
            end
        end
    end
    --
    A.global.raidCds = raidPeople
    deadCheck()
    updateGUI()
end

local function handleCommand(msg)
    -- if firstTimeOpen == 0 then
    --     firstTimeOpen = 1
    -- else
    --     firstTimeOpen = -1
    -- end
    -- :: Indikatoru ayarla
    -- print('jaaja')
    scanGroup()

    -- :: Announce
    if UnitName('target') and (UnitAffectingCombat("player") or UnitIsDeadOrGhost('player')) then

        if msg ~= '' then
            local que = tonumber(msg)
            local queCounter = 1
            for ii = 1, #raidPeople do
                if raidPeople[ii] then
                    if raidPeople[ii].spell and raidPeople[ii].alive and raidPeople[ii].trackSpell == "Rebirth" then
                        if queCounter == que then
                            if UnitName('target') then
                                SendChatMessage('{triangle} ' .. raidPeople[ii].name .. ' combat res ' ..
                                                    UnitName('target') .. ' {triangle}', "raid_warning", nil, nil)
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
        if isFrameOpen then
            frame:Hide()
        else
            frame:Show()
        end
        isFrameOpen = not isFrameOpen
    elseif msg == 'lock' then
        frame:SetMovable(not A.global.rcFrameLock)
        frame:EnableMouse(not A.global.rcFrameLock)
        A.global.rcFrameLock = not A.global.rcFrameLock
        --
        if not A.global.rcFrameLock then

        end
    elseif msg == 'move' then
        frame:SetMovable(true)
        frame:EnableMouse(true)
        A.global.rcFrameLock = true
    elseif msg == 'reset' then
        A.global.rcFramePos = {0, 0}
        rcFramePos = {0, 0}
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", rcFramePos[1], rcFramePos[2])
    elseif msg == 'scan' then
        scanGroup()
    end
end

-- :: sets closest cd arrival for cooldowned rebirth
local function setClosestAvailable()
    if #raidPeople > 1 then
        closestAvailable = raidPeople[1].availableAt
        for ii = 1, #raidPeople - 1 do
            if raidPeople[ii].availableAt <= raidPeople[ii + 1].availableAt then
                closestAvailable = raidPeople[ii + 1].availableAt
                -- print('closest return is ' .. closestAvailable)
            end
        end
    elseif #raidPeople == 1 then
        closestAvailable = raidPeople[1].availableAt
    else
        closestAvailable = 0
    end
    if closestAvailable > GetTime() then
        inquiryCD = true
        return
    end
    inquiryCD = false
    -- print('closest available is ' .. closestAvailable)
end

-- :: This function activates rebirth cooldown and turns rebirth availability false for given druid
local function startCooldown(srcName, spellID, spellName)
    for ii = 1, #raidPeople do
        if raidPeople[ii].name == srcName and raidPeople[ii].trackSpell == spellName then
            raidPeople[ii].spell = false
            raidPeople[ii].availableAt = (GetTime() + getSpellCooldown(spellName))
            setClosestAvailable()
        end
    end
    deadCheck()
end

-- local function removeBear(srcName)
--     for ii = 1, #raidPeople do
--         if srcName == raidPeople[ii].name then
--             table.remove(raidPeople, ii)
--         end
--     end
--     deadCheck()
-- end

-- :: controls with random combat logs if rebirth is available
local function endCooldown()
    if raidPeople == nil then
        raidPeople = A.global.raidCds
    end
    for ii = 1, #raidPeople do
        if raidPeople[ii].availableAt >= closestAvailable then
            raidPeople[ii].spell = true
            -- print(raidPeople[ii].name .. ' can use now')
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
function module:Initialize()
    self.initialized = true
    --
    if A.global.raidCds == nil then
        raidPeople = {}
        A.global.raidCds = {}
    end
    if A.global.rcFrameLock == nil then
        A.global.rcFrameLock = true
    else
        rcFrameLock = A.global.rcFrameLock
    end
    if A.global.rcFramePos == nil then
        A.global.rcFramePos = {"CENTER", "CENTER", 0, 0}
    end
    --
    rcFramePos = A.global.rcFramePos
    frame:ClearAllPoints()
    frame:SetPoint(rcFramePos[1], nil, rcFramePos[2], rcFramePos[3], rcFramePos[4])
    frame:SetMovable(rcFrameLock)
    frame:EnableMouse(rcFrameLock)
    --
    -- if rcFramePos[1] == 0 and rcFramePos[2] == 0 then
    --     frame:SetPoint("CENTER", rcFramePos[1], rcFramePos[2])
    -- end
    --
    if not UnitInRaid('player') then
        raidPeople = {}
        A.global.raidCds = {}
    end
    scanGroup()
end

-- ==== Event Handlers
-- function module:COMBAT_LOG_EVENT_UNFILTERED(timestamp, eventType, _, _, srcName, isDead, _, _, dstName, _, _, spellId, spellName,
--     _, ...) -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
function module:COMBAT_LOG_EVENT_UNFILTERED() -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = CombatLogGetCurrentEventInfo()
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
    -- if not UnitInRaid('player') then raidPeople = {} deadCheck() return end
    -- :: Dead
    if eventType == "UNIT_DIED" then
        for ii = 1, #raidPeople do
            if dstName == raidPeople[ii].name then
                raidPeople[ii].alive = false
                -- deadCheck()
            end
        end
    end
    -- :: Rebirth cast edilmis ise
    if spellName == "Rebirth" and eventType == "SPELL_RESURRECT" then -- 48477(rebirth)
        for ii = 1, #raidPeople do
            if dstName == raidPeople[ii].name then
                raidPeople[ii].alive = true
                break
            end
        end
        startCooldown(srcName, spellId, spellName)
    end
    -- :: Innervate
    if spellId == 29166 and eventType == "SPELL_CAST_SUCCESS" then
        for ii = 1, #raidPeople do
            if dstName == raidPeople[ii].name then
                raidPeople[ii].alive = true
                break
            end
        end
        startCooldown(srcName, spellId, spellName)
    end
    -- :: Hunter Misdirection
    if spellId == 34477 and eventType == "SPELL_CAST_SUCCESS" then
        for ii = 1, #raidPeople do
            if dstName == raidPeople[ii].name then
                raidPeople[ii].alive = true
                break
            end
        end
        startCooldown(srcName, spellId, spellName)
    end
    -- :: Soulstone Resurrection
    if spellId == 47883 then
        for ii = 1, #raidPeople do
            if dstName == raidPeople[ii].name then
                raidPeople[ii].alive = true
                break
            end
        end
        startCooldown(srcName, spellId, spellName)
    end

    -- test shaman
    -- if spellName == "Lesser Healing Wave" and eventType == "SPELL_HEAL" then -- shaman lesser healing wave
    --     startCooldown(srcName, spellId, spellName)
    -- end
    -- test shaman end

    -- test mage
    if spellName == "Cone of Cold" then -- shaman lesser healing wave
        -- print('stuff')
        startCooldown(srcName, spellId, spellName)
    end
    -- test mage end

    -- :: Checktime if some cd exists
    if inquiryCD then
        if closestAvailable <= GetTime() then
            endCooldown()
            deadCheck()
        end
    end
    -- deadCheck()
end

-- ==== Scan on group changes
function module:PLAYER_REGEN_ENABLED()
    scanGroup()
end
function module:PLAYER_REGEN_DISABLED()
    scanGroup()
end
function module:PARTY_MEMBERS_CHANGED()
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

-- ==== GUI Update
frame:SetScript("OnUpdate", function(_, elapsed)
    if isFrameOpen then
        timeSinceLastUpdate = timeSinceLastUpdate + elapsed;
        if (timeSinceLastUpdate > UpdateInterval) then

            timeSinceLastUpdate = 0;
            -- for ii = 1, #raidPeople do
            --     if not raidPeople[ii].spell then
            updateGUI()
            --         break
            --     end
            -- end

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
--     print('asdf')
-- end

-- -- ==== End
local function InitializeCallback()
    module:Initialize()
    -- :: Register some events
    module:RegisterEvent("PLAYER_REGEN_DISABLED")
    module:RegisterEvent("PLAYER_REGEN_ENABLED")
    module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --
    -- module:RegisterEvent("PARTY_MEMBERS_CHANGED")
    module:RegisterEvent("RAID_ROSTER_UPDATE")
    module:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
    module:RegisterEvent("PLAYER_ENTERING_WORLD")
    module:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[
    -->> Displays next combat resser on screen
    1- Loops through raidPeople in raid
    2- If druid used his rebirth within [cd] adds true false variable to them
    3- If cr is true for druid registers druid for display
    4- Checks for raid if is anyone dead display if its true 


    raidPeople = {
    name = UnitName('player'),
    class = UnitClass('player'),
    availableAt = GetTime(),
    spell = true,
    alive = true
})

]]
