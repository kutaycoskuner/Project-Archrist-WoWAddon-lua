------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'CRIndicator';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local people
local inquiryCD = true
local closestAvailable = 0
local isFrameVisible = false
local spellCooldown = Arch_spellCooldowns

-- -- ==== GUI
local f = CreateFrame("frame", "MyAddonFrame")
f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    --   edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", 
    tile = 1,
    tileSize = 32,
    edgeSize = 32,
    insets = {left = 11, right = 12, top = 12, bottom = 11}
})
f:SetSize(174, 52)
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", function(self) self:StartMoving() end)
f:SetScript("OnDragStart", function(self) self:StartMoving() end)
f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
f:SetFrameStrata("FULLSCREEN_DIALOG")
--
local frameText = f:CreateFontString(nil, "ARTWORK")
frameText:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE")
frameText:SetPoint("CENTER", 0, 0)
frameText:SetText("|cff464646Combat Res Frame|r")
--
f:SetPoint("CENTER", 536, 200)
f:Hide()

-- ==== Methods
local function getIndicator()
    local players = ''
    local dru = '|cffFF7D0A'
    local cooldown = '|cff464646'
    local endtext = '|r'
    --
    for ii = 1, #people do
        local add = ''
        if not people[ii].rebirth then
            add = '' -- cooldown .. people[ii].name .. endtext .. ' '
        else
            add = dru .. people[ii].name .. endtext .. ' '
        end
        players = players .. add
        --
        if ii == 3 then break end
    end
    --
    if UnitInRaid('player') then
        f:Show()
    else
        f:Hide()
    end
    --
    if players == '' then
        frameText:SetText("|cff464646Combat Res Frame|r")
    elseif  players  ~= nil then
        frameText:SetText(players)
    end
end

local function scanDruids()
    if people == nil then people = A.global.rebirth end
    --
    if not UnitInRaid('player') then
        people = {}
        -- return
    end
    -- test 
    if not UnitInRaid('player') and #people < 1 then
        table.insert(people, {
            name = UnitName('player'),
            availableAt = GetTime(),
            rebirth = true
        })
    end
    --
    if UnitInRaid('player') or GetNumPartyMembers() >= 1 then
        for ii = 1, #people do
            if people[ii].name == UnitName('player') and UnitClass('player') ~=
                'Druid' then
                table.remove(people, ii)
                break
            end
        end
    end
    -- test end
    --
    if UnitInRaid('player') then
        local isExists = false
        for ii = 1, GetNumRaidMembers() do
            local druidName, rank, subgroup, level, class =
                GetRaidRosterInfo(ii)
            if class == 'Druid' then
                for yy = 1, #people do
                    if people[yy].name == druidName then
                        isExists = true
                        break
                    end
                end
                --
                if isExists == false then
                    table.insert(people, {
                        name = druidName,
                        availableAt = GetTime(),
                        rebirth = true
                    })
                end
                isExists = false
            end
        end
    end
    --
    A.global.rebirth = people
    getIndicator()
end

local function handleCommand(msg)
    if msg == '' then
        if isFrameVisible then
            f:Hide()
        else
            f:Show()
        end
        isFrameVisible = not isFrameVisible
    elseif msg == 'lock' then
        f:SetMovable(false)
        f:EnableMouse(false)
    elseif msg == 'move' then
        f:SetMovable(true)
        f:EnableMouse(true)
    elseif msg == 'scan' then
        scanDruids()
    end
end

-- :: sets closest cd arrival for cooldowned rebirth
local function setClosestAvailable()
    if #people > 1 then
        closestAvailable = people[1].availableAt
        for ii = 1, #people - 1 do
            if people[ii].availableAt <= people[ii + 1].availableAt then
                closestAvailable = people[ii + 1].availableAt
                -- print('closest return is ' .. closestAvailable)
            end
        end
    elseif #people == 1 then
        closestAvailable = people[1].availableAt
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
local function startCooldown(srcName, spell)
    -- local start, duration, enabled = GetSpellCooldown(spell)
    -- print(srcName .. ' ' .. spell)
    -- start, duration, enabled = GetSpellCooldown(30823)
    -- print(start .. ' ' .. duration ..' ' .. enabled )
    for ii = 1, #people do
        if people[ii].name == srcName then
            people[ii].rebirth = false
            people[ii].availableAt = (GetTime() + spellCooldown(spell)) -- saniye olarak ekle
            setClosestAvailable()
        end
    end
    getIndicator()
end

-- :: controls with random combat logs if rebirth is available
local function endCooldown()
    if people == nil then people = A.global.rebirth end
    for ii = 1, #people do
        if people[ii].availableAt >= closestAvailable then
            people[ii].rebirth = true
            -- print(people[ii].name .. ' can use now')
        end
    end
    setClosestAvailable()
    getIndicator()
end

-- ==== Start
function module:Initialize()
    self.initialized = true
    if A.global.rebirth == nil then people, A.global.rebirth = {}, {} end
    if not UnitInRaid('player') then people, A.global.rebirth = {}, {} end
    scanDruids()
    -- :: Register some events
    module:RegisterEvent("COMBAT_LOG_EVENT")
    module:RegisterEvent("PARTY_MEMBERS_CHANGED")
end

-- ==== Event Handlers
function module:COMBAT_LOG_EVENT(event, _, eventType, _, srcName, _, _, dstName,
                                 _, spellId, spellName, _, ...) -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    -- print(event .. ' ' .. eventType .. ' ' .. srcName .. ' ' .. spellId)
    -- :: Raidde degilse rebirth listesini sifirliyor
    -- if not UnitInRaid('player') then people = {} getIndicator() return end

    -- :: Rebirth cast edilmis ise
    if (spellId == 48477 and eventType == "SPELL_RESURRECT") then -- 48477(rebirth)
        -- print(spellId)
        startCooldown(srcName, spellId)
    end
    -- :: Checktime if some cd exists
    if inquiryCD then if closestAvailable <= GetTime() then endCooldown() end end
end

function module:PARTY_MEMBERS_CHANGED() scanDruids() end

-- ==== Slash Handlersd
SLASH_cr1 = "/cr"
SlashCmdList["cr"] = function(msg) handleCommand(msg) end

-- -- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[
    -->> Displays next combat resser on screen
    1- Loops through people in raid
    2- If druid used his rebirth within [cd] adds true false variable to them
    3- If cr is true for druid registers druid for display
    4- Checks for raid if is anyone dead display if its true 
]]
