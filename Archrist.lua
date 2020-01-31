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
-- :: Lua functions
local _G, min, pairs, strsplit, unpack, wipe, type, tcopy = _G, min, pairs, strsplit, unpack,wipe, type,table.copy
-- :: WoW API / Variables
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
-- Addon Decleration
BINDING_HEADER_ARCH = GetAddOnMetadata(..., "Title")
Addon.callbacks = Addon.callbacks or CallbackHandler:New(Addon)
Addon.DF = {profile = {}, global = {}};
Addon.privateVars = {profile = {}}; -- Defaults
Addon.options = {type = "group", name = AddonName, args = {}}
--
System[1] = Addon
System[2] = {}
System[3] = Addon.privateVars.profile
System[4] = Addon.DF.profile
System[5] = Addon.DF.global
_G[AddonName] = System


-- ==== Custom Libraries

-- ==== Modules




-- Addon.test = Addon:NewModule("test")


-- :: Escape string for characters ().%+-*?[^$
-- do
-- 	local arg2, arg3 = "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1"
-- 	function Addon:EscapeString(str)
-- 		return gsub(str, arg2, arg3)
-- 	end
-- end

-- ==== Addon Init

function Addon:OnInitialize()
    -- -- :: if there is no database creatae one
	-- if not ArchCharacterDB then
	-- 	ArchCharacterDB = {}
	-- end

	-- self.db = tcopy(self.DF.profile, true)
	-- self.global = tcopy(self.DF.global, true)
	
	-- -- :: eger db varsa profili programa al (cache)  
	-- if ArchDB then
	-- 	if ArchDB.global then
	-- 		self:CopyTable(self.global, ArchDB.global)
	-- 	end

	-- 	local profileKey
	-- 	if ArchDB.profileKeys then
	-- 		profileKey = ArchDB.profileKeys[self.myname.." ["..self.myrealm.."]"]
	-- 	end

	-- 	if profileKey and ArchDB.profiles and ArchDB.profiles[profileKey] then
	-- 		self:CopyTable(self.db, ArchDB.profiles[profileKey])
	-- 	end
	-- end

	-- self.private = tcopy(self.privateVars.profile, true)
	-- -- :: private DB icin ayni islemi uygula
	-- if ArchPrivateDB then
	-- 	local profileKey
	-- 	if ArchPrivateDB.profileKeys then
	-- 		profileKey = ArchPrivateDB.profileKeys[self.myname.." ["..self.myrealm.."]"]
	-- 	end

	-- 	if profileKey and ArchPrivateDB.profiles and ArchPrivateDB.profiles[profileKey] then
	-- 		self:CopyTable(self.private, ArchPrivateDB.profiles[profileKey])
	-- 	end
	-- end

	-- self.twoPixelsPlease = false
	-- self.ScanTooltip = CreateFrame("GameTooltip", "ElvUI_ScanTooltip", _G.UIParent, "GameTooltipTemplate")
	-- self.PixelMode = self.twoPixelsPlease or self.private.general.pixelPerfect -- keep this over `UIScale`
	-- self:UIScale(true)
	-- self:UpdateMedia()

	-- self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", "PixelScaleChanged")
	-- self:RegisterEvent("PLAYER_REGEN_DISABLED")
	-- self:Contruct_StaticPopups()
	-- self:InitializeInitialModules()

	-- local GameMenuButton = CreateFrame("Button", "ElvUI_MenuButton", GameMenuFrame, "GameMenuButtonTemplate")
	-- GameMenuButton:SetText(self.title)
	-- GameMenuButton:SetScript("OnClick", function()
	-- 	AddOn:ToggleOptionsUI()
	-- 	HideUIPanel(GameMenuFrame)
	-- end)
	-- GameMenuFrame[AddOnName] = GameMenuButton

	-- GameMenuButton:Size(GameMenuButtonLogout:GetWidth(), GameMenuButtonLogout:GetHeight())
	-- GameMenuButtonRatings:HookScript("OnShow", function(self)
	-- 	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + self:GetHeight())
	-- end)
	-- GameMenuButtonRatings:HookScript("OnHide", function(self)
	-- 	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() - self:GetHeight())
	-- end)

	-- GameMenuFrame:HookScript("OnShow", function()
	-- 	if not GameMenuFrame.isElvUI then
	-- 		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 1)
	-- 		GameMenuFrame.isElvUI = true
	-- 	end
	-- 	local _, relTo = GameMenuButtonLogout:GetPoint()
	-- 	if relTo ~= GameMenuFrame[AddOnName] then
	-- 		GameMenuFrame[AddOnName]:ClearAllPoints()
	-- 		GameMenuFrame[AddOnName]:Point("TOPLEFT", relTo, "BOTTOMLEFT", 0, -1)
	-- 		GameMenuButtonLogout:ClearAllPoints()
	-- 		GameMenuButtonLogout:Point("TOPLEFT", GameMenuFrame[AddOnName], "BOTTOMLEFT", 0, -16)
	-- 	end
	-- end)

	self.loadedtime = GetTime()
end


-- test 