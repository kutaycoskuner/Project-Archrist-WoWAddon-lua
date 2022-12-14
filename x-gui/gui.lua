------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'ArchGUI';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------

-- Globals Section
local UpdateInterval = 1.0; -- How often the OnUpdate code will run (in seconds)
local announceChannel
AceGUI = LibStub("AceGUI-3.0")
local list
local recursive = false
local realmName = GetRealmName()
local textStore
local currentLootList = {}
local focus = Arch_focusColor
local fixArgs = Arch_fixArgs
--
Arch_guiFrame = nil
Arch_isFrameOpen = false
--
local frame2
local frameOpen2 = false
local frameStopTrack2 = true
--
local lootFramePos
local voaFramePos
--

local diverseRaid

-- ==== Module GUI
local function setPoint(self)
    local scale = self:GetEffectiveScale()
    local x, y = GetCursorPosition()
    self:ClearAllPoints()
    self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / scale, (y + 10) / scale)
end

local function setGameTooltip(widget)
    GameTooltip:SetOwner(Arch_guiFrame, "ANCHOR_CURSOR", 0, 0);
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints();
    GameTooltip:SetPoint("bottomleft", Arch_guiFrame, "topright", 0, 0);
    GameTooltip:ClearLines()
    -- print(frame)
end

local function diverseRaidGUI()
    Arch_guiFrame:SetWidth(280)
    Arch_guiFrame:SetHeight(730)
    Arch_guiFrame:ClearAllPoints()
    if A.global.voaFrame == {} then
        Arch_guiFrame:SetPoint("CENTER", 0, 0)
    else
        Arch_guiFrame:SetPoint(voaFramePos[1], voaFramePos[3], voaFramePos[4])
    end
    local heading = AceGUI:Create('Heading')
    heading:SetText('Diverse Raid')
    heading:SetRelativeWidth(1)
    Arch_guiFrame:ReleaseChildren()
    Arch_guiFrame:AddChild(heading)
    --
    for ii = 1, #diverseRaid do
        for key in pairs(diverseRaid[ii]) do
            local group = AceGUI:Create("SimpleGroup")
            group:SetFullWidth(true)
            group:SetLayout('Flow')
            Arch_guiFrame:AddChild(group)
            --
            local groupName = AceGUI:Create("Heading")
            groupName:SetText(key)
            groupName:SetRelativeWidth(1)
            group:AddChild(groupName)
            for subkey in pairs(diverseRaid[ii][key]) do
                local specTick = AceGUI:Create("CheckBox")
                specTick:SetValue(A.global.voaRaid[ii][key][subkey])
                specTick:SetLabel(subkey)
                specTick:SetCallback("OnValueChanged", function(self, value)
                    -- diverseRaid[ii][key][subkey] =
                    --     not diverseRaid[ii][key][subkey]
                    A.global.voaRaid[ii][key][subkey] = not A.global.voaRaid[ii][key][subkey]
                    -- print(diverseRaid[ii][key][subkey])
                end)
                group:AddChild(specTick)
            end
        end
    end
    -- 
    local channel = AceGUI:Create('EditBox')
    channel:SetText(announceChannel or 'Set announce channel key here')
    channel:SetFullWidth(true)
    channel:SetCallback("OnEnterPressed", function(widget, event, text)
        announceChannel = text
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Announce Channel is now: " .. announceChannel)
    end)
    Arch_guiFrame:AddChild(channel)
    -- :: AnnounceButton
    local annButton = AceGUI:Create('Button')
    annButton:SetText('Announce')
    annButton:SetFullWidth(true)
    annButton:SetCallback("OnClick", function(widget, event, text)
        VoA_announce(false)
    end)
    Arch_guiFrame:AddChild(annButton)
end

-- ==== Core
-- :: Sadece Komutla aciliyor
function toggleGUI(key)
    if not Arch_isFrameOpen then
        Arch_isFrameOpen = true
        Arch_guiFrame = AceGUI:Create("Frame")
        Arch_guiFrame:SetTitle(N)

        Arch_guiFrame:SetCallback("OnClose", function(widget)
            Arch_isFrameOpen = false
            local a, b, c, d, e = Arch_guiFrame:GetPoint()
            -- print(a,b,c,d,e)
            -- A.global.lootFrame = {a, c, d, e}
            -- A.global.voaFrame = {a, c, d, e}
            if key == "pugRaid" then
                A.global.pugFrame = {a, c, d, e}
            elseif key == "CraftGuides" then
                A.global.guideFrame = {a, c, d, e}
            end
            -- print(lootFramePos[1], lootFramePos[2], lootFramePos[3], lootFramePos[4])
            -- print(A.global.lootFrame[1].. d)
        end)
        Arch_guiFrame:SetLayout("Flow")
        -- :: select the gui
        if key == 'TodoList' then
            Arch_TodoListGUI()
        elseif key == "pugRaid" then
            Arch_pugRaidGUI()
        elseif key == "CraftGuides" then
            Arch_craftGuidesGUI()
        elseif key == 'PlayerDB' then
            Arch_playerDB_GUI()
            -- elseif key == 'LootDatabase' then
            --     LootDatabaseGUI()
            -- elseif key == 'LootDatabasePrune' then
            --     currentLootList = {}
            --     toggleGUI('LootDatabase')
            -- elseif key == "DiverseRaid" then
            --     diverseRaidGUI()
        end
        -- test
    elseif recursive then
        Arch_guiFrame:Release()
        Arch_isFrameOpen = false
        toggleGUI(key)
    else
        Arch_guiFrame:Release()
        frameOpen = false
    end
end

function Arch_setGUI(key, isRecursive)
    recursive = false
    if isRecursive then
        recursive = true
    end
    if key ~= 'raidCooldowns' then
        toggleGUI(key)
    else
        -- toggleGUI_2(key)
    end
end

-- function GUI_insertPerson(target, reload)
--     local isPersonExists = false
--     local player = A.loot[realmName][target]
--     -- :: kisi varsa sil
--     -- if target == nil then target = '' end
--     for ii = 1, #currentLootList do
--         if currentLootList[ii][1] == target then
--             table.remove(currentLootList, ii)
--             isPersonExists = true
--         end
--     end
--     -- :: kisi yoksa ekle
--     if not isPersonExists or reload ~= nil then
--         local nominee = {}
--         nominee[1] = target -- name

--         nominee[2] = (#player or 0) -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         for ii = 1, #player do
--             if GetItemInfo(player[ii][3]) then -- [3] id ye bakiyor
--                 local _, a = GetItemInfo(player[ii][3])
--                 nominee[2 + ii] = {player[ii][1], a}
--             end
--             if ii == 3 then
--                 break
--             end
--         end
--         for ii = 3, 5 do
--             if not nominee[ii] then
--                 nominee[ii] = {nil, nil}
--             end
--         end
--         local previous = #currentLootList or 0
--         table.insert(currentLootList, 1, nominee)
--     end
--     -- :: eger bir onceki listeden farkliysa listeyi guncelle
--     if not frameOpen then
--         Arch_setGUI('LootDatabase')
--     else
--         frame:Release()
--         frameOpen = false
--         Arch_setGUI('LootDatabase')
--     end

-- end

function return_diverseRaid()
    return {diverseRaid, announceChannel}
end

-- Functions Section
function GUI_OnUpdate(self, elapsed)
    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

    if (self.TimeSinceLastUpdate > UpdateInterval) then

        self.TimeSinceLastUpdate = 0;
    end
end

function module:Initialize()
    self.Initialized = true
    if not A.global.lootFrame then
        A.global.lootFrame = {"CENTER", "CENTER", 0, 0}
    end
    lootFramePos = A.global.lootFrame
    diverseRaid = A.global.voaRaid
    --
    if not A.global.voaFrame then
        A.global.voaFrame = {"CENTER", "CENTER", 0, 0}
    end
    voaFramePos = A.global.voaFrame
    -- :: Register Events
    -- self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
    -- self:RegisterEvent("CHAT_MSG_RAID_WARNING")
    -- "MAIL_INBOX_UPDATE"
end

-- ==== Slash Handlers
-- SLASH_arch1 = "/arch"
-- SlashCmdList["arch"] = function() toggleGUI(false) end

-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)

-- :: function that draws the widgets for the first tab
local function DrawGroup1(container)
    local desc = AceGUI:Create("Label")
    desc:SetText("This is Tab 1")
    desc:SetFullWidth(true)
    container:AddChild(desc)

    local button = AceGUI:Create("Button")
    button:SetText("Tab 1 Button")
    button:SetWidth(200)
    container:AddChild(button)
end

-- :: function that draws the widgets for the second tab
local function DrawGroup2(container)
    local desc = AceGUI:Create("Label")
    desc:SetText("This is Tab 2")
    desc:SetFullWidth(true)
    container:AddChild(desc)

    local button = AceGUI:Create("Button")
    button:SetText("Tab 2 Button")
    button:SetWidth(200)
    container:AddChild(button)
end

-- :: Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "tab1" then
        DrawGroup1(container)
    elseif group == "tab2" then
        DrawGroup2(container)
    end
end
