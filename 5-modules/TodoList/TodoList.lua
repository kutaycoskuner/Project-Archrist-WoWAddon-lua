------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'TodoList';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
module.loaded = true
if module == nil then
    return
end
------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[

]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local list = {}

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Register some events
    -- module:RegisterEvent("CHAT_MSG_SAY");
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
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
        Arch_setGUI(moduleName)
        -- SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'You are missing issuer or todo')
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Method
function Arch_TodoListGUI()
    if A.global.todo then
        local heading = AceGUI:Create('Heading')
        heading:SetText('Todo List')
        heading:SetRelativeWidth(1)
        Arch_guiFrame:ReleaseChildren()
        Arch_guiFrame:AddChild(heading)
        -- :: Labels
        local labelIssuer = AceGUI:Create("Label")
        labelIssuer:SetText("")
        labelIssuer:SetRelativeWidth(0.1)
        Arch_guiFrame:AddChild(labelIssuer)
        --
        local labelTodo = AceGUI:Create("Label")
        labelTodo:SetText("Todo")
        labelTodo:SetRelativeWidth(0.7)
        Arch_guiFrame:AddChild(labelTodo)
        --
        local labelButton = AceGUI:Create("Label")
        labelButton:SetText("Complete")
        labelButton:SetRelativeWidth(0.2)
        Arch_guiFrame:AddChild(labelButton)
        --
        -- :: Set Variable for cache
        local list = A.global.todo
        for ii = 1, #list do
            -- :: her bir todo icin
            local label = AceGUI:Create("Label")
            label:SetText(ii .. "# ")
            label:SetRelativeWidth(0.1)
            Arch_guiFrame:AddChild(label)
            --
            local editbox = AceGUI:Create("Label")
            editbox:SetText(list[ii].todo)
            editbox:SetRelativeWidth(0.7)
            Arch_guiFrame:AddChild(editbox)
            --
            local button = AceGUI:Create("Button")
            button:SetText("Done!")
            button:SetRelativeWidth(0.2)
            button:SetCallback("OnClick", function(widget)
                table.remove(list, ii)
                A.global.todo = list
                -- :: Recursive
                recursive = true
                toggleGUI('TodoList')
            end)
            Arch_guiFrame:AddChild(button)
        end
        -- :: gui Add Todo
        local newIssuer, newTodo
        --
        local addIssuer = AceGUI:Create("Label")
        addIssuer:SetText(#A.global.todo + 1 .. "# ")
        addIssuer:SetRelativeWidth(0.1)
        Arch_guiFrame:AddChild(addIssuer)
        -- addIssuer:SetCallback("OnEnterPressed", function(widget, event, text)
        --     newIssuer = text
        -- end)
        --
        local addTodo = AceGUI:Create("EditBox")
        addTodo:SetLabel("Todo")
        addTodo:SetRelativeWidth(0.7)
        addTodo:SetCallback("OnEnterPressed", function(widget, event, text)
            newTodo = text
        end)
        Arch_guiFrame:AddChild(addTodo)
        --
        local button = AceGUI:Create("Button")
        button:SetText("Add")
        button:SetRelativeWidth(0.2)
        button:SetCallback("OnClick", function(widget)
            list = A.global.todo
            table.insert(list, {
                todo = newTodo
            })
            A.global.todo = list
            -- :: Recursive
            recursive = true
            toggleGUI('TodoList')
        end)
        Arch_guiFrame:AddChild(button)
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Main

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers



------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_todo1 = "/todo"
SlashCmdList["todo"] = function(msg) handleTodo(msg) end
-- SLASH_test1 = "/trade"
-- SlashCmdList["trade"] = function(msg) handleTrade(msg) end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

------------------------------------------------------------------------------------------------------------------------
-- ==== Callback & Register [last arg]
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)
