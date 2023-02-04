------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "Discord", "Discord";
local group = "assist";
local module = A:GetModule(m_name, true);
local moduleAlert = M .. m_name2 .. ": |r";
local mprint = function(msg)
    print(moduleAlert .. msg)
end
local aprint = Arch_print
if module == nil then return end

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
-- ==== Variables
local raidAlerts = Arch_raidAlerts
local announce = Arch_announce
local split = Arch_split
local cCol = Arch_commandColor
local vc = "" 
local isEnabled = true

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- -- :: construct
    if A.global[group] == nil then
        A.global[group] = {}
    end
    if A.global[group]["raidCommands"] == nil then 
        A.global[group]["raidCommands"] = {}
    end
    if A.global[group]["raidCommands"][m_name] == nil then
        A.global[group]["raidCommands"][m_name] = vc
    else
        vc = A.global[group]["raidCommands"][m_name]
    end
end


------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function announceDiscord()
    if isEnabled then
        -- SELECTED_CHAT_FRAME:AddMessage(string1)
        SendChatMessage(raidAlerts.community.discord, "RAID_WARNING") -- RAID_WARNING, SAY
    end
end

local function announceVoiceCommunication(msg)
    if isEnabled then
        if msg == "" or msg == nil then
            SendChatMessage(raidAlerts.vc.mandatory, "RAID")
        else
            SendChatMessage(raidAlerts.vc.voluntary, "RAID")
        end
        SendChatMessage(raidAlerts.vc.nickname, "RAID")
        SendChatMessage(raidAlerts.vc.auth, "RAID")
    end
end

local function announceGuild()
    if isEnabled then
        -- SELECTED_CHAT_FRAME:AddMessage(string1)
        SendChatMessage(raidAlerts.community.guild, "RAID_WARNING") -- RAID_WARNING, SAY
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)

end

local function handleCommand(msg)
    local par = split(msg)
    if par[1] == "1" then
        announce("Furher runs: >> " .. vc .. " <<")
    elseif par[1] == "is" then
        if par[2] then
            vc = par[2]
            A.global[group]["raidCommands"][m_name] = vc
            aprint("Your voice communication is now: " .. vc)
        else
            aprint("Need link as well. Try " .. cCol("/vc is <link>"))
        end
    else 
        if vc == "" then
            aprint("You did not set any voice communication link.")
            aprint("Try " .. cCol("/vc is <link>"))
        else
            aprint("Your voice communication is: " .. vc)
        end
    end
end



------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
-- function module:PLAYER_REGEN_ENABLED()
--     -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
--     isInCombat = false
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
-- SLASH_DISCORD1 = "/discord"
-- SlashCmdList["DISCORD"] = function(msg) announceDiscord() end
SLASH_vc1 = "/vc"
SlashCmdList["vc"] = function(msg) handleCommand(msg) end
-- SLASH_ARCHGUILD1 = "/guild"
-- SlashCmdList["ARCHGUILD"] = function(msg) announceGuild() end


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

-- ==== Slash commands [last arg]
-- https://www.wowinterface.com/forums/showthread.php?t=37386
-- https://discord.gg/wQTEexv