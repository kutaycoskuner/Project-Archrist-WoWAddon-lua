------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'PlayerDB';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - create command [x]
    - understand command arguments
]]

-- use case ------------------------------------------------------------------------------------------------------------
--[[
this component works with a command and requires name parameter
- -> presents /rep help
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

player oyunda degilse /who isim kontrolu yapilamiyor bu durumda playeri yazarak da olsa eklemek icin
/rep /<playerName> [n]

/rrep        grubu reputation check yapiyor. Dusuk reputationlu olan varsa haber veriyor
/rrep [n]    butun gruba reputation veriyor 

]]
------------------------------------------------------------------------------------------------------------------------

-- ==== Variables
-- !! IMPORTANT GLOBAL
local Raidscore
local mod = 'patates' -- rep / not
local args = {}
local isPlayerExists = false
local isInCombat = false
local realmName = GetRealmName()
local factionName = UnitFactionGroup('player')
local focusColor = Arch_focusColor
local quantitative = {'reputation', 'strategy', 'discipline', 'attendance', 'damage'}
local lastBlacklist

-- ==== Start
function module:Initialize()
    self.Initialized = true
    if not A.people[realmName] then
        A.people[realmName] = {}
    end
    module:RegisterEvent("PLAYER_REGEN_ENABLED")
    module:RegisterEvent("PLAYER_REGEN_DISABLED")
    module:RegisterEvent("WHO_LIST_UPDATE")
    module:RegisterEvent("RAID_ROSTER_UPDATE")
end

-- ==== Methods
-- :: Argumanlari ayirip bas harflerini buyutuyor
local function fixArgs(msg)
    -- :: this is separating the given arguments after command
    local sep;
    if sep == nil then
        sep = "%s"
    end
    local args = {};
    for str in string.gmatch(msg, "([^" .. sep .. "]+)") do
        table.insert(args, str)
    end

    -- :: this capitalizes first letters of each given string
    for ii = 1, #args, 1 do
        args[ii] = args[ii]:lower()
        if ii == 1 then
            args[ii] = args[ii]:gsub("^%l", string.upper)
        end
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
        note = ''
    }
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. ' New player (' .. player .. ') added in your database')
end

-- :: Calculate raidscore
function Archrist_PlayerDB_calcRaidScore(player)

    if not A.people[realmName][player] then
        archAddPlayer(player)
    end
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
        if not GearScore_GetScore then
            return
        end
        if GearScore_GetScore(Name, "mouseover") then
            if A.people[realmName][Name] then
                local gearScore = GearScore_GetScore(Name, "mouseover")
                if gearScore and gearScore > 0 then
                    local personalData = Archrist_PlayerDB_calcRaidScore(Name)
                    -- local note = Archrist_PlayerDB_getNote(Name)
                    local raidScore = personalData
                    if gearScore ~= raidScore then
                        GameTooltip:AddLine('RaidScore: ' .. raidScore, 0, 78, 100)
                    end
                end
            end
        end
    end
end

local function Archrist_PlayerDB_getPlayerData()
    if not isInCombat then
        local Name = GameTooltip:GetUnit();
        if Name ~= UnitName('player') then
            if A.people[realmName][Name] then
                for ii = 1, #quantitative do
                    local data = A.people[realmName][Name][quantitative[ii]]
                    if data ~= 0 then
                        GameTooltip:AddLine(quantitative[ii] .. ' ' .. data, 0.5, 0.5, 0.5, true)
                    end
                end
            end
        end
    end
end
-- :: Get Player Stats
local function archGetPlayer(player)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. focusColor(player))
    factionName = UnitFactionGroup('player')
    for yy = 1, #quantitative do
        if A.people[realmName][player][quantitative[yy]] ~= 0 then
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. quantitative[yy] .. ': ' ..
                                               A.people[realmName][player][quantitative[yy]])
        end
    end
    --
    if A.people[realmName][player].note ~= '' then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'note: ' .. A.people[realmName][player].note)
    end
end

-- ==== Main 
local function checkStatLimit(player, stat)
    if A.people[realmName][player][stat] >= 5 then
        A.people[realmName][player][stat] = 5
    elseif A.people[realmName][player][stat] <= -5 then
        A.people[realmName][player][stat] = -5
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
    if UnitExists('target') and UnitIsPlayer('target') and UnitName('target') ~= UnitName('player') then
        if A.people[realmName][UnitName('target')] == nil then
            archAddPlayer(UnitName('target'))
        end
        A.people[realmName][UnitName('target')].note = msg
        if msg ~= '' then
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. focusColor(UnitName('target')) .. ': ' ..
                                               A.people[realmName][UnitName('target')].note)
        else
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Note for ' .. focusColor(UnitName('target')) ..
                                               ' has been pruned.')
        end
    elseif UnitName('target') == UnitName('player') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'You cannot add note for your own character')
    else
        -- :: Get Name and not after
        args = fixArgs(msg)
        mod = 'not'
        if args[1] then
            C_FriendList.SetWhoToUi(1)
            C_FriendList.SendWho('n-"' .. args[1] .. '"')
        end
    end

end

-- :: add if player note exists on tooltip
local function addNote(args)
    local name = table.remove(args, 1)
    local note = table.concat(args, ' ')

    if A.people[realmName][name] == nil then
        archAddPlayer(name)
    end
    A.people[realmName][name].note = note

    if args[1] then
        -- print(note)
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. focusColor(name) .. ': ' .. A.people[realmName][name].note)
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Note for ' .. focusColor(name) .. ' has been pruned.')
    end
end

local function handlePlayerStat(msg, parameter, pass)

    args = fixArgs(msg)
    mod = parameter

    if args[1] then
        -- :: Isim oncelikli entry
        if type(tonumber(args[1])) ~= "number" then
            C_FriendList.SetWhoToUi(1)
            C_FriendList.SendWho('n-"' .. args[1] .. '"')
        else
            -- :: Target varsa
            if UnitExists('target') and UnitName('target') ~= UnitName('player') and UnitIsPlayer('target') then
                -- factionName = UnitFactionGroup('target')
                if A.people[realmName][UnitName('target')] == nil then
                    archAddPlayer(UnitName('target'))
                end

                if type(tonumber(args[1])) == "number" then
                    A.people[realmName][UnitName('target')][parameter] = tonumber(
                        A.people[realmName][UnitName('target')][parameter]) + tonumber(args[1])
                    checkStatLimit(UnitName('target'), parameter)
                    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. focusColor(UnitName('target')) .. ' ' .. parameter ..
                                                       ' is now ' .. A.people[realmName][UnitName('target')][parameter])
                end
            end
            -- :: not varsa   
            -- test
            if args[3] then
                table.remove(args, 1)
                table.insert(args, 1, tostring(UnitName('target')))
                -- local asdf = table.concat(args, ' ')
                -- SELECTED_CHAT_FRAME:AddMessage(asdf)
                local noteBlock = args
                addNote(noteBlock)
            end
            -- test end
        end

    else
        -- :: isim argumani yok ise targeta bak
        if UnitExists('target') and UnitName('target') ~= UnitName('player') and UnitIsPlayer('target') then
            factionName = UnitFactionGroup('target')
            -- :: Create person if not already exists
            if A.people[realmName][UnitName('target')] == nil then
                archAddPlayer(UnitName('target'))
            else
                archGetPlayer(UnitName('target'))
            end
        end
    end
end

-- :: add player stat [who da kullaniliyor] args[1] = player name args[]
local function addPlayerStat(args, parameter)
    if A.people[realmName][args[1]] == nil then
        archAddPlayer(args[1])
    end
    if args[2] then
        if type(tonumber(args[2])) == "number" then
            A.people[realmName][args[1]][parameter] = tonumber(A.people[realmName][args[1]][parameter]) +
                                                          tonumber(args[2])
            checkStatLimit(args[1], parameter)
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. args[1] .. ' ' .. parameter .. ' is now ' ..
                                               A.people[realmName][args[1]][parameter])
            -- test
            if args[3] then
                table.remove(args, 2)
                -- SELECTED_CHAT_FRAME:AddMessage(args[1] .. ' '.. args[2])
                local noteBlock = args
                addNote(noteBlock)
            end
            -- test
        else
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'your entry is not valid')
        end
    else
        archGetPlayer(args[1])
    end
end

-- :: main function
local function groupRepCheck(msg)
    -- do return end
    local groupMembers = 0
    groupRoster = {'party1', 'party2', 'party3', 'party4'}
    local groupType = nil
    if UnitInRaid('player') then
        groupType = "raid"
        groupMembers = GetNumRaidMembers()
    elseif UnitInParty('player') then
        groupType = "party"
        groupMembers = GetNumGroupMembers()
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'you are not in group')
    end
    if groupType ~= nil then
        local blacklist = {}
        local whitelist = {}
        local person
        -- :: add raidwise reputation
        if msg ~= nil and msg ~= '' then
            if type(tonumber(msg)) == "number" then
                for ii = 1, groupMembers do
                    -- local person = GetRaidRosterInfo(ii)
                    if groupType == "raid" then
                        args[1] = GetRaidRosterInfo(ii)
                    elseif groupType == "party" then
                        args[1] = UnitName(groupRoster[ii])
                    end
                    -- :: control break
                    if args[1] == nil then
                        do
                            return
                        end
                    end
                    args[2] = msg
                    addPlayerStat(args, 'reputation')
                    -- handlePlayerStat(person .. ' ' .. msg, 'reputation') 
                end
            end
        end
        --
        -- :: check if blacklisted
        --
        for ii = 1, groupMembers do
            -- :: check if party or group
            if groupType == "raid" then
                person = GetRaidRosterInfo(ii)
            elseif groupType == "party" then
                person = UnitName(groupRoster[ii])
            end
            -- :: control break
            if person ~= nil then
                if A.people[realmName][person] == nil then
                    archAddPlayer(person)
                else
                    for yy = 1, #quantitative do
                        if A.people[realmName][person][quantitative[yy]] < 0 then
                            table.insert(blacklist, person)
                            break
                        elseif A.people[realmName][person][quantitative[yy]] > 0 then
                            if Archrist_PlayerDB_calcRaidScore(person) > 0 then
                                table.insert(whitelist, person)
                                break
                            end
                        end
                    end
                end
            end
        end
        --
        local checkWhitelist = ''
        if #whitelist > 0 then
            for ii = 1, #whitelist do
                checkWhitelist = checkWhitelist .. whitelist[ii]
                if ii ~= #whitelist then
                    checkWhitelist = checkWhitelist .. ', '
                end
            end
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. focusColor('Whitelist: ') .. checkWhitelist)
        end
        --
        local checkBlacklist = ''
        -- print(#blacklist)
        if #blacklist > 0 then
            for ii = 1, #blacklist do
                checkBlacklist = checkBlacklist .. blacklist[ii]
                if ii ~= #blacklist then
                    checkBlacklist = checkBlacklist .. ', '
                end
            end
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. focusColor('Blacklist: ') .. checkBlacklist)
            -- return
        else
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'nobody in raid in your blacklist')
        end
    end
end

-- ==== Event Handlers
function module:PLAYER_REGEN_ENABLED()
    -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
    isInCombat = false
end

function module:PLAYER_REGEN_DISABLED()
    isInCombat = true
end

function module:WHO_LIST_UPDATE() -- CHAT_MSG_SYSTEM()whitelist
    if mod ~= 'patates' and mod ~= 'lootEntry' then
        -- print(args[1] .. " " .. type(args[1]) .. " " .. #args[1])
        for ii = 1, C_FriendList.GetNumWhoResults() do
            local char = C_FriendList.GetWhoInfo(ii)
            if char.fullName == args[1] then
                isPlayerExists = true
                break
            end
        end
        -- table.remove(args, 1)
        -- args = table.concat(args, " ")
        -- args = fixArgs(args)
        -- for ii=1, #args do
        --     print(args[ii])
        -- end
        ToggleFriendsFrame(2)
        -- FriendsFrame:Hide()
        -- :: playeri adinin basina / yazildiysa who kontrolu olmadan ekle kontrolsuz ekle
        if not isPlayerExists and string.sub(args[1], 1, 1) == '/' then
            args[1] = string.sub(args[1], 2)
            args = table.concat(args, " ")
            args = fixArgs(args)
            -- :: eski kod
            -- table.remove(args, 1)
            -- args = table.concat(args, " ")
            -- args = fixArgs(args)
            isPlayerExists = true
        end
        --
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
    end
    mod = 'patates'

end

function module:RAID_ROSTER_UPDATE()
    if UnitInRaid('player') then
        local blacklist = {}
        local whitelist = {}
        for ii = 1, GetNumRaidMembers() do
            local person = GetRaidRosterInfo(ii)
            if A.people[realmName][person] == nil then
                archAddPlayer(person)
            else
                for yy = 1, #quantitative do
                    if A.people[realmName][person][quantitative[yy]] < 0 then
                        table.insert(blacklist, person)
                        break
                    end
                end
            end
        end
        --
        local checkBlacklist = ''
        if #blacklist > 0 then
            for ii = 1, #blacklist do
                checkBlacklist = checkBlacklist .. blacklist[ii]
                if ii ~= #blacklist then
                    checkBlacklist = checkBlacklist .. ', '
                end
            end
            if lastBlacklist ~= checkBlacklist then
                SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. focusColor('Warning Blacklist: ') .. checkBlacklist)
                lastBlacklist = checkBlacklist
            end
            -- return
            -- else
            --     SELECTED_CHAT_FRAME:AddMessage(
            --         moduleAlert .. 'nobody in raid in your blacklist')
        end
        --
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'you are not in raid')
    end
end

-- ==== Slash Handlers
SLASH_reputation1 = "/rep"
SlashCmdList["reputation"] = function(msg)
    handlePlayerStat(msg, 'reputation')
end
SLASH_discipline1 = "/dsc"
SlashCmdList["discipline"] = function(msg)
    handlePlayerStat(msg, 'discipline')
end
SLASH_strategy1 = "/str"
SlashCmdList["strategy"] = function(msg)
    handlePlayerStat(msg, 'strategy')
end
SLASH_damage1 = "/dmg"
SlashCmdList["damage"] = function(msg)
    handlePlayerStat(msg, 'damage')
end
SLASH_attendance1 = "/att"
SlashCmdList["attendance"] = function(msg)
    handlePlayerStat(msg, 'attendance')
end
SLASH_groupRepCheck1 = "/rrep"
SlashCmdList["groupRepCheck"] = function(msg)
    groupRepCheck(msg)
end
SLASH_not1 = "/not"
SlashCmdList["not"] = function(msg)
    handleNote(msg)
end

-- ==== GUI
GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)
