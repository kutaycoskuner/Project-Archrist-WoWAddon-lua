------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'ArchGUI';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------

local AceGUI = LibStub("AceGUI-3.0")
local list
local frame
local frameOpen = false
local textStore

-- :: Sadece Komutla aciliyor
function toggleGUI(key)
    if not frameOpen then
        frameOpen = true
        frame = AceGUI:Create("Frame")
        frame:SetTitle(N)
        -- frame:SetStatusText("AceGUI-3.0 Example Container Frame")
        frame:SetCallback("OnClose", function(widget)
            -- AceGUI:Release(widget)
            frameOpen = false
        end)
        frame:SetLayout("Flow")

        if A.global.todo then
            -- :: Labels
            local labelIssuer = AceGUI:Create("Label")
            labelIssuer:SetText("")
            labelIssuer:SetWidth(60)
            frame:AddChild(labelIssuer)
            --
            local labelTodo = AceGUI:Create("Label")
            labelTodo:SetText("Todo")
            labelTodo:SetWidth(480)
            frame:AddChild(labelTodo)
            --
            local labelButton = AceGUI:Create("Label")
            labelButton:SetText("Complete")
            labelButton:SetWidth(80)
            frame:AddChild(labelButton)
            --
            for ii = 1, #A.global.todo do
                -- :: Bu bir todo
                local label = AceGUI:Create("Label")
                label:SetText(ii .. "# ")
                label:SetWidth(60)
                frame:AddChild(label)
                --
                local editbox = AceGUI:Create("Label")
                editbox:SetText(A.global.todo[ii].todo)
                editbox:SetWidth(480)
                -- editbox:SetCallback("OnEnterPressed", function(widget, event, text)
                --     textStore = text
                -- end)
                frame:AddChild(editbox)
                --
                local button = AceGUI:Create("Button")
                button:SetText("Done!")
                button:SetWidth(80)
                button:SetCallback("OnClick", function(widget)
                    list = A.global.todo
                    table.remove(list, ii)
                    A.global.todo = list
                    --:: Recursive
                    toggleGUI(true)
                    -- editbox = nil
                    -- label = nil
                end)
                frame:AddChild(button)
            end
            -- :: gui Add Todo
            local newIssuer, newTodo
            --
            local addIssuer = AceGUI:Create("Label")
            addIssuer:SetText(#A.global.todo +1 .. "# ")
            addIssuer:SetWidth(60)
            frame:AddChild(addIssuer)
            -- addIssuer:SetCallback("OnEnterPressed", function(widget, event, text)
            --     newIssuer = text
            -- end)
            --
            local addTodo = AceGUI:Create("EditBox")
            addTodo:SetLabel("Todo")
            addTodo:SetWidth(480)
            addTodo:SetCallback("OnEnterPressed", function(widget, event, text)
                newTodo = text
            end)
            frame:AddChild(addTodo)
            --
            local button = AceGUI:Create("Button")
            button:SetText("Add")
            button:SetWidth(80)
            button:SetCallback("OnClick", function(widget)
                list = A.global.todo
                table.insert(list, {todo = newTodo})
                A.global.todo = list
                --:: Recursive
                toggleGUI(true)
                -- editbox = nil
                -- label = nil
            end)
            frame:AddChild(button)
        end
    elseif key then
        frame:Release()
        frameOpen = false
        toggleGUI(false)
    else
        frame:Release()
        frameOpen = false
    end
end

function module:Initialize()
    self.Initialized = true
    -- self:RegisterEvent("MAIL_INBOX_UPDATE")
    -- "MAIL_INBOX_UPDATE"
end

-- ==== Slash Handlers
-- SLASH_arch1 = "/arch"
-- SlashCmdList["arch"] = function() toggleGUI(false) end

-- ==== Callback & Register [last arg]
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- Fill Layout - the TabGroup widget will fill the whole frame
-- frame:SetLayout("Fill")

-- local editbox = AceGUI:Create("EditBox")
-- editbox:SetLabel("Insert text:")
-- editbox:SetWidth(200)
-- editbox:SetCallback("OnEnterPressed",
--                     function(widget, event, text) textStore = text end)
-- frame:AddChild(editbox)

-- local button = AceGUI:Create("Button")
-- button:SetText("Click Me!")
-- button:SetWidth(200)
-- button:SetCallback("OnClick", function() print(textStore) end)
-- frame:AddChild(button)

-- :: function that draws the widgets for the first tab
local function DrawGroup1(container)
    local desc = AceGUI:Create("Label")
    desc:SetText("This is Tab 1")
    desc:SetFullWidth(true)
    container:AddChild(desc)

    local button = AceGUI:Create("Button")
    button:SetText("Tab 1 Button")
    button:SetWidth(200)
    container:AddChild(button)
end

-- :: function that draws the widgets for the second tab
local function DrawGroup2(container)
    local desc = AceGUI:Create("Label")
    desc:SetText("This is Tab 2")
    desc:SetFullWidth(true)
    container:AddChild(desc)

    local button = AceGUI:Create("Button")
    button:SetText("Tab 2 Button")
    button:SetWidth(200)
    container:AddChild(button)
end

-- :: Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "tab1" then
        DrawGroup1(container)
    elseif group == "tab2" then
        DrawGroup2(container)
    end
end

----

-- local tab = AceGUI:Create("TabGroup")
-- tab:SetLayout("Flow")
-- -- Setup which tabs to show
-- tab:SetTabs({{text = "Tab 1", value = "tab1"}, {text = "Tab 2", value = "tab2"}})
-- -- Register callback
-- tab:SetCallback("OnGroupSelected", SelectGroup)
-- -- Set initial Tab (this will fire the OnGroupSelected callback)
-- tab:SelectTab("tab1")

-- -- add to the frame container
-- frame:AddChild(tab)
