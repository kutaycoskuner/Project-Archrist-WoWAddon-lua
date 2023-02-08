------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "RaidWarnings", "Raid Warnings";
local group = "assist";
local module = A:GetModule(m_name, true);
local moduleAlert = M .. m_name2 .. ": |r";
local mprint = function(msg)
    print(moduleAlert .. msg)
end
local aprint = Arch_print
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------

-- use case ------------------------------------------------------------------------------------------------------------
--[[
    ]]

-- blackboard ------------------------------------------------------------------------------------------------------------
--[[
]]

-- todo ----------------------------------------------------------------------------------------------------------------
--[[
]]

------------------------------------------------------------------------------------------------------------------------
-- :: Former  : /click WarnButton2
-- :: Current : /run SendChatMessage(Arch_RaidWarnings[1], Arch_comms,nil,Arch_forthKey)
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
-- :: global Functions
local fCol = Arch_focusColor
local cCol = Arch_commandColor
local mCol = Arch_moduleColor
local tCol = Arch_trivialColor
local classCol = Arch_classColor
local realmName = GetRealmName()
-- :: local
local boss = 'none';
local comms = '/p ';
local isEnabled = true;
--
local rwDefault = {}
rwDefault[1] = "{skull} Focus on [%t] {skull}"
rwDefault[2] = '{square} Combat Res [%t] {square}'
rwDefault[3] = '{circle} Heroism Now! {circle}'
rwDefault[4] = '{triangle} Innervate Please {triangle}'
--
Arch_RaidWarnings = {}
Arch_RaidWarnings[1] = ''
Arch_RaidWarnings[2] = ''
Arch_RaidWarnings[3] = ''
Arch_RaidWarnings[4] = ''
Arch_comms = 'SAY'
Arch_forthKey = "1"
--
local fixArgs = Arch_fixArgs
local focus = Arch_focusColor

local previousComms = ""
--
-- :: buttons
local warn1 = CreateFrame("CheckButton", "WarnButton1", UIParent, "SecureActionButtonTemplate")
warn1:SetAttribute("type", "macro")
local warn2 = CreateFrame("CheckButton", "WarnButton2", UIParent, "SecureActionButtonTemplate")
warn2:SetAttribute("type", "macro")
local warn3 = CreateFrame("CheckButton", "WarnButton3", UIParent, "SecureActionButtonTemplate")
warn3:SetAttribute("type", "macro")
local warn4 = CreateFrame("CheckButton", "WarnButton4", UIParent, "SecureActionButtonTemplate")
warn4:SetAttribute("type", "macro")

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- :: construct
    if A.global[group] == nil then
        A.global[group] = {}
    end
    if A.global[group][m_name] == nil then
        A.global[group][m_name] = {}
    end
    if A.global[group][m_name].isEnabled == nil then
        A.global[group][m_name].isEnabled = isEnabled
    end
    isEnabled = A.global[group][m_name].isEnabled
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
function module:Initialize()
    self.initialized = true

    if A.global.comms == nil then
        A.global.comms = '/p '
    end
    --
    if A.global.raidWarnings == nil then
        A.global.raidWarnings = {
            rw1 = rwDefault[1],
            rw2 = rwDefault[2],
            rw3 = rwDefault[3],
            rw4 = rwDefault[4]
        }
    end
    --
    Arch_RaidWarnings[1] = A.global.raidWarnings.rw1
    Arch_RaidWarnings[2] = A.global.raidWarnings.rw2
    Arch_RaidWarnings[3] = A.global.raidWarnings.rw3
    Arch_RaidWarnings[4] = A.global.raidWarnings.rw4
    --
    comms = A.global.comms
    --
    Arch_setRaidWarnings()
    -- :: Register some events
end

-- :: sets raid warning
function Arch_setRaidWarnings()
    -- WarnButton1:SetAttribute("macrotext", comms .. Arch_RaidWarnings[1])
    -- WarnButton2:SetAttribute("macrotext", comms .. Arch_RaidWarnings[2])
    -- WarnButton3:SetAttribute("macrotext", comms .. Arch_RaidWarnings[3])
    -- WarnButton4:SetAttribute("macrotext", comms .. Arch_RaidWarnings[4])
end

local function setRaidWarnings(msg)
    local pass = false
    local args = fixArgs(msg)
    local mod = tonumber(table.remove(args, 1))
    local entry = string.gsub(" " .. table.concat(args, ' '), "%W%l", string.upper):sub(2)
    if entry ~= '' then
        entry = "{triangle} " .. entry .. " {triangle}"
    end
    local rw = 'rw' .. tostring(mod)
    local default = 'rwDefault' .. tostring(mod)
    -- :: Defensive
    for ii = 1, 4 do
        if tonumber(mod) == ii then
            pass = true
        end
    end
    if pass then
        if entry == nil or entry == '' then
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'you need to enter a valid text')
            return
        end
        --
        if entry == 'default' then
            A.global.raidWarnings[rw] = rwDefault[mod]
            Arch_RaidWarnings[mod] = rwDefault[mod]
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your ' .. rw .. ' set as: ' .. focus(rwDefault[mod]))
            return
        end
        --
        A.global.raidWarnings[rw] = entry
        Arch_RaidWarnings[tonumber(mod)] = entry
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your ' .. rw .. ' set as: ' .. focus(entry))
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'you need to enter numbers between 1-4 as first argument')
        return
    end
    Arch_setRaidWarnings()

end

-- :: selecting boss via slash command
local function selectBoss(boss)
    if boss then
        local firsti, lasti, command, value = string.find(boss, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(boss, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(boss, "(%w+)");
        end
        -- :: komut varsa
        if (command ~= nil) then
            command = string.lower(command);
        end
        --
        -- :: Dungeons
        if (command == "skadi") then
            Arch_RaidWarnings[1] = '{triangle} Watchout for Breath {triangle}'
            Arch_RaidWarnings[2] = '{triangle} LEFT {triangle}'
            Arch_RaidWarnings[3] = '{triangle} RIGHT {triangle}'
            Arch_RaidWarnings[4] = '{triangle} Use Harpoons {triangle}'
            --
        elseif (command == "malygos") then
            Arch_RaidWarnings[1] = '{triangle} Spread 11 Yards {triangle}'
            Arch_RaidWarnings[2] = '{square} Stay In Dome MDPS Take Discs {square}'
            Arch_RaidWarnings[3] = '{skull} Spread {skull}'
            Arch_RaidWarnings[4] = '{triangle} Move Move Move {triangle}'
            --
            -- :: Naxxramas
        elseif (command == "maexxna") then
            Arch_RaidWarnings[1] = '{triangle} Kill the webs {triangle}'
            Arch_RaidWarnings[2] = '{skull} Focus on Big Add {skull}'
            Arch_RaidWarnings[3] = '{skull} Back to boss {skull}'
            Arch_RaidWarnings[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "noth") then
            Arch_RaidWarnings[1] = '{triangle} Watch for debuffs and dispel {triangle}'
            Arch_RaidWarnings[2] = '{skull} Focus on Big Add {skull}'
            Arch_RaidWarnings[3] = '{skull} Back to boss {skull}'
            Arch_RaidWarnings[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "anubrekhan") then
            Arch_RaidWarnings[1] = '{triangle} Locust Swarm!! Run clockwise. {triangle}'
            Arch_RaidWarnings[2] = '{skull} Kill Crypt Lord {skull}'
            Arch_RaidWarnings[3] = '{skull} Back to boss {skull}'
            Arch_RaidWarnings[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "patchwerk") then
            Arch_RaidWarnings[1] = '{triangle} Melee dip into Green slime {triangle}'
            Arch_RaidWarnings[2] = '{skull} Only heal tanks! {skull}'
            Arch_RaidWarnings[3] = '{skull} Back to boss {skull}'
            Arch_RaidWarnings[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "grobbulus") then
            Arch_RaidWarnings[1] = '{triangle} Dont stand infront of the boss {triangle}'
            Arch_RaidWarnings[2] = '{square} do not stand in green slime {square}'
            Arch_RaidWarnings[3] = '{skull} Kill the adds as they are 3 {skull}'
            Arch_RaidWarnings[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "gluth") then
            Arch_RaidWarnings[1] = '{triangle} Kite the zombie {triangle}'
            Arch_RaidWarnings[2] = '{square} %t Combat Res {square}'
            Arch_RaidWarnings[3] = '{skull} AoE Zombies now! {skull}'
            Arch_RaidWarnings[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "thaddius") then
            Arch_RaidWarnings[1] = '{triangle} <<< Left Slow Down {triangle}'
            Arch_RaidWarnings[2] = '{square} Right Slow Down >>> {square}'
            Arch_RaidWarnings[3] = '{skull} Switch {skull}'
            Arch_RaidWarnings[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "sapphiron") then
            Arch_RaidWarnings[1] = '{triangle} Move out of Blizzard {triangle}'
            Arch_RaidWarnings[2] = '{square} Hide Behind Ice {square}'
            Arch_RaidWarnings[3] = '{skull} Spread {skull}'
            Arch_RaidWarnings[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "kelthuzad") then
            Arch_RaidWarnings[1] = '{triangle} Spread 11 Yards {triangle}'
            Arch_RaidWarnings[2] = '{square} Interrupt frostbolt! {square}'
            Arch_RaidWarnings[3] = '{skull} Spread {skull}'
            Arch_RaidWarnings[4] = '{triangle} Pets passive! {triangle}'
            --
            -- :: VoA
        elseif (command == "emalon") then
            Arch_RaidWarnings[1] = '{triangle} Run away from the boss {triangle}'
            Arch_RaidWarnings[2] = '{skull} Focus on Big Add {skull}'
            Arch_RaidWarnings[3] = '{skull} Back to boss {skull}'
            Arch_RaidWarnings[4] = '{triangle} Spread 10 yard {triangle}'
            --
            -- :: Ulduar
        elseif (command == "leviathan") then
            Arch_RaidWarnings[1] = '{triangle} Keep Pyerite Stacks Up! {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            --
        elseif (command == "razorscale") then
            Arch_RaidWarnings[1] = '{triangle}  {triangle}'
            Arch_RaidWarnings[2] = '{skull} Sentinels > Watchers > Guardians {skull}'
            Arch_RaidWarnings[3] = '{skull} Interrupt Watchers {skull}'
            Arch_RaidWarnings[4] = '{triangle} Nuke the Boss {triangle}'
            --
        elseif (command == "deconstructor") then
            Arch_RaidWarnings[1] = '{triangle} Kill the adds {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            --
        elseif (command == "ignis") then
            Arch_RaidWarnings[1] = '{triangle}  {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            --
        elseif (command == "assembly") then
            Arch_RaidWarnings[1] = '{triangle}  {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            --
        elseif (command == "kologarn") then
            Arch_RaidWarnings[1] = '{triangle}  {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            --
        elseif (command == "auriaya") then
            Arch_RaidWarnings[1] = '{triangle}  {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            --
        elseif (command == "vezax") then
            Arch_RaidWarnings[1] = '{triangle} Kill the Saronite {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle} Innervate me please! {triangle}'
            --
        elseif (command == "yogg") then
            Arch_RaidWarnings[1] = '{triangle} Kill the Saronite {triangle}'
            Arch_RaidWarnings[2] = '{skull}  {skull}'
            Arch_RaidWarnings[3] = '{skull}  {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            -- :: ToGC
        elseif (command == "Beasts") then
            Arch_RaidWarnings[1] = '{triangle} Snobold Get In Melee Cleave Range {triangle}'
            Arch_RaidWarnings[2] = '{skull} If you have poison get in the range of fire debuff {skull}'
            Arch_RaidWarnings[3] = '{skull} Run away from charge path {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
        elseif (command == "Jarraxus") then
            Arch_RaidWarnings[1] = '{triangle} Hardswitch to adds! {triangle}'
            Arch_RaidWarnings[2] = '{skull} Steal the Nether Power {skull}'
            Arch_RaidWarnings[3] = '{skull} Run away from charge path {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
        elseif (command == "Faction") then
            Arch_RaidWarnings[1] = '{triangle} Snobold Get In Melee Cleave Range {triangle}'
            Arch_RaidWarnings[2] = '{skull} If you have poison get in the range of fire debuff {skull}'
            Arch_RaidWarnings[3] = '{skull} Run away from charge path {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
        elseif (command == "Twin") then
            Arch_RaidWarnings[1] = '{triangle} Snobold Get In Melee Cleave Range {triangle}'
            Arch_RaidWarnings[2] = '{skull} If you have poison get in the range of fire debuff {skull}'
            Arch_RaidWarnings[3] = '{skull} Run away from charge path {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
        elseif (command == "Anub") then
            Arch_RaidWarnings[1] = '{triangle} Kill the adds {triangle}'
            Arch_RaidWarnings[2] = '{skull} Marked People Run through station, Keep HoP ready {skull}'
            Arch_RaidWarnings[3] = '{skull} Slow Down Heal {skull}'
            Arch_RaidWarnings[4] = '{triangle}  {triangle}'
            -- :: Wintergrasp
        elseif command == 'wg' then
            Arch_RaidWarnings[1] = '{triangle} STACK SIEGES AT BROKEN AND ATTACK NW {triangle}'
            Arch_RaidWarnings[2] = '{skull} YELL FOR CANNONER IF YOU DONT HAVE ONE {skull}'
            Arch_RaidWarnings[3] = '{skull} CANNONERS KILL CANNONS & PEOPLE {skull}'
            Arch_RaidWarnings[4] = '{triangle} Protect Sieges {triangle}'
        else
            boss = 'default'
            Arch_RaidWarnings[1] = rwDefault[1];
            Arch_RaidWarnings[2] = rwDefault[2];
            Arch_RaidWarnings[3] = rwDefault[3];
            Arch_RaidWarnings[4] = rwDefault[4];
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff128ec4[Archrium] Raidwarnings:|r " .. tostring(boss))
        UIErrorsFrame:AddMessage("|cff128ec4Raidwarnings|r " .. tostring(boss))
    end
    Arch_setRaidWarnings();
end

local function selectChannel(channel)
    if channel then
        local firsti, lasti, command, value = string.find(channel, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(channel, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(channel, "(%w+)");
        end
        -- :: komut varsa
        if (command ~= nil) then
            command = string.lower(command);
        end
        --
        if (command == "w" or command == "test") then
            comms = "/w " .. UnitName('player') .. " "
            A.global.comms = "/w " .. UnitName('player') .. " "
            Arch_comms = 'whisper'
            Arch_forthKey = UnitName('player')
        elseif (command == "s" or command == "say") then
            comms = "/s "
            A.global.comms = '/s '
            Arch_comms = 'SAY'
        elseif (command == "p" or command == "party") then
            comms = "/p "
            A.global.comms = "/p "
            Arch_comms = 'PARTY'
        elseif (command == "ra" or command == "raid") then
            comms = "/ra "
            A.global.comms = "/ra "
            Arch_comms = 'RAID'
        elseif (command == "rw" or command == "raidwarning") then
            comms = "/rw "
            A.global.comms = "/rw "
            Arch_comms = 'RAID_WARNING'
        elseif (command == "bg" or command == "battleground") then
            comms = "/bg "
            A.global.comms = "/bg "
            Arch_comms = "BATTLEGROUND"
        elseif (command == "wg" or command == "wintegrasp" or command == "1") then
            comms = "/1 "
            A.global.comms = "/1 "
            Arch_comms = 'CHANNEL'
            Arch_forthKey = "1"
        else
            comms = comms
            A.global.comms = comms
            Arch_comms = 'CHANNEL'
            Arch_forthKey = "1"
        end
        aprint("|cff128ec4Warning Channel:|r " .. tostring(comms))
        UIErrorsFrame:AddMessage("|cff128ec4Warning Channel|r " .. tostring(comms))
    end
    Arch_setRaidWarnings();
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)
    if isEnabled then
        -- :: register
        module:RegisterEvent("CHAT_MSG_SYSTEM")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is enabled")
        end
    else
        -- :: deregister
        module:UnregisterEvent("CHAT_MSG_SYSTEM")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is disabled")
        end
    end
    if not isSilent then
        isEnabled = not isEnabled
        -- A.global.assist.groupOrganizer.isEnabled = isEnabled
    end
end

local function handleCommand(msg)
end

local function autoSelectComms()
    local isLeader = UnitIsGroupLeader("player")
    local isAssist = UnitIsGroupAssistant("player")
    if isLeader or isAssist then
        Arch_comms = "RAID_WARNING"
    elseif UnitInRaid("player") then
        Arch_comms = "RAID"
    elseif UnitInParty("player") then
        Arch_comms = "PARTY"
    elseif UnitInBattleground("player") then
        Arch_comms = "BATTLEGROUND"
    else
        Arch_comms = "SAY"
    end
    comms = Arch_comms
    A.global.comms = comms
    if Arch_comms ~= previousComms then
        aprint("|cff128ec4Warning Channel:|r " .. tostring(comms))
        UIErrorsFrame:AddMessage("|cff128ec4Warning Channel|r " .. tostring(comms))
        previousComms = Arch_comms
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
function module:CHAT_MSG_SYSTEM(_, arg1)
    if string.find(arg1, "You leave the group") then
        autoSelectComms()
    elseif string.find(arg1, "leaves the") then
        autoSelectComms()
    elseif string.find(arg1, "joins the") then
        autoSelectComms()
    elseif string.find(arg1, "joined the") then
        autoSelectComms()
    elseif string.find(arg1, "has been disbanded") then
        group = {}
        autoSelectComms()
    elseif string.find(arg1, "Party converted to Raid") then
        autoSelectComms()
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_RaidWarning1 = "/battle"
SlashCmdList["RaidWarning"] = function(boss)
    selectBoss(boss)
end
SLASH_SelectLeadChannel1 = "/comms"
SlashCmdList["SelectLeadChannel"] = function(channel)
    selectChannel(channel)
end
SLASH_RaidWarnings1 = "/war"
SlashCmdList["RaidWarnings"] = function(msg)
    setRaidWarnings(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

------------------------------------------------------------------------------------------------------------------------
-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
    toggleModule(true)
end
A:RegisterModule(module:GetName(), InitializeCallback)
