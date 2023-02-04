-- ==== Credit
-- This Addon is created by inspecting ElvUI, Spy, PostureCheck by Sir_Onionknight, tacotip
-- ==== Create Addon
local AceAddon, AceAddonMinor = LibStub("AceAddon-3.0")
local CallbackHandler = LibStub("CallbackHandler-1.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Archrist") -- :: translations usage: L['<data>']
local AddonName, System = ... -- :: this declares addon scope variable

local Addon = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0",
                                "AceTimer-3.0", "AceHook-3.0")

-- :: lua Functions
local tcopy = table.copy;
local twipe = table.wipe;

-- :: Addon Tables, Variables
Addon.callbacks = Addon.callbacks or CallbackHandler:New(Addon)
Addon.DF = {profile = {}, global = {}} -- Profiles
Addon.privateVars = {profile = {}} -- Defaults
Addon.options = {type = "group", name = AddonName, args = {}}
Addon.peopleDF = {profile = {}}
Addon.lootDF = {profile = {}, global = {}}
Addon.ArchModuleInfo = "|cff00c8ff[Archrist]|r |cff00efff"


-- :: Create global addon module
System[1] = Addon;
System[2] = {}; -- :: locales
System[3] = Addon.privateVars.profile or {}; -- :: private global
System[4] = Addon.DF.profile or {}; -- :: character profile
System[5] = Addon.DF.global; -- :: global profile 
System[6] = Addon.peopleDF.global;
System[7] = Addon.lootDF.global;
System[8] = Addon.ArchModuleInfo;
System[9] = AddonName;
_G[AddonName] = System;


-- self.private = self.charSettings.profile
-- self.db = self.data.profile
-- self.global = self.data.global

-- test


-- test end

-- :: expansion
Addon.Wrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

-- ==== Instantiation
-- :: Elaborate Libraries
do
    -- assert(LibStub:GetLibrary("LibClassicInspector", true), "Archrist requires LibClassicInspector")
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
    Addon:AddLib("Detours", "LibDetours-1.0")
    Addon:AddLib("LCI", "LibClassicInspector")
    -- Addon:AddLib('LCS', 'LibClassicSpecs-ElvUI')
end


do
    -- :: Create Modules
    -- testing
    Addon.test = Addon:NewModule("test", "AceHook-3.0", "AceEvent-3.0")
    -- testing end
    -- :: External Memory
    Addon.todoList = Addon:NewModule("TodoList", "AceHook-3.0", "AceEvent-3.0")
    Addon.playerDB = Addon:NewModule("PlayerDB", "AceHook-3.0", "AceEvent-3.0")
    -- :: Guide
    Addon.craftGuides = Addon:NewModule("CraftGuides", "AceHook-3.0", "AceEvent-3.0")
    Addon.levelingGuides = Addon:NewModule("LevelingGuides", "AceHook-3.0", "AceEvent-3.0")
    -- :: Assistance
    Addon.cRIndicator = Addon:NewModule("CRIndicator", "AceHook-3.0", "AceEvent-3.0")
    Addon.pug = Addon:NewModule("Pug", "AceHook-3.0", "AceEvent-3.0")
    Addon.announcer = Addon:NewModule("Announcer", "AceHook-3.0", "AceEvent-3.0")
    Addon.groupOrganizer = Addon:NewModule("GroupOrganizer", "AceHook-3.0", "AceEvent-3.0")
    Addon.raidWarnings = Addon:NewModule("RaidWarnings", "AceHook-3.0", "AceEvent-3.0")
    -- :: Utility
    Addon.lootMsgFilter = Addon:NewModule("LootFilter")
    Addon.postureCheck = Addon:NewModule("PostureCheck")
    Addon.guideMaker = Addon:NewModule("GuideMaker")
    Addon.encounterStopwatch = Addon:NewModule("EncounterStopwatch", "AceEvent-3.0")
    -- :: Extended Macros
    Addon.macro = Addon:NewModule("Macro")
    Addon.milling = Addon:NewModule("Milling", "AceEvent-3.0")
    Addon.prospecting = Addon:NewModule("Prospecting", "AceEvent-3.0")
    Addon.disenchanting = Addon:NewModule("Disenchanting", "AceEvent-3.0")
    Addon.eatDrink = Addon:NewModule("EatDrink", "AceEvent-3.0")
    Addon.feedPet = Addon:NewModule("FeedPet", "AceEvent-3.0")
    Addon.autoMount = Addon:NewModule("AutoMount")
    -- :: architectural
    Addon.help = Addon:NewModule("Help", "AceHook-3.0", "AceEvent-3.0")
    Addon.archGUI = Addon:NewModule("ArchGUI", "AceHook-3.0", "AceEvent-3.0")
    -- :: adapters
    Addon.adapterDatabase = Addon:NewModule("DatabaseAdapter", "AceHook-3.0", "AceEvent-3.0")
    -- todo other
    --:: disabled
    -- Addon.deleteAucMail = Addon:NewModule("DeleteAucMail", "AceHook-3.0", "AceEvent-3.0")
    -- Addon.autoLoot = Addon:NewModule("AutoLoot", "AceHook-3.0", "AceEvent-3.0")
    -- Addon.lootDB = Addon:NewModule("LootDB", "AceHook-3.0", "AceEvent-3.0")
    Addon.voa = Addon:NewModule("VoA", "AceHook-3.0", "AceEvent-3.0")
    -- Addon.Distributor = Addon:NewModule("Distributor", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
    -- Addon.macro = Addon:NewModule("RaidCommands")
    -- :: Empty Modules
    -- :: Macros
    Addon.discord = Addon:NewModule('Discord')
    Addon.tank = Addon:NewModule('Tank')
    Addon.spread = Addon:NewModule('Spread')
    Addon.stack = Addon:NewModule('Stack')
    Addon.lootRules = Addon:NewModule('LootRules')
    Addon.paladinBuffs = Addon:NewModule('PaladinBuffs')
    Addon.warrior = Addon:NewModule('Warrior', "AceHook-3.0", "AceEvent-3.0")
    Addon.shaman = Addon:NewModule('Shaman', "AceHook-3.0", "AceEvent-3.0")
    Addon.attendance = Addon:NewModule('Attendance', "AceHook-3.0", "AceEvent-3.0")
    Addon.tactics = Addon:NewModule('Tactics', "AceHook-3.0", "AceEvent-3.0")
end

-- :: fix module names
do
    local arg2, arg3 = "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1"
    function Addon:EscapeString(str) return gsub(str, arg2, arg3) end
end

-- Main lifecycle event handlers

-- -- ==== Create Modules
-- -- Addon.Testcore = Addon:NewModule('testa')
-- ==== Declare Event Behaviors
-- :: define behavior on event
function Addon:OnInitialize()

    if not ArchCharacterDB then ArchCharacterDB = {} end
    if not ArchDB then ArchDB = {} end
    if not ArchPrivateDB then ArchPrivateDB = {} end
    if not ArchPeopleDB then ArchPeopleDB = {} end
    if not ArchLootDB then ArchLootDB = {} end

    self.db = tcopy(self.DF.profile, true)
    self.global = tcopy(self.DF.global, true)
    self.people = tcopy(self.peopleDF.global, true)
    self.loot = tcopy(self.lootDF.global, true)

    -- **

    -- if ArchDB then
    --     if ArchDB.global then self:CopyTable(self.global, ArchDB.global) end

    --     local profileKey
    --     if ArchDB.profileKeys then
    --         profileKey =
    --             ArchDB.profileKeys[self.myname .. " - " .. self.myrealm]
    --     end

    --     if profileKey and ArchDB.profiles and ArchDB.profiles[profileKey] then
    --         self:CopyTable(self.db, ArchDB.profiles[profileKey])
    --     end
    -- end

    -- self.private = tcopy(self.privateVars.profile, true)

    -- if ArchPrivateDB then
    --     local profileKey
    --     if ArchPrivateDB.profileKeys then
    --         profileKey = ArchPrivateDB.profileKeys[self.myname .. " - " ..
    --                          self.myrealm]
    --     end

    --     if profileKey and ArchPrivateDB.profiles and
    --         ArchPrivateDB.profiles[profileKey] then
    --         self:CopyTable(self.private, ArchPrivateDB.profiles[profileKey])
    --     end
    -- end

    -- **
    -- Called when the addon is loaded
    -- self.db = LibStub("AceDB-3.0"):New("ArchDB", defaults, true)
    -- LibStub("AceConfig-3.0"):RegisterOptionsTable("Addon", options) -- :: addon, options
    -- self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Addon", "Archrist") -- :: addon, name
    -- self:RegisterChatCommand("ar", "ChatCommand")
    -- self:RegisterChatCommand("archrist", "ChatCommand")
    -- Addon.message = "Welcome Home!"
    -- Addon.showInChat = false
    -- Addon.showOnScreen = true
end

local LoadUI = CreateFrame("Frame")
LoadUI:RegisterEvent("PLAYER_LOGIN")
LoadUI:SetScript("OnEvent", function() Addon:Initialize() end)
