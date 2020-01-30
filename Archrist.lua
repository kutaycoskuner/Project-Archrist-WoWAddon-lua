-- ==== Variables
-- --[[ 
--     To load the AddOn engine add this to the top of your file:
-- 	local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
-- ]]
-- -- Lua functions
-- local _G, min, pairs, strsplit, unpack, wipe, type, tcopy = _G, min, pairs, strsplit, unpack, wipe, type, table.copy
-- -- WoW API / Variables
-- local hooksecurefunc = hooksecurefunc
-- local CreateFrame = CreateFrame
-- local GetAddOnInfo = GetAddOnInfo
-- local GetAddOnMetadata = GetAddOnMetadata
-- local GetTime = GetTime
-- local HideUIPanel = HideUIPanel
-- local InCombatLockdown = InCombatLockdown
-- local IsAddOnLoaded = IsAddOnLoaded
-- local LoadAddOn = LoadAddOn
-- local ReloadUI = ReloadUI

-- local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
-- local GameMenuButtonLogout = GameMenuButtonLogout
-- local GameMenuFrame = GameMenuFrame

-- BINDING_HEADER_ARCH = GetAddOnMetadata(..., "Title")

-- local AddOnName, Engine = ...;
-- local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0"); -- ** "AceTimer-3.0", "AceHook-3.0"
-- -- AddOn.callbacks = AddOn.callbacks or CallbackHandler:New(AddOn)
-- AddOn.DF = {profile = {}, global = {}}; AddOn.privateVars = {profile = {}} -- Defaults
-- AddOn.Options = {type = "group", name = AddOnName, args = {}}

-- Engine[1] = AddOn
-- Engine[2] = {}
-- Engine[3] = AddOn.privateVars.profile
-- Engine[4] = AddOn.DF.profile
-- Engine[5] = AddOn.DF.global
-- _G[AddOnName] = Engine

-- -- test
-- print(AddOnName)

-- ==== Development
SLASH_RELOADUI1 = "/rl"; -- for quicker reload
SlashCmdList.RELOADUI = ReloadUI;

SLASH_FRAMESTK1 = "/fs"; -- for quicker access to frame stack
SlashCmdList.FRAMESTK = function()
    LoadAddOn('Blizzard_DebugTools');
    FrameStackTooltip_Toggle();
end

for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false);
end

-- ==== Start
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0",
                                               "AceEvent-3.0")

local options = {
    name = "WelcomeHome",
    handler = WelcomeHome,
    type = "group",
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message text to be displayed",
            usage = "<Your message here>",
            get = "GetMessage",
            set = "SetMessage"
        },
        showInChat = {
            type = "toggle",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat"
        },
        showOnScreen = {
            type = "toggle",
            name = "Show on Screen",
            desc = "Toggles the display of the message on the screen.",
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen"
        }
    }
}

local defaults = {
    profile = {
        message = "Welcome Home!",
        showInChat = false,
        showOnScreen = true
    }
}

WelcomeHome.showInChat = false
WelcomeHome.showOnScreen = true

function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("testDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
                            "WelcomeHome", "WelcomeHome")
    self:RegisterChatCommand("wh", "ChatCommand")
    self:RegisterChatCommand("welcomehome", "ChatCommand")
end

function WelcomeHome:OnEnable()
    -- Called when the addon is enabled
    self:RegisterEvent("ZONE_CHANGED")
end

function WelcomeHome:OnDisable()
    -- Called when the addon is disabled
end

function WelcomeHome:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        if self.db.profile.showInChat then
            self:Print(self.db.profile.message);
        end

        if self.db.profile.showOnScreen then
            UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
        end
    end
end

function WelcomeHome:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("wh", "WelcomeHome", input)
    end
end

function WelcomeHome:GetMessage(info) return self.db.profile.message end

function WelcomeHome:SetMessage(info, newValue)
    self.db.profile.message = newValue
end

function WelcomeHome:IsShowInChat(info) return self.db.profile.showInChat end

function WelcomeHome:ToggleShowInChat(info, value)
    self.db.profile.showInChat = value
end

function WelcomeHome:IsShowOnScreen(info) return self.db.profile.showOnScreen end

function WelcomeHome:ToggleShowOnScreen(info, value)
    self.db.profile.showOnScreen = value
end

-- local EventFrame = CreateFrame("Frame")
-- EventFrame:RegisterEvent("PLAYER_LOGIN")
-- EventFrame:SetScript("OnEvent", function(self,event,...) 
-- 	if type(ArchCharDB) ~= "number" then
-- 		ArchCharDB = 1;
-- 		ChatFrame1:AddMessage('Welcome '.. UnitName("Player") .. ' this is your first login with Archrist addon please use /arch to configure');
-- 	else
-- 		if ArchCharDB then
-- 			ChatFrame1:AddMessage('Welcome '.. UnitName("Player") .. " you have entered world " ..  ArchCharDB .. " times before.");
-- 		end
-- 		ArchCharDB = ArchCharDB + 1;
-- 	end
-- end)

-- --[[
--     CreateFrame Arguments:
--         1- The type of frame - 'frame'
--         2- The global frame name 
--         3- The parent frame (not a string)
--         4- A comma separated list (string list) of xml templates to inherit from
-- ]]

-- UIConfig.SetSize(300, 360);
-- UIConfig.SetPoint("CENTER", UIParent, "CENTER"); -- point, relativeFrame, relativePoint, xOffset, yOffset

-- --[[
--     "TOPLEFT"
--     "TOP"
--     "TOPRIGHT"
--     "LEFT"
--     "CENTER"
--     "RIGHT"
--     "BOTTOMLEFT"
--     "BOTTOM"
--     "BOTTOMRIGHT"
-- ]]
