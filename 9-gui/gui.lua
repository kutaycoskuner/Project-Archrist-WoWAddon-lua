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
local fixArgs = Arch_fixArgs

local lootFramePos

-- ==== Module GUI
local function TodoListGUI()
    if A.global.todo then
        local heading = AceGUI:Create('Heading')
        heading:SetText('Todo List')
        heading:SetRelativeWidth(1)
        frame:ReleaseChildren()
        frame:AddChild(heading)
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

local function setPoint(self)
    local scale = self:GetEffectiveScale()
    local x, y = GetCursorPosition()
    self:ClearAllPoints()
    self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / scale,
                  (y + 10) / scale)
end

local function setGameTooltip(widget)
    -- GameTooltip:SetOwner(frame, "ANCHOR_CURSOR", 0, 0);
    -- GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    -- GameTooltip:ClearAllPoints();
    -- GameTooltip:SetPoint("bottomleft", frame, "topright", 0, 0);
    -- GameTooltip:ClearLines()
    -- print(frame)
end

local function LootDatabaseGUI()
    frame:SetWidth(280)
    frame:ClearAllPoints()
    if A.global.lootFrame == {} then
        frame:SetPoint("CENTER", 0, 0)
    else
        frame:SetPoint(lootFramePos[1], lootFramePos[3], lootFramePos[4])
    end
    local heading = AceGUI:Create('Heading')
    heading:SetText('Loot Database')
    heading:SetRelativeWidth(1)
    frame:ReleaseChildren()
    frame:AddChild(heading)
    -- 
    if #currentLootList > 0 then
        for ii = 1, #currentLootList do
            local unit = AceGUI:Create("SimpleGroup")
            unit:SetFullWidth(true)
            -- closeBtn:ClearAllPoints()
            -- unit:SetTitle(currentLootList[ii][1])
            -- unit:SetWidth(300)
            -- unit:SetHeight(140)
            -- unit:SetPoint('CENTER')
            unit:SetLayout('Flow')
            frame:AddChild(unit)
            --
            local add = AceGUI:Create("Label")
            add:SetText(focus(currentLootList[ii][1]) .. ' acquired total ' ..
                            focus(currentLootList[ii][2]) ..
                            ' items in guild\n\n')
            add:SetWidth(200)
            unit:AddChild(add)

            local closeBtn = AceGUI:Create('Button')
            closeBtn:ClearAllPoints()
            closeBtn:SetWidth(40)
            closeBtn:SetHeight(15)
            closeBtn:SetText('x')
            closeBtn:SetCallback("OnClick", function(widget)
                currentLootList[ii] = nil
                recursive = true
                toggleGUI('LootDatabase')
            end)
            closeBtn:SetPoint("TOPRIGHT")
            unit:AddChild(closeBtn)
            --
            -- local button = AceGUI:Create("Button")
            -- button:SetText('x')
            -- button:SetPoint(..., "TOPRIGHT")
            -- unit:AddChild(button)
            --
            for yy = 3, 5 do
                if currentLootList[ii][yy] ~= nil then
                    local add1 = AceGUI:Create("Label")
                    add1:SetText(currentLootList[ii][yy][1] or '')
                    add1:SetWidth(240)
                    unit:AddChild(add1)
                    --
                    if currentLootList[ii][yy][1] then
                        local removeBtn = AceGUI:Create('Button')
                        -- removeBtn:SetPoint('RIGHT')
                        removeBtn:SetWidth(38)
                        removeBtn:SetHeight(15)
                        removeBtn:SetText('x')
                        removeBtn:SetCallback("OnClick", function(widget)
                            table.remove(
                                A.loot[realmName][currentLootList[ii][1]],
                                yy - 2)
                            currentLootList[ii][yy] = {nil, nil}
                            for jj = 1, #A.loot[realmName][currentLootList[ii][1]] do
                                if A.loot[realmName][currentLootList[ii][1]][jj] then
                                    local _, a = GetItemInfo(A.loot[realmName][currentLootList[ii][1]][jj][3])
                                    currentLootList[ii][jj+2] =
                                        {
                                            A.loot[realmName][currentLootList[ii][1]][jj][1],
                                            a
                                        }
                                end
                                if jj == 3 then
                                    break
                                end
                            end
                            recursive = true
                            toggleGUI('LootDatabase')
                        end)
                        unit:AddChild(removeBtn)
                    end
                    --
                    add = AceGUI:Create("InteractiveLabel")
                    add:SetText(currentLootList[ii][yy][2])
                    add:SetWidth(160)
                    --
                    add:SetCallback("OnEnter", function(widget)
                        if string.match(currentLootList[ii][yy][2] or '',
                                        "item[%-?%d:]+") then

                            -- >>
                            -- hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
                            --     tooltip:SetOwner(parent, "ANCHOR_CURSOR")
                            --     setPoint(tooltip)
                            --     tooltip.default = 1
                            -- end)
                            GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
                            GameTooltip:ClearAllPoints();
                            setPoint(GameTooltip)
                            GameTooltip:ClearLines()
                            -- >>
                            GameTooltip:SetHyperlink(
                                string.match(currentLootList[ii][yy][2],
                                             "item[%-?%d:]+"))
                            GameTooltip:Show()
                        end
                    end)
                    --
                    add:SetCallback("OnLeave",
                                    function(self)
                        GameTooltip:Hide()
                    end)
                    unit:AddChild(add)
                    --
                end
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
        --
        -- frame:SetMovable(true)
        -- frame:EnableMouse(true)
        -- frame:RegisterForDrag("LeftButton")
        -- frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        -- frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        -- frame:SetScript("OnDragStop", function(self)
        --     self:StopMovingOrSizing()
        -- end)
        --
        frame:SetCallback("OnClose", function(widget)
            frameOpen = false
            local a, b, c, d, e = frame:GetPoint()
            -- print(a,b,c,d,e)
            A.global.lootFrame = {a, c, d, e}
            lootFramePos = A.global.lootFrame
            -- print(lootFramePos[1], lootFramePos[2], lootFramePos[3], lootFramePos[4])
            -- print(A.global.lootFrame[1].. d)
        end)
        frame:SetLayout("Flow")
        -- test
        if key == 'TodoList' then TodoListGUI() end
        if key == 'LootDatabase' then LootDatabaseGUI() end
        if key == 'LootDatabasePrune' then
            currentLootList = {}
            toggleGUI('LootDatabase')
        end
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

function Arch_setGUI(key, isRecursive)
    recursive = false
    if isRecursive then recursive = true end
    toggleGUI(key)
end

function GUI_insertPerson(target, reload)
    local isPersonExists = false
    local player = A.loot[realmName][target]
    -- :: kisi varsa sil
    -- if target == nil then target = '' end
    for ii = 1, #currentLootList do
        if currentLootList[ii][1] == target then
            table.remove(currentLootList, ii)
            isPersonExists = true
        end
    end
    -- :: kisi yoksa ekle
    if not isPersonExists or reload ~= nil then
        local nominee = {}
        nominee[1] = target -- name
        nominee[2] = (#player or 0) -- item count
        for ii = 1, #player do
            if GetItemInfo(player[ii][3]) then -- [3] id ye bakiyor
                local _, a = GetItemInfo(player[ii][3])
                nominee[2 + ii] = {player[ii][1], a}
            end
            if ii == 3 then break end
        end
        for ii = 3, 5 do
            if not nominee[ii] then nominee[ii] = {nil, nil} end
        end
        local previous = #currentLootList or 0
        table.insert(currentLootList, 1, nominee)
    end
    -- :: eger bir onceki listeden farkliysa listeyi guncelle
    if not frameOpen then
        Arch_setGUI('LootDatabase')
    else
        frame:Release()
        frameOpen = false
        Arch_setGUI('LootDatabase')
    end

end

function module:Initialize()
    self.Initialized = true
    if not A.global.lootFrame then
        A.global.lootFrame = {"CENTER", "CENTER", 0, 0}
    end
    lootFramePos = A.global.lootFrame
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
        -- print(currentLootList[1])
        currentLootList = {}
        -- print(currentLootList[0])
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
