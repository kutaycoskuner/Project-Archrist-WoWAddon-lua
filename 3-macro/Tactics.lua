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
local bossName
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

local tacticsDatabase = Arch_tactics

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
            tacticDefault[1], tacticDefault[2], tacticDefault[3],
            tacticDefault[4], tacticDefault[5], tacticDefault[6],
            tacticDefault[7], tacticDefault[8]
        }
    end
    --
    tactics[1] = A.global.tactics[1]
    tactics[2] = A.global.tactics[2]
    tactics[3] = A.global.tactics[3]
    tactics[4] = A.global.tactics[4]
    tactics[5] = A.global.tactics[5]
    tactics[6] = A.global.tactics[6]
    tactics[7] = A.global.tactics[7]
    tactics[8] = A.global.tactics[8]
    --
    comms = A.global.comms
    --
    -- Arch_callTactics()
    -- :: Register some events
end

-- :: sets raid warning
function Arch_callTactics()
    local warning = 1
    for ii = 1, (#tacticsDatabase[bossName] or 0) do
        if (tactics[ii] ~= '') then
            if string.sub(tactics[ii], 1, 1) == "!" then
                SELECTED_CHAT_FRAME:AddMessage(
                    moduleAlert .. string.sub(tactics[ii], 3))
            elseif string.sub(tactics[ii], 1, 1) == "=" then
                SELECTED_CHAT_FRAME:AddMessage(string.sub(tactics[ii],2,2))
                if type(tonumber(string.sub(tactics[ii],2,2))) == "number" then
                    Arch_RaidWarnings[tonumber(string.sub(tactics[ii],2,2))] = string.sub(tactics[ii], 4)
                else
                    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Please give 1-4 number after warning prefix")
                --     Arch_RaidWarnings[warning] = string.sub(tactics[ii], 3)
                --     if warning ~= 4 then warning = warning + 1 end
                end
            else
                SendChatMessage(tactics[ii], "raid", nil, nil)
            end
        end
    end
end

-- :: selecting boss via slash command
local function selectBoss(boss)
    local target = boss
    if boss ~= '' then
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
        bossName = command
        -- :: Dungeons
        if (tacticsDatabase[command]) then
            for ii = 1, #tacticsDatabase[command] do
                tactics[ii] = tacticsDatabase[command][ii]
            end
        end
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Tactics for ' ..
                                           focus(target))
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

