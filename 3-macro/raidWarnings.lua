------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'RaidWarnings';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local boss = 'none';
local comms = '/p ';
--
local rwDefault = {}
rwDefault[1] = "{skull} Focus on [%t] {skull}"
rwDefault[2] = '{square} Combat Res [%t] {square}'
rwDefault[3] = '{circle} Heroism Now! {circle}'
rwDefault[4] = '{triangle} Innervate Please {triangle}'
--
local raidWarning = {}
raidWarning[1] = ''
raidWarning[2] = ''
raidWarning[3] = ''
raidWarning[4] = ''
--
local fixArgs = Arch_fixArgs
local focus = Arch_focusColor
--
-- :: buttons
local warn1 = CreateFrame("CheckButton", "WarnButton1", UIParent,
                          "SecureActionButtonTemplate")
warn1:SetAttribute("type", "macro")
local warn2 = CreateFrame("CheckButton", "WarnButton2", UIParent,
                          "SecureActionButtonTemplate")
warn2:SetAttribute("type", "macro")
local warn3 = CreateFrame("CheckButton", "WarnButton3", UIParent,
                          "SecureActionButtonTemplate")
warn3:SetAttribute("type", "macro")
local warn4 = CreateFrame("CheckButton", "WarnButton4", UIParent,
                          "SecureActionButtonTemplate")
warn4:SetAttribute("type", "macro")

-- ==== Start
function module:Initialize()
    self.initialized = true

    if A.global.comms == nil then
        A.global.comms = '/p '
    end
    --
    if A.global.raidWarnings == nil then
        A.global.raidWarnings = {rw1 = rwDefault[1], rw2 = rwDefault[2], rw3 = rwDefault[3], rw4 = rwDefault[4]}
    end
    --
    raidWarning[1] = A.global.raidWarnings.rw1
    raidWarning[2] = A.global.raidWarnings.rw2
    raidWarning[3] = A.global.raidWarnings.rw3
    raidWarning[4] = A.global.raidWarnings.rw4
    --
    comms = A.global.comms
    --
    Arch_setRaidWarnings()
    -- :: Register some events
end

local function setRaidWarnings(msg)
    local args = fixArgs(msg)
    local mod = tonumber(table.remove(args, 1))
    local entry = table.concat(args, ' ')
    local rw = 'rw' .. tostring(mod)
    local default = 'rwDefault' .. tostring(mod)
    -- :: Defensive
    if type(tonumber(mod)) ~= "number" then 
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'you have to give 1-4 as first argument')
        return
    end
    --
    if entry == nil or entry == '' then 
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'you need to enter a valid text')
        return
    end
    --
    if entry == 'default' then
        A.global.raidWarnings[rw] = rwDefault[mod]
        raidWarning[mod] = rwDefault[mod]
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your ' .. rw .. ' set as: ' .. focus(rwDefault[mod]))
        return
    end 
    --
    A.global.raidWarnings[rw], raidWarning[mod] = entry, entry
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your ' .. rw .. ' set as: ' .. focus(entry))

end

-- :: sets raid warning
function Arch_setRaidWarnings()
    WarnButton1:SetAttribute("macrotext", comms .. raidWarning[1])
    WarnButton2:SetAttribute("macrotext", comms .. raidWarning[2])
    WarnButton3:SetAttribute("macrotext", comms .. raidWarning[3])
    WarnButton4:SetAttribute("macrotext", comms .. raidWarning[4])
end

-- :: selecting boss via slash command
local function selectBoss(boss)
    if boss then
        local firsti, lasti, command, value =
            string.find(boss, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(boss, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(boss, "(%w+)");
        end
        -- :: komut varsa
        if (command ~= nil) then command = string.lower(command); end
        --
        -- :: Dungeons
        if (command == "skadi") then
            raidWarning[1] = '{triangle} Watchout for Breath {triangle}'
            raidWarning[2] = '{triangle} LEFT {triangle}'
            raidWarning[3] = '{triangle} RIGHT {triangle}'
            raidWarning[4] = '{triangle} Use Harpoons {triangle}'
            --
        elseif (command == "malygos") then
            raidWarning[1] = '{triangle} Spread 11 Yards {triangle}'
            raidWarning[2] = '{square} Interrupt frostbolt! {square}'
            raidWarning[3] = '{skull} Spread {skull}'
            raidWarning[4] = '{triangle} Pets passive! {triangle}'
            --
        -- :: Naxxramas
        elseif (command == "maexxna") then
            raidWarning[1] = '{triangle} Kill the webs {triangle}'
            raidWarning[2] = '{skull} Focus on Big Add {skull}'
            raidWarning[3] = '{skull} Back to boss {skull}'
            raidWarning[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "noth") then
            raidWarning[1] = '{triangle} Watch for debuffs and dispel {triangle}'
            raidWarning[2] = '{skull} Focus on Big Add {skull}'
            raidWarning[3] = '{skull} Back to boss {skull}'
            raidWarning[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "anubrekhan") then
            raidWarning[1] = '{triangle} Locust Swarm!! Run clockwise. {triangle}'
            raidWarning[2] = '{skull} Kill Crypt Lord {skull}'
            raidWarning[3] = '{skull} Back to boss {skull}'
            raidWarning[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "patchwerk") then
            raidWarning[1] = '{triangle} Melee dip into Green slime {triangle}'
            raidWarning[2] = '{skull} Only heal tanks! {skull}'
            raidWarning[3] = '{skull} Back to boss {skull}'
            raidWarning[4] = '{triangle} Spread 10 yard {triangle}'
            --
        elseif (command == "grobbulus") then
            raidWarning[1] = '{triangle} Dont stand infront of the boss {triangle}'
            raidWarning[2] = '{square} do not stand in green slime {square}'
            raidWarning[3] = '{skull} Kill the adds as they are 3 {skull}'
            raidWarning[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "gluth") then
            raidWarning[1] = '{triangle} Kite the zombie {triangle}'
            raidWarning[2] = '{square} %t Combat Res {square}'
            raidWarning[3] = '{skull} AoE Zombies now! {skull}'
            raidWarning[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "thaddius") then
            raidWarning[1] = '{triangle} <<< Left Slow Down {triangle}'
            raidWarning[2] = '{square} Right Slow Down >>> {square}'
            raidWarning[3] = '{skull} Switch {skull}'
            raidWarning[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "sapphiron") then
            raidWarning[1] = '{triangle} Move out of Blizzard {triangle}'
            raidWarning[2] = '{square} Hide Behind Ice {square}'
            raidWarning[3] = '{skull} Spread {skull}'
            raidWarning[4] = '{triangle} %t run away for the Dispel {triangle}'
            --
        elseif (command == "kelthuzad") then
            raidWarning[1] = '{triangle} Spread 11 Yards {triangle}'
            raidWarning[2] = '{square} Interrupt frostbolt! {square}'
            raidWarning[3] = '{skull} Spread {skull}'
            raidWarning[4] = '{triangle} Pets passive! {triangle}'
            --
        -- :: VoA
        elseif (command == "emalon") then
            raidWarning[1] = '{triangle} Run away from the boss {triangle}'
            raidWarning[2] = '{skull} Focus on Big Add {skull}'
            raidWarning[3] = '{skull} Back to boss {skull}'
            raidWarning[4] = '{triangle} Spread 10 yard {triangle}'
            --
        -- :: Ulduar
        elseif (command == "leviathan") then
            raidWarning[1] = '{triangle} Keep Pyerite Stacks Up! {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle}  {triangle}'
            --
        elseif (command == "razorscale") then
            raidWarning[1] = '{triangle}  {triangle}'
            raidWarning[2] = '{skull} Sentinels > Watchers > Guardians {skull}'
            raidWarning[3] = '{skull} Interrupt Watchers {skull}'
            raidWarning[4] = '{triangle} Nuke the Boss {triangle}'
            --
        elseif (command == "deconstructor") then
            raidWarning[1] = '{triangle} Kill the adds {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle}  {triangle}'
            --
        elseif (command == "ignis") then
            raidWarning[1] = '{triangle}  {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle}  {triangle}'
            --
        elseif (command == "assembly") then
            raidWarning[1] = '{triangle}  {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle}  {triangle}'
            --
        elseif (command == "kologarn") then
            raidWarning[1] = '{triangle}  {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle}  {triangle}'
            --
        elseif (command == "auriaya") then
            raidWarning[1] = '{triangle}  {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle}  {triangle}'
            --
        elseif (command == "vezax") then
            raidWarning[1] = '{triangle} Kill the Saronite {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle} Innervate me please! {triangle}'
            --
        elseif (command == "yogg") then
            raidWarning[1] = '{triangle} Kill the Saronite {triangle}'
            raidWarning[2] = '{skull}  {skull}'
            raidWarning[3] = '{skull}  {skull}'
            raidWarning[4] = '{triangle}  {triangle}'
        elseif command == 'wg' then
            raidWarning[1] = '{triangle} Stack Sieges and Attack NorthWest Gate {triangle}'
            raidWarning[2] = '{skull} Attack Cannons {skull}'
            raidWarning[3] = '{skull} Get Broken Temple Workshop {skull}'
            raidWarning[4] = '{triangle} Protect Sieges {triangle}'
            --[[
                brain links
                get in portals two group
                portal gets plate
                
            ]]
        else
            boss = 'default'
            raidWarning[1] = rwDefault[1];
            raidWarning[2] = rwDefault[2];
            raidWarning[3] = rwDefault[3];
            raidWarning[4] = rwDefault[4];
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff128ec4[Archrium] Raidwarnings:|r " ..
                                          tostring(boss))
        UIErrorsFrame:AddMessage("|cff128ec4Raidwarnings|r " .. tostring(boss))
    end
    Arch_setRaidWarnings();
end

local function selectChannel(channel)
    if channel then
        local firsti, lasti, command, value =
            string.find(channel, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(channel, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(channel, "(%w+)");
        end
        -- :: komut varsa
        if (command ~= nil) then command = string.lower(command); end
        --
        if (command == "w" or command == "test") then
            comms = "/w " .. UnitName('player') .. " "
            A.global.comms = "/w " .. UnitName('player') .. " "
        elseif (command == "s" or command == "say") then
            comms = "/s "
            A.global.comms = '/s '
        elseif (command == "p" or command == "party") then
            comms = "/p "
            A.global.comms = "/p "
        elseif (command == "ra" or command == "raid") then
            comms = "/ra "
            A.global.comms = "/ra "
        elseif (command == "rw" or command == "raidwarning") then
            comms = "/rw "
            A.global.comms = "/rw "
        elseif (command == "bg" or command == "battleground") then
            comms = "/bg "
            A.global.comms = "/bg "
        elseif (command == "wg" or command == "wintegrasp") then
            comms = "/1 "
            A.global.comms = "/1 "
        else
            comms = comms
            A.global.comms = comms
        end
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cff128ec4[Archrium] WarningChannel:|r " .. tostring(comms))
        UIErrorsFrame:AddMessage("|cff128ec4WarningChannel|r " ..
                                     tostring(comms))
    end
    Arch_setRaidWarnings();
end

-- -- ==== End
-- Arch_setRaidWarnings();
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Slash Handlers
SLASH_RaidWarning1 = "/war"
SlashCmdList["RaidWarning"] = function(boss) selectBoss(boss) end
SLASH_SelectLeadChannel1 = "/comms"
SlashCmdList["SelectLeadChannel"] = function(channel) selectChannel(channel) end
SLASH_RaidWarnings1 = "/rw"
SlashCmdList["RaidWarnings"] = function(msg) setRaidWarnings(msg) end

-- ==== Example Usage [last arg]
--[[
/click WarnButton1;  
/click WarnButton2; 
/click WarnButton3; 
/click WarnButton4; 
--]]