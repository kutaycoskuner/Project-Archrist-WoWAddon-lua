------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'playerDB';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------

-- ==== Start
-- !! IMPORTANT GLOBAL
local Raidscore
local args = {}

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

local function archGetPlayer(player) 
    print(moduleAlert .. player)
    print(moduleAlert .. 'reputation: ' ..
              A.people[player].reputation)
    print(moduleAlert .. 'discipline: ' ..
              A.people[player].discipline)
    print(moduleAlert .. 'strategy: ' ..
              A.people[player].strategy)
    print(moduleAlert .. 'damage: ' ..
              A.people[player].damage)
    print(moduleAlert .. 'attendance: ' ..
              A.people[player].attendance)
    print(moduleAlert .. 'gearscore: ' ..
              A.people[player].gearscore)
    print(moduleAlert .. 'note: ' ..
              A.people[player].note)
end

local function handleReputation(msg, parameter)

    args = fixArgs(msg)

    if args[1] == nil then
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
            else
                archGetPlayer(UnitName('target'))
            end
        end
    else
        -- :: Eger ikinci arguman args[1] var ise
        if UnitExists('target') then
            if type(tonumber(args[1])) == "number" then
                A.people[UnitName('target')][parameter] =
                    tonumber(A.people[UnitName('target')][parameter]) +
                        tonumber(args[1])
                print(moduleAlert .. UnitName('target') .. ' ' .. parameter ..
                          ' is now ' .. A.people[UnitName('target')][parameter])
            end
        end

        -- >> Burada yazilan ismin varolup olmadigini sorgulayip olmasi durumunda islem yapacak
        if A.people[args[1]] then
            if type(tonumber(args[1])) ~= "number" then
                archGetPlayer(args[1])
            end
        else
            print('not worked')
        end
    end

    -- :: if first unit is player this function returns true

    -- test end
end

local function getGearScoreRecord(msg)

    args = fixArgs(msg)
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

        -- :: Get Gearscore
        local Name = GameTooltip:GetUnit();
        A.people[UnitName('target')].gearscore =
            GearScore_GetScore(Name, "mouseover")
        print(
            moduleAlert .. UnitName('target') .. ' gearscore is updated as ' ..
                A.people[UnitName('target')].gearscore)
    end

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
SLASH_gsr1 = "/gsr"
SlashCmdList["gsr"] = function(msg) getGearScoreRecord(msg) end

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
