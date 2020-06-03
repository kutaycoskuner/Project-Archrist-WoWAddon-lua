------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'ArchGUI';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------

local AceGUI = LibStub("AceGUI-3.0")
local list
local frame
local frameOpen = false
local recursive = false
local realmName = GetRealmName()
local textStore
local currentLootList = {}
local focus = Arch_focusColor

-- ==== Module GUI
local function TodoListGUI()
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
        -- :: Set Variable for cache
        local list = A.global.todo
        for ii = 1, #list do
            -- :: her bir todo icin
            local label = AceGUI:Create("Label")
            label:SetText(ii .. "# ")
            label:SetWidth(60)
            frame:AddChild(label)
            --
            local editbox = AceGUI:Create("Label")
            editbox:SetText(list[ii].todo)
            editbox:SetWidth(480)
            frame:AddChild(editbox)
            --
            local button = AceGUI:Create("Button")
            button:SetText("Done!")
            button:SetWidth(80)
            button:SetCallback("OnClick", function(widget)
                table.remove(list, ii)
                A.global.todo = list
                -- :: Recursive
                recursive = true
                toggleGUI('TodoList')
                -- editbox = nil
                -- label = nil
            end)
            frame:AddChild(button)
        end
        -- :: gui Add Todo
        local newIssuer, newTodo
        --
        local addIssuer = AceGUI:Create("Label")
        addIssuer:SetText(#A.global.todo + 1 .. "# ")
        addIssuer:SetWidth(60)
        frame:AddChild(addIssuer)
        -- addIssuer:SetCallback("OnEnterPressed", function(widget, event, text)
        --     newIssuer = text
        -- end)
        --
        local addTodo = AceGUI:Create("EditBox")
        addTodo:SetLabel("Todo")
        addTodo:SetWidth(480)
        addTodo:SetCallback("OnEnterPressed",
                            function(widget, event, text) newTodo = text end)
        frame:AddChild(addTodo)
        --
        local button = AceGUI:Create("Button")
        button:SetText("Add")
        button:SetWidth(80)
        button:SetCallback("OnClick", function(widget)
            list = A.global.todo
            table.insert(list, {todo = newTodo})
            A.global.todo = list
            -- :: Recursive
            recursive = true
            toggleGUI('TodoList')
        end)
        frame:AddChild(button)
    end
end

local function LootDatabaseGUI()
    frame:SetWidth(280)
    frame:SetPoint("CENTER", 640, 0);
    local heading = AceGUI:Create('Heading')
    heading:SetText('Loot Database')
    heading:SetRelativeWidth(1)
    frame:AddChild(heading)
    frame:ReleaseChildren()
    -- 
    if #currentLootList >= 0 then
        for ii = 1, #currentLootList do
            local unit = AceGUI:Create("SimpleGroup")
            unit:SetFullWidth(true)
            -- unit:SetTitle(currentLootList[ii][1])
            -- unit:SetWidth(300)
            -- unit:SetHeight(140)
            -- unit:SetPoint('CENTER')
            frame:AddChild(unit)
            --
            local add = AceGUI:Create("Label")
            add:SetText(focus(currentLootList[ii][1]) .. ' acquired total ' ..
                            focus(currentLootList[ii][2]) ..
                            ' items in guild\n\n')
            add:SetWidth(220)
            unit:AddChild(add)
            --
            for yy = 3, 5 do
                local add1 = AceGUI:Create("Label")
                add1:SetText(currentLootList[ii][yy][1])
                add1:SetWidth(60)
                unit:AddChild(add1)
                local add = AceGUI:Create("InteractiveLabel")
                add:SetText(currentLootList[ii][yy][2])
                add:SetWidth(160)
                -- add:SetCallback("OnEnter", function(self)
                --     if string.match(currentLootList[ii][yy][2], "item[%-?%d:]+") then
                --         local itemString =
                --             string.match(currentLootList[ii][yy][2],
                --                          "item[%-?%d:]+")
                --         -- hooksecurefunc("GameTooltip_SetDefaultAnchor",
                --         --                function(self, parent)
                --         --     self:SetOwner(parent, "ANCHOR_CURSOR")
                --         -- end)
                --         -- GameTooltip:SetOwner(add, "ANCHOR_RIGHT")
                --         -- GameTooltip:SetX()
                --         GameTooltip:SetHyperlink(itemString)
                --     end
                -- end)
                add:SetCallback("OnEnter", function(self)
                    -- GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
                    -- GameTooltip:SetText("LootDB", 0.5, 0.5, 0.5, 0.75, true)
                    -- GameTooltip:SetX(arguments)
                    if string.match(currentLootList[ii][yy][2], "item[%-?%d:]+") then
                        -- hooksecurefunc("GameTooltip_SetDefaultAnchor",
                        --                function(self, parent)
                        --     self:SetOwner(parent, "ANCHOR_CURSOR")
                        -- end)
                        GameTooltip:SetHyperlink(
                            string.match(currentLootList[ii][yy][2],
                                         "item[%-?%d:]+"))
                    end
                end)
                add:SetCallback("OnLeave", function(self)
                    -- hooksecurefunc("GameTooltip_SetDefaultAnchor",
                    --                    function(self, parent)
                    --         self:SetOwner(UIParent, "ANCHOR_RIGHT")
                    --     end)
                    GameTooltip:SetText("LootDB", 0.5, 0.5, 0.5, 0.75, true)
                end)
                unit:AddChild(add)
                -- add:SetMouseEnabled(true)
                -- -- set handler for mouse enter:
                -- add:SetHandler("OnMouseEnter", function(self)
                --     InitializeTooltip(ItemTooltip, self, BOTTOMLEFT, 0, 0)
                --     ItemTooltip:SetLink(self:GetText())
                -- end)

                -- -- set handler for mouse exit:
                -- add:SetHandler("OnMouseExit",
                --                  function(self)
                --     ClearTooltip(ItemTooltip)
                -- end)
            end
        end
        -- :: Set Variable for cache

    end
end

-- ==== Core
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
        -- test
        if key == 'TodoList' then TodoListGUI() end
        if key == 'LootDatabase' then LootDatabaseGUI() end
        -- test
    elseif recursive then
        frame:Release()
        frameOpen = false
        toggleGUI(key)
    else
        frame:Release()
        frameOpen = false
    end
end

function Arch_setGUI(key)
    recursive = false
    toggleGUI(key)
end

function GUI_insertPerson(target)
    local player = A.loot[realmName][target]
    -- print(arg2 .. ' acquired ' .. #player .. ' items in guild runs.')
    -- print('last items: ')
    local nominee = {}
    nominee[1] = target
    nominee[2] = (#player or 0)
    for ii = 1, #player do
        if GetItemInfo(player[ii][1]) then
            local _, a = GetItemInfo(player[ii][1])
            nominee[2 + ii] = {player[ii][2], a}
        end
        if ii == 3 then break end
    end
    for ii = 3, 5 do if not nominee[ii] then nominee[ii] = {'', ''} end end
    local previous = #currentLootList
    table.insert(currentLootList, 1, nominee)
    if #currentLootList > previous then
        if not frameOpen then
            Arch_setGUI('LootDatabase')
        else
            frame:Release()
            frameOpen = false
            Arch_setGUI('LootDatabase')
        end
    end
end

function module:Initialize()
    self.Initialized = true
    self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
    self:RegisterEvent("CHAT_MSG_RAID_WARNING")
    -- "MAIL_INBOX_UPDATE"
end

-- ==== Events
function module:CHAT_MSG_WHISPER_INFORM()
    if string.match(arg1, 'You are now being considered for') then
        if not A.loot[realmName][arg2] then A.loot[realmName][arg2] = {} end
        GUI_insertPerson(arg2)
    end
end

function module:CHAT_MSG_RAID_WARNING()
    if string.match(arg1, 'now under consideration') then
        currentLootList = {}
        frame:Release()
        frameOpen = false
        Arch_setGUI('LootDatabase')
    end
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
