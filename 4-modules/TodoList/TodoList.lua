------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'TodoList';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local list = {}

-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Register some events
    -- module:RegisterEvent("CHAT_MSG_SAY");
end

-- ==== Methods
-- :: Argumanlari ayirip bas harflerini buyutuyor
local function fixArgs(msg)
    -- :: this is separating the given arguments after command
    local sep;
    if sep == nil then sep = "%s" end
    local args = {};
    for str in string.gmatch(msg, "([^" .. sep .. "]+)") do
        table.insert(args, str)
    end

    -- :: this capitalizes first letters of each given string
    for ii = 1, #args, 1 do
        args[ii] = args[ii]:lower()
        if ii == 1 then args[ii] = args[ii]:gsub("^%l", string.upper) end
    end

    return args;
end

local function handleTodo(msg)
    if not A.global.todo then
        A.global.todo = {}
    end
    list = A.global.todo
    local args = fixArgs(msg)
    -- local issuer = table.remove(args, 1)
    local note = table.concat(args, ' ')

    if issuer == 'S' then
        issuer = UnitName('player')
    end

    if #note > 0 then
    table.insert(list, {todo = note})
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. list[#list].todo) -- list[#list].issuedBy .. ' | ' ..
    A.global.todo = list
    -- toggleGUI(true)
    else
        toggleGUI(false)
        -- SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'You are missing issuer or todo')
    end
end

-- ==== Slash Handlersd
SLASH_todo1 = "/todo"
SlashCmdList["todo"] = function(msg) handleTodo(msg) end
-- SLASH_test1 = "/trade"
-- SlashCmdList["trade"] = function(msg) handleTrade(msg) end

-- -- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo

-- ==== UseCase
-- Todolist
-- >> take notes for what todo
-- >> Mainly for glyphs
--[[
 simdilik sadece ilk girilen entry issuer ve not olarak alsin.

]]