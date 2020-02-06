-- ==== Metadata
local A, L, V, P, G = unpack(select(2, ...)) -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local module = A:GetModule('raidWarnings');

-- ==== Macros
local warn1 = CreateFrame("CheckButton", "WarnButton1", UIParent, "SecureActionButtonTemplate")
warn1:SetAttribute("type", "macro")
local warn2 = CreateFrame("CheckButton", "WarnButton2", UIParent, "SecureActionButtonTemplate")
warn2:SetAttribute("type", "macro")
local warn3 = CreateFrame("CheckButton", "WarnButton3", UIParent, "SecureActionButtonTemplate")
warn3:SetAttribute("type", "macro")
local warn4 = CreateFrame("CheckButton", "WarnButton4", UIParent, "SecureActionButtonTemplate")
warn4:SetAttribute("type", "macro")

local raidWarning1, raidWarning2, raidWarning3, raidWarning4 = "test1", "test2", "test3", "test4" 

function setRaidWarnings()
        WarnButton1:SetAttribute("macrotext", "/w orthrin " .. raidWarning1)
        WarnButton2:SetAttribute("macrotext", "/w orthrin " .. raidWarning2)
        WarnButton3:SetAttribute("macrotext", "/w orthrin " .. raidWarning3)
        WarnButton4:SetAttribute("macrotext", "/w orthrin " .. raidWarning4)
end