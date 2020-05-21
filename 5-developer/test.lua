-- ------------------------------------------------------------------------------------------------------------------------
-- -- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
-- local A, L, V, P, G, C, M, N = unpack(select(2, ...));
-- local moduleName = 'test';
-- local moduleAlert = M .. moduleName .. ": |r";
-- local module = A:GetModule(moduleName);
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Variables

-- -- -- ==== GUI
-- -- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- -- ==== Methods

-- local function handleCommand(msg)
--     if msg == '' then
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Archrist_Archrist is general purpose assistant addon for 3.3.5a patch')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'please use ' .. Arch_commandColor('/arch help') .. ' command to see modules')
--     elseif msg == 'help' then
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'These are the modules Archrist offering')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('TodoList: ') .. 'helps you to create todo list')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('PlayerDB: ') .. 'player database module for interactions')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('CRIndicator: ') .. 'raid combat res indicator for leading')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'please use ' .. Arch_commandColor('/arch <modulename>') .. ' to get detailed information')
--     elseif msg == 'todolist' then
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('TodoList'))
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'note taking and todo list module')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/todo') .. ' to see your current todo list')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/todo <note>') .. ' for creating new todo on console')
--     elseif msg == 'playerdb' then
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('PlayerDB'))
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'playerscoring and note taking module for your interactions')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'calculates Raidscore for player by given attributes if you have ' .. Arch_addonColor('GearScoreLite'))
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'quantitative parameters: [dmg], [str], [rep], [att], [dsc]')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'qualitative parameters: note[not]')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep') .. ' adds target person to your database')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep') .. ' present player details if existing in database')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep <number>') .. ' increases or decreases score')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep <playername> <number>') .. ' non target variant')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/not <note>') .. ' taking not for target player')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/not <playername> <note>') .. ' non target variant')
--     elseif msg == 'crindicator' then
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('CRIndicator'))
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'simple frame module to inform raid leader how many rebirths are available in raid')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/cr') .. ' for toggle frame|r')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/cr lock') ..' for lock frame|r')
--         SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/cr move') ..' for move frame|r')
--     end
-- end

-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true
-- end

-- -- ==== Event Handlers

-- -- ==== Slash Handlersd
-- SLASH_archrist1 = "/arch"
-- SLASH_archrist2 = "/archrist"
-- SlashCmdList["archrist"] = function(msg) handleCommand(msg) end

-- -- ==== End
-- local function InitializeCallback() module:Initialize() end
-- A:RegisterModule(module:GetName(), InitializeCallback)

-- -- ==== Todo
-- --[[
--     - addonColor
--     - moduleColor
--     - commandColor
--     - focusColor
--     - trivialColor
-- ]]

-- -- ==== UseCase
-- --[[]]