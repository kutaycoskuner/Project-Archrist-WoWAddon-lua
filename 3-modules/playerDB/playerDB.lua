------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'PlayerDB', "Player Database";
local moduleAlert = M .. moduleName2 .. ": |r";
local module = A:GetModule(moduleName1, true);
local aprint = Arch_print
local mprint = function(msg)
    print(moduleAlert .. msg)
end
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
local cCol = Arch_commandColor
local fCol = Arch_focusColor
local classCol = Arch_classColor
local tCol = Arch_trivialColor
local pCase = Arch_properCase
local addPlayer = arch_addPersonToDatabase

-- !! IMPORTANT GLOBAL
local Raidscore
local mod = 'patates' -- rep / not
local args = {}
local isPlayerExists = false
local isInCombat = false
local realmName = GetRealmName()
local factionName = UnitFactionGroup('player')
local quantitative = {'reputation', 'strategy', 'discipline', 'attendance', 'damage'}
local lastBlacklist

local drawMainFrame = nil
--
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
local category = "impressions"
local categories = {
    ["impressions"] = impressions,
    ["organization"] = organization
}
--
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
    module:RegisterEvent("CHAT_MSG_SYSTEM")
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

-- :: Calculate raidscore
-- function Archrist_PlayerDB_calcRaidScore(player)

--     if not A.people[realmName][player][category] then
--         archAddPlayer(player)
--     end
--     local rep = (tonumber(A.people[realmName][player][category].reputation) * 250)
--     local dsc = (tonumber(A.people[realmName][player][category].discipline) * 300)
--     local str = (tonumber(A.people[realmName][player][category].strategy) * 300)
--     local dmg = (tonumber(A.people[realmName][player][category].damage) * 200)
--     local att = (tonumber(A.people[realmName][player][category].attendance) * 100)
--     local gsr
--     local raidScore = rep + dsc + str + dmg + att

--     if GameTooltip:GetUnit() then
--         local Name = GameTooltip:GetUnit();
--         -- if GearScore_GetScore(Name, "mouseover") then
--         -- gsr = 0 --GearScore_GetScore(Name, "mouseover")
--         -- print(gsr)
--         -- print(raidScore + gsr)
--         -- return (raidScore + gsr)
--         -- end
--     end

--     return raidScore
-- end

-- :: present player note
function Archrist_PlayerDB_getNote(player)
    if not isInCombat then
        local Name = GameTooltip:GetUnit();
        if Name ~= UnitName('player') then
            if A.people[realmName][Name] then
                local note = A.people[realmName][Name][category].note
                if note ~= '' then
                    GameTooltip:AddLine(note, 0.5, 0.5, 0.5, true)
                end
            end
        end
    end
end

local function Archrist_PlayerDB_getRaidScore()
    if GameTooltip:GetUnit() then
        -- local Name = GameTooltip:GetUnit();
        -- if not GearScore_GetScore then
        --     return
        -- end
        -- if GearScore_GetScore(Name, "mouseover") then
        --     if A.people[realmName][Name] then
        --         local gearScore = GearScore_GetScore(Name, "mouseover")
        --         if gearScore and gearScore > 0 then
        --             local personalData = Archrist_PlayerDB_calcRaidScore(Name)
        --             -- local note = Archrist_PlayerDB_getNote(Name)
        --             local raidScore = personalData
        --             if gearScore ~= raidScore then
        --                 GameTooltip:AddLine('RaidScore: ' .. raidScore, 0, 78, 100)
        --             end
        --         end
        --     end
        -- end
    end
end

local function Archrist_PlayerDB_getPlayerData()
    if not isInCombat then
        local Name = GameTooltip:GetUnit();
        if Name ~= UnitName('player') then
            if A.people[realmName][Name] then
                for ii = 1, #quantitative do
                    if A.people[realmName][Name][category][quantitative[ii]] ~= nil then
                        local data = A.people[realmName][Name][category][quantitative[ii]]
                        if data ~= 0 then
                            GameTooltip:AddLine(quantitative[ii] .. ' ' .. data, 0.5, 0.5, 0.5, true)
                        end
                    end
                end
            end
        end
    end
end
-- :: Get Player Stats
local function archGetPlayer(player)
    if A.people[realmName][player] then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. fCol(player))
        factionName = UnitFactionGroup('player')
        for yy = 1, #quantitative do
            if A.people[realmName][player][category][quantitative[yy]] ~= 0 then
                aprint(tCol(quantitative[yy] .. ': ') .. A.people[realmName][player][category][quantitative[yy]])
            end
        end
        --
        if A.people[realmName][player][category].note ~= '' then
            aprint(tCol("Note:") .. A.people[realmName][player][category].note)
        end
    else
        aprint(fCol(player) .. " not found in your database.")
        -- C_FriendList.SetWhoToUi(1)
        -- C_FriendList.SendWho('n-"' .. player .. '"')
    end
end

-- ==== Main 
local function checkStatLimit(player, stat)
    if A.people[realmName][player][category][stat] == nil then
        A.people[realmName][player][category][stat] = stat
    elseif A.people[realmName][player][category][stat] >= 5 then
        A.people[realmName][player][category][stat] = 5
    elseif A.people[realmName][player][category][stat] <= -5 then
        A.people[realmName][player][category][stat] = -5
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
            local p_name, p_server, guid, p_class = identifyPlayer("target")
            addPlayer(p_name, p_server) -- bu fonksiyon grouporgnizer icinde
        end
        A.people[realmName][UnitName('target')][category].note = msg
        if msg ~= '' then
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. fCol(UnitName('target')) .. ': ' ..
                                               A.people[realmName][UnitName('target')][category].note)
        else
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Note for ' .. fCol(UnitName('target')) .. ' has been pruned.')
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
        aprint("cannot find " .. fCol(args) .. " in your database.")
    end
    A.people[realmName][name][category].note = note

    if args[1] then
        -- print(note)
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. fCol(name) .. ': ' .. A.people[realmName][name][category].note)
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Note for ' .. fCol(name) .. ' has been pruned.')
    end
end

local function changeQuanParam(par, val, name, server)
    if type(tonumber(val)) == "number" then
        arch_addPersonToDatabase(name, server)
        A.people[realmName][name][category][par] = tonumber(A.people[realmName][name][category][par]) + tonumber(val)
        checkStatLimit(name, par)
        aprint(fCol(name) .. ' ' .. par .. tCol(' is now ') .. cCol(A.people[realmName][name][category][par]))
    end
    -- archGetPlayer(name)
end

local function changeNote(note, name, server)
    if type(note) == "string" then
        A.people[realmName][name][category].note = note
        aprint(fCol(name) .. tCol("note has changed to ") .. note)
    end
end

local function handlePlayerStat(msg, parameter, pass)

    args = fixArgs(msg)
    mod = parameter
    -- :: ek parametre var mi isim, sayi etc
    if args[1] then
        -- :: Isim oncelikli entry
        if type(tonumber(args[1])) ~= "number" then
            -- :: isim varsa ve reputation belirtilmemisse karakteri cek
            if args[2] == nil and A.people[realmName][args[1]] ~= nil then
                archGetPlayer(args[1])
                do
                    return
                end
            end
            -- :: ilk karakter / ise dogrudan ekle
            if string.sub(args[1], 1, 1) == "/" then
                args[1] = pCase(args[1]:sub(2))
                addPlayer(args[1], "")
                local p_name = table.remove(args, 1)
                if args[2] ~= nil then
                    -- :: eger reputation varsa
                    local p_parValue = table.remove(args, 1)
                    changeQuanParam(parameter, p_parValue, p_name, "")
                    -- :: comment varsa
                    if args[3] ~= nil then
                        local comment = table.concat(args, " ")
                        changeNote(comment, p_name, "")
                    end
                end
                archGetPlayer(p_name)
                do
                    return
                end
            end
            -- :: who gonderip event triggerla ordan hallediyor
            C_FriendList.SetWhoToUi(1)
            C_FriendList.SendWho('n-"' .. args[1] .. '"')
        else
            -- :: Target varsa
            if UnitExists('target') then
                local p_name, p_server, guid, p_class = identifyPlayer("target")
                if UnitIsPlayer('target') then
                    if UnitName('target') ~= UnitName('player') then
                        if A.people[realmName][UnitName('target')] == nil then
                            arch_addPersonToDatabase(p_name, p_server)
                        end
                        -- :: change q param
                        changeQuanParam(parameter, args[1], p_name, p_server)
                    end
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
                local p_name, p_server, guid, p_class = identifyPlayer("target")
                arch_addPersonToDatabase(p_name, p_server)
            else
                archGetPlayer(UnitName('target'))
            end
        end
    end
end

-- :: add player stat [who da kullaniliyor] args[1] = player name args[]
local function addPlayerStat(args, parameter)
    if A.people[realmName][args[1]] == nil then
        arch_addPersonToDatabase(args[1], "")
    end
    if args[2] ~= nil then
        if type(tonumber(args[2])) == "number" then
            A.people[realmName][args[1]][category][parameter] = tonumber(
                A.people[realmName][args[1]][category][parameter]) + tonumber(args[2])
            checkStatLimit(args[1], parameter)
            aprint(fCol(args[1]) .. ' ' .. parameter .. tCol(' is now ') ..
                       cCol(A.people[realmName][args[1]][category][parameter]))
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
    groupRoster = {'player', 'party1', 'party2', 'party3', 'party4'}
    local groupType = nil
    if UnitInRaid('player') then
        groupType = "raid"
        groupMembers = GetNumGroupMembers()
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
                    local p_name, p_server, guid, p_class = identifyPlayer(ii)
                    arch_addPersonToDatabase(p_name, p_server)
                else
                    for yy = 1, #quantitative do
                        if A.people[realmName][person] == nil then
                            local p_name, p_server, guid, p_class = identifyPlayer(ii)
                            arch_addPersonToDatabase(p_name, p_server)
                        end
                        local qPar = A.people[realmName][person][category][quantitative[yy]]
                        if qPar ~= nil then
                            if type(qPar) == "number" then
                                if qPar < 0 then
                                    print('test 3')
                                    table.insert(blacklist, person)
                                    break
                                elseif qPar > 0 then
                                    -- if true then -- Archrist_PlayerDB_calcRaidScore(person) > 0 then
                                    --     table.insert(whitelist, person)
                                    --     break
                                    -- end
                                end
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
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. fCol('Whitelist: ') .. checkWhitelist)
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
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. fCol('Blacklist: ') .. checkBlacklist)
            -- return
        else
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'nobody in raid in your blacklist')
        end
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
            aprint('Player not found on who inquiry')
        end
    end
    mod = 'patates'

end

function module:CHAT_MSG_SYSTEM(_, arg1)
    if string.find(arg1, "joins the") then
        if GetNumGroupMembers() == 5 or GetNumGroupMembers() == 10 or GetNumGroupMembers() == 18 or GetNumGroupMembers() ==
            25 then
            groupRepCheck("")
        end
    elseif string.find(arg1, "leaves the") then
    elseif string.find(arg1, "Party converted to Raid") then
    elseif string.find(arg1, "You leave the group") then
    elseif string.find(arg1, "has been disbanded") then
    end
end

function module:RAID_ROSTER_UPDATE()
    if UnitInRaid('player') then
        local blacklist = {}
        local whitelist = {}
        for ii = 1, GetNumRaidMembers() do
            local person = GetRaidRosterInfo(ii)
            local p_name, p_server, guid, p_class = identifyPlayer(ii)
            if A.people[realmName][person] == nil then
                arch_addPersonToDatabase(p_name, p_server)
            else
                for yy = 1, #quantitative do
                    if A.people[realmName][person][category][quantitative[yy]] < 0 then
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
                SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. fCol('Warning Blacklist: ') .. checkBlacklist)
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

-- ==== GuI Drawing util
-- :: draw head
local function drawHead(name, parent)
    local heading = AceGUI:Create('Heading')
    heading:SetText(name)
    heading:SetRelativeWidth(1)
    parent:AddChild(heading)
end

drawMainFrame = function()
    -- :: create frame
    -- Arch_guiFrame:SetWidth(440)
    -- Arch_guiFrame:SetHeight(420)
    Arch_guiFrame:ClearAllPoints()
    -- :: remembering the position of frame
    -- guideFramePos = A.global.guideFrame
    -- if A.global.guideFrame == {} then
    --     Arch_guiFrame:SetPoint("CENTER", 0, 0)
    -- else
    --     Arch_guiFrame:SetPoint(guideFramePos[1], guideFramePos[3], guideFramePos[4])
    -- end
    -- Arch_guiFrame:ReleaseChildren()
    -- :: heading 
    drawHead("Player Database", Arch_guiFrame)
    -- :: Player entry log
    -- name, level, class, rep, dsc, str, dmg, not, time
    -- dd:SetList(guideType)
    -- dd:SetValue(A.global.selectedGuide)
    -- dd:SetFullWidth(true)
    -- dd:SetCallback("OnValueChanged", function(widget, event, selection)
    --     setFramePos()
    --     if guide_Assoc[selection] then
    --         A.global.selectedGuide = selection
    --         profession = selection
    --         guide = guide_Assoc[selection]
    --         selectTargetLevel()
    --         adaptResourceList()
    --         drawRepeat()
    --     end
    -- end)
    -- Arch_guiFrame:AddChild(dd)
    -- :: draw tabs
    -- drawBtn("Material List", 0.5, Arch_guiFrame)
    -- drawBtn("Craft Guide", 0.5, Arch_guiFrame)
end

function Arch_playerDB_GUI()
    drawMainFrame()
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
SLASH_pdb1 = "/pdb"
SlashCmdList["pdb"] = function(msg)
    Arch_setGUI('PlayerDB')
end

-- ==== GUI
GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)
