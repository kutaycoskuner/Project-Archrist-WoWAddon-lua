------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, N = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
------------------------------------------------------------------------------------------------------------------------

-- ==== Variables
--Lua functions
local _G = _G
local tonumber, pairs, ipairs, error, unpack, select, tostring = tonumber, pairs, ipairs, error, unpack, select, tostring
local assert, type, print = assert, type, print
local twipe, tinsert, tremove, next = table.wipe, tinsert, tremove, next
local format, find, match, strrep, strlen, sub, gsub, strjoin = string.format, string.find, string.match, strrep, strlen, string.sub, string.gsub, strjoin
--WoW API / Variables
local CreateFrame = CreateFrame
local GetAddOnInfo = GetAddOnInfo
local GetCVar = GetCVar
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local IsInInstance = IsInInstance
local SendAddonMessage = SendAddonMessage
local UnitGUID = UnitGUID
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

--Constants
A.noop = function() end
A.title = format("|cff1784d1E|r|cffe5e3e3lvUI|r") -->> degisecek
A.myfaction, A.myLocalizedFaction = UnitFactionGroup("player")
A.mylevel = UnitLevel("player")
A.myLocalizedClass, A.myclass = UnitClass("player")
A.myLocalizedRace, A.myrace = UnitRace("player")
A.myname = UnitName("player")
A.myrealm = GetRealmName()
A.version = GetAddOnMetadata("ElvUI", "Version") -->> degisecek
A.wowpatch, A.wowbuild = GetBuildInfo()
A.wowbuild = tonumber(A.wowbuild)
A.resolution = GetCVar("gxResolution")
A.screenwidth, A.screenheight = tonumber(match(A.resolution, "(%d+)x+%d")), tonumber(match(A.resolution, "%d+x(%d+)"))
A.isMacClient = IsMacClient()
A.NewSign = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t" -->> degisecek
A.InfoColor = "|cfffe7b2c"

--Tables
A.media = {}
A.frames = {}
A.unitFrameElements = {}
A.statusBars = {}
A.texts = {}
A.snapBars = {}
A.RegisteredModules = {}
A.RegisteredInitialModules = {}
A.ModuleCallbacks = {["CallPriority"] = {}}
A.InitialModuleCallbacks = {["CallPriority"] = {}}
A.valueColorUpdateFuncs = {}
A.TexCoords = {0, 1, 0, 1}
A.VehicleLocks = {}
A.CreditsList = {}

-- ==== Functions
function A:CopyTable(currentTable, defaultTable)
	if type(currentTable) ~= "table" then currentTable = {} end

	if type(defaultTable) == "table" then
		for option, value in pairs(defaultTable) do
			if type(value) == "table" then
				value = self:CopyTable(currentTable[option], value)
			end

			currentTable[option] = value
		end
	end

	return currentTable
end

-- test
-- print(P)
-- print('core not in func')
-- test end

-- ==== Core Init [last arg]
function A:Initialize()

	-- test
	-- print(P)
	-- print('core')
	-- test end

	-- twipe(self.db)
	-- twipe(self.global)
	-- twipe(self.private)

	self.myguid = UnitGUID("player")
	self.data = A.Libs.AceDB:New(N.."DB", self.DF)
	-- self.data.RegisterCallback(self, "OnProfileChanged", "UpdateAll")
	-- self.data.RegisterCallback(self, "OnProfileCopied", "UpdateAll")
	-- self.data._ResetProfile = self.data.ResetProfile
	-- self.data.ResetProfile = self.OnProfileReset
	self.charSettings = A.Libs.AceDB:New(N.."PrivateDB", self.privateVars)
	self.private = self.charSettings.profile
	self.db = self.data.profile
	self.global = self.data.global


	-- self:InitializeModules()
	self.initialized = true

	-- Minimap:UpdateSettings()

	-- if self.db.general.loginmessage then
	-- 	local msg = format(L["LOGIN_MSG"], self.media.hexvaluecolor, self.media.hexvaluecolor, self.version)
	-- 	if Chat.Initialized then msg = select(2, Chat:FindURL("CHAT_MSG_DUMMY", msg)) end
	-- 	print(msg)
	-- end

	if not GetCVar("scriptProfile") == "1" then
		collectgarbage("collect")
	end
end