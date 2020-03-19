-- ==== Create Addon
local L = LibStub("AceLocale-3.0"):GetLocale("Archrist") -- :: translations usage: L['<data>']
local AddonName, System = ... -- :: this declares addon scope variable
local AceAddon, AceAddonMinor = LibStub("AceAddon-3.0")
local Addon = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0",
                                "AceTimer-3.0", "AceHook-3.0")
local CallbackHandler = LibStub("CallbackHandler-1.0")

-- :: lua Functions
local tcopy = table.copy;
local twipe = table.wipe;

-- :: Addon Tables, Variables
Addon.callbacks = Addon.callbacks or CallbackHandler:New(Addon);
Addon.DF = {profile = {}, global = {}}; -- Profiles
Addon.privateVars = {profile = {}} -- Defaults
Addon.options = {type = "group", name = AddonName, args = {}};
Addon.peopleDF = {people = {}};
ArchModuleInfo = "|cff00c8ff[Archrist]|r |cff00efff";

-- :: Create global addon module
System[1] = Addon;
System[2] = {}; -- :: locales
System[3] = Addon.privateVars.profile or {}; -- :: private global
System[4] = Addon.DF.profile; -- :: character profile
System[5] = Addon.DF.global; -- :: global profile 
System[6] = Addon.peopleDF.people;
System[7] = ArchModuleInfo;
System[8] = AddonName;
_G[AddonName] = System;

-- self.private = self.charSettings.profile
-- self.db = self.data.profile
-- self.global = self.data.global

-- test

-- print(System[4])
-- print('arch')

-- test end

-- ==== Instantiation
-- :: Elaborate Libraries
do
    Addon.Libs = {}
    Addon.LibsMinor = {}
    function Addon:AddLib(name, major, minor)
        if not name then return end

        -- in this case: `major` is the lib table and `minor` is the minor version
        if type(major) == "table" and type(minor) == "number" then
            self.Libs[name], self.LibsMinor[name] = major, minor
        else -- in this case: `major` is the lib name and `minor` is the silent switch
            self.Libs[name], self.LibsMinor[name] = LibStub(major, minor)
        end
    end

    Addon:AddLib("AceAddon", AceAddon, AceAddonMinor)
    Addon:AddLib("AceDB", "AceDB-3.0")
end

-- :: Create Modules
-- :: Modules
do
    Addon.test = Addon:NewModule("test", "AceHook-3.0", "AceEvent-3.0")
    Addon.lootMsgFilter = Addon:NewModule("lootMsgFilter")
    Addon.deleteAucMail = Addon:NewModule("deleteAucMail", "AceHook-3.0", "AceEvent-3.0")
    Addon.playerDB = Addon:NewModule("playerDB", "AceHook-3.0", "AceEvent-3.0")
    Addon.autoLoot = Addon:NewModule("autoLoot", "AceHook-3.0", "AceEvent-3.0")
    -- Addon.Distributor = Addon:NewModule("Distributor", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
end
-- :: Macros
Addon.milling = Addon:NewModule("milling", "AceEvent-3.0")
Addon.prospecting = Addon:NewModule("prospecting", "AceEvent-3.0")
Addon.raidWarnings = Addon:NewModule("raidWarnings")
Addon.discord = Addon:NewModule('discord')
Addon.tank = Addon:NewModule('tank')
Addon.spread = Addon:NewModule('spread')
Addon.stack = Addon:NewModule('stack')
Addon.paladinBuffs = Addon:NewModule('paladinBuffs')

-- :: fix moduule names
do
    local arg2, arg3 = "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1"
    function Addon:EscapeString(str) return gsub(str, arg2, arg3) end
end

-- Main lifecycle event handlers

-- ==== Create Variables
local defaults = {
    profile = {
        message = "Welcome Home!",
        showInChat = false,
        showOnScreen = true
    }
}

local options = {
    name = "Archrist",
    handler = Addon, -- :: addon
    type = "group",
    args = {
        msg = {
            type = "input",
            name = L["Message"],
            desc = L["The message to be displayed when you get home."],
            usage = L["<Your message>"],
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

-- -- ==== Create Modules
-- -- Addon.Testcore = Addon:NewModule('testa')
-- ==== Declare Event Behaviors
-- :: define behavior on event
function Addon:OnInitialize()

    if not ArchCharacterDB then ArchCharacterDB = {} end

    self.db = tcopy(self.DF.profile, true)
    self.global = tcopy(self.DF.global, true)

    -- **

    if ArchDB then
        if ArchDB.global then self:CopyTable(self.global, ArchDB.global) end

        local profileKey
        if ArchDB.profileKeys then
            profileKey =
                ArchDB.profileKeys[self.myname .. " - " .. self.myrealm]
        end

        if profileKey and ArchDB.profiles and ArchDB.profiles[profileKey] then
            self:CopyTable(self.db, ArchDB.profiles[profileKey])
        end
    end

    self.private = tcopy(self.privateVars.profile, true)

    if ArchPrivateDB then
        local profileKey
        if ArchPrivateDB.profileKeys then
            profileKey = ArchPrivateDB.profileKeys[self.myname .. " - " ..
                             self.myrealm]
        end

        if profileKey and ArchPrivateDB.profiles and
            ArchPrivateDB.profiles[profileKey] then
            self:CopyTable(self.private, ArchPrivateDB.profiles[profileKey])
        end
    end

    -- **
    -- Called when the addon is loaded
    -- self.db = LibStub("AceDB-3.0"):New("ArchDB", defaults, true)
    -- LibStub("AceConfig-3.0"):RegisterOptionsTable("Addon", options) -- :: addon, options
    -- self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Addon", "Archrist") -- :: addon, name
    self:RegisterChatCommand("ar", "ChatCommand")
    self:RegisterChatCommand("archrist", "ChatCommand")
    Addon.message = "Welcome Home!"
    Addon.showInChat = false
    Addon.showOnScreen = true
end

-- :: command handler
function Addon:ChatCommand(input)
    if not input or input:trim() == "" then
        -- InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("ar", "Addon", input) -- :: key, addon, input
    end
end

-- :: register an event to addon
function Addon:OnEnable()
    -- self:Print("Hello World!")
    -- self:RegisterEvent("CHAT_MSG_SAY")
end

-- :: response to registered event
function Addon:CHAT_MSG_SAY()
    -- if self.db.profile.showInChat then
    -- self:Print(self.db.message); -- ** aware that P is capital
    -- end

    -- if self.db.profile.showOnScreen then
    --     UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
    -- end
end

function Addon:GetMessage(info) return self.db.message end

function Addon:SetMessage(info, newValue)
    self.db.message = newValue
    self.private.message = newValue
    self.global.message = newValue
    -- self:Print(self.DF.profile.message)
end

function Addon:IsShowInChat(info) return self.DF.profile.showInChat end

function Addon:IsShowOnScreen(info) return self.DF.profile.showOnScreen end

function Addon:ToggleShowInChat(info, value) self.DF.profile.showInChat = value end

function Addon:ToggleShowOnScreen(info, value)
    self.DF.profile.showOnScreen = value
end

local LoadUI = CreateFrame("Frame")
LoadUI:RegisterEvent("PLAYER_LOGIN")
LoadUI:SetScript("OnEvent", function() Addon:Initialize() end)
