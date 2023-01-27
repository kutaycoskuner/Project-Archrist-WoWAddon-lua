------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'GroupOrganizer', "Organizer";
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
]]

-- theory / calculation ------------------------------------------------------------------------------------------------
--[[
        - warrior   mdps, tank              | dps = mortal strike, blood rush | tank = 
        - paladin   tank, heal, mdps        | tank = 
        - hunter    rdps
        - rogue     mdps
        - priest    heal, rdps              |
        - shaman    heal, mdps, rdps        |
        - mage      rdps
        - warlock   rdps    
        - druid     tank, heal, mdps, rdps  | 
        - dk        tank, mdps              | tank = heart strike | mdps = frost strike

]]

-- use case ------------------------------------------------------------------------------------------------------------
--[[
    - [x] trigger veya belirtilen komut ile grubu scanleyip rollere gore kategorize edecek
        - [c] organizer enable ise giren herkes icin rol secme ekle belirli araliklarla hatirlat
            - [x] manual role
                - [x] target secip 4 rolden birini gir
                - [x] data ["playerName"] = {["role"]="4 rolden biri", ["tasks"]=}{"birden fazla olabilir: interrupter, decurser, dispeller, paladinspecial"}}
                    - [x] random rol vermesini engelle
                        - [x] 4 rolden biri olmali
                        - [x] class in olabildigi rollerden biri olmali
            - [x] auto role
                - methods    
                    - [x] single role
                    - [x] inspect
                    - [c] specific skill usage
                - constraints
                    - [x] yabanci server olanlari ekleme

        - [x] gruptaki rolleri komutla goster

    - [x] tank, healer, mdps, rdps olarak rol atayacak
    
    - [x] mdps yi interrupter siniflarina ayiracak
        - [x] 3 group | her birine sirayla atasin

    - [x] boss interrupt skill cast ettiginde sirayla gruba alert gonderecek
    
    - [x] bazi ozel moblar icin paladinlerin talent i varsa sirasiyla kimin kullanacagini soyleyecek

    - [x] spell track customizability
        	- [x] spell que tut bunlari registera aktar

    - [x] disable module and registrations
    
    - [x] fix: isim veya spell id 
    
    - [x] event trigger a delay ekle 

    - [x] mage focus que

    ]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
-- :: imports
local LCI = A.Libs.LCI
LCI:IsWotlk()
-- local LCS = A.Libs.LCS
-- local GetSpecialization = (A.Classic or A.Wrath and LCS.GetSpecialization) or GetSpecialization
-- local GetSpecializationRole = (A.Classic or A.Wrath and LCS.GetSpecializationRole) or GetSpecializationRole
-- local GetInspectSpecialization = (A.Classic or A.Wrath and LCS.GetInspectSpecialization) or GetInspectSpecialization
-- local GetSpecialization = LCI.GetSpecialization
-- local GetTalentPoints = LCI.GetTalentPoints
-- local GetActiveTalentGroup = LCI.GetActiveTalentGroup
-- local GetSpecializationName = LCI.GetSpecializationName -- class, spec, true

-- :: global Functions
local fCol = Arch_focusColor
local cCol = Arch_commandColor
local mCol = Arch_moduleColor
local tCol = Arch_trivialColor
local classCol = Arch_classColor
local pCase = Arch_properCase
local a_announce = Arch_sendChatMessage
local addPlayer = arch_addPersonToDatabase
local split = Arch_split
arch_opt_triggerSpells = {}

local realmName = GetRealmName()
local triggerSpells = {}

-- :: announcer
local isEnabled = true
local timeInMin = 10
local delayInSecs = 3
local delayedStart = tonumber(GetTime())
local announceType = 'self'
local text = "Check your posture!"

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
local category = "organization"

-- :: announce frame
local f = CreateFrame("Frame")

-- :: group utility
local group_roles = {
    ["heal"] = {},
    ["mdps"] = {},
    ["rdps"] = {},
    ["tank"] = {},
    ["unassigned"] = {}
}
-- ::jump1
local group_pos = {
    ["mdps"] = {
        [1] = {},
        [2] = {},
        [3] = {}
    },
    ["rdps"] = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {}
    },
    ["heal"] = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {}
    }
}

local pos_tracker = {
    ["mdps"] = 1,
    ["rdps"] = 1,
    ["heal"] = 1
}

local pos_tracker_limit = {
    ["mdps"] = 6,
    ["rdps"] = 6,
    ["heal"] = 6
}

local pos_heal = {}

local role_order = {"tank", "heal", "mdps", "rdps", "unassigned"}

local group_tasks = {
    ["interrupter"] = {},
    ["decurser"] = {},
    ["dispeller"] = {},
    ["guardian"] = {}
}

local interrupt_groups = {
    [1] = {},
    [2] = {},
    [3] = {}
}
local interrupt_groups_size = 0
for keys in pairs(interrupt_groups) do
    interrupt_groups_size = interrupt_groups_size + 1
end

-- local dispellers = {}
-- local decursers = {}
local divine_sacrifice = {}
local aura_mastery = {}
local focus_magic = {}

local que_interrupt = 0
local que_auraMastery = 0
local que_divineSacrifice = 0

local sign_group_task = {
    [1] = "interrupt",
    [2] = "aura",
    [3] = "divine"
}

local function announce(string, isSilent)
    if not isSilent then
        local announce = string
        if UnitInRaid('player') then
            SendChatMessage(announce, "raid", nil, "channel")
        elseif UnitInParty('player') then
            SendChatMessage(announce, "party", nil, "channel")
        end
    else
        aprint(announce)
    end
end

-- :: availability
local available_interruptors = {
    ["WARRIOR"] = true,
    ["SHAMAN"] = true,
    ["DEATHKNIGHT"] = true,
    ["ROGUE"] = true
    --
    -- ["MAGE"] = true,
    -- ["PALADIN"] = true,
    -- ["DRUID"] = true
}

local available_roles = {
    ["Warrior"] = {"mdps", "mank"},
    ["Paladin"] = {"tank", "heal", "mdps"},
    ["Hunter"] = {"rdps"},
    ["Rogue"] = {"mdps"},
    ["Priest"] = {"rdps", "heal"},
    ["Shaman"] = {"heal", "mdps", "rdps"},
    ["Mage"] = {"rdps"},
    ["Warlock"] = {"rdps"},
    ["Druid"] = {"tank", "heal", "mdps", "rdps"},
    ["Death Knight"] = {"tank", "mdps"}

}

local available_spec_role = {
    ['Blood'] = "tank",
    ['Frost'] = "mdps",
    ['Unholy'] = "mdps",
    ['Holy'] = "heal",
    ['Balance'] = "rdps",
    ['Feral Combat'] = "mdps",
    ['Restoration'] = "heal",
    ['Beast Mastery'] = "rdps",
    ['Marksmanship'] = "rdps",
    ['Survival'] = "rdps",
    ['Arcane'] = "rdps",
    ['Fire'] = "rdps",
    ['Protection'] = "tank",
    ['Retribution'] = "mdps",
    ['Discipline'] = "heal",
    ['Shadow'] = "rdps",
    ['Assassination'] = "mdps",
    ['Combat'] = "mdps",
    ['Sublety'] = "mdps",
    ['Elemental'] = "rdps",
    ['Enhancement'] = "mdps",
    ['Affliction'] = "rdps",
    ['Demonology'] = "rdps",
    ['Destruction'] = "rdps",
    ['Arms'] = "mdps",
    ['Fury'] = "mdps"
}

-- :: msg table
-- local msg_handle_function = {
--     [""] = nil
--     [""] = 
-- }
createOptTable_triggerSpells = nil

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- :: construct
    if A.people == nil then
        A.people = {}
    end
    if A.people[realmName] == nil then
        A.people[realmName] = {}
    end
    -- :: construct
    if A.global.assist == nil then
        A.global.assist = {}
    end
    if A.global.assist.groupOrganizer == nil then
        A.global.assist.groupOrganizer = {}
    end
    -- :: is module enabled
    if A.global.assist.groupOrganizer.isEnabled == nil then
        A.global.assist.groupOrganizer.isEnabled = isEnabled
    end
    isEnabled = A.global.assist.groupOrganizer.isEnabled
    -- :: track spells
    if A.global.assist.groupOrganizer.triggerSpells == nil then
        A.global.assist.groupOrganizer.triggerSpells = triggerSpells
    end
    triggerSpells = A.global.assist.groupOrganizer.triggerSpells
    -- :: option role
    if A.global.assist.groupOrganizer.task == nil then
        A.global.assist.groupOrganizer.task = ""
    end
    -- test
    createOptTable_triggerSpells()
    -- for k, v in pairs(arch_opt_triggerSpells) do
    --     aprint(k)
    -- end
    -- test end

end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function isDelayed()
    local current = tonumber(GetTime())
    if current <= delayedStart then
        return false
    else
        delayedStart = current + delayInSecs
        return true
    end
end

-- :: utility functions
local function resetTable(t)
    if t ~= nil then
        for k, v in pairs(t) do
            t[k] = {}
        end
    end
end

local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a, b)
            return order(t, a, b)
        end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local function properCase(str)
    if str ~= nil then
        return (str:gsub("^%l", string.upper))
    end
end

function identifyPlayer(ii)
    local guid
    if type(ii) == "number" then
        if UnitInRaid('player') then
            guid = UnitGUID("raid" .. ii)
        else
            guid = UnitGUID("party" .. ii)
            if guid == nil then
                guid = UnitGUID("player")
            end
        end
    elseif ii == "target" then
        guid = UnitGUID('target')
    else
        return
    end
    local _, p_class, _, p_race, _, p_name, p_server = GetPlayerInfoByGUID(guid)
    local p_guid = guid
    return p_name, p_server, p_guid, p_class
    -- local  p_name, p_server, guid, p_class = identifyPlayer(ii)
end

local function setRole(player, class, role, server)
    -- :: if there is no player add
    arch_addPersonToDatabase(player, server)
    -- :: 
    if A.people[realmName][player][category] == nil then
        do
            return
        end
    end
    class = pCase(class)
    if available_roles[class] then
        for ii = 1, #available_roles[class] do
            if role == available_roles[class][ii] then
                A.people[realmName][player][category]["role"] = role
                aprint("you have set " .. fCol(properCase(role)) .. " role to " .. classCol(class, UnitName("target")))
                return
            end
        end
    end
    aprint("given role is not applicable for " .. classCol(class, class))
end

local function printGroupRoles()
    -- for role in spairs(group_roles) do
    local printTitle = true
    for ii = 1, #role_order do
        if printTitle then
            aprint(fCol(":: Group Role Categorization ::"))
            printTitle = false
        end
        local role = role_order[ii]
        local role_string = mCol(properCase(role) .. ": ")
        for player in pairs(group_roles[role]) do
            role_string = role_string .. player .. " "
        end
        if role_string ~= mCol(properCase(role) .. ": ") then
            print(M .. "|r" .. role_string)
        end
    end
end

local function printTasks()
    -- :: print interruptors
    local printTitle = true
    for group in ipairs(interrupt_groups) do
        if printTitle then
            aprint(fCol(":: Task Groups ::"))
            printTitle = false
        end
        -- 
        local group_string = mCol(properCase("Interrupt group " .. group) .. ": ")
        for ii = 1, #interrupt_groups[group] do
            group_string = group_string .. interrupt_groups[group][ii] .. " "
        end
        if group_string ~= mCol(properCase("Interrupt group " .. group) .. ": ") then
            print(M .. "|r" .. group_string)
        end
    end
    -- :: print guardians
    local guardian_string = mCol(properCase("Guardian Paladins: "))
    for ii = 1, #divine_sacrifice do
        guardian_string = guardian_string .. divine_sacrifice[ii] .. " "
    end
    if guardian_string ~= mCol(properCase("Guardian Paladins: ")) then
        print(M .. "|r" .. guardian_string)
    end
    -- :: aura master
    local guardian_string = mCol(properCase("Aura Paladins: "))
    for ii = 1, #aura_mastery do
        guardian_string = guardian_string .. aura_mastery[ii] .. " "
    end
    if guardian_string ~= mCol(properCase("Aura Paladins: ")) then
        print(M .. "|r" .. guardian_string)
    end
end

-- :: announce player / group
local function announceDivine(msg)
    local string = ""
    que_divineSacrifice = que_divineSacrifice + 1
    -- :: pick sequence
    if divine_sacrifice[que_divineSacrifice] ~= nil then
        string = divine_sacrifice[que_divineSacrifice]
    end
    -- :: print
    if string ~= "" then
        string = msg .. " >> " .. string .. " <<"
        if UnitIsGroupLeader('player') then
            SendChatMessage(string, "raid_warning", nil, "channel")
        elseif UnitInRaid('player') then
            SendChatMessage(string, "raid", nil, "channel")
        elseif UnitInParty('player') then
            SendChatMessage(string, "party", nil, "channel")
        else
            aprint(string)
        end
    end
    if que_divineSacrifice > #divine_sacrifice then
        que_divineSacrifice = 1
    end
end

local function announceAura(msg)
    local string = ""
    que_auraMastery = que_auraMastery + 1
    -- :: pick sequence
    if aura_mastery[que_auraMastery] ~= nil then
        string = aura_mastery[que_auraMastery]
    end
    -- :: print
    if string ~= "" then
        string = msg .. " >> " .. string .. " <<"
        if UnitIsGroupLeader('player') then
            SendChatMessage(string, "raid_warning", nil, "channel")
        elseif UnitInRaid('player') then
            SendChatMessage(string, "raid", nil, "channel")
        elseif UnitInParty('player') then
            SendChatMessage(string, "party", nil, "channel")
        else
            aprint(string)
        end
    end
    if que_auraMastery > #aura_mastery then
        que_auraMastery = 1
    end
end

local function announceGroup()
    -- :: counter
    que_interrupt = que_interrupt + 1
    -- :: ilk sira bos ise announce yok
    if interrupt_groups[que_interrupt] == nil then
        que_interrupt = 1
        if #interrupt_groups[que_interrupt] == 0 then
            return
        end
    end
    -- :: grup bossa
    if #interrupt_groups[que_interrupt] == 0 then
        local b_foundGroup = false
        for ii = que_interrupt, interrupt_groups_size do
            que_interrupt = que_interrupt + 1
            if interrupt_groups[que_interrupt] ~= nil then
                if #interrupt_groups[que_interrupt] > 0 then
                    b_foundGroup = true
                    break
                end
            end
        end
        if not b_foundGroup then
            que_interrupt = 1
        end
    end
    -- :: print
    local string = ""
    for ii = 1, #interrupt_groups[que_interrupt] do
        -- print(interrupt_groups[interruptQue][ii])
        if interrupt_groups[que_interrupt][ii] ~= nil then
            string = (string .. interrupt_groups[que_interrupt][ii] .. " ")
        end
    end
    if string ~= "" then
        string = "Interrupters" .. " >> " .. string .. " <<"
        -- aprint(string)
        if UnitInRaid('player') then
            if UnitIsGroupLeader('player') then
                SendChatMessage(string, "raid_warning", nil, "channel")
            else
                SendChatMessage(string, "raid", nil, "channel")
            end
        elseif UnitInParty('player') then
            SendChatMessage(string, "party", nil, "channel")
        else
            aprint(string)
        end
    end
end

local function announceFocusQue(isSilent)
    if #focus_magic > 1 then
        local announce = "Focus Link: "
        for ii = 1, #focus_magic do
            announce = announce .. focus_magic[ii] .. " >> "
        end
        announce = announce .. focus_magic[1]
        if not isSilent then
            if UnitInRaid('player') then
                SendChatMessage(announce, "raid", nil, "channel")
            elseif UnitInParty('player') then
                SendChatMessage(announce, "party", nil, "channel")
            end
        else
            aprint(fCol(":: Suggested Focus Queue ::"))
            aprint(announce)
        end
    else
        if not isSilent then
            aprint("not enough people for focus link")
        end
    end
end
--
local function assignInterruptor(player)
    local smallestGroup
    local smallestGroupKey
    for key, group in ipairs(interrupt_groups) do
        if smallestGroup == nil then
            smallestGroup = group
            smallestGroupKey = key
        elseif #group < #smallestGroup then
            smallestGroup = group
            smallestGroupKey = key
        end
    end
    -- :: unique check
    local isExists = false
    for key, group in ipairs(interrupt_groups) do
        for ii = 1, #group do
            if group[ii] == player then
                isExists = true
            end
        end
    end
    if not isExists then
        table.insert(interrupt_groups[smallestGroupKey], player)
    end
end

local function assignPlayer(player, taskGroup)
    local smallestGroup
    -- :: unique check
    local b_exists = false
    for ii = 1, #taskGroup do
        if taskGroup[ii] == player then
            b_exists = true
        end
    end
    if not b_exists then
        table.insert(taskGroup, player)
    end
end

local function organizeGroup()
    resetTable(group_roles)
    resetTable(interrupt_groups)
    aura_mastery = {}
    divine_sacrifice = {}
    focus_magic = {}
    for ii = 1, GetNumGroupMembers() do
        local id_string
        -- :: determine whether party or raid
        local p_name, p_server, guid, p_class = identifyPlayer(ii)
        -- :: rest
        arch_addPersonToDatabase(p_name, p_server)
        if A.people[realmName][p_name] == nil then
            do
                return
            end
        end
        -- :: role assignment
        if A.people[realmName][p_name][category]["role"] then
            local role = A.people[realmName][p_name][category]["role"]
            if group_roles ~= nil then
                if group_roles[role] ~= nil then
                    if group_roles[role][p_name] == nil then
                        group_roles[role][p_name] = true
                    end
                end
            end
        else
            local isExists = false
            for role in pairs(group_roles) do
                for player in pairs(group_roles[role]) do
                    if p_name == player then
                        isExists = true
                    end
                end
            end
            if not isExists then
                group_roles["unassigned"][p_name] = true
            end
        end
        -- == task assignment
        -- :: interruptors
        if available_interruptors[p_class] ~= nil then
            assignInterruptor(p_name)
        end
        -- :: assign guardian
        if p_class == "PALADIN" then
            local talentName, _, _, _, rank, maxRank = LCI:GetTalentInfo(guid, 2, 24)
            if rank == 1 then
                assignPlayer(p_name, divine_sacrifice)
            end
            local talentName, _, _, _, rank, maxRank = LCI:GetTalentInfo(guid, 1, 3)
            if rank == 1 then
                assignPlayer(p_name, aura_mastery)
            end
        end
        -- :: focus magic
        if p_class == "MAGE" then
            local talentName, _, _, _, rank, maxRank = LCI:GetTalentInfo(guid, 1, 29)
            if rank == 1 then
                assignPlayer(p_name, focus_magic)
            end
        end
    end
end

local function organizePositions()
    -- :: reset organizePositions
    for k in pairs(pos_tracker) do
        pos_tracker[k] = 1
    end
    for k in pairs(group_pos) do
        for index in pairs(group_pos[k]) do
            group_pos[k][index] = {}
        end
    end
    -- :: get player assign group
    for role in pairs(group_roles) do
        for player in pairs(group_roles[role]) do
            if group_pos[role] and pos_tracker[role] <= pos_tracker_limit[role] then
                table.insert(group_pos[role][pos_tracker[role]], player)
                pos_tracker[role] = pos_tracker[role] + 1
                if group_pos[role][pos_tracker[role]] == nil or pos_tracker[role] > pos_tracker_limit[role] then
                    pos_tracker[role] = 1
                end
            end
        end
    end
end

local function printPositions(isSilent)
    local short = {
        ["mdps"] = "M",
        ["rdps"] = "R",
        ["heal"] = "H"
    }
    if not isSilent then
        announce("[Archrist] :: Positions ::")
    else
        aprint(fCol(":: Positions ::"))
    end
    for role, pos in pairs(group_pos) do
        local string = ""
        for index, players in ipairs(pos) do
            local substring = short[role] .. index .. ": "
            for ii = 1, #players do
                substring = substring .. players[ii] .. " "
            end
            if #players > 0 then
                string = string .. substring
            end
        end
        if not isSilent then
            announce(string)
        elseif string ~= "" then
            aprint(string)
        end
        string = ""
    end
end

local function autoRole_single(player, class, p_server)
    -- :: if there is no player add
    arch_addPersonToDatabase(player, p_server)
    if A.people[realmName][player] == nil then
        do
            return
        end
    end
    local role
    -- :: single roles
    if available_roles[class] and #available_roles[class] == 1 then
        role = available_roles[class][1]
        A.people[realmName][player][category]["role"] = role
    end
    -- :: rol yoksa
    if role ~= nil then
        aprint(fCol(properCase(role)) .. " role automaticaly assigned to " .. classCol(class, player))
    end
    -- :: inspect
end

local function autoRole_inspect()
    for ii = 1, GetNumGroupMembers() do
        local id_string
        -- :: determine whether party or raid
        local p_name, p_server, guid, p_class = identifyPlayer(ii)
        -- :: retrieve data
        if p_class == nil then
            do
                return
            end
        end
        p_class = string.upper(p_class)
        local dist, tabIndex = {}, 0
        local active = LCI:GetActiveTalentGroup(guid)
        local spec1 = LCI:GetSpecialization(guid, 1)
        -- :: which spec is active?G
        if active == 1 then
            dist[1], dist[2], dist[3] = LCI:GetTalentPoints(guid, 1)
        else
            dist[1], dist[2], dist[3] = LCI:GetTalentPoints(guid, 2)
        end
        -- :: find spec
        local biggest = 0
        for ii = 1, #dist do
            if dist[ii] > biggest then
                biggest = dist[ii]
                tabIndex = ii
            end
        end
        -- :: defensive: spec cekebildi mi F
        local specName
        if tabIndex > 0 then
            specName = LCI:GetSpecializationName(p_class, tabIndex)
        end
        -- :: assign role
        arch_addPersonToDatabase(p_name, p_server)
        if A.people[realmName][p_name] == nil then
            do
                return
            end
        end
        autoRole_single(p_name, p_class, p_server)
        if (A.people[realmName][p_name][category]["role"] ~= available_spec_role[specName] or
            A.people[realmName][p_name][category]["role"] == nil) then
            -- :: exceptions
            -- :: mage frostsa rdps
            if p_class == "MAGE" and
                (A.people[realmName][p_name][category]["role"] == nil or A.people[realmName][p_name][category]["role"] ==
                    "mdps") then
                A.people[realmName][p_name][category]["role"] = "rdps"
                aprint(fCol(properCase(available_spec_role[specName])) .. " role automaticaly assigned to " ..
                           classCol(p_class, p_name))
                -- :: druidde tank talenti varsa tank
            elseif p_class == "DRUID" and specName == "Feral Combat" then
                local talentName, _, _, _, rank, maxRank = LCI:GetTalentInfo(guid, 2, 29)
                if rank == 3 then
                    if A.people[realmName][p_name][category]["role"] ~= "tank" then
                        A.people[realmName][p_name][category]["role"] = "tank"
                        aprint(fCol(properCase("tank")) .. " role automaticaly assigned to " ..
                                   classCol(p_class, p_name))
                    end
                else
                    if A.people[realmName][p_name][category]["role"] ~= "mdps" then
                        A.people[realmName][p_name][category]["role"] = "mdps"
                        aprint(fCol(properCase("mdps")) .. " role automaticaly assigned to " ..
                                   classCol(p_class, p_name))
                    end
                end
            else
                if available_spec_role[specName] then
                    A.people[realmName][p_name][category]["role"] = available_spec_role[specName]
                    aprint(fCol(properCase(available_spec_role[specName])) .. " role automaticaly assigned to " ..
                               classCol(p_class, p_name))
                end
            end
        end
    end
    organizeGroup()
end

local function scanGroup()
    for ii = 1, GetNumGroupMembers() do
        local guid, p_name, p_class, role
        local id_string
        -- :: determine whether party or raid
        local p_name, p_server, guid, p_class = identifyPlayer(ii)
        -- == auto role
        arch_addPersonToDatabase(p_name, p_server)
        if A.people[realmName][p_name] == nil then
            do
                return
            end
        end

        if A.people[realmName][p_name][category]["role"] == nil then
            -- :: single role class
            autoRole_single(p_name, p_class, p_server)
            -- todo skill scan
            -- todo close inspection
        else -- :: rolleri yerlestir
            local groupRole = A.people[realmName][p_name][category]["role"]
            -- table.insert(group_roles[role], player)
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods
createOptTable_triggerSpells = function()
    for k, v in pairs(arch_opt_triggerSpells) do
        arch_opt_triggerSpells[k] = nil
    end
    for k, v in pairs(A.global.assist.groupOrganizer.triggerSpells) do
        local spellName, spellId = GetSpellLink(k)
        local val
        -- :: spell name or id
        if spellName ~= nil then
            val = spellName
        end
        if val ~= nil then
            -- :: option block
            local opt = {
                name = tCol(sign_group_task[v]) .. " " .. tostring(val),
                type = "toggle",
                order = 1,
                width = 1.5,
                get = function(info)
                    return true
                end,
                set = function(info, val)
                    A.global.assist.groupOrganizer.triggerSpells[k] = nil
                    InterfaceOptionsFrame_Show()
                    InterfaceAddOnsList_Update()
                    createOptTable_triggerSpells()
                    A.OpenInterfaceConfig()
                end
            }
            -- :: insert 
            arch_opt_triggerSpells[k] = opt
        end
    end
    triggerSpells = A.global.assist.groupOrganizer.triggerSpells
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)
    if isEnabled then
        module:RegisterEvent("CHAT_MSG_SYSTEM")
        module:RegisterEvent("CHAT_MSG_WHISPER")
        module:RegisterEvent("CHAT_MSG_SAY")
        module:RegisterEvent("PLAYER_REGEN_ENABLED")
        module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        if not isSilent or isSilent == nil then
            aprint(fCol(moduleName2) .. " is enabled")
        end
    else
        module:UnregisterEvent("CHAT_MSG_SYSTEM")
        module:UnregisterEvent("CHAT_MSG_WHISPER")
        module:UnregisterEvent("CHAT_MSG_SAY")
        module:UnregisterEvent("PLAYER_REGEN_ENABLED")
        module:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        if not isSilent or isSilent == nil then
            aprint(fCol(moduleName2) .. " is disabled")
        end
    end
    if not isSilent then
        isEnabled = not isEnabled
        A.global.assist.groupOrganizer.isEnabled = isEnabled
    end
end
module.toggleModule = toggleModule

local function handleCommand(msg)
    scanGroup()
    -- :: defensive
    local target = UnitName("target")
    -- :: handle parameter
    local params = split(msg, " ")
    if msg == "" then
        if target then
            local guid = UnitGUID("target")
            local _, p_class, _, p_race, _, p_name, p_server = GetPlayerInfoByGUID(guid)
            autoRole_single(target, p_class, p_class)
        end
        autoRole_inspect()
        printGroupRoles()
        printTasks()
        announceFocusQue(true)
    elseif msg == "focus" then
        autoRole_inspect()
        announceFocusQue()
    elseif msg == "toggle" then
        toggleModule()
    elseif group_roles[msg] then
        if target ~= nil then
            local guid = UnitGUID("target")
            local _, p_class, _, p_race, _, p_name, p_server = GetPlayerInfoByGUID(guid)
            -- print(p_name, p_class, p_server)
            setRole(p_name, p_class, msg, p_server)
        else
            aprint("you need to target someone to assign them role or task")
        end
    elseif params[1] == "pos" or params[1] == "position" then
        if params[2] then
            if params[2] == "1" or params[2] == "announce" then
                autoRole_inspect()
                organizePositions()
                printPositions()
            elseif pos_tracker[params[2]] and params[3] and type(tonumber(params[3])) == "number" and tonumber(params[3]) <= 6 then
                pos_tracker_limit[params[2]] = tonumber(params[3])
                aprint("Group limit for " .. params[2] .. " is " .. tonumber(params[3]))
            end
        else
            autoRole_inspect()
            organizePositions()
            printPositions(true)
        end
    else
        if target then
            aprint("the role you have attempted to assign is not recognized.")
        else
            aprint("you need to target someone to assign them role or task")
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
-- f:SetScript("OnUpdate", function(self, elapsed)
--     -- timeInMin = timeInMin - elapsed
--     -- if timeInMin <= 0 then
--     --     -- :: defensive
--     --     if A.global.utility.posture.isEnabled ~= isEnabled then
--     --         isEnabled = A.global.utility.posture.isEnabled 
--     --     end
--     --     if A.global.utility.posture.text ~= text then
--     --         text = A.global.utility.posture.text 
--     --     end
--     --     if A.global.utility.posture.announceType ~= announceType then
--     --         announceType = A.global.utility.posture.announceType 
--     --     end
--     --     if isEnabled then
--     --         if announceType == 1 then -- announce type 1 = self print
--     --             print(moduleAlert .. text)
--     --         -- elseif announceType == "party" then
--     --             -- SendChatMessage(raidAlerts.lootrules.onetrophy, "RAID_WARNING")
--     --         -- elseif announceType == "raid" then
--     --         end
--     --         -- RaidNotice_AddMessage(RaidBossEmoteFrame, "Check your posture!", ChatTypeInfo["RAID_BOSS_EMOTE"])
--     --         -- PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_2)
--     --     end
--     --     timeInMin = (A.global.utility.posture.timeInMin * 60 * 15)
--     -- end
-- end)

function module:CHAT_MSG_SYSTEM(_, arg1)
    if string.find(arg1, "joins the") then
        scanGroup()
    elseif string.find(arg1, "leaves the") then
        organizeGroup()
    elseif string.find(arg1, "Party converted to Raid") then
        organizeGroup()
    elseif string.find(arg1, "You leave the group") then
        organizeGroup()
    elseif string.find(arg1, "has been disbanded") then
        organizeGroup()
    end
end

function module:CHAT_MSG_WHISPER(_, msg, author)
    -- print(msg, author, lang)
    -- if msg == "cast" then
    --     announceInterruptGroup()
    -- elseif msg == "tantrum" then
    --     announcePlayer(divine_sacrifice, que_guardian)
    -- elseif msg == "aura" then
    --     announcePlayer(aura_mastery, que_aura)
    -- end
end

function module:CHAT_MSG_SAY(_, msg, author)
    -- print(msg, author, lang)
    if msg == "testing cast" then
        announceGroup()
    elseif msg == "testing divine" then
        announceDivine("Divine Sacrifice")
    elseif msg == "testing aura" then
        announceAura("Aura Mastery")
    end
end

function module:COMBAT_LOG_EVENT_UNFILTERED() -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 =
        CombatLogGetCurrentEventInfo()
    local timestamp, eventType, srcName, dstName, spellId, spellName = arg1, arg2, arg5, arg9, arg12, arg13
    -- aprint('test 1')
    if triggerSpells[tostring(spellId)] ~= nil or triggerSpells[spellName] ~= nil then
        local track
        if triggerSpells[tostring(spellId)] ~= nil then
            track = triggerSpells[tostring(spellId)]
        elseif triggerSpells[spellName] ~= nil then
            track = triggerSpells[spellName]
        end
        -- 
        if sign_group_task[track] == "interrupt" then
            if isDelayed() then
                announceGroup()
            end
        elseif sign_group_task[track] == "aura" then
            if isDelayed() then
                announceAura("Aura Mastery")
            end
        elseif sign_group_task[track] == "divine" then
            if isDelayed() then
                announceDivine("Divine Sacrifice")
            end
        end
    end

end

function module:PLAYER_REGEN_ENABLED()
    autoRole_inspect()
end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_org1 = "/org"
SlashCmdList["org"] = function(msg)
    handleCommand(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

------------------------------------------------------------------------------------------------------------------------
-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
    -- Register
    toggleModule(true)
end
A:RegisterModule(module:GetName(), InitializeCallback)

