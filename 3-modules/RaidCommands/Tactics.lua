------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Tactics';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then return end

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
    -- if bossName == "" or bossName == nil then bossName = "genel" end
    -- :: Defensive: Eger o isimde bir taktik yoksa
    if not tacticsDatabase[bossName] then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "given boss not found")
        return
    end
    -- 
    for ii = 1, (#tacticsDatabase[bossName] or 0) do
        if (tactics[ii] ~= '') then
            if string.sub(tactics[ii], 1, 1) ~= "!" and
                string.sub(tactics[ii], 1, 1) ~= "=" then
                -- :: Alerts
                SendChatMessage(tactics[ii], "raid", nil, nil)
            end
        end
    end
    --
    for ii = 1, (#tacticsDatabase[bossName] or 0) do
        if string.sub(tactics[ii], 1, 1) == "=" then
            -- :: Warning
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert ..
                    focus("Warning " .. string.sub(tactics[ii], 2, 2)) ..
                    string.sub(tactics[ii], 3))
            if type(tonumber(string.sub(tactics[ii], 2, 2))) == "number" then
                Arch_RaidWarnings[tonumber(string.sub(tactics[ii], 2, 2))] =
                    string.sub(tactics[ii], 4)
            else
                SELECTED_CHAT_FRAME:AddMessage(
                    moduleAlert .. "Please give 1-4 number after warning prefix")
            end
        elseif string.sub(tactics[ii], 1, 1) == "!" then
            -- :: Self Reminder
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. string.sub(tactics[ii], 3))
        end
    end
end

-- :: selecting boss via slash commandd
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
        -- :: Eger o isimde bir taktik yoksa
        if not tacticsDatabase[bossName] then
            SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "given boss not found")
            return
        end
        -- :: Dungeons
        if (tacticsDatabase[command]) then
            for ii = 1, #tacticsDatabase[command] do
                tactics[ii] = tacticsDatabase[command][ii]
            end
        end
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Tactics for ' ..
                                           focus(target))
    elseif bossName ~= nil then
        Arch_callTactics()
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'No boss selected')
    end
end

-- -- ==== End
-- Arch_callTactics();
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Slash Handlers
SLASH_Tactics1 = "/tact"
SlashCmdList["Tactics"] = function(boss) selectBoss(boss) end

