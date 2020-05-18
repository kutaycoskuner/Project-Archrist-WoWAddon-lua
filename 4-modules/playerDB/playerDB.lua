------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'PlayerDB';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
-- !! IMPORTANT GLOBAL
local Raidscore
local mod = 'patates' -- rep / not
local args = {}
local isPlayerExists = false

-- ==== Start
function module:Initialize()
    self.Initialized = true
    module:RegisterEvent("WHO_LIST_UPDATE");
end

-- ==== Methods
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
        if ii == 1 then args[ii] = args[ii]:gsub("^%l", string.upper) end
    end

    return args;

end

-- :: Calculate raidscore
function Archrist_PlayerDB_calcRaidScore(player)
    local rep = (tonumber(A.people[player].reputation) * 250)
    local dsc = (tonumber(A.people[player].discipline) * 300)
    local str = (tonumber(A.people[player].strategy) * 300)
    local dmg = (tonumber(A.people[player].damage) * 200)
    local att = (tonumber(A.people[player].attendance) * 100)
    local gsr = (tonumber(A.people[player].gearscore) * 1)

    local raidScore = rep + dsc + str + dmg + att

    return raidScore;
end

-- :: Create Player Entry
local function archAddPlayer(player)
    A.people[player] = {
        reputation = 0,
        discipline = 0,
        strategy = 0,
        damage = 0,
        attendance = 0,
        gearscore = 0,
        note = ''
    }
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. ' New player (' .. player ..
                                       ') added in your database')
end

-- :: Get Player Stats
local function archGetPlayer(player)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. player)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'reputation: ' ..
                                       A.people[player].reputation)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'discipline: ' ..
                                       A.people[player].discipline)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'strategy: ' ..
                                       A.people[player].strategy)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'damage: ' ..
                                       A.people[player].damage)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'attendance: ' ..
                                       A.people[player].attendance)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'gearscore: ' ..
                                       A.people[player].gearscore)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'note: ' ..
                                       A.people[player].note)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Raidscore: ' ..
                                       Archrist_PlayerDB_calcRaidScore(player))
end

-- ==== Main 
local function handlePlayerStat(msg, parameter)

    args = fixArgs(msg)
    mod = parameter

    if args[1] then
        -- :: Isim oncelikli entry
        if type(tonumber(args[1])) ~= "number" then
            SetWhoToUI(1)
            SendWho('n-"' .. args[1] .. '"')
        end

        -- :: Target varsa
        if UnitExists('target') and UnitName('target') ~= UnitName('player') and
            UnitIsPlayer('target') then
            if A.people[UnitName('target')] == nil then
                archAddPlayer(UnitName('target'))
            end

            if type(tonumber(args[1])) == "number" then
                A.people[UnitName('target')][parameter] =
                    tonumber(A.people[UnitName('target')][parameter]) +
                        tonumber(args[1])
                SELECTED_CHAT_FRAME:AddMessage(
                    moduleAlert .. UnitName('target') .. ' ' .. parameter ..
                        ' is now ' .. A.people[UnitName('target')][parameter])
            end
        end
    else
        -- :: isim argumani yok ise targeta bak
        if UnitExists('target') and UnitName('target') ~= UnitName('player') and
            UnitIsPlayer('target') then
            -- :: Create person if not already exists
            if A.people[UnitName('target')] == nil then
                archAddPlayer(UnitName('target'))
            else
                archGetPlayer(UnitName('target'))
            end
        end
    end
end

local function addPlayerStat(args, parameter)
    if A.people[args[1]] == nil then archAddPlayer(args[1]) end
    if args[2] then
        if type(tonumber(args[2])) == "number" then
            A.people[args[1]][parameter] =
                tonumber(A.people[args[1]][parameter]) + tonumber(args[2])
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. args[1] .. ' ' .. parameter .. ' is now ' ..
                    A.people[args[1]][parameter])
        else
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. 'your entry is not valid')
        end
    else
        archGetPlayer(args[1])
    end
end

local function getGearScoreRecord(msg)

    args = fixArgs(msg)
    -- :: if first unit is player this function returns true
    if UnitExists('target') and UnitIsPlayer('target') then

        -- :: Create person if not already exists
        if A.people[UnitName('target')] == nil then
            archAddPlayer(UnitName('target'))
        end

        -- :: Get Gearscore
        local Name = GameTooltip:GetUnit();

        if Name == UnitName('target') then
            A.people[UnitName('target')].gearscore =
                GearScore_GetScore(Name, "mouseover")
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. UnitName('target') .. ' gearscore is updated as ' ..
                    A.people[UnitName('target')].gearscore)
        else
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. 'you need to mouseover target to calculate gs')
        end
    end

end

local function handleNote(msg)

    -- :: Burda target oncelikli
    if UnitExists('target') and UnitIsPlayer('target') then
        if A.people[UnitName('target')] == nil then
            archAddPlayer(UnitName('target'))
        end
        A.people[UnitName('target')].note = msg
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. UnitName('target') ..
                                           ' note: ' ..
                                           A.people[UnitName('target')].note)
    else
        -- :: Get Name and not after
        args = fixArgs(msg)
        mod = 'not'
        if args[1] then
            SetWhoToUI(1)
            SendWho('n-"' .. args[1] .. '"')
        end
    end

end

local function addNote(args)

    SELECTED_CHAT_FRAME:AddMessage(args[2])
    -- print(args)
    local name = table.remove(args, 1)
    -- print(name)
    local note = table.concat(args, ' ')
    -- print(note)
    if A.people[name] == nil then archAddPlayer(name) end
    A.people[name].note = note
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. name .. ' note: ' ..
                                       A.people[name].note)

end

-- ==== Event Handlers
function module:WHO_LIST_UPDATE() -- CHAT_MSG_SYSTEM()

    if mod ~= 'patates' then

        for ii = 1, GetNumWhoResults() do
            print(args[1])
            if GetWhoInfo(ii) == args[1] then
                -- print('this person exists')
                isPlayerExists = true
                break
            end
        end

        if isPlayerExists then
            if mod == 'not' then
                addNote(args)
            else
                addPlayerStat(args, mod)
            end
            isPlayerExists = false
        else
            print('Player not found')
        end

        FriendsFrame:Hide()
    end
    mod = 'patates'

end

-- ==== Slash Handlers
SLASH_reputation1 = "/rep"
SlashCmdList["reputation"] =
    function(msg) handlePlayerStat(msg, 'reputation') end
SLASH_discipline1 = "/dsc"
SlashCmdList["discipline"] =
    function(msg) handlePlayerStat(msg, 'discipline') end
SLASH_strategy1 = "/str"
SlashCmdList["strategy"] = function(msg) handlePlayerStat(msg, 'strategy') end
SLASH_damage1 = "/dmg"
SlashCmdList["damage"] = function(msg) handlePlayerStat(msg, 'damage') end
SLASH_attendance1 = "/att"
SlashCmdList["attendance"] =
    function(msg) handlePlayerStat(msg, 'attendance') end
SLASH_gsr1 = "/gsr"
SlashCmdList["gsr"] = function(msg) getGearScoreRecord(msg) end
SLASH_not1 = "/not"
SlashCmdList["not"] = function(msg) handleNote(msg) end

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

yazilmis isim target'a oncelikli
/rep <isim> 1 :: bu ismi aliyor
/rep 1 :: bu targeti aliyor

]]
