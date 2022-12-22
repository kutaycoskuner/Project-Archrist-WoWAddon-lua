------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "GuideMaker", "Guide Maker";
local group = "utility";
local module = A:GetModule(m_name, true);
local moduleAlert = M .. m_name2 .. ": |r";
local mprint = function(msg)
    print(moduleAlert .. msg)
end
local aprint = Arch_print
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------

-- use case ------------------------------------------------------------------------------------------------------------
--[[
    - craft guides icin rehber hazirlamak zor oluyor bunu oyun icinden ekleyecek interface ile calisan bir module
    - gui acacak
        - rehberin adini koy
        - her bir entry 

]]

-- blackboard ------------------------------------------------------------------------------------------------------------
--[[
]]

-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - [x] craft tab yaratma tab ekleme
    - [x] tab ekledikten sonra taba entry girme
    - rehber silme
    - rehbere yeni girdi yaratma

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = true
-- :: global Functions
local fCol = Arch_focusColor
local cCol = Arch_commandColor
local mCol = Arch_moduleColor
local tCol = Arch_trivialColor
local hCol = Arch_headerColor
local classCol = Arch_classColor
local pCase = Arch_properCase
local split = Arch_split
local realmName = GetRealmName()

-- :: local variables
local framePos = {"CENTER", "CENTER", 0, 0}
local test_guide
local col_widths = {0.03, 0.07, 0.30, 0.18, 0.41}

-- :: Functions
local drawMainFrame = nil
local draw_widget_label = nil
local draw_widget_interactiveLabel = nil
local draw_widget_editBox = nil
local draw_widget_editBox2 = nil
local drawEditCategoryBox = nil
local insertframe
local skillUpLimit = 450

local draw_block_row = nil
local draw_block_editRow = nil
local draw_block_newCategory = nil

local tab = "tailoring"
local guide_list = {}

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- :: construct
    if A.global[group] == nil then
        A.global[group] = {}
    end
    if A.global[group][m_name] == nil then
        A.global[group][m_name] = {}
    end
    if A.global[group][m_name].isEnabled == nil then
        A.global[group][m_name].isEnabled = isEnabled
    end
    isEnabled = A.global[group][m_name].isEnabled
    -- :: gui construct
    if A.global.gui == nil then
        A.global.gui = {}
    end
    if A.global.gui.guideMaker == nil then
        A.global.gui.guideMaker = {}
    end
    -- :: initialize frame lock
    if A.global.gui.guideMaker.frameLock == nil then
        A.global.gui.guideMaker.frameLock = true
    else
        -- rcFrameLock = A.global.gui.guildeMaker.frameLock
    end
    -- :: initialize gui position
    if A.global.gui.guideMaker.position == nil then
        A.global.gui.guideMaker.position = {"CENTER", "CENTER", 0, 0}
    else
        framePos = A.global.gui.guideMaker.position
    end
    -- :: initialize gui isOpen
    if A.global.gui.guideMaker.isOpen == nil then
        A.global.gui.guideMaker.isOpen = false
    end
    -- :: construct guides
    if A.global.guides == nil then
        A.global.guides = {}
        A.global.guides.tailoring = Arch_guide_tailor
        A.global.guides.engineering = Arch_guide_engineer
    end
    --
    local once = true
    for k, v in pairs(A.global.guides) do
        table.insert(guide_list, k)
        if once then
            tab = string.lower(k)
            once = false
        end
    end
    -- for ii=1, #A.global.guides.tailoring do 
    --     if A.global.guides.tailoring[ii] then
    --         A.global.guides.tailoring[tostring(ii)] = A.global.guides.tailoring[ii]
    --         A.global.guides.tailoring[ii] = nil
    --     end
    -- end
    test_guide = A.global.guides[tab]
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function drawButton(name, width, parent, fx)
    local widget = AceGUI:Create("Button")
    widget:SetText(name)
    widget:SetUserData("key", name)
    widget:SetRelativeWidth(width)
    widget:SetCallback("OnClick", function(self, value)
    end)
    widget:SetCallback("OnClick", function(widget, event, text)
        -- todo tab in adinin + olusu problemine cozum bul
        -- tab data icinde varsa ekle
        tab = widget:GetUserData("key")
        fx()
    end)
    parent:AddChild(widget)
end

local function drawButton2(name, width, parent, fx)
    local widget = AceGUI:Create("Button")
    widget:SetText(name)
    widget:SetUserData("key", name)
    widget:SetRelativeWidth(width)
    widget:SetCallback("OnClick", function(self, value)
    end)
    widget:SetCallback("OnClick", function(widget, event, text)
        -- todo tab in adinin + olusu problemine cozum bul
        fx()
    end)
    parent:AddChild(widget)
end

local function btnFunction_retrieveGuide()
    test_guide = A.global.guides[string.lower(tab)]
    Arch_setGUI(m_name, true)
end

local function btnFunction_addGuide()
    draw_block_newCategory()
end

local function btnFunction_deleteGuide()
    if tab then
        tab = string.lower(tab)
        A.global.guides[tab] = nil
        for ii = 1, #guide_list do
            if tab == guide_list[ii] then
                table.remove(guide_list, ii)
                A.global.guides[string.lower(tab)] = nil
                break
            end
        end
        tab = nil
        Arch_setGUI(m_name, true)
    end
end

local function btnFunction_addEntry()
    local highest = 1
    -- if tab == nil then
    --     tab = guide_list[1]
    -- end
    print(tab)
    if tab == nil then
        do
            return
        end
        aprint('there are no guide')
    end
    tab = string.lower(tab)
    for ii = 1, skillUpLimit do
        if A.global.guides[tab] then
            if A.global.guides[tab][ii] ~= nil then
                highest = ii
            end
        end
    end
    highest = tonumber(tonumber(highest) + 1)
    print(tab, highest, type(highest))
    A.global.guides[string.lower(tab)][highest] = {
        ['item'] = "New",
        ['howtolearn'] = " ",
        ["levels"] = {highest, highest + 5, highest + 10, highest + 15},
        ['mats'] = {}
    }
    Arch_setGUI(m_name, true)
end

local function validateGuide(data, oldKey)
    -- d1 = sequence, d2 = target, d3 = nae, d4 = levels
    tab = string.lower(tab)
    -- :: eger target level varsa
    if A.global.guides[tab][data[2]] ~= nil then
        -- == validate item
        if data[3] then
            local itemName, itemLink = GetItemInfo(tostring(data[3]))
            -- print(itemLink, #data[3], type(data[3]), data[3])
            local itemID
            if itemLink then
                itemID = GetItemInfoFromHyperlink(itemLink)
            end
            if itemID then
                A.global.guides[tab][data[2]].item = itemID
            end
        end
        -- == validate levels
        if data[4] then
            local levels = split(data[4])
            -- print(levels[1])
            if #levels == 4 then
                -- todo 
                -- for ii=1, #levels do
                --     levels[ii] = split(levels[ii],"|")
                --     levels[ii] = levels[ii]
                -- end
                A.global.guides[tab][data[2]].levels = levels
            end
        end
        -- == validate materials
        if data[5] then
            local mats = split(data[5], ";")
            if #mats > 0 then
                -- print("mat size " .. #mats)
                local first = true
                for ii = 1, #mats do
                    local mat = split(mats[ii], "=")
                    -- for ii = 1, #mat do
                    --     print(ii, mat[ii])
                    -- end
                    if #mat == 2 then
                        local matID = mat[1]
                        local amount = mat[2]
                        if type(tonumber(amount)) == "number" then
                            local itemName, itemLink = GetItemInfo(matID)
                            local itemID = false
                            if itemLink then
                                itemID = GetItemInfoFromHyperlink(itemLink)
                            end
                            if itemID then
                                -- aprint(itemID, amount)
                                if first then
                                    A.global.guides[tab][data[2]].mats = {}
                                    first = false
                                end
                                A.global.guides[tab][data[2]].mats[itemID] = {amount}
                            end
                        end
                    end
                end
            end
        end
    end
    -- == validate key
    if oldKey then
        if oldKey >= 0 then
            if type(tonumber(data[2])) == "number" then
                -- print(data[2])
                A.global.guides[tab][tonumber(data[2])] = A.global.guides[tab][oldKey]
                A.global.guides[tab][oldKey] = nil
            elseif data[2] == "" then
                A.global.guides[tab][oldKey] = nil
            end
        end
    end
    test_guide = A.global.guides[tab]
    Arch_setGUI(m_name, true)
    Arch_setGUI(m_name, true)
end

draw_block_newCategory = function()
    Arch_guiFrame:Hide()
    insertframe = CreateFrame("frame", nil, nil, 'BackdropTemplate')
    local frameWidth = 210
    local frameHeight = 36
    local fontSize = 12
    local rowHeight = frameHeight
    local iconDimension = frameHeight
    local rowSizeMultiplier = 1.5
    --
    local baseFrameText = "|cff464646 |r"
    --
    local backdropInfo = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 1,
        edgeSize = 1,
        insets = {
            left = -4,
            right = -4,
            top = -4,
            bottom = -4
        }
    }
    insertframe:SetBackdrop(backdropInfo)
    insertframe:SetBackdropColor(0, 0, 0, 0.8)
    insertframe:SetBackdropBorderColor(0, 0, 0, 0)
    insertframe:SetSize(frameWidth, frameHeight) -- 180 50
    insertframe:RegisterForDrag("LeftButton")
    insertframe:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    insertframe:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local a, _, c, x, y = frame:GetPoint();
        -- rcFramePos = {a, c, x, y}
        -- A.global.gui.groupCooldown.position = rcFramePos
    end)
    insertframe:SetFrameStrata("MEDIUM")
    -- for k, v in pairs(frame) do
    --     aprint(k, v)
    -- end
    -- newFrame.closeutton:Hide()
    -- newFrame:ClearAllPoints()
    -- newFrame:SetPoint("CENTER", 0, 0)
    drawEditCategoryBox("", 1, frame, "Enter new guide name:")
    -- :: Acilis ekrani koy
    local frameTextName = insertframe:CreateFontString(nil, "ARTWORK")
    frameTextName:SetFont("Fonts\\FRIZQT__.ttf", fontSize, "OUTLINE")
    frameTextName:SetPoint("CENTER")
    frameTextName:SetText(baseFrameText)
    --
    insertframe:SetPoint("CENTER", 0, 0)
    insertframe:Show()
end

local function drawHead(name, parent)
    local heading = AceGUI:Create('Heading')
    heading:SetText(name)
    heading:SetRelativeWidth(1)
    parent:AddChild(heading)
end

draw_widget_label = function(content, width, parent)
    local editbox = AceGUI:Create("Label")
    editbox:SetText(content)
    editbox:SetRelativeWidth(width)
    parent:AddChild(editbox)
end

draw_widget_editBox = function(content, width, parent, label)
    local widget = AceGUI:Create("EditBox")
    if label then
        widget:SetLabel(label)
    end
    widget:SetText(content)
    widget:SetUserData("key", content)
    -- widget:SetHeight(16)
    widget:SetFullHeight(true)
    widget:SetRelativeWidth(width)
    widget:SetCallback("OnEnterPressed", function(widget, event, text)
        -- :: create editbox
        local d = {}
        local counter = 0
        widget:SetUserData("key", text)
        for children in pairs(parent.children) do
            counter = counter + 1
            for k, v in pairs(parent.children[children].userdata) do
                d[counter] = v
            end
        end
        parent:ReleaseChildren()
        validateGuide(d)
    end)
    parent:AddChild(widget)
end

draw_widget_editBox2 = function(content, width, parent, label)
    local widget = AceGUI:Create("EditBox")
    if label then
        widget:SetLabel(label)
    end
    widget:SetText(content)
    widget:SetUserData("key", content)
    -- widget:SetHeight(16)
    widget:SetFullHeight(true)
    widget:SetRelativeWidth(width)
    widget:SetCallback("OnEnterPressed", function(widget, event, text)
        -- :: create editbox
        local d = {}
        local counter = 0
        local oldKey = widget:GetUserData("key")
        widget:SetUserData("key", text)
        for children in pairs(parent.children) do
            counter = counter + 1
            for k, v in pairs(parent.children[children].userdata) do
                d[counter] = v
            end
        end
        parent:ReleaseChildren()
        validateGuide(d, oldKey)
        Arch_setGUI(m_name, true)
        Arch_setGUI(m_name, true)
        -- drawRow(parent, data[1], data[2], data[3], data[4], true)
    end)
    parent:AddChild(widget)
end

drawEditCategoryBox = function(content, width, parent, label)
    local widget = AceGUI:Create("EditBox")
    if label then
        widget:SetLabel(label)
    end
    widget:SetText(content)
    widget:SetUserData("key", content)
    -- widget:SetHeight(16)
    widget:SetFullHeight(true)
    widget:SetRelativeWidth(width)
    widget:SetCallback("OnEnterPressed", function(widget, event, text)
        -- :: create editbox
        tab = string.lower(text)
        if A.global.guides[tab] == nil then
            A.global.guides[tab] = {}
            table.insert(guide_list, tab)
            insertframe:Hide()
            widget:Release()
            Arch_setGUI(m_name)
        end
    end)
    -- parent:AddChild(widget)
    widget.frame:SetPoint("CENTER", 0, 0)
    widget.frame:SetParent(parent)
    widget.frame:Show()
end

draw_widget_interactiveLabel = function(text, width, parent, isNotHighlighted)
    local widget = AceGUI:Create("InteractiveLabel")
    widget:SetText(text)
    widget:SetUserData("key", text)
    widget:SetRelativeWidth(width)
    -- widget:SetColor(140, 255, 255)
    -- Interface\\Tooltips\\UI-Tooltip-Background
    -- Interface\\DialogFrame\\UI-DialogBox-Background
    -- https://github.com/Gethe/wow-ui-textures
    if not isNotHighlighted then
        widget:SetHighlight("Interface\\Buttons\\UI-Listbox-Highlight")
    end
    parent:AddChild(widget)
    widget:SetCallback("OnEnter", function(widget, event, selection)
    end)
    widget:SetCallback("OnClick", function(widget, event, selection)
        -- :: create editbox
        local data = {}
        local counter = 0
        for children in pairs(parent.children) do
            counter = counter + 1
            for k, v in pairs(parent.children[children].userdata) do
                data[counter] = v
            end
        end
        parent:ReleaseChildren()
        draw_block_editRow(parent, data[1], data[2], data[3], data[4], data[5])
    end)
end

local function drawHeaderRow(parent)
    local row = parent
    draw_widget_label(hCol(""), col_widths[1], row)
    draw_widget_label(hCol("Target"), col_widths[2], row)
    draw_widget_label(hCol("Item Name"), col_widths[3], row)
    draw_widget_label(hCol("Levels"), col_widths[4], row)
    draw_widget_label(hCol("Materials"), col_widths[5], row)
end

draw_block_row = function(parent, c1, c2, c3, c4, c5, b_NotNewRow)
    local row
    if not b_NotNewRow then
        row = AceGUI:Create("SimpleGroup")
        row:SetFullWidth(true)
        row:SetLayout("Flow") -- important!
    else
        row = parent
    end
    draw_widget_interactiveLabel(c1, col_widths[1], row, true)
    draw_widget_interactiveLabel(c2, col_widths[2], row)
    draw_widget_interactiveLabel(c3, col_widths[3], row)
    draw_widget_interactiveLabel(c4, col_widths[4], row)
    draw_widget_interactiveLabel(c5, col_widths[5], row)
    if not b_NotNewRow then
        parent:AddChild(row)
    end
end

draw_block_editRow = function(parent, c1, c2, c3, c4, c5)
    draw_widget_interactiveLabel(c1, col_widths[1], parent, true)
    draw_widget_editBox2(c2, col_widths[2], parent)
    draw_widget_editBox(c3, col_widths[3], parent)
    draw_widget_editBox(c4, col_widths[4], parent)
    draw_widget_editBox(c5, col_widths[5], parent)
end

drawMainFrame = function()
    -- :: reset
    Arch_guiFrame:SetWidth(960)
    Arch_guiFrame:SetHeight(720)
    Arch_guiFrame:ReleaseChildren()
    -- :: set scroll frame
    Arch_guiFrame:SetLayout("Fill") -- Fill will make the first child fill the whole content area
    local frame = AceGUI:Create("ScrollFrame")
    frame:SetLayout("Flow")
    Arch_guiFrame:AddChild(frame)
    -- :: heading | title of module 
    drawHead("Guide Maker", frame)
    -- :: category
    local cats = AceGUI:Create("SimpleGroup")
    cats:SetFullWidth(true)
    cats:SetLayout("Flow") -- important!
    for ii = 1, #guide_list do
        drawButton(pCase(guide_list[ii]), (1 - 0.06) / #guide_list, cats, btnFunction_retrieveGuide)
    end
    drawButton2("+", 0.05, cats, btnFunction_addGuide)
    frame:AddChild(cats)
    -- :: buttons
    local buttons = AceGUI:Create("SimpleGroup")
    buttons:SetFullWidth(true)
    buttons:SetLayout("Flow") -- important!
    drawButton2("Add New Entry", 0.30, buttons, btnFunction_addEntry)
    if tab == nil then
        for ii = 1, #guide_list do
            tab = guide_list[ii]
            break
        end
    end
    if tab == nil then
        do
            return
        end
    end
    drawButton2("Delete " .. pCase(tab), 0.25, buttons, btnFunction_deleteGuide)
    frame:AddChild(buttons)
    -- :: header row
    drawHeaderRow(frame)
    -- :: draw rows
    -- :: 
    local counter = 0
    if test_guide then
        for ii = 1, skillUpLimit do
            if test_guide[ii] then
                counter = counter + 1
                local tar = test_guide[ii]
                -- get levels
                local levels = ""
                for ii = 1, #tar["levels"] do
                    local col
                    if ii == 1 then
                        col = "|cffef8048"
                    elseif ii == 2 then
                        col = "|cffffff25"
                    elseif ii == 3 then
                        col = "|cff5cc85c"
                    elseif ii == 4 then
                        col = "|cff9c9487"
                    end
                    levels = levels .. col .. tar["levels"][ii] .. "|r "
                end
                -- get materials
                local mats = ""
                local lastMatId = 0
                for mat, val in pairs(tar["mats"]) do
                    lastMatId = mat
                end
                --
                --
                for mat, val in pairs(tar["mats"]) do
                    local amount = val[1]
                    if true then -- lastMatId == mat then
                        mats = mats .. mat .. tCol("=") .. fCol(amount) .. tCol(";")
                    else
                        mats = mats .. tCol(mat) .. tCol("=") .. tCol(amount) .. tCol(";")
                    end
                end
                if mats == "" then
                    mats = tCol("MatId_1=amount_1; MatId_2=amount_2; ")
                end
                local c1, c2, c3, c4, c5 = hCol(counter), ii, GetItemInfo(tar["item"]) or tCol("Enter ID or Name"),
                    levels, mats
                draw_block_row(frame, c1, c2, c3, c4, c5)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods
function Arch_guideMaker_GUI()
    drawMainFrame()
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)
    if isEnabled then
        -- :: register
        -- module:RegisterEvent("CHAT_MSG_SYSTEM")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is enabled")
        end
    else
        -- :: deregister
        -- module:UnregisterEvent("CHAT_MSG_SYSTEM")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is disabled")
        end
    end
    if not isSilent then
        isEnabled = not isEnabled
        -- A.global.assist.groupOrganizer.isEnabled = isEnabled
    end
end

local function handleCommand(msg)
    Arch_setGUI(m_name)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
-- function module:PLAYER_REGEN_ENABLED()
--     -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
--     isInCombat = false
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_guideMaker1 = "/gm"
SlashCmdList["guideMaker"] = function(msg)
    -- local link, spellId = GetSpellLink(8799)
    -- link = link:gsub("|", " ")
    -- print(link, text:gsub("|", "||")) 
    -- print(link, type(link))
    -- drawNewCategory()
    handleCommand(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

------------------------------------------------------------------------------------------------------------------------
-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
    toggleModule(true)
end
A:RegisterModule(module:GetName(), InitializeCallback)
