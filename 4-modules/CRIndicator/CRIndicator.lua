------------------------------------------------------------------------------------------------------------------------
-- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'CRIndicator';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local druids
local inquiryCD = true
local closestAvailable = 0
local isFrameVisible = false

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
frameText:SetText('|cff464646Combat Res Frame|r')
--
f:SetPoint("CENTER", 536, 200)
f:Hide()

-- ==== Methods
local function calcTimeInSec()
    local date = date("%H:%M:%S")
    local sep = ':';
    if sep == nil then sep = "%s" end
    local args = {};
    for str in string.gmatch(date, "([^" .. sep .. "]+)") do
        table.insert(args, str)
    end
    if args[1] == 0 then args[1] = 12 end
    return tonumber(args[1] * 3600 + args[2] * 60 + args[3])
end

local function getIndicator()
    local players = ''
    local dru = '|cffFF7D0A'
    local cooldown = '|cff464646'
    local endtext = '|r'
    for ii = 1, #druids do
        local add = ''
        if not druids[ii].rebirth then
            add = '' -- cooldown .. druids[ii].name .. endtext .. ' '
        else
            add = dru .. druids[ii].name .. endtext .. ' '
        end
        players = players .. add
    end
    if UnitInRaid('player') then f:Show() end
    if players == '' then players = '|cff464646Combat Res Frame|r' end
    if druids ~= nil then frameText:SetText(players) end
end

local function scanDruids()
    if druids == nil then druids = A.global.rebirth end
    --
    if not UnitInRaid('player') then
        druids = {}
        f:Hide()
        return
    end
    --
    local isExists = false
    for ii = 1, GetNumRaidMembers() do
        local druidName, rank, subgroup, level, class = GetRaidRosterInfo(ii)
        if class == 'Druid' then
            for yy = 1, #druids do
                if druids[yy].name == druidName then
                    isExists = true
                    break
                end
            end
            --
            if isExists == false then
                table.insert(druids, {
                    name = druidName,
                    availableAt = calcTimeInSec(),
                    rebirth = true
                })
            end
            isExists = false
        end
    end
    --
    -- for ii=1, #druids do
    --     print(druids[ii].name)
    -- end
    --
    A.global.rebirth = druids
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
    elseif msg == 'help' then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. '/cr |cff767676for toggle frame|r')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. '/cr lock |cff767676for lock frame|r')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. '/cr move |cff767676for move frame|r')
    elseif msg == 'scan' then
        scanDruids()
    end
end

-- :: sets closest cd arrival for cooldowned rebirth
local function setClosestAvailable()
    if #druids > 1 then
        for ii = 1, #druids - 1 do
            if druids[ii].availableAt >= druids[ii + 1].availableAt then
                closestAvailable = druids[ii].availableAt
                -- print('closest return is ' .. closestAvailable)
            end
        end
    elseif #druids == 1 then
        closestAvailable = druids[1].availableAt
    else
        closestAvailable = 0
    end
    if closestAvailable > calcTimeInSec() then
        inquiryCD = true
        return
    end
    inquiryCD = false
    -- print('closest available is ' .. closestAvailable)
end

-- :: This function activates rebirth cooldown and turns rebirth availability false for given druid
local function startCooldown(srcName)
    for ii = 1, #druids do
        if druids[ii].name == srcName then
            druids[ii].rebirth = false
            druids[ii].availableAt = (calcTimeInSec() + 5)
            setClosestAvailable()
        end
    end
end

-- :: controls with random combat logs if rebirth is available
local function endCooldown()
    if druids == nil then druids = A.global.rebirth end
    for ii = 1, #druids do
        if druids[ii].availableAt >= closestAvailable then
            druids[ii].rebirth = true
            -- print(druids[ii].name .. ' can use now')
        end
    end
    setClosestAvailable()
end

-- ==== Start
function module:Initialize()
    self.initialized = true
    if A.global.rebirth == nil then A.global.rebirth = {} end
    if not UnitInRaid('player') then druids, A.global.rebirth = {}, {} end
    scanDruids()
    -- :: Register some events
    module:RegisterEvent("COMBAT_LOG_EVENT")
    module:RegisterEvent("PARTY_MEMBERS_CHANGED")
end

-- ==== Event Handlers
function module:COMBAT_LOG_EVENT(event, _, eventType, _, srcName, _, _, dstName,
                                 _, spellId, spellName, _, ...) -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    if spellId==48477 and eventType=="SPELL_CAST_SUCCESS" then -- 48477(rebirth)
        startCooldown(srcName)
        getIndicator()
    end
    -- --
    if inquiryCD then
        if closestAvailable <= calcTimeInSec() then
            endCooldown()
            getIndicator()
        end
    end
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
    1- Loops through druids in raid
    2- If druid used his rebirth within [cd] adds true false variable to them
    3- If cr is true for druid registers druid for display
    4- Checks for raid if is anyone dead display if its true 
]]
