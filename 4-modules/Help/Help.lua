------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Help';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then return end
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local Arch_focusColor = Arch_focusColor
local Arch_commandColor = Arch_commandColor

local Arch_modules = {
    ["TodoList"] = 'Helps you to create todo list',
    ["PlayerDB"] = 'Player database module for interactions',
    ["Pug"] = 'For creating fast and editable PuG announces',
    ["VoA"] = 'For Creating specific VoA18 spec run announcements',
    ["CRIndicator"] = 'Raid combat res indicator for leading',
    ["RaidCommands"] = 'Work in progress not yet finished',
    ["Macro"] = 'Allows you to create your own macros more than 255 characters with lua'
}
-- ==== GUI

-- ==== Methods
local function shouldRender(par)
    return A:GetModule(par, true) ~= nil
end


local function handleCommand(msg)
    -- do return end
    if msg == '' then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Archrist is general purpose assistant addon for 3.3.5a patch')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'please use ' .. Arch_commandColor('/arch help') .. ' command to see modules')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'please use ' .. Arch_commandColor('/arch config') .. ' command to see interface options')
    elseif msg == 'config' then
        A.OpenInterfaceConfig()
    elseif msg == 'help' then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'These are relatively different functional modules')
        for k, v in pairs(Arch_modules) do
            if(shouldRender(k)) then SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor(k .. ': ') .. v) end 
        end
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'please use ' .. Arch_commandColor('/arch <modulename>') .. ' to get detailed information')
    elseif msg == "v" or msg == "version" or msg == "ver" then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "version: " .. Arch_focusColor( A.version ) .. " Release date: ".. Arch_focusColor(A.releaseDate) )
    elseif msg == 'todolist' and shouldRender('TodoList') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('TodoList'))
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'note taking and todo list module')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/todo') .. ' to see your current todo list')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/todo <note>') .. ' for creating new todo on console')
    elseif msg == 'playerdb' and shouldRender('PlayerDB') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('PlayerDB'))
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'playerscoring and note taking module for your interactions')
        -- SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'calculates Raidscore for player by given attributes if you have ' .. Arch_addonColor('GearScoreLite'))
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'quantitative parameters: [dmg], [str], [rep], [att], [dsc]')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'qualitative parameters: note[not]')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep') .. ' adds target person to your database, if target is already added displays data')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep') .. ' present player details if existing in database')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep <number>') .. ' increases or decreases score')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rep <playername> <number>') .. ' non target variant')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/not <note>') .. ' taking not for target player')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/not <playername> <note>') .. ' non target variant')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rrep') .. ' without parameter checks if anyone has negative reputation in your group')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/rrep <number>') .. ' gives everyone a given reputation in the group')

    elseif msg == 'crindicator' and shouldRender('CRIndicator') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('CRIndicator'))
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'simple frame module to inform raid leader how many crucial raid cooldowns are available in raid')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/cr') .. ' for toggle frame|r')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/cr lock') ..' for lock frame|r')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/cr move') ..' for move frame|r')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_commandColor('/cr <number>') ..' In combat this command announces <n>th available Rebirth for combat res|r')
    elseif msg == 'pug' and shouldRender('Pug') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('Pug'))
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Helps to creates adaptive raid forming announcements through web interface')
    elseif msg == 'macro' and shouldRender('Macro') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('Macro'))
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. '1. Create your own macro in 3-macro folder in addon')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. '2. Give it a unique button name ex. feedButton')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. '3. Create an ingame macro as "/run setFeedButton() /click feedButton"')
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Limitations: Due to prevent combat abuse: You cannot dynamically change macros in combat')
    elseif msg == 'raidcommands' and shouldRender('RaidCommands') then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. Arch_focusColor('RaidCommands'))
    end
end

-- ==== Start
function module:Initialize()
    self.initialized = true
end

-- ==== Event Handlers

-- ==== Slash Handlersd
SLASH_archrist1 = "/arch"
SLASH_archrist2 = "/archrist"
SlashCmdList["archrist"] = function(msg) handleCommand(msg) end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[
    
]]

-- ==== UseCase
--[[]]