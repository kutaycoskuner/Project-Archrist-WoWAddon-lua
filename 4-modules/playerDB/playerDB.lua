------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
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
local isInCombat = false
local realmName = GetRealmName()

-- ==== Start
function module:Initialize()
    self.Initialized = true
    if not A.people[realmName] then A.people[realmName] = {} end
    module:RegisterEvent("PLAYER_REGEN_ENABLED")
    module:RegisterEvent("PLAYER_REGEN_DISABLED")
    module:RegisterEvent("WHO_LIST_UPDATE")
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

-- :: Create Player Entry
local function archAddPlayer(player)
    A.people[realmName][player] = {
        reputation = 0,
        discipline = 0,
        strategy = 0,
        damage = 0,
        attendance = 0,
        -- gearscore = 0,
        note = '',
    }
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. ' New player (' .. player ..
                                       ') added in your database')
end

-- :: Calculate raidscore
function Archrist_PlayerDB_calcRaidScore(player)

    if not A.people[realmName][player] then archAddPlayer(player) end
    local rep = (tonumber(A.people[realmName][player].reputation) * 250)
    local dsc = (tonumber(A.people[realmName][player].discipline) * 300)
    local str = (tonumber(A.people[realmName][player].strategy) * 300)
    local dmg = (tonumber(A.people[realmName][player].damage) * 200)
    local att = (tonumber(A.people[realmName][player].attendance) * 100)
    local gsr
    local raidScore = rep + dsc + str + dmg + att

    if GameTooltip:GetUnit() then
        local Name = GameTooltip:GetUnit();
        if GearScore_GetScore(Name, "mouseover") then
            gsr = GearScore_GetScore(Name, "mouseover")
            -- print(gsr)
            -- print(raidScore + gsr)
            return (raidScore + gsr)
        end
    end

    return raidScore
end

-- :: present player note
function Archrist_PlayerDB_getNote(player)
    if not isInCombat then
        local Name = GameTooltip:GetUnit();
        if Name ~= UnitName('player') then
            if A.people[realmName][Name] then
                local note = A.people[realmName][Name].note
                if note ~= '' then
                    GameTooltip:AddLine(note, 0.5, 0.5, 0.5, true)
                end
            end
        end
    end
end

local function Archrist_PlayerDB_getRaidScore()
    if GameTooltip:GetUnit() then
        local Name = GameTooltip:GetUnit();
        if not GearScore_GetScore then return end
        if GearScore_GetScore(Name, "mouseover") then
            if A.people[realmName][Name] then
                local gearScore = GearScore_GetScore(Name, "mouseover")
                if gearScore and gearScore > 0 then
                    local personalData = Archrist_PlayerDB_calcRaidScore(Name)
                    -- local note = Archrist_PlayerDB_getNote(Name)
                    local raidScore = personalData
                    if gearScore ~= raidScore then
                        GameTooltip:AddLine('RaidScore: ' .. raidScore, 0, 78,
                                            100)
                    end
                end
            end
        end
    end
end

-- :: Get Player Stats
local function archGetPlayer(player)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. player)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'reputation: ' ..
                                       A.people[realmName][player].reputation)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'discipline: ' ..
                                       A.people[realmName][player].discipline)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'strategy: ' ..
                                       A.people[realmName][player].strategy)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'damage: ' ..
                                       A.people[realmName][player].damage)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'attendance: ' ..
                                       A.people[realmName][player].attendance)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'gearscore: ' ..
                                       A.people[realmName][player].gearscore)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'note: ' ..
                                       A.people[realmName][player].note)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Raidscore: ' ..
                                       Archrist_PlayerDB_calcRaidScore(player))
end

-- ==== Main 
local function checkStatLimit(player, stat)
    if A.people[realmName][player][stat] >= 5 then
        A.people[realmName][player][stat] = 5
    elseif A.people[realmName][player][stat] <= -5 then
        A.people[realmName][player][stat] = -5
    end
end

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
            if A.people[realmName][UnitName('target')] == nil then
                archAddPlayer(UnitName('target'))
            end

            if type(tonumber(args[1])) == "number" then
                A.people[realmName][UnitName('target')][parameter] =
                    tonumber(A.people[realmName][UnitName('target')][parameter]) +
                        tonumber(args[1])
                checkStatLimit(UnitName('target'), parameter)
                SELECTED_CHAT_FRAME:AddMessage(
                    moduleAlert .. UnitName('target') .. ' ' .. parameter ..
                        ' is now ' .. A.people[realmName][UnitName('target')][parameter])
            end
        end
    else
        -- :: isim argumani yok ise targeta bak
        if UnitExists('target') and UnitName('target') ~= UnitName('player') and
            UnitIsPlayer('target') then
            -- :: Create person if not already exists
            if A.people[realmName][UnitName('target')] == nil then
                archAddPlayer(UnitName('target'))
            else
                archGetPlayer(UnitName('target'))
            end
        end
    end
end

local function addPlayerStat(args, parameter)
    if A.people[realmName][args[1]] == nil then archAddPlayer(args[1]) end
    if args[2] then
        if type(tonumber(args[2])) == "number" then
            A.people[realmName][args[1]][parameter] =
                tonumber(A.people[realmName][args[1]][parameter]) + tonumber(args[2])
            checkStatLimit(args[1], parameter)
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. args[1] .. ' ' .. parameter .. ' is now ' ..
                    A.people[realmName][args[1]][parameter])
        else
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. 'your entry is not valid')
        end
    else
        archGetPlayer(args[1])
    end
end

-- >> Disabled
-- local function getGearScoreRecord(msg)

--     args = fixArgs(msg)
--     -- :: if first unit is player this function returns true
--     if UnitExists('target') and UnitIsPlayer('target') then

--         -- :: Create person if not already exists
--         if A.people[realmName][UnitName('target')] == nil then
--             archAddPlayer(UnitName('target'))
--         end

--         -- :: Get Gearscore
--         local Name = GameTooltip:GetUnit();

--         if Name == UnitName('target') then
--             A.people[realmName][UnitName('target')].gearscore =
--                 GearScore_GetScore(Name, "mouseover")
--             SELECTED_CHAT_FRAME:AddMessage(
--                 moduleAlert .. UnitName('target') .. ' gearscore is updated as ' ..
--                     A.people[realmName][UnitName('target')].gearscore)
--         else
--             SELECTED_CHAT_FRAME:AddMessage(
--                 moduleAlert .. 'you need to mouseover target to calculate gs')
--         end
--     end

-- end

local function handleNote(msg)

    -- :: Burda target oncelikli
    if UnitExists('target') and UnitIsPlayer('target') and UnitName('target') ~=
        UnitName('player') then
        if A.people[realmName][UnitName('target')] == nil then
            archAddPlayer(UnitName('target'))
        end
        A.people[realmName][UnitName('target')].note = msg
        if msg ~= '' then
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. UnitName('target') .. ': ' ..
                    A.people[realmName][UnitName('target')].note)
        else
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. 'Note for ' .. UnitName('target') ..
                    ' has been pruned.')
        end
    elseif UnitName('target') == UnitName('player') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert ..
                                           'You cannot add note for your own character')
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

-- :: add if player note exists on tooltip
local function addNote(args)
    local name = table.remove(args, 1)
    local note = table.concat(args, ' ')

    if A.people[realmName][name] == nil then archAddPlayer(name) end
    A.people[realmName][name].note = note

    if args[1] then
        -- print(note)
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. name .. ': ' ..
                                           A.people[realmName][name].note)
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Note for ' .. name ..
                                           ' has been pruned.')
    end
end

-- ==== Event Handlers
function module:PLAYER_REGEN_ENABLED()
    -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
    isInCombat = false
end

function module:PLAYER_REGEN_DISABLED() isInCombat = true end

function module:WHO_LIST_UPDATE() -- CHAT_MSG_SYSTEM()

    if mod ~= 'patates' then

        for ii = 1, GetNumWhoResults() do
            if GetWhoInfo(ii) == args[1] then
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

-- ==== GUI
GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)
GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

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
