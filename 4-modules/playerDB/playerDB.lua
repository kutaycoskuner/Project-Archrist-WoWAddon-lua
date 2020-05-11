------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'playerDB';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------

-- ==== Start
-- if A.db.people == nil then A.db.people = {} end 

-- :: Argumanlari ayirip bas harflerini buyutuyor
local function fixArgs(msg)
    -- :: this is separating the given arguments after command
    local sep;
    if sep == nil then sep = "%s" end
    local args = {};
    for str in string.gmatch(msg, "([^" .. sep .. "]+)") do
        table.insert(args, str)
    end

    -- :: this capitalizes first letters of each given string
    for ii = 1, #args, 1 do
        args[ii] = args[ii]:lower()
        args[ii] = args[ii]:gsub("^%l", string.upper)
    end

    return args;
end

local function handleReputation(msg, parameter)

    -- local parName
    -- if par == 'rep' then
    --     parName = 'reputation'
    -- else if par == 'str' then
    --     parName = "strategy"
    -- end

    local args = fixArgs(msg)
    -- :: if first unit is player this function returns true
    if UnitExists('target') then

        -- :: Create person if not already exists
        if A.people[UnitName('target')] == nil then
            A.people[UnitName('target')] =
                {
                    reputation = 0,
                    discipline = 0,
                    strategy = 0,
                    damage = 0,
                    attendance = 0,
                    gearscore = 0,
                    note = ''
                }
            print(moduleAlert .. ' New player added in your database')
        end

        -- :: Add Reputation
        if args[1] then
            if type(tonumber(args[1])) == "number" then
                A.people[UnitName('target')][parameter] =
                    tonumber(A.people[UnitName('target')][parameter]) +
                        tonumber(args[1])
                print(moduleAlert .. UnitName('target') .. ' ' .. parameter ..
                          ' is now ' .. A.people[UnitName('target')][parameter])
            else
                print('not worked')
                print(type(args[1]))
            end
        else
            print(moduleAlert .. UnitName('target'))
            print(moduleAlert .. 'reputation: ' .. A.people[UnitName('target')].reputation)
            print(moduleAlert .. 'discipline: ' .. A.people[UnitName('target')].discipline)
            print(moduleAlert .. 'strategy: ' .. A.people[UnitName('target')].strategy)
            print(moduleAlert .. 'damage: ' .. A.people[UnitName('target')].damage)
            print(moduleAlert .. 'attendance: ' .. A.people[UnitName('target')].attendance)
        end

    end
    -- test end
end

function module:Initialize()
    self.Initialized = true
    -- self:RegisterEvent("MAIL_INBOX_UPDATE")
    -- "MAIL_INBOX_UPDATE"
end

-- ==== Slash Handlers
SLASH_reputation1 = "/rep"
SlashCmdList["reputation"] =
    function(msg) handleReputation(msg, 'reputation') end
SLASH_discipline1 = "/dsc"
SlashCmdList["discipline"] =
    function(msg) handleReputation(msg, 'discipline') end
SLASH_strategy1 = "/str"
SlashCmdList["strategy"] = function(msg) handleReputation(msg, 'strategy') end
SLASH_damage1 = "/dmg"
SlashCmdList["damage"] = function(msg) handleReputation(msg, 'damage') end
SLASH_attendance1 = "/att"
SlashCmdList["attendance"] =
    function(msg) handleReputation(msg, 'attendance') end

-- ==== Callback & Register [last arg]
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[
    - create command [x]
    - understand command arguments
]]

-- ==== UseCase
--[[
this component works with a command and requires name parameter
- /rep -> presents /rep help
- /rep <playerName> -> presents reputation of given player if there is not creates 0
- /rep <playerName> [d | s | c] <number> g->  changes discipline, strategy or core points of character if empty plain reputation
- /rep <playerName> [n] <args> gives an opportunity to leave comment about player

data structure = 
[playerName] = {
    reputation: [max 5 : min -5]
    discipline: [max 3 : min -2]
    strategy: [max 3 : min -2]
    core [dps | heal | tank]: [max 3 : min -2]
    note: <commentAboutPlayer>
}

Further additions
- get and set info about players from ingame gui
- sync different player databases

- rep, dmg, dsc, str, att



]]
