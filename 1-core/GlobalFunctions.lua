------------------------------------------------------------------------------------------------------------------------
-- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
-- local A, L, V, P, G, C, M, N = unpack(select(2, ...));
-- local moduleName = 'GlobalFunctions';
-- local moduleAlert = M .. moduleName .. ": |r";
-- local module = A:GetModule(moduleName);
-- ------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local addonColor = '|cff00c8ff'
local moduleColor = '|cff00efff'
local commandColor = '|cfff7882f'
local focusColor = '|cffbf4aa8'
local trivialColor = '|cff767676'
local colorEnd = '|r'

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- ==== Functions

-- :: Colors
function Arch_addonColor(msg) return (addonColor .. tostring(msg) .. colorEnd) end

function Arch_moduleColor(msg) return (moduleColor .. tostring(msg) .. colorEnd) end

function Arch_commandColor(msg)
    return (commandColor .. tostring(msg) .. colorEnd)
end

function Arch_focusColor(msg) return (focusColor .. tostring(msg) .. colorEnd) end

function Arch_trivialColor(msg)
    return (trivialColor .. tostring(msg) .. colorEnd)
end

-- :: Time
function Arch_calcTimeInSec()
    local date = date("%H:%M:%S")
    local sep = ':';
    if sep == nil then sep = "%s" end
    local args = {};
    for str in string.gmatch(date, "([^" .. sep .. "]+)") do
        table.insert(args, str)
    end
    if args[1] == 0 then args[1] = 12 end
    return tonumber(args[1] * 3600 + args[2] * 60 + args[3])
end

-- :: String Manipulation
function Arch_fixArgs(msg)
    -- :: this is separating the given arguments after command
    local sep;
    if sep == nil then sep = "%s" end
    local args = {};
    for str in string.gmatch(msg, "([^" .. sep .. "]+)") do
        table.insert(args, str)
    end

    -- :: this capitalizes first letters of each given string
    for ii = 1, #args, 1 do
        if type(args[ii]) == 'string' then args[ii] = args[ii]:lower() end
        if ii == 1 then args[ii] = args[ii]:gsub("^%l", string.upper) end
    end

    return args;
end

-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true
--     -- :: Register some events
--     module:RegisterEvent("CHAT_MSG_SAY");
-- end

-- ==== Todo
--[[
    - addonColor
    - moduleColor
    - commandColor
    - focusColor
    - trivialColor
]]

-- ==== UseCase
--[[]]
