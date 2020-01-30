-- ==== Variables
--[[ 
    To load the Addon engine add this to the top of your file:
	local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
]]
-- Lua functions
local _G, min, pairs, strsplit, unpack, wipe, type, tcopy = _G, min, pairs, strsplit, unpack, wipe, type, table.copy
-- WoW API / Variables
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
BINDING_HEADER_ARCH = GetAddOnMetadata(..., "Title")
local AddonName, Engine = ...;
local Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0"); -- ** "AceTimer-3.0", "AceHook-3.0"
-- !! Addon.callbacks = Addon.callbacks or CallbackHandler:New(Addon)
Addon.DF = {profile = {}, global = {}}; Addon.privateVars = {profile = {}} -- Defaults
Addon.Options = {type = "group", name = AddonName, args = {}}
Engine[1] = Addon
Engine[2] = {}
Engine[3] = Addon.privateVars.profile
Engine[4] = Addon.DF.profile
Engine[5] = Addon.DF.global
_G[AddonName] = Engine
-- -- test
-- print(_G)

-- ==== Start


-- ====

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
