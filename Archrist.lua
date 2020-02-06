-- ==== Project Archrist started at 25-Jan-2020
--[[ 
    Disclaimer: This addon created by inspectation and use of ElvUI
    To load the Addon engine add this to the top of your file:
------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)) --Import: Archrist, Locales, PrivateDB, ProfileDB, GlobalDB
------------------------------------------------------------------------------------------
]] -- ==== Variables
-- :: Lua functions
local _G, min, pairs, strsplit, unpack, wipe, type, tcopy = _G, min, pairs,
                                                            strsplit, unpack,
                                                            wipe, type,
                                                            table.copy
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
local L = LibStub("AceLocale-3.0") --:GetLocale("Archrist") -- :: translations usage: L['<data>']
local AceAddon, AceAddonMinor = LibStub("AceAddon-3.0")
local CallbackHandler = LibStub("CallbackHandler-1.0")
local AddonName, System = ...; -- this declares addon scope variable
local Addon = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
-- :: Addon Decleration
BINDING_HEADER_ARCH = GetAddOnMetadata(..., "Title")
Addon.callbacks = Addon.callbacks or CallbackHandler:New(Addon)
Addon.DF = {profile = {}, global = {}}
Addon.privateVars = {profile = {}} -- Defaults
Addon.options = {type = "group", name = AddonName, args = {}}
--
System[1] = Addon
System[2] = {}
System[3] = Addon.privateVars.profile
System[4] = Addon.DF.profile
System[5] = Addon.DF.global -- ?? dataframe
_G[AddonName] = System

-- ==== Minor Libraries and Modules
do
    -- :: Create a function to add minor libraries
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

    -- :: add minor libraries
    Addon:AddLib("AceAddon", AceAddon, AceAddonMinor)
    Addon:AddLib("AceDB", "AceDB-3.0")
    -- Addon:AddLib("EP", "LibElvUIPlugin-1.0")
    Addon:AddLib("LSM", "LibSharedMedia-3.0")
    -- Addon:AddLib("ACL", "AceLocale-3.0-ElvUI")
    -- Addon:AddLib("LAB", "LibActionButton-1.0-ElvUI")
    -- Addon:AddLib("LAI", "LibAuraInfo-1.0-ElvUI", true)
    -- Addon:AddLib("LBF", "LibButtonFacade", true)
    -- Addon:AddLib("LDB", "LibDataBroker-1.1")
    -- Addon:AddLib("DualSpec", "LibDualSpec-1.0")
    -- Addon:AddLib("SimpleSticky", "LibSimpleSticky-1.0")
    -- Addon:AddLib("SpellRange", "SpellRange-1.0")
    -- Addon:AddLib("ItemSearch", "LibItemSearch-1.2-ElvUI")
    -- Addon:AddLib("Compress", "LibCompress")
    -- Addon:AddLib("Base64", "LibBase64-1.0-ElvUI")
    -- Addon:AddLib("Translit", "LibTranslit-1.0")
    -- added on ElvUI_OptionsUI load: AceGUI, AceConfig, AceConfigDialog, AceConfigRegistry, AceDBOptions

    -- :: whatever is that means backwards compatible for plugins
    -- Addon.LSM = Addon.Libs.LSM
    -- Addon.Masque = Addon.Libs.Masque
end

-- :: Modules
Addon.test = Addon:NewModule("test", "AceHook-3.0", "AceEvent-3.0")
Addon.lootMsgFilter = Addon:NewModule("lootMsgFilter")
Addon.Distributor = Addon:NewModule("Distributor", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
Addon.ActionBars = Addon:NewModule("ActionBars", "AceHook-3.0", "AceEvent-3.0")
-- :: Macros
Addon.milling = Addon:NewModule("milling", "AceHook-3.0", "AceEvent-3.0")
Addon.raidWarnings = Addon:NewModule("raidWarnings", "AceHook-3.0", "AceEvent-3.0")
-- Addon.oUF = Engine.oUF
-- Addon.ActionBars = Addon:NewModule("ActionBars","AceHook-3.0","AceEvent-3.0")
-- Addon.AFK = Addon:NewModule("AFK","AceEvent-3.0","AceTimer-3.0")
-- Addon.Auras = Addon:NewModule("Auras","AceHook-3.0","AceEvent-3.0")
-- Addon.Bags = Addon:NewModule("Bags","AceHook-3.0","AceEvent-3.0","AceTimer-3.0")
-- Addon.Blizzard = Addon:NewModule("Blizzard","AceEvent-3.0","AceHook-3.0")
-- Addon.Chat = Addon:NewModule("Chat","AceTimer-3.0","AceHook-3.0","AceEvent-3.0")
-- Addon.DataBars = Addon:NewModule("DataBars","AceEvent-3.0")
-- Addon.DataTexts = Addon:NewModule("DataTexts","AceTimer-3.0","AceHook-3.0","AceEvent-3.0")
-- Addon.DebugTools = Addon:NewModule("DebugTools","AceEvent-3.0","AceHook-3.0")
-- Addon.Distributor = Addon:NewModule("Distributor","AceEvent-3.0","AceTimer-3.0","AceComm-3.0","AceSerializer-3.0")
-- Addon.Layout = Addon:NewModule("Layout","AceEvent-3.0")
-- Addon.Minimap = Addon:NewModule("Minimap","AceEvent-3.0")
-- Addon.Misc = Addon:NewModule("Misc","AceEvent-3.0","AceTimer-3.0")
-- Addon.ModuleCopy = Addon:NewModule("ModuleCopy","AceEvent-3.0","AceTimer-3.0","AceComm-3.0","AceSerializer-3.0")
-- Addon.NamePlates = Addon:NewModule("NamePlates","AceHook-3.0","AceEvent-3.0","AceTimer-3.0")
-- Addon.PluginInstaller = Addon:NewModule("PluginInstaller")
-- Addon.RaidUtility = Addon:NewModule("RaidUtility","AceEvent-3.0")
-- Addon.ReminderBuffs = Addon:NewModule("ReminderBuffs", "AceEvent-3.0")
-- Addon.Skins = Addon:NewModule("Skins","AceTimer-3.0","AceHook-3.0","AceEvent-3.0")
-- Addon.Threat = Addon:NewModule("Threat","AceEvent-3.0")
-- Addon.Tooltip = Addon:NewModule("Tooltip","AceTimer-3.0","AceHook-3.0","AceEvent-3.0")
-- Addon.TotemBar = Addon:NewModule("Totems","AceEvent-3.0")
-- Addon.UnitFrames = Addon:NewModule("UnitFrames","AceTimer-3.0","AceEvent-3.0","AceHook-3.0")
-- Addon.WorldMap = Addon:NewModule("WorldMap","AceHook-3.0","AceEvent-3.0","AceTimer-3.0")

-- :: Escape string for characters ().%+-*?[^$ modullerin isimlerini duzeltiyor
do
    local arg2, arg3 = "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1"
    function Addon:EscapeString(str) return gsub(str, arg2, arg3) end
end

-- ==== Addon Init
function Addon:OnInitialize()
    -- :: if there is no database create one
    if not ArchCharacterDB then ArchCharacterDB = {} end

    self.db = tcopy(self.DF.profile, true)
    self.global = tcopy(self.DF.global, true)

    -- :: eger db varsa profili programa al (cache)  
    if ArchDB then
        if ArchDB.global then self:CopyTable(self.global, ArchDB.global) end

        local profileKey
        if ArchDB.profileKeys then
                profileKey = ArchDB.profileKeys[self.myname .. " [" .. self.myrealm .. "]"]
        end

        if profileKey and ArchDB.profiles and ArchDB.profiles[profileKey] then
            self:CopyTable(self.db, ArchDB.profiles[profileKey])
        end
    end

    self.private = tcopy(self.privateVars.profile, true)

    -- :: private DB icin ayni islemi uygula
    if ArchPrivateDB then
        local profileKey
        if ArchPrivateDB.profileKeys then
            profileKey = ArchPrivateDB.profileKeys[self.myname .. " [" .. self.myrealm .. "]"]
        end

        if profileKey and ArchPrivateDB.profiles and
            ArchPrivateDB.profiles[profileKey] then
            self:CopyTable(self.private, ArchPrivateDB.profiles[profileKey])
        end
    end

    self.twoPixelsPlease = false
    self.ScanTooltip = CreateFrame("GameTooltip", "ElvUI_ScanTooltip",
                                   _G.UIParent, "GameTooltipTemplate")
    self.PixelMode = (self.twoPixelsPlease) -- keep this over `UIScale`  or self.private.general.pixelPerfect
    self:UIScale(true)
    self:UpdateMedia()

    self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", "PixelScaleChanged")
    -- self:RegisterEvent("PLAYER_REGEN_DISABLED")
    -- self:Contruct_StaticPopups()
    self:InitializeInitialModules()

    -- :: Game menu buttons
    -- local GameMenuButton = CreateFrame("Button", "ElvUI_MenuButton", GameMenuFrame, "GameMenuButtonTemplate")
    -- GameMenuButton:SetText(self.title)
    -- GameMenuButton:SetScript("OnClick", function()
    -- 	Addon:ToggleOptionsUI()
    -- 	HideUIPanel(GameMenuFrame)
    -- end)
    -- GameMenuFrame[AddonName] = GameMenuButton

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

    -- :: loadtime
    self.loadedtime = GetTime()
end

-- ==== Profile
function Addon:ResetProfile()
    local profileKey

    if ArchPrivateDB.profileKeys then
        profileKey = ArchPrivateDB.profileKeys[self.myname .. " - " ..
                         self.myrealm]

        if profileKey and ArchPrivateDB.profiles and
            ArchPrivateDB.profiles[profileKey] then
            ArchPrivateDB.profiles[profileKey] = nil
        end
    end

    ElvCharacterDB = nil
    self.data:_ResetProfile()
    ReloadUI()
end

-- ==== Gui
function Addon:GetConfigDefaultSize()
    local width, height = Addon:GetConfigSize()
    local maxWidth, maxHeight = Addon.UIParent:GetSize()
    width, height = min(maxWidth - 50, width), min(maxHeight - 50, height)
    return width, height
end

function Addon:ResetConfigSettings()
    Addon.configSavedPositionTop, Addon.configSavedPositionLeft = nil, nil
    Addon.global.general.AceGUI = Addon:CopyTable({}, Addon.DF.global.general
                                                      .AceGUI)
end

function Addon:GetConfigSize()
    return Addon.global.general.AceGUI.width, Addon.global.general.AceGUI.height
end

function Addon:UpdateConfigSize(reset)
    local frame = self.GUIFrame
    if not frame then return end

    local maxWidth, maxHeight = self.UIParent:GetSize()
    frame:SetMinResize(600, 500)
    frame:SetMaxResize(maxWidth - 50, maxHeight - 50)

    self.Libs.AceConfigDialog:SetDefaultSize(AddonName,
                                             self:GetConfigDefaultSize())

    local status = frame.obj and frame.obj.status
    if status then
        if reset then
            self:ResetConfigSettings()

            status.top, status.left = self:GetConfigPosition()
            status.width, status.height = self:GetConfigDefaultSize()

            frame.obj:ApplyStatus()
        else
            local top, left = self:GetConfigPosition()
            if top and left then
                status.top, status.left = top, left

                frame.obj:ApplyStatus()
            end
        end
    end
end

-- ==== Login [last arg]

local LoadUI = CreateFrame("Frame")
LoadUI:RegisterEvent("PLAYER_LOGIN")
LoadUI:SetScript("OnEvent", function() Addon:Initialize() end)

-- test 
