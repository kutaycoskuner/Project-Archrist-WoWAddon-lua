------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'CRIndicator';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local inquiryCD = true
local closestAvailable = 0
local isFrameVisible = false
local spells = Arch_spells
local classColors = Arch_classColors
--
local frameOpen = false
local frameRecursive = false
--
local raidPeople
Arch_raidPeople = {}
Arch_trackSpells = {"Rebirth","Innervate","Misdirection"}

-- ==== GUI
local frame = CreateFrame("frame", "MyAddonFrame")
local frameHeight = 50
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    --   edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", 
    tile = 1,
    tileSize = 20,
    edgeSize = 0,
    insets = {
        left = -6,
        right = -6,
        top = 12,
        bottom = 12
    }
})
frame:SetSize(150, frameHeight) -- 180 50
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
frame:SetFrameStrata("FULLSCREEN")
--
-- :: Acilis ekrani koy
local frameTextName = frame:CreateFontString(nil, "ARTWORK")
frameTextName:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
frameTextName:SetPoint("CENTER", 0, 0)
frameTextName:SetText("|cff464646Combat Res Frame|r")

-- -- :: subframe ekleme
-- local tab = 0
-- for ii = 1, 1 do
--     local subFrame = CreateFrame("frame", "subFrame", frame)
--     subFrame:ClearAllPoints()
--     subFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, tab)
--     subFrame:SetSize(180, 50)
--     subFrame:SetFrameStrata("FULLSCREEN_DIALOG")
--     --
--     local frameTextName = subFrame:CreateFontString(nil, "ARTWORK")
--     frameTextName:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
--     frameTextName:SetPoint("LEFT")
--     frameTextName:SetText("Combat Res Frame")
--     --
--     local frameTextCD = subFrame:CreateFontString(nil, "ARTWORK")
--     frameTextCD:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
--     frameTextCD:SetPoint("RIGHT")
--     frameTextCD:SetText("Ready\n")
--     --
--     tab = tab - 16
--     frameHeight = frameHeight + 12

-- end
-- --
-- :: Frame i yerlestir ve sakla
frame:SetSize(174, frameHeight)
frame:SetPoint("CENTER", 536, 200)
frame:Hide()

-- ==== Methods
local function getSpellCooldown(spellName)
    if spells[spellName] then
        return spells[spellName][2]
    end
end

local function getIndicator()
    Arch_raidPeople = raidPeople
    local players = ''
    local color = '|cffFF7D0A'
    local cooldown = '|cff464646'
    local endtext = '|r'
    --
    for ii = 1, #raidPeople do
        color = classColors[raidPeople[ii].class] or '|cff464646'
        local add = ''
        if not raidPeople[ii].spell or not raidPeople[ii].alive then
            add = '' -- cooldown .. raidPeople[ii].name .. endtext .. ' '
        else
            add = color .. raidPeople[ii].name .. endtext .. ' '
        end
        players = players .. add
        -- combatResser = players
        --
        if ii == 3 then
            break
        end
    end
    -- :: GUIye gonder
    Arch_setGUI('raidCooldowns', true)
    -- if UnitInRaid('player') then
    --     frame:Show()
    -- else
    --     frame:Hide()
    -- end
    -- --
    -- if players == '' then
    --     frameTextName:SetText("|cff464646Combat Res Frame|r")
    -- elseif players ~= nil then
    --     frameTextName:SetText(players)
    -- end
end

local function scanGroup()
    if raidPeople == nil then
        raidPeople = A.global.raidCds
    end
    --
    if not UnitInRaid('player') then
        raidPeople = {}
        -- return
    end
    -- test 
    if not UnitInRaid('player') and #raidPeople < 1 then
        table.insert(raidPeople, {
            name = UnitName('player'),
            class = UnitClass('player'),
            availableAt = GetTime(),
            spell = true,
            alive = true
        })
    end
    --
    if UnitInRaid('player') or GetNumPartyMembers() >= 1 then
        for ii = 1, #raidPeople do
            if raidPeople[ii].name == UnitName('player') and UnitClass('player') ~= 'Druid' then
                table.remove(raidPeople, ii)
                break
            end
        end
    end
    -- test end
    --
    if UnitInRaid('player') then
        local isExists = false
        for ii = 1, GetNumRaidMembers() do
            local druidName, rank, subgroup, level, vclass = GetRaidRosterInfo(ii)
            if vclass == 'Druid' then
                for yy = 1, #raidPeople do
                    if raidPeople[yy].name == druidName then
                        isExists = true
                        break
                    end
                end
                --
                if isExists == false then
                    table.insert(raidPeople, {
                        name = druidName,
                        class = vclass,
                        availableAt = GetTime(),
                        spell = true,
                        alive = true
                    })
                end
                isExists = false
            end
        end
        -- :: Artik raidde olmayanlari cikar
        for ii = 1, #raidPeople do
            local stillIn = false
            for yy = 1, GetNumRaidMembers() do
                local druidName = GetRaidRosterInfo(yy)
                if raidPeople[ii].name then
                    if druidName == raidPeople[ii].name then
                        stillIn = true
                    end
                end
            end
            if not stillIn then
                table.remove(raidPeople, ii)
            end
        end
    end
    --
    A.global.raidCds = raidPeople
    getIndicator()
end

local function handleCommand(msg)
    if UnitName('target') and (UnitAffectingCombat("player") or UnitIsDeadOrGhost('player')) then
        --
        if msg ~= '' then
            if raidPeople[tonumber(msg)] then
                if raidPeople[tonumber(msg)].spell and raidPeople[ii].alive then
                    SendChatMessage(
                        '{triangle} ' .. raidPeople[tonumber(msg)].name .. ' combat res ' .. UnitName('target') ..
                            ' {triangle}', "raid_warning", nil, nil)
                    -- SELECTED_CHAT_FRAME:AddMessage(
                    --     '{triangle} ' .. raidPeople[tonumber(msg)].name ..
                    --         ' combat res ' .. UnitName('target') ..
                    --         ' {triangle}')
                    return
                end
            end
        end
        --
        for ii = 1, #raidPeople do
            if raidPeople[ii].spell and raidPeople[ii].alive then
                SendChatMessage('{triangle} ' .. raidPeople[ii].name .. ' combat res ' .. UnitName('target') ..
                                    ' {triangle}', "raid_warning", nil, nil)
                break
            end
        end
        --
    else
        if msg == '' then
            if isFrameVisible then
                frame:Hide()
            else
                frame:Show()
            end
            isFrameVisible = not isFrameVisible
        elseif msg == 'lock' then
            frame:SetMovable(false)
            frame:EnableMouse(false)
        elseif msg == 'move' then
            frame:SetMovable(true)
            frame:EnableMouse(true)
        elseif msg == 'scan' then
            scanGroup()
        end
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
    -- local start, duration, enabled = GetSpellCooldown(spell)
    -- print(srcName .. ' ' .. spell)
    -- start, duration, enabled = GetSpellCooldown(30823)
    -- print(start .. ' ' .. duration ..' ' .. enabled )
    for ii = 1, #raidPeople do
        if raidPeople[ii].name == srcName then
            raidPeople[ii].spell = false
            raidPeople[ii].availableAt = (GetTime() + getSpellCooldown(spellName)) -- saniye olarak ekle
            -- saniye olarak ekle
            -- saniye olarak ekle
            -- saniye olarak ekle
            -- saniye olarak ekle
            -- saniye olarak ekle
            setClosestAvailable()
        end
    end
    getIndicator()
end

local function removeBear(srcName)
    for ii = 1, #raidPeople do
        if srcName == raidPeople[ii].name then
            table.remove(raidPeople, ii)
        end
    end
    getIndicator()
end

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
    getIndicator()
end

-- ==== Start
function module:Initialize()
    self.initialized = true
    if A.global.raidCds == nil then
        raidPeople, A.global.raidCds = {}, {}
    end
    if not UnitInRaid('player') then
        raidPeople, A.global.raidCds = {}, {}
    end
    -- toggleGUI()
    scanGroup()

    -- :: Register some events
    -- module:RegisterEvent("PLAYER_REGEN_DISABLED")
    -- module:RegisterEvent("PLAYER_REGEN_ENABLED")
    module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --
    module:RegisterEvent("PARTY_MEMBERS_CHANGED")
    module:RegisterEvent("RAID_ROSTER_UPDATE")
    module:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
    module:RegisterEvent("PLAYER_ENTERING_WORLD")
    module:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
end

-- ==== Event Handlers
function module:COMBAT_LOG_EVENT_UNFILTERED(event, _, eventType, _, srcName, isDead, _, dstName, _, spellId, spellName,
    _, ...) -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    -- :: Print event names
    -- SELECTED_CHAT_FRAME:AddMessage(
    --     event .. ' | ' .. eventType .. ' | ' .. isDead .. ' | ' .. dstName)
    -- :: Raidde degilse rebirth listesini sifirliyor
    -- if not UnitInRaid('player') then raidPeople = {} getIndicator() return end
    -- :: Dead
    if eventType == "UNIT_DIED" then
        for ii = 1, #raidPeople do
            if dstName == raidPeople[ii].name then
                raidPeople[ii].alive = false
                getIndicator()
                break
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
    -- :: remove bear when you see mangle spell
    -- if spellName == "Mangle (Bear)" and eventType == "SPELL_AURA_APPLIED" then
    --     removeBear(srcName)
    -- end
    -- test shaman
    if spellName == "Lesser Healing Wave" and eventType == "SPELL_HEAL" then -- shaman lesser healing wave
        startCooldown(srcName, spellId, spellName)
    end
    -- test
    -- :: Checktime if some cd exists
    if inquiryCD then
        if closestAvailable <= GetTime() then
            endCooldown()
        end
    end
    -- getIndicator()
end

-- ==== Scan on group changes
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

-- ==== Slash Handlersd
SLASH_cr1 = "/cr"
SlashCmdList["cr"] = function(msg)
    handleCommand(msg)
end

-- -- ==== End
local function InitializeCallback()
    module:Initialize()
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