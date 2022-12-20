------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
-- local moduleName1, moduleName2  = 'PostureCheck', "Posture Check";
-- local moduleAlert = M .. moduleName2 .. ": |r";
-- local module = A:GetModule(moduleName1, true);
-- if module == nil then
--     return
-- end

-- ------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local addonColor = '|cff00c8ff'
local moduleColor = '|cff00efff'
local commandColor = '|cfff7882f'
local focusColor = '|cffbf4aa8'
local trivialColor = '|cff767676'
local colorEnd = '|r'
local addonName = "[Archrist]: "
local realmName = GetRealmName()

local Arch_classColors = {
    ["Death Knight"] = '|cffC41F3B',    
    ["Druid"] = '|cffFF7D0A',
    ["Hunter"] = '|cffA9D271',
    ["Mage"] = '|cff40C7EB',
    ["Paladin"] = '|cffF58CBA',
    ["Priest"] = '|cffFFFFFF',
    ["Rogue"] = '|cffFFF569',
    ["Shaman"] = '|cff0070DE',
    ["Warlock"] = '|cff8787ED',
    ["Warrior"] = '|cffC79C6E',
}

-- :: category
local impressions = {
    ["reputation"] = 0,
    ["strategy"] = 0,
    ["attendance"] = 0,
    ["discipline"] = 0,
    ["damage"] = 0,
    ["note"] = ""
}
local organization = {
    ["role"] = "",
    ["tasks"] = {}
}
local categories = {
    ["impressions"] = impressions,
    ["organization"] = organization
}

-- ==== Functions
-- :: Colors
function Arch_addonColor(msg) return (addonColor .. tostring(msg) .. colorEnd) end
local aCol = Arch_addonColor

function Arch_moduleColor(msg) return (moduleColor .. tostring(msg) .. colorEnd) end
local mCol = Arch_moduleColor


function Arch_commandColor(msg)
    return (commandColor .. tostring(msg) .. colorEnd)
end
local cCol = Arch_commandColor

function Arch_focusColor(msg) return (focusColor .. tostring(msg) .. colorEnd) end
local fCol = Arch_focusColor


function Arch_classColor(class, msg) return (Arch_classColors[class] .. tostring(msg) .. colorEnd) end
local classCol = Arch_classColor

function Arch_trivialColor(msg)
    return (trivialColor .. tostring(msg) .. colorEnd)
end
local tCol = Arch_trivialColor


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

function Arch_properCase(str)
    if str ~= nil then
        return (str:gsub("^%l", string.upper))
    end
end

-- :: addon functions with multiple user modules
function Arch_print(msg)
    print(Arch_addonColor(addonName) .. tostring(msg))
end
local aprint = Arch_print
-- 
function arch_addPersonToDatabase(player, server)
    -- :: def: server farkliysa ekleme
    if "" ~= server or string.find(player, "-") then
        do
            return
        end
    end
    -- :: def: player varsa
    if A.people[realmName][player] ~= nil then
        -- aprint(fCol(player) .. " added to your database.")
        do return end 
    end
    -- :: add player name
    A.people[realmName][player] = {}
    aprint(fCol(player) .. " added to your database.")
    -- :: add categories
    for cat, subcat in pairs(categories) do
        if A.people[realmName][player][cat] == nil then
            A.people[realmName][player][cat] = {}
        end
        for key, val in pairs(subcat) do
            if A.people[realmName][player][cat][key] == nil then
                A.people[realmName][player][cat][key] = val
            end
        end
    end
end
