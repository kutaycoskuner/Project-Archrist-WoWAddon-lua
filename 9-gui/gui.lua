-- local frame = AceGUI:Create("Frame")
-- frame:SetTitle("Example Frame")
-- frame:SetStatusText("AceGUI-3.0 Example Container Frame")

-- local textStore
-- local AceGUI = LibStub("AceGUI-3.0")
-- local frame = AceGUI:Create("Frame")
-- frame:SetTitle(AddonName)
-- frame:SetStatusText("AceGUI-3.0 Example Container Frame")
-- frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
-- -- Fill Layout - the TabGroup widget will fill the whole frame
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

-- function that draws the widgets for the first tab
-- local function DrawGroup1(container)
--     local desc = AceGUI:Create("Label")
--     desc:SetText("This is Tab 1")
--     desc:SetFullWidth(true)
--     container:AddChild(desc)

--     local button = AceGUI:Create("Button")
--     button:SetText("Tab 1 Button")
--     button:SetWidth(200)
--     container:AddChild(button)
-- end

-- -- function that draws the widgets for the second tab
-- local function DrawGroup2(container)
--     local desc = AceGUI:Create("Label")
--     desc:SetText("This is Tab 2")
--     desc:SetFullWidth(true)
--     container:AddChild(desc)

--     local button = AceGUI:Create("Button")
--     button:SetText("Tab 2 Button")
--     button:SetWidth(200)
--     container:AddChild(button)
-- end

-- -- Callback function for OnGroupSelected
-- local function SelectGroup(container, event, group)
--     container:ReleaseChildren()
--     if group == "tab1" then
--         DrawGroup1(container)
--     elseif group == "tab2" then
--         DrawGroup2(container)
--     end
-- end

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
