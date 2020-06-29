------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Tactics';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local boss = 'none';
local comms = '/p ';
--
local tacticDefault = {}
tacticDefault[1] = "{skull} Focus on [%t] {skull}"
tacticDefault[2] = '{square} Combat Res [%t] {square}'
tacticDefault[3] = '{circle} Heroism Now! {circle}'
tacticDefault[4] = '{triangle} Innervate Please {triangle}'
tacticDefault[5] = '{triangle} Innervate Please {triangle}'
tacticDefault[6] = '{triangle} Innervate Please {triangle}'
tacticDefault[8] = '{triangle} Innervate Please {triangle}'
tacticDefault[9] = '{triangle} Innervate Please {triangle}'
--
local tactics = {}
tactics[1] = ''
tactics[2] = ''
tactics[3] = ''
tactics[4] = ''
tactics[5] = ''
tactics[6] = ''
tactics[7] = ''
tactics[8] = ''

--
local fixArgs = Arch_fixArgs
local focus = Arch_focusColor
--

-- ==== Start
function module:Initialize()
    self.initialized = true

    if A.global.comms == nil then A.global.comms = '/p ' end
    --
    if A.global.tactics == nil then
        A.global.tactics = {
            tacticDefault[1],
            tacticDefault[2],
            tacticDefault[3],
            tacticDefault[4],
            tacticDefault[5],
            tacticDefault[6],
            tacticDefault[7],
            tacticDefault[8]
        }
    end
    --
    tactics[1] = A.global.tactics[1]
    tactics[1] = A.global.tactics[2]
    tactics[1] = A.global.tactics[3]
    tactics[1] = A.global.tactics[4]
    tactics[1] = A.global.tactics[5]
    tactics[1] = A.global.tactics[6]
    tactics[1] = A.global.tactics[7]
    tactics[1] = A.global.tactics[8]
    --
    comms = A.global.comms
    --
    Arch_callTactics()
    -- :: Register some events
end

-- :: sets raid warning
function Arch_callTactics()
    SELECTED_CHAT_FRAME:AddMessage(tactics[1])
    -- WarnButton1:SetAttribute("macrotext", comms .. tactics[1])
    -- WarnButton2:SetAttribute("macrotext", comms .. tactics[2])
    -- WarnButton3:SetAttribute("macrotext", comms .. tactics[3])
    -- WarnButton4:SetAttribute("macrotext", comms .. tactics[4])
end

-- local function setRaidWarnings(msg)
--     local pass = false
--     local args = fixArgs(msg)
--     local mod = tonumber(table.remove(args, 1))
--     local entry = string.upper(table.concat(args, ' '))
--     local rw = 'rw' .. tostring(mod)
--     local default = 'tacticDefault' .. tostring(mod)
--     -- :: Defensive
--     for ii = 1, 4 do if tonumber(mod) == ii then pass = true end end
--     if pass then
--         if entry == nil or entry == '' then
--             SELECTED_CHAT_FRAME:AddMessage(
--                 moduleAlert .. 'you need to enter a valid text')
--             return
--         end
--         --
--         if entry == 'default' then
--             A.global.tactics[rw] = tacticDefault[mod]
--             tactics[mod] = tacticDefault[mod]
--             SELECTED_CHAT_FRAME:AddMessage(
--                 moduleAlert .. 'Your ' .. rw .. ' set as: ' ..
--                     focus(tacticDefault[mod]))
--             return
--         end
--         --
--         A.global.raidWarnings[rw] = entry
--         tactics[tonumber(mod)] = entry
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your ' .. rw ..
--                                            ' set as: ' .. focus(entry))
--     else
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert ..
--                                            'you need to enter numbers between 1-4 as first argument')
--         return
--     end
--     Arch_callTactics()

-- end

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
            tactics[1] = focus('mdps') .. 'Kill the snobolds as they spawn'
            tactics[2] = '{triangle} LEFT {triangle}'
            tactics[3] = '{triangle} RIGHT {triangle}'
            tactics[4] = '{triangle} Use Harpoons {triangle}'
            --
        elseif (command == "malygos") then
            tactics[1] = '{triangle} Spread 11 Yards {triangle}'
            tactics[2] = '{square} Stay In Dome MDPS Take Discs {square}'
            tactics[3] = '{skull} Spread {skull}'
            tactics[4] = '{triangle} Move Move Move {triangle}'
            --
        else
            Arch_callTactics()
            -- boss = 'default'
            -- tactics[1] = tacticDefault[1];
            -- tactics[2] = tacticDefault[2];
            -- tactics[3] = tacticDefault[3];
            -- tactics[4] = tacticDefault[4];
        end
    else
        Arch_callTactics()
    end
end

-- -- ==== End
-- Arch_callTactics();
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Slash Handlers
SLASH_Tactics1 = "/tact"
SlashCmdList["Tactics"] = function(boss) selectBoss(boss) end

-- ==== Example Usage [last arg]
--[[
/click WarnButton1;  
/click WarnButton2; 
/click WarnButton3; 
/click WarnButton4; 
--]]
