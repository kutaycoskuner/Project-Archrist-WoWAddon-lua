-- ==== Project Archrist started at 25-Jan-2020
--[[ 
    Disclaimer: This addon created by inspectation and use of ElvUI
    To load the Addon engine add this to the top of your file:
------------------------------------------------------------------------------------------
-- Orthplate
local Arch, L, V, P, G = unpack(select(2, ...)); --Import: System, Locales, PrivateDB, ProfileDB, GlobalDB
------------------------------------------------------------------------------------------
]] 
-- ==== Variables
-- Lua functions
local _G, min, pairs, strsplit, unpack, wipe, type, tcopy = _G, min, pairs, strsplit, unpack,wipe, type,table.copy
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local GetAddOnInfo = GetAddOnInfo
local GetAddOnMetadata = GetAddOnMetadata
local GetTime = GetTime
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local ReloadUI = ReloadUI
--
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local GameMenuButtonLogout = GameMenuButtonLogout
local GameMenuFrame = GameMenuFrame
--
local AceAddon, AceAddonMinor = LibStub("AceAddon-3.0")
local CallbackHandler = LibStub("CallbackHandler-1.0")
local AddonName, System = ...; -- this declares addon scope variable
local Addon = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0"); -- "AceTimer-3.0", "AceHook-3.0"
BINDING_HEADER_ARCH = GetAddOnMetadata(..., "Title")
-- Addon Decleration
Addon.callbacks = Addon.callbacks or CallbackHandler:New(Addon)
Addon.DF = {profile = {}, global = {}};
Addon.privateVars = {profile = {}} -- Defaults
Addon.options = {type = "group", name = AddonName, args = {}}
System[1] = Addon
System[2] = {}
System[3] = Addon.privateVars.profile
System[4] = Addon.DF.profile
System[5] = Addon.DF.global
_G[AddonName] = System

-- ==== Main

-- ==== Modules
Addon.archTest = Addon:NewModule("archTest")


-- test 