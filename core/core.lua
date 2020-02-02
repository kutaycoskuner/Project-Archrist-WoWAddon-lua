local Arch = select(2, ...)

-- local gameLocale
-- do -- Locale doesn't exist yet, make it exist.
-- 	local convert = {["enGB"] = "enUS", ["esES"] = "esMX", ["itIT"] = "enUS"}
-- 	local lang = GetLocale()

-- 	gameLocale = convert[lang] or lang or "enUS"
-- 	ElvUI[2] = ElvUI[1].Libs.ACL:GetLocale("ElvUI", gameLocale)
-- end

local main, L, V, P, G = unpack(Arch); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

-- local ActionBars = E:GetModule("ActionBars")
-- local AFK = E:GetModule("AFK")
-- local Auras = E:GetModule("Auras")
-- local Bags = E:GetModule("Bags")
-- local Blizzard = E:GetModule("Blizzard")
-- local Chat = E:GetModule("Chat")
-- local DataBars = E:GetModule("DataBars")
-- local DataTexts = E:GetModule("DataTexts")
-- local Layout = E:GetModule("Layout")
-- local Minimap = E:GetModule("Minimap")
-- local NamePlates = E:GetModule("NamePlates")
-- local Threat = E:GetModule("Threat")
-- local Tooltip = E:GetModule("Tooltip")
-- local Totems = E:GetModule("Totems")
-- local ReminderBuffs = E:GetModule("ReminderBuffs")
-- local UnitFrames = E:GetModule("UnitFrames")

-- local LSM = E.Libs.LSM

-- :: Lua functions
local _G = _G
local tonumber, pairs, ipairs, error, unpack, select, tostring = tonumber, pairs, ipairs, error, unpack, select, tostring
local assert, type, print = assert, type, print
local twipe, tinsert, tremove, next = table.wipe, tinsert, tremove, next
local format, find, match, strrep, strlen, sub, gsub, strjoin = string.format, string.find, string.match, strrep, strlen, string.sub, string.gsub, strjoin
-- :: WoW API / Variables
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

-- :: Constants
main.noop = function() end
main.title = format("|cff1784d1E|r|cffe5e3e3lvUI|r")
main.myfaction, main.myLocalizedFaction = UnitFactionGroup("player")
main.mylevel = UnitLevel("player")
main.myLocalizedClass, main.myclass = UnitClass("player")
main.myLocalizedRace, main.myrace = UnitRace("player")
main.myname = UnitName("player")
main.myrealm = GetRealmName()
main.version = GetAddOnMetadata("ElvUI", "Version")
main.wowpatch, main.wowbuild = GetBuildInfo()
main.wowbuild = tonumber(main.wowbuild)
main.resolution = GetCVar("gxResolution")
main.screenwidth, main.screenheight = tonumber(match(main.resolution, "(%d+)x+%d")), tonumber(match(main.resolution, "%d+x(%d+)"))
main.isMacClient = IsMacClient()
main.NewSign = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t"
main.InfoColor = "|cfffe7b2c"

-- :: Tables
main.media = {}
main.frames = {}
main.unitFrameElements = {}
main.statusBars = {}
main.texts = {}
main.snapBars = {}
main.RegisteredModules = {}
main.RegisteredInitialModules = {}
main.ModuleCallbacks = {["CallPriority"] = {}}
main.InitialModuleCallbacks = {["CallPriority"] = {}}
main.valueColorUpdateFuncs = {}
main.TexCoords = {0, 1, 0, 1}
main.VehicleLocks = {}
main.CreditsList = {}

main.InversePoints = {
	TOP = "BOTTOM",
	BOTTOM = "TOP",
	TOPLEFT = "BOTTOMLEFT",
	TOPRIGHT = "BOTTOMRIGHT",
	LEFT = "RIGHT",
	RIGHT = "LEFT",
	BOTTOMLEFT = "TOPLEFT",
	BOTTOMRIGHT = "TOPRIGHT",
	CENTER = "CENTER"
}

main.HealingClasses = {
	PALADIN = 1,
	SHAMAN = 3,
	DRUID = 3,
	PRIEST = {1, 2}
}

main.ClassRole = {
	PALADIN = {
		[1] = "Caster",
		[2] = "Tank",
		[3] = "Melee"
	},
	PRIEST = "Caster",
	WARLOCK = "Caster",
	WARRIOR = {
		[1] = "Melee",
		[2] = "Melee",
		[3] = "Tank"
	},
	HUNTER = "Melee",
	SHAMAN = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Caster"
	},
	ROGUE = "Melee",
	MAGE = "Caster",
	DEATHKNIGHT = {
		[1] = "Tank",
		[2] = "Melee",
		[3] = "Melee"
	},
	DRUID = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Caster"
	}
}

main.DispelClasses = {
	PRIEST = {Magic = true, Disease = true},
	SHAMAN = {Poison = true, Disease = true, Curse = false},
	PALADIN = {Poison = true, Magic = true, Disease = true},
	MAGE = {Curse = true},
	DRUID = {Curse = true, Poison = true}
}

local colorizedName
function main:ColorizedName(name, arg2)
	local length = strlen(name)
	for i = 1, length do
		local letter = sub(name, i, i)
		if i == 1 then
			colorizedName = format("|cff1784d1%s", letter)
		elseif i == 2 then
			colorizedName = format("%s|r|cffe5e3e3%s", colorizedName, letter)
		elseif i == length and arg2 then
			colorizedName = format("%s%s|r|cff1784d1:|r", colorizedName, letter)
		else
			colorizedName = colorizedName..letter
		end
	end
	return colorizedName
end

-- :: Workaround for people wanting to use white and it reverting to their class color.
main.PriestColors = {r = 0.99, g = 0.99, b = 0.99}

-- :: This frame everything in ElvUI should be anchored to for Eyefinity support.
main.UIParent = CreateFrame("Frame", "ArchGUIParent", UIParent)
main.UIParent:SetFrameLevel(UIParent:GetFrameLevel())
main.UIParent:SetSize(UIParent:GetSize())
main.UIParent:SetPoint("CENTER", UIParent, "CENTER")
main.snapBars[#main.snapBars + 1] = main.UIParent

-- -- main.HiddenFrame = CreateFrame("Frame")
-- -- main.HiddenFrame:Hide()

-- -- do -- used in optionsUI
-- -- 	E.DEFAULT_FILTER = {}
-- -- 	for filter, tbl in pairs(G.unitframe.aurafilters) do
-- -- 		E.DEFAULT_FILTER[filter] = tbl.type
-- -- 	end
-- -- end

-- -- function main:Print(...)
-- -- 	(_G[self.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin(" ", self:ColorizedName("ElvUI", true), ...)) -- I put DEFAULT_CHAT_FRAME as a fail safe.
-- -- end

-- local delayedTimer
-- local delayedFuncs = {}
-- function main:ShapeshiftDelayedUpdate(func, ...)
-- 	delayedFuncs[func] = {...}

-- 	if delayedTimer then return end

-- 	delayedTimer = main:ScheduleTimer(function()
-- 		for f in pairs(delayedFuncs) do
-- 			f(unpack(delayedFuncs[f]))
-- 		end

-- 		twipe(delayedFuncs)
-- 		delayedTimer = nil
-- 	end, 0.05)
-- end

-- -- function E:GrabColorPickerValues(r, g, b)
-- -- 	-- we must block the execution path to `ColorCallback` in `AceGUIWidget-ColorPicker-ElvUI`
-- -- 	-- in order to prevent an infinite loop from `OnValueChanged` when passing into `E.UpdateMedia` which eventually leads here again.
-- -- 	ColorPickerFrame.noColorCallback = true

-- -- 	-- grab old values
-- -- 	local oldR, oldG, oldB = ColorPickerFrame:GetColorRGB()

-- -- 	-- set and define the new values
-- -- 	ColorPickerFrame:SetColorRGB(r, g, b)
-- -- 	r, g, b = ColorPickerFrame:GetColorRGB()

-- -- 	-- swap back to the old values
-- -- 	if oldR then ColorPickerFrame:SetColorRGB(oldR, oldG, oldB) end

-- -- 	-- free it up..
-- -- 	ColorPickerFrame.noColorCallback = nil

-- -- 	return r, g, b
-- -- end

-- :: Basically check if another class border is being used on a class that doesn't match. And then return true if a match is found.
function main:CheckClassColor(r, g, b)
	r, g, b = main:GrabColorPickerValues(r, g, b)
	local matchFound = false
	for class in pairs(RAID_CLASS_COLORS) do
		if class ~= main.myclass then
			local colorTable = class == "PRIEST" and main.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class])
			local red, green, blue = main:GrabColorPickerValues(colorTable.r, colorTable.g, colorTable.b)
			if red == r and green == g and blue == b then
				matchFound = true
			end
		end
	end

	return matchFound
end

-- function main:SetColorTable(t, data)
-- 	if not data.r or not data.g or not data.b then
-- 		error("SetColorTable: Could not unpack color values.")
-- 	end

-- 	if t and (type(t) == "table") then
-- 		t[1], t[2], t[3], t[4] = main:UpdateColorTable(data)
-- 	else
-- 		t = main:GetColorTable(data)
-- 	end

-- 	return t
-- end

-- function main:UpdateColorTable(data)
-- 	if not data.r or not data.g or not data.b then
-- 		error("UpdateColorTable: Could not unpack color values.")
-- 	end

-- 	if (data.r > 1 or data.r < 0) then data.r = 1 end
-- 	if (data.g > 1 or data.g < 0) then data.g = 1 end
-- 	if (data.b > 1 or data.b < 0) then data.b = 1 end
-- 	if data.a and (data.a > 1 or data.a < 0) then data.a = 1 end

-- 	if data.a then
-- 		return data.r, data.g, data.b, data.a
-- 	else
-- 		return data.r, data.g, data.b
-- 	end
-- end

-- function main:GetColorTable(data)
-- 	if not data.r or not data.g or not data.b then
-- 		error("GetColorTable: Could not unpack color values.")
-- 	end

-- 	if (data.r > 1 or data.r < 0) then data.r = 1 end
-- 	if (data.g > 1 or data.g < 0) then data.g = 1 end
-- 	if (data.b > 1 or data.b < 0) then data.b = 1 end
-- 	if data.a and (data.a > 1 or data.a < 0) then data.a = 1 end

-- 	if data.a then
-- 		return {data.r, data.g, data.b, data.a}
-- 	else
-- 		return {data.r, data.g, data.b}
-- 	end
-- end

function main:UpdateMedia()
	if not self.db.general or not self.private.general then return end --Prevent rare nil value errors

	-- Fonts
	self.media.normFont = LSM:Fetch("font", self.db.general.font)
	self.media.combatFont = LSM:Fetch("font", self.private.general.dmgfont)

	-- Textures
	self.media.blankTex = LSM:Fetch("background", "ElvUI Blank")
	self.media.normTex = LSM:Fetch("statusbar", self.private.general.normTex)
	self.media.glossTex = LSM:Fetch("statusbar", self.private.general.glossTex)

	-- Border Color
	local border = main.db.general.bordercolor
	if self:CheckClassColor(border.r, border.g, border.b) then
		local classColor = main.myclass == "PRIEST" and main.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[main.myclass] or RAID_CLASS_COLORS[main.myclass])
		main.db.general.bordercolor.r = classColor.r
		main.db.general.bordercolor.g = classColor.g
		main.db.general.bordercolor.b = classColor.b
	end

	self.media.bordercolor = {border.r, border.g, border.b}

	-- UnitFrame Border Color
	border = main.db.unitframe.colors.borderColor
	if self:CheckClassColor(border.r, border.g, border.b) then
		local classColor = main.myclass == "PRIEST" and main.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[main.myclass] or RAID_CLASS_COLORS[main.myclass])
		main.db.unitframe.colors.borderColor.r = classColor.r
		main.db.unitframe.colors.borderColor.g = classColor.g
		main.db.unitframe.colors.borderColor.b = classColor.b
	end
	self.media.unitframeBorderColor = {border.r, border.g, border.b}

	-- Backdrop Color
	self.media.backdropcolor = main:SetColorTable(self.media.backdropcolor, self.db.general.backdropcolor)

	-- Backdrop Fade Color
	self.media.backdropfadecolor = main:SetColorTable(self.media.backdropfadecolor, self.db.general.backdropfadecolor)

	-- Value Color
	local value = self.db.general.valuecolor

	if self:CheckClassColor(value.r, value.g, value.b) then
		value = main.myclass == "PRIEST" and main.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[main.myclass] or RAID_CLASS_COLORS[main.myclass])
		self.db.general.valuecolor.r = value.r
		self.db.general.valuecolor.g = value.g
		self.db.general.valuecolor.b = value.b
	end

	self.media.hexvaluecolor = self:RGBToHex(value.r, value.g, value.b)
	self.media.rgbvaluecolor = {value.r, value.g, value.b}

	if LeftChatPanel and LeftChatPanel.tex and RightChatPanel and RightChatPanel.tex then
		LeftChatPanel.tex:SetTexture(main.db.chat.panelBackdropNameLeft)
		local a = main.db.general.backdropfadecolor.a or 0.5
		LeftChatPanel.tex:SetAlpha(a)

		RightChatPanel.tex:SetTexture(main.db.chat.panelBackdropNameRight)
		RightChatPanel.tex:SetAlpha(a)
	end

	self:ValueFuncCall()
	self:UpdateBlizzardFonts()
end

-- do	
-- :: Update font/texture paths when they are registered by the addon providing them
-- :: This helps fix most of the issues with fonts or textures reverting to default because the addon providing them is loading after ElvUI.
-- :: We use a wrapper to avoid errors in :UpdateMedia because "self" is passed to the function with a value other than ElvUI.
-- 	local function LSMCallback() main:UpdateMedia() end
-- 	LSM.RegisterCallback(main, "LibSharedMedia_Registered", LSMCallback)
-- end

-- function main:ValueFuncCall()
-- 	for func in pairs(self.valueColorUpdateFuncs) do
-- 		func(self.media.hexvaluecolor, unpack(self.media.rgbvaluecolor))
-- 	end
-- end

-- function main:UpdateFrameTemplates()
-- 	for frame in pairs(self.frames) do
-- 		if frame and frame.template and not frame.ignoreUpdates then
-- 			if not frame.ignoreFrameTemplates then
-- 				frame:SetTemplate(frame.template, frame.glossTex, nil, frame.forcePixelMode)
-- 			end
-- 		else
-- 			self.frames[frame] = nil
-- 		end
-- 	end

-- 	for frame in pairs(self.unitFrameElements) do
-- 		if frame and frame.template and not frame.ignoreUpdates then
-- 			if not frame.ignoreFrameTemplates then
-- 				frame:SetTemplate(frame.template, frame.glossTex, nil, frame.forcePixelMode, frame.isUnitFrameElement)
-- 			end
-- 		else
-- 			self.unitFrameElements[frame] = nil
-- 		end
-- 	end
-- end

-- function main:UpdateBorderColors()
-- 	for frame in pairs(self.frames) do
-- 		if frame and not frame.ignoreUpdates then
-- 			if not frame.ignoreBorderColors then
-- 				if frame.template == "Default" or frame.template == "Transparent" or frame.template == nil then
-- 					frame:SetBackdropBorderColor(unpack(self.media.bordercolor))
-- 				end
-- 			end
-- 		else
-- 			self.frames[frame] = nil
-- 		end
-- 	end

-- 	for frame in pairs(self.unitFrameElements) do
-- 		if frame and not frame.ignoreUpdates then
-- 			if not frame.ignoreBorderColors then
-- 				if frame.template == "Default" or frame.template == "Transparent" or frame.template == nil then
-- 					frame:SetBackdropBorderColor(unpack(self.media.unitframeBorderColor))
-- 				end
-- 			end
-- 		else
-- 			self.unitFrameElements[frame] = nil
-- 		end
-- 	end
-- end

-- function main:UpdateBackdropColors()
-- 	for frame in pairs(self.frames) do
-- 		if frame and not frame.ignoreUpdates then
-- 			if not frame.ignoreBackdropColors then
-- 				if frame.template == "Default" or frame.template == nil then
-- 					frame:SetBackdropColor(unpack(self.media.backdropcolor))
-- 				elseif frame.template == "Transparent" then
-- 					frame:SetBackdropColor(unpack(self.media.backdropfadecolor))
-- 				end
-- 			end
-- 		else
-- 			self.frames[frame] = nil
-- 		end
-- 	end

-- 	for frame in pairs(self.unitFrameElements) do
-- 		if frame and not frame.ignoreUpdates then
-- 			if not frame.ignoreBackdropColors then
-- 				if frame.template == "Default" or frame.template == nil then
-- 					frame:SetBackdropColor(unpack(self.media.backdropcolor))
-- 				elseif frame.template == "Transparent" then
-- 					frame:SetBackdropColor(unpack(self.media.backdropfadecolor))
-- 				end
-- 			end
-- 		else
-- 			self.unitFrameElements[frame] = nil
-- 		end
-- 	end
-- end

-- function main:UpdateFontTemplates()
-- 	for text in pairs(self.texts) do
-- 		if text then
-- 			text:FontTemplate(text.font, text.fontSize, text.fontStyle)
-- 		else
-- 			self.texts[text] = nil
-- 		end
-- 	end
-- end

-- function main:RegisterStatusBar(statusBar)
-- 	tinsert(self.statusBars, statusBar)
-- end

-- function main:UpdateStatusBars()
-- 	for _, statusBar in pairs(self.statusBars) do
-- 		if statusBar and statusBar:IsObjectType("StatusBar") then
-- 			statusBar:SetStatusBarTexture(self.media.normTex)
-- 		elseif statusBar and statusBar:IsObjectType("Texture") then
-- 			statusBar:SetTexture(self.media.normTex)
-- 		end
-- 	end
-- end

-- function main:IncompatibleAddOn(addon, module)
-- 	main.PopupDialogs.INCOMPATIBLE_ADDON.button1 = addon
-- 	main.PopupDialogs.INCOMPATIBLE_ADDON.button2 = "ElvUI "..module
-- 	main.PopupDialogs.INCOMPATIBLE_ADDON.addon = addon
-- 	main.PopupDialogs.INCOMPATIBLE_ADDON.module = module
-- 	main:StaticPopup_Show("INCOMPATIBLE_ADDON", addon, module)
-- end

-- function main:IsAddOnEnabled(addon)
-- 	local _, _, _, enabled, _, reason = GetAddOnInfo(addon)
-- 	if reason ~= "MISSING" and enabled then
-- 		return true
-- 	end
-- end

-- function main:CheckIncompatible()
-- 	if main.global.ignoreIncompatible then return end

-- 	if main.private.chat.enable then
-- 		if self:IsAddOnEnabled("Prat-3.0") then
-- 			self:IncompatibleAddOn("Prat-3.0", "Chat")
-- 		elseif self:IsAddOnEnabled("Chatter") then
-- 			self:IncompatibleAddOn("Chatter", "Chat")
-- 		end
-- 	end

-- 	if main.private.nameplates.enable then
-- 		if self:IsAddOnEnabled("Aloft") then
-- 			self:IncompatibleAddOn("Aloft", "NamePlates")
-- 		elseif self:IsAddOnEnabled("Healers-Have-To-Die") then
-- 			self:IncompatibleAddOn("Healers-Have-To-Die", "NamePlates")
-- 		elseif self:IsAddOnEnabled("TidyPlates") then
-- 			self:IncompatibleAddOn("TidyPlates", "NamePlates")
-- 		end
-- 	end

-- 	if main.private.tooltip.enable and self:IsAddOnEnabled("TipTac") then
-- 		self:IncompatibleAddOn("TipTac", "Tooltip")
-- 	end

-- 	if main.private.worldmap.enable and self:IsAddOnEnabled("Mapster") then
-- 		self:IncompatibleAddOn("Mapster", "WorldMap")
-- 	end
-- end

-- function main:CopyTable(currentTable, defaultTable)
-- 	if type(currentTable) ~= "table" then currentTable = {} end

-- 	if type(defaultTable) == "table" then
-- 		for option, value in pairs(defaultTable) do
-- 			if type(value) == "table" then
-- 				value = self:CopyTable(currentTable[option], value)
-- 			end

-- 			currentTable[option] = value
-- 		end
-- 	end

-- 	return currentTable
-- end

-- function main:RemoveEmptySubTables(tbl)
-- 	if type(tbl) ~= "table" then
-- 		main:Print("Bad argument #1 to 'RemoveEmptySubTables' (table expected)")
-- 		return
-- 	end

-- 	for k, v in pairs(tbl) do
-- 		if type(v) == "table" then
-- 			if next(v) == nil then
-- 				tbl[k] = nil
-- 			else
-- 				self:RemoveEmptySubTables(v)
-- 			end
-- 		end
-- 	end
-- end

-- --Compare 2 tables and remove duplicate key/value pairs
-- --param cleanTable : table you want cleaned
-- --param checkTable : table you want to check against.
-- --return : a copy of cleanTable with duplicate key/value pairs removed
-- function main:RemoveTableDuplicates(cleanTable, checkTable)
-- 	if type(cleanTable) ~= "table" then
-- 		main:Print("Bad argument #1 to 'RemoveTableDuplicates' (table expected)")
-- 		return
-- 	end
-- 	if type(checkTable) ~= "table" then
-- 		main:Print("Bad argument #2 to 'RemoveTableDuplicates' (table expected)")
-- 		return
-- 	end

-- 	local rtdCleaned = {}
-- 	for option, value in pairs(cleanTable) do
-- 		if type(value) == "table" and checkTable[option] and type(checkTable[option]) == "table" then
-- 			rtdCleaned[option] = self:RemoveTableDuplicates(value, checkTable[option])
-- 		else
-- 			-- Add unique data to our clean table
-- 			if cleanTable[option] ~= checkTable[option] then
-- 				rtdCleaned[option] = value
-- 			end
-- 		end
-- 	end

-- 	--Clean out empty sub-tables
-- 	self:RemoveEmptySubTables(rtdCleaned)

-- 	return rtdCleaned
-- end

-- :: Compare 2 tables and remove blacklisted key/value pairs
-- :: param cleanTable : table you want cleaned
-- :: param blacklistTable : table you want to check against.
-- :: return : a copy of cleanTable with blacklisted key/value pairs removed
function main:FilterTableFromBlacklist(cleanTable, blacklistTable)
	if type(cleanTable) ~= "table" then
		main:Print("Bad argument #1 to 'FilterTableFromBlacklist' (table expected)")
		return
	end
	if type(blacklistTable) ~= "table" then
		main:Print("Bad argument #2 to 'FilterTableFromBlacklist' (table expected)")
		return
	end

	local tfbCleaned = {}
	for option, value in pairs(cleanTable) do
		if type(value) == "table" and blacklistTable[option] and type(blacklistTable[option]) == "table" then
			tfbCleaned[option] = self:FilterTableFromBlacklist(value, blacklistTable[option])
		else
			-- Filter out blacklisted keys
			if blacklistTable[option] ~= true then
				tfbCleaned[option] = value
			end
		end
	end

	-- :: Clean out empty sub-tables
	self:RemoveEmptySubTables(tfbCleaned)

	return tfbCleaned
end

do	-- :: The code in this function is from WeakAuras, credit goes to Mirrored and the WeakAuras Team
	-- :: Code slightly modified by Simpy
	local function recurse(table, level, ret)
		for i, v in pairs(table) do
			ret = ret..strrep("    ", level).."["
			if type(i) == "string" then ret = ret..'"'..i..'"' else ret = ret..i end
			ret = ret.."] = "

			if type(v) == "number" then
				ret = ret..v..",\n"
			elseif type(v) == "string" then
				ret = ret.."\""..gsub(gsub(gsub(gsub(v, "\\", "\\\\"), "\n", "\\n"), "\"", "\\\""), "\124", "\124\124").."\",\n"
			elseif type(v) == "boolean" then
				if v then ret = ret.."true,\n" else ret = ret.."false,\n" end
			elseif type(v) == "table" then
				ret = ret.."{\n"
				ret = recurse(v, level + 1, ret)
				ret = ret..strrep("    ", level).."},\n"
			else
				ret = ret.."\""..tostring(v).."\",\n"
			end
		end

		return ret
	end

	function main:TableToLuaString(inTable)
		if type(inTable) ~= "table" then
			main:Print("Invalid argument #1 to main:TableToLuaString (table expected)")
			return
		end

		local ret = "{\n"
		if inTable then ret = recurse(inTable, 1, ret) end
		ret = ret.."}"

		return ret
	end
end

do	-- :: The code in this function is from WeakAuras, credit goes to Mirrored and the WeakAuras Team
	-- :: Code slightly modified by Simpy
	local lineStructureTable, profileFormat = {}, {
		profile = "main.db",
		private = "main.private",
		global = "main.global",
		filters = "main.global",
		styleFilters = "main.global"
	}

	local function buildLineStructure(str) -- str is profileText
		for _, v in ipairs(lineStructureTable) do
			if type(v) == "string" then
				str = str..'["'..v..'"]'
			else
				str = str..'['..v..']'
			end
		end

		return str
	end

	local sameLine
	local function recurse(tbl, ret, profileText)
		local lineStructure = buildLineStructure(profileText)
		for k, v in pairs(tbl) do
			if not sameLine then
				ret = ret..lineStructure
			end

			ret = ret.."["

			if type(k) == "string" then
				ret = ret..'"'..k..'"'
			else
				ret = ret..k
			end

			if type(v) == "table" then
				tinsert(lineStructureTable, k)
				sameLine = true
				ret = ret.."]"
				ret = recurse(v, ret, profileText)
			else
				sameLine = false
				ret = ret.."] = "

				if type(v) == "number" then
					ret = ret..v.."\n"
				elseif type(v) == "string" then
					ret = ret.."\""..gsub(gsub(gsub(gsub(v, "\\", "\\\\"), "\n", "\\n"), "\"", "\\\""), "\124", "\124\124").."\"\n"
				elseif type(v) == "boolean" then
					if v then
						ret = ret.."true\n"
					else
						ret = ret.."false\n"
					end
				else
					ret = ret.."\""..tostring(v).."\"\n"
				end
			end
		end

		tremove(lineStructureTable)

		return ret
	end

	function main:ProfileTableToPluginFormat(inTable, profileType)
		local profileText = profileFormat[profileType]
		if not profileText then return end

		twipe(lineStructureTable)
		local ret = ""
		if inTable and profileType then
			sameLine = false
			ret = recurse(inTable, ret, profileText)
		end

		return ret
	end
end

-- :: Split string by multi-character delimiter (the strsplit / string.split function provided by WoW doesn't allow multi-character delimiter)
do	
	local splitTable = {}
	function main:SplitString(str, delim)
		assert(type (delim) == "string" and strlen(delim) > 0, "bad delimiter")

		local start = 1
		twipe(splitTable) -- results table

		-- find each instance of a string followed by the delimiter
		while true do
			local pos = find(str, delim, start, true) -- plain find
			if not pos then break end

			tinsert(splitTable, sub(str, start, pos - 1))
			start = pos + strlen(delim)
		end -- while

		-- insert final one (after last delimiter)
		tinsert(splitTable, sub(str, start))

		return unpack(splitTable)
	end
end

-- do
-- 	local SendMessageWaiting
-- 	local SendRecieveGroupSize = 0

-- 	function main:SendMessage()
-- 		if GetNumRaidMembers() > 1 then
-- 			local _, instanceType = IsInInstance()
-- 			if instanceType == "pvp" then
-- 				SendAddonMessage("ELVUI_VERSIONCHK", main.version, "BATTLEGROUND")
-- 			else
-- 				SendAddonMessage("ELVUI_VERSIONCHK", main.version, "RAID")
-- 			end
-- 		elseif GetNumPartyMembers() > 0 then
-- 			SendAddonMessage("ELVUI_VERSIONCHK", main.version, "PARTY")
-- 		elseif IsInGuild() then
-- 			SendAddonMessage("ELVUI_VERSIONCHK", main.version, "GUILD")
-- 		end

-- 		SendMessageWaiting = nil
-- 	end

-- 	local function SendRecieve(_, event, prefix, message, _, sender)
-- 		if event == "CHAT_MSG_ADDON" then
-- 			if prefix ~= "ELVUI_VERSIONCHK" then return end
-- 			if not sender or sender == main.myname then return end

-- 			local ver = tonumber(main.version)
-- 			message = tonumber(message)

-- 			if ver ~= G.general.version then
-- 				if not main.shownUpdatedWhileRunningPopup and not InCombatLockdown() then
-- 					main:StaticPopup_Show("ELVUI_UPDATED_WHILE_RUNNING")

-- 					main.shownUpdatedWhileRunningPopup = true
-- 				end
-- 			elseif message and (message > ver) then
-- 				if not main.recievedOutOfDateMessage then
-- 					main:Print(L["ElvUI is out of date. You can download the newest version from https://github.com/ElvUI-WotLK/ElvUI"])

-- 					if message and ((message - ver) >= 0.01) and not InCombatLockdown() then
-- 						main:StaticPopup_Show("ELVUI_UPDATE_AVAILABLE")
-- 					end

-- 					main.recievedOutOfDateMessage = true
-- 				end
-- 			end
-- 		elseif event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" then
-- 			local numRaid = GetNumRaidMembers()
-- 			local num = numRaid > 0 and numRaid or (GetNumPartyMembers() + 1)
-- 			if num ~= SendRecieveGroupSize then
-- 				if num > 1 and num > SendRecieveGroupSize then
-- 					if not SendMessageWaiting then
-- 						SendMessageWaiting = main:Delay(10, main.SendMessage)
-- 					end
-- 				end
-- 				SendRecieveGroupSize = num
-- 			end
-- 		elseif event == "PLAYER_ENTERING_WORLD" then
-- 			if not SendMessageWaiting then
-- 				SendMessageWaiting = main:Delay(10, main.SendMessage)
-- 			end
-- 		end
-- 	end

-- 	local f = CreateFrame("Frame")
-- 	f:RegisterEvent("CHAT_MSG_ADDON")
-- 	f:RegisterEvent("RAID_ROSTER_UPDATE")
-- 	f:RegisterEvent("PARTY_MEMBERS_CHANGED")
-- 	f:RegisterEvent("PLAYER_ENTERING_WORLD")
-- 	f:SetScript("OnEvent", SendRecieve)
-- end

function main:UpdateAll(ignoreInstall)
	main.private = main.charSettings.profile
	main.db = main.data.profile
	main.global = main.data.global
	main.db.theme = nil
	main.db.install_complete = nil

	main:DBConversions()

	ActionBars.db = main.db.actionbar
	Auras.db = main.db.auras
	Bags.db = main.db.bags
	Chat.db = main.db.chat
	DataBars.db = main.db.databars
	DataTexts.db = main.db.datatexts
	NamePlates.db = main.db.nameplates
	Threat.db = main.db.general.threat
	Tooltip.db = main.db.tooltip
	Totems.db = main.db.general.totems
	ReminderBuffs.db = main.db.general.reminder
	UnitFrames.db = main.db.unitframe

	--The mover is positioned before it is resized, which causes issues for unitframes
	--Allow movers to be "pushed" outside the screen, when they are resized they should be back in the screen area.
	--We set movers to be clamped again at the bottom of this function.
	main:SetMoversClampedToScreen(false)
	main:SetMoversPositions()

	main:UpdateMedia()
	main:UpdateBorderColors()
	main:UpdateBackdropColors()
	main:UpdateFrameTemplates()
	main:UpdateStatusBars()
	-- main:UpdateCooldownSettings("all")

	Layout:ToggleChatPanels()
	Layout:BottomPanelVisibility()
	Layout:TopPanelVisibility()
	Layout:SetDataPanelStyle()

	if main.private.actionbar.enable then
		ActionBars:ToggleDesaturation()
		ActionBars:UpdateButtonSettings()
		ActionBars:UpdateMicroPositionDimensions()
	end

	AFK:Toggle()

	if main.private.bags.enable then
		Bags:Layout()
		Bags:Layout(true)
		Bags:SizeAndPositionBagBar()
		Bags:UpdateCountDisplay()
		Bags:UpdateItemLevelDisplay()
	end

	if main.private.chat.enable then
		Chat:PositionChat(true)
		Chat:SetupChat()
		Chat:UpdateAnchors()
	end

	DataBars:EnableDisable_ExperienceBar()
	DataBars:EnableDisable_ReputationBar()
	DataBars:UpdateDataBarDimensions()

	DataTexts:LoadDataTexts()

	if main.private.general.minimap.enable then
		Minimap:UpdateSettings()
	end

	if main.private.nameplates.enable then
		NamePlates:ConfigureAll()
		NamePlates:StyleFilterInitialize()
	end

	Threat:ToggleEnable()
	Threat:UpdatePosition()

	if main.myclass == "SHAMAN" then
		Totems:ToggleEnable()
		Totems:PositionAndSize()
	end

	ReminderBuffs:UpdateSettings()

	if main.private.unitframe.enable then
		UnitFrames:Update_AllFrames()
	end

	if ElvUIPlayerBuffs then
		Auras:UpdateHeader(ElvUIPlayerBuffs)
	end

	if ElvUIPlayerDebuffs then
		Auras:UpdateHeader(ElvUIPlayerDebuffs)
	end

	if main.RefreshGUI then
		main:RefreshGUI()
	end

	if not ignoreInstall and not main.private.install_complete then
		main:Install()
	end

	Blizzard:SetWatchFrameHeight()
	main:SetMoversClampedToScreen(true) -- Go back to using clamp after resizing has taken place.
end

do
	main.ObjectEventTable, main.ObjectEventFrame = {}, CreateFrame("Frame")
	local eventFrame, eventTable = main.ObjectEventFrame, main.ObjectEventTable

	eventFrame:SetScript("OnEvent", function(_, event, ...)
		local objs = eventTable[event]
		if objs then
			for object, funcs in pairs(objs) do
				for _, func in ipairs(funcs) do
					func(object, event, ...)
				end
			end
		end
	end)

	function main:HasFunctionForObject(event, object, func)
		if not (event and object and func) then
			main:Print("Error. Usage: HasFunctionForObject(event, object, func)")
			return
		end

		local objs = eventTable[event]
		local funcs = objs and objs[object]
		return funcs and tContains(funcs, func)
	end

	function main:IsEventRegisteredForObject(event, object)
		if not (event and object) then
			main:Print("Error. Usage: IsEventRegisteredForObject(event, object)")
			return
		end

		local objs = eventTable[event]
		local funcs = objs and objs[object]
		return funcs ~= nil, funcs
	end

-- -- 	:: Registers specified event and adds specified func to be called for the specified object.
-- -- 	:: Unless all parameters are supplied it will not register.
-- -- 	:: If the specified object has already been registered for the specified event
-- -- 	:: then it will just add the specified func to a table of functions that should be called.
-- -- 	:: When a registered event is triggered, then the registered function is called with
-- -- 	:: the object as first parameter, then event, and then all the parameters for the event itself.
-- -- 	:: @param event The event you want to register.
-- -- 	:: @param object The object you want to register the event for.
-- -- 	:: @param func The function you want executed for this object.
	function main:RegisterEventForObject(event, object, func)
		if not (event and object and func) then
			main:Print("Error. Usage: RegisterEventForObject(event, object, func)")
			return
		end

		local objs = eventTable[event]
		if not objs then
			objs = {}
			eventTable[event] = objs
			eventFrame:RegisterEvent(event)
		end

		local funcs = objs[object]
		if not funcs then
			objs[object] = {func}
		elseif not tContains(funcs, func) then
			tinsert(funcs, func)
		end
	end

-- -- 	:: Unregisters specified function for the specified object on the specified event.
-- -- 	:: Unless all parameters are supplied it will not unregister.
-- -- 	:: @param event The event you want to unregister an object from.
-- -- 	:: @param object The object you want to unregister a func from.
-- -- 	:: @param func The function you want unregistered for the object.
	function main:UnregisterEventForObject(event, object, func)
		if not (event and object and func) then
			main:Print("Error. Usage: UnregisterEventForObject(event, object, func)")
			return
		end

		local objs = eventTable[event]
		local funcs = objs and objs[object]
		if funcs then
			for index, fnc in ipairs(funcs) do
				if func == fnc then
					tremove(funcs, index)
					break
				end
			end

			if #funcs == 0 then
				objs[object] = nil
			end

			if not next(funcs) then
				eventFrame:UnregisterEvent(event)
				eventTable[event] = nil
			end
		end
	end
end

function main:ResetAllUI()
	self:ResetMovers()

	if main.db.layoutSet then
		main:SetupLayout(main.db.layoutSet, true)
	end
end

function main:ResetUI(...)
	if InCombatLockdown() then main:Print(ERR_NOT_IN_COMBAT) return end

	if ... == "" or ... == " " or ... == nil then
		main:StaticPopup_Show("RESETUI_CHECK")
		return
	end

	self:ResetMovers(...)
end

function main:CallLoadedModule(obj, silent, object, index)
	local name, func
	if type(obj) == "table" then name, func = unpack(obj) else name = obj end
	local module = name and self:GetModule(name, silent)

	if not module then return end
	if func and type(func) == "string" then
		main:RegisterCallback(name, module[func], module)
	elseif func and type(func) == "function" then
		main:RegisterCallback(name, func, module)
	elseif module.Initialize then
		main:RegisterCallback(name, module.Initialize, module)
	end

	main.callbacks:Fire(name)

	if object and index then object[index] = nil end
end

function main:RegisterInitialModule(name, func)
	self.RegisteredInitialModules[#self.RegisteredInitialModules + 1] = (func and {name, func}) or name
end

function main:RegisterModule(name, func)
	if self.initialized then
		-- test
		print(name)
		main:CallLoadedModule((func and {name, func}) or name)
	else
		self.RegisteredModules[#self.RegisteredModules + 1] = (func and {name, func}) or name
		-- test
		print(self.RegisteredModules);
	end
end

function main:InitializeInitialModules()
	for index, object in ipairs(main.RegisteredInitialModules) do
		main:CallLoadedModule(object, true, main.RegisteredInitialModules, index)
	end
end

function main:InitializeModules()
	for index, object in ipairs(main.RegisteredModules) do
		main:CallLoadedModule(object, true, main.RegisteredModules, index)
	end
end

-- ==== DATABASE CONVERSIONS
function main:DBConversions()
	-- :: Fix issue where UIScale was incorrectly stored as string
	main.global.general.UIScale = tonumber(main.global.general.UIScale)

	-- :: Not sure how this one happens, but prevent it in any case
	if main.global.general.UIScale <= 0 then
		main.global.general.UIScale = G.general.UIScale
	end

	if gameLocale and main.global.general.locale == "auto" then
		main.global.general.locale = gameLocale
	end

	-- :: Combat & Resting Icon options update
	if main.db.unitframe.units.player.combatIcon ~= nil then
		main.db.unitframe.units.player.CombatIcon.enable = main.db.unitframe.units.player.combatIcon
		main.db.unitframe.units.player.combatIcon = nil
	end
	if main.db.unitframe.units.player.restIcon ~= nil then
		main.db.unitframe.units.player.RestIcon.enable = main.db.unitframe.units.player.restIcon
		main.db.unitframe.units.player.restIcon = nil
	end

	-- :: [Fader] Combat Fade options for Player
	if main.db.unitframe.units.player.combatfade ~= nil then
		local enabled = main.db.unitframe.units.player.combatfade
		main.db.unitframe.units.player.fader.enable = enabled

		if enabled then -- use the old min alpha too
			main.db.unitframe.units.player.fader.minAlpha = 0
		end

		main.db.unitframe.units.player.combatfade = nil
	end

	-- :: [Fader] Range check options for Units
	do
		local outsideAlpha
		if main.db.unitframe.OORAlpha ~= nil then
			outsideAlpha = main.db.unitframe.OORAlpha
			main.db.unitframe.OORAlpha = nil
		end

		local rangeCheckUnits = {"target", "targettarget", "targettargettarget", "focus", "focustarget", "pet", "pettarget", "boss", "arena", "party", "raid", "raid40", "raidpet", "tank", "assist"}
		for _, unit in pairs(rangeCheckUnits) do
			if main.db.unitframe.units[unit].rangeCheck ~= nil then
				local enabled = main.db.unitframe.units[unit].rangeCheck
				main.db.unitframe.units[unit].fader.enable = enabled
				main.db.unitframe.units[unit].fader.range = enabled

				if outsideAlpha then
					main.db.unitframe.units[unit].fader.minAlpha = outsideAlpha
				end

				main.db.unitframe.units[unit].rangeCheck = nil
			end
		end
	end

	-- :: Convert old "Buffs and Debuffs" font size option to individual options
	if main.db.auras.fontSize then
		local fontSize = main.db.auras.fontSize
		main.db.auras.buffs.countFontSize = fontSize
		main.db.auras.buffs.durationFontSize = fontSize
		main.db.auras.debuffs.countFontSize = fontSize
		main.db.auras.debuffs.durationFontSize = fontSize
		main.db.auras.fontSize = nil
	end

	-- :: Convert old private cooldown setting to profile setting
	if main.private.cooldown and (main.private.cooldown.enable ~= nil) then
		main.db.cooldown.enable = main.private.cooldown.enable
		main.private.cooldown.enable = nil
		main.private.cooldown = nil
	end

	if not main.db.chat.panelColorConverted then
		local color = main.db.general.backdropfadecolor
		main.db.chat.panelColor = {r = color.r, g = color.g, b = color.b, a = color.a}
		main.db.chat.panelColorConverted = true
	end

	-- :: Convert cropIcon to tristate
	local cropIcon = main.db.general.cropIcon
	if type(cropIcon) == "boolean" then
		main.db.general.cropIcon = (cropIcon and 2) or 0
	end

	-- :: Vendor Greys option is now in bags table
	if main.db.general.vendorGrays then
		main.db.bags.vendorGrays.enable = main.db.general.vendorGrays
		main.db.general.vendorGrays = nil
		main.db.general.vendorGraysDetails = nil
	end

	-- :: Heal Prediction is now a table instead of a bool
	local healPredictionUnits = {"player", "target", "focus", "pet", "arena", "party", "raid", "raid40", "raidpet"}
	for _, unit in pairs(healPredictionUnits) do
		if type(main.db.unitframe.units[unit].healPrediction) ~= "table" then
			local enabled = main.db.unitframe.units[unit].healPrediction
			main.db.unitframe.units[unit].healPrediction = {}
			main.db.unitframe.units[unit].healPrediction.enable = enabled
		end
	end

	-- :: Health Backdrop Multiplier
	if main.db.unitframe.colors.healthmultiplier ~= nil then
		if main.db.unitframe.colors.healthmultiplier > 0.75 then
			main.db.unitframe.colors.healthMultiplier = 0.75
		else
			main.db.unitframe.colors.healthMultiplier = main.db.unitframe.colors.healthmultiplier
		end

		main.db.unitframe.colors.healthmultiplier = nil
	end

	if sub(main.db.chat.timeStampFormat, -1) == " " then
		main.db.chat.timeStampFormat = sub(main.db.chat.timeStampFormat, 1, -2)
	end
end

function main:RefreshModulesDB()
	-- -- :: this function is specifically used to reference the new database
	-- -- :: onto the unitframe module, its useful dont delete! D:
	-- twipe(UnitFrames.db) -- :: old ref, dont need so clear it
	-- UnitFrames.db = self.db.unitframe -- :: new ref
end

function main:Initialize() -- !!
	twipe(self.db)
	twipe(self.global)
	twipe(self.private)

	self.myguid = UnitGUID("player")
	self.data = main.Libs.AceDB:New("ArchDB", self.DF)
	self.data.RegisterCallback(self, "OnProfileChanged", "UpdateAll")
	self.data.RegisterCallback(self, "OnProfileCopied", "UpdateAll")
	self.data._ResetProfile = self.data.ResetProfile
	self.data.ResetProfile = self.OnProfileReset
	self.charSettings = main.Libs.AceDB:New("ArchPrivateDB", self.privateVars)
	-- main.Libs.DualSpec:EnhanceDatabase(self.data, "ElvUI")
	self.private = self.charSettings.profile
	self.db = self.data.profile
	self.global = self.data.global

	-- self:CheckIncompatible()
	-- self:DBConversions()
	-- self:UIScale()
	-- self:BuildPrefixValues()
	-- self:LoadAPI()
	-- self:LoadCommands()
	self:InitializeModules()
	self:RefreshModulesDB()
	-- self:LoadMovers()
	self:UpdateMedia()
	-- self:UpdateCooldownSettings("all")
	-- self:Tutorials()
	self.initialized = true

	-- Minimap:UpdateSettings()

	-- if main.db.general.smoothingAmount and (main.db.general.smoothingAmount ~= 0.33) then
	-- 	main:SetSmoothingAmount(main.db.general.smoothingAmount)
	-- end

	-- if not self.private.install_complete then
	-- 	self:Install()
	-- end

	-- if self.db.general.loginmessage then
	-- 	local msg = format(L["LOGIN_MSG"], self.media.hexvaluecolor, self.media.hexvaluecolor, self.version)
	-- 	if Chat.Initialized then msg = select(2, Chat:FindURL("CHAT_MSG_DUMMY", msg)) end
	-- 	print(msg)
	-- end

	if not GetCVar("scriptProfile") == "1" then
		collectgarbage("collect")
	end
end