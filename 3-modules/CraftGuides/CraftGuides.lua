------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'CraftGuides';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - [x] item in zorluk seviyesini cekmeyi ogren 
    - [x] Bupdate frame on craft
    - [x] 31.10.2022 frame position hatirla
    - [x] 31.10.2022 table view
    - [x] 31.10.2022 calculate and 
    - [x] 31.10.2022 buy resource list
    - [x] 31.10.2022 buy list yap
    - [c] 31.10.2022 tab ile guide/list change
    - [x] 31.10.2022 widgetlari fonksiyon yapip tek satirda yerlestir
    - [x] 31.10.2022 adding tab to gui
    - [x] 01.11.2022 resource list profession levela gore calculator
    - [x] 01.11.2022 resource list player levela gore calculator
    - [x] 01.11.2022 database i zorluk seviyelerine gore multiplerlarla duzenle
    - [x] 01.11.2022 alisveris listesi ekle 
    - [c] 02.11.2022 raw material conversions -> bolt to cloth
    - [x] 02.11.2022 farkli professionlar icin duzenle
    - [x] 02.11.2022 craft section calculator duzenle
    ]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[
        - Guide addon and material calculator for efficient profession grinding.
            - Calculates adaptive material requirements for your level
            - Suggests item to create to progress on crafting profession        
        ]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
-- :: professions
local tai = "Tailoring"
local eng = "Engineering"

-- :: localization (language) --
local locale = GetLocale()
if locale == "deDE" then
    tai = "Schneiderei"
    eng = "Ingenieuerskunst"
end

-- :: frame position variable
local guideFramePos
-- :: edit
local profession = nil
local guide_Assoc = {
    [tai] = Arch_guide_tailor,
    [eng] = Arch_guide_engineer
}
local guide = nil
-- :: edit
local currentLevel = 0
local targetLevel = nil
local targetItem = nil
local targetData = nil

local tabMode = nil
local drawMainFrame = nil
local drawSectionResourceList = nil
local drawSectionGuide = nil
local drawBtn = nil
local drawLbl = nil
local drawRepeat = nil
local adaptResourceList = nil

local profLimitByLevel = 0
-- :: orange, yellow, green profession contribution multipliers 1, 1, 1.35, 4
local multipliers = {1, 1, 1.35, 4}

-- :: calculated resource list
local adaptedList = {}
local resourceList = {}
-- :: icons
local iconBag = GetItemIcon(4500)
local iconBank = GetItemIcon(45986)
iconBag = "|T" .. iconBag .. ":0|t"
iconBank = "|T" .. iconBank .. ":0|t"

-- :: used by adaptResourceList
local prevItemTargetLevel = 0
------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
-- :: lua table i sorted olmadigi icin soted sekilde kullanmak icin custom fonksiyon
-- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a, b)
            return order(t, a, b)
        end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local function calcProfLimitByLevel()
    local playerLevel = UnitLevel('player')
    local maxProfession = {
        [5] = 75,
        [10] = 150,
        [20] = 225,
        [35] = 300,
        [65] = 375,
        [75] = 450
    }
    -- 
    for level, profLimit in spairs(maxProfession) do
        if playerLevel > level or true then
            profLimitByLevel = profLimit
        end
    end
end

local function learnCurrentLevel()
    for ii = 1, GetNumSkillLines() do
        local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable,
            stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(ii)
        if skillName == profession then
            currentLevel = skillRank
            -- print(skillName, skillRank)
        end
    end
end

local function selectTargetLevel()
    table.sort(guide)
    learnCurrentLevel()
    for k, v in spairs(guide) do
        if k > currentLevel then
            targetLevel = k
            targetData = guide[k]
            _, targetItem = GetItemInfo(targetData['item'])
            -- print("current target is " .. k)
            break
        end
    end
end

local function round(number)
    if (number - (number % 0.1)) - (number - (number % 1)) < 0.5 then
        number = number - (number % 1)
    else
        number = (number - (number % 1)) + 1
    end
    return number
end

local function calcTotalMaterial(matId, amount, prev, next, levels)
    local stepLimit = 0
    local calcUpLimit
    local calcDownLimit = prev
    local size
    local total = 0
    for ii, level in ipairs(levels) do
        stepLimit = stepLimit + 1
        if calcDownLimit < next and calcDownLimit < level then -- calcDownLimit < currentLevel and
            -- :: find which level range to calculate
            calcUpLimit = level
            if calcUpLimit > next then
                calcUpLimit = next
            end
            -- :: calculate size of craft ex. 45 to 50 = 5
            size = calcUpLimit - calcDownLimit
            -- :: add to total with multiplier
            if size > 0 then
                total = total + (round(amount * (size * multipliers[stepLimit])))
            end
            calcDownLimit = calcUpLimit
        end
    end
    return total
end

local function calcTotalDiffMaterial(matId, amount, prev, next, levels)
    -- print(profession)
    learnCurrentLevel()
    local stepLimit = 0
    local calcUpLimit
    local calcDownLimit = prev
    local size = 0
    local total = 0
    for ii, level in pairs(levels) do
        -- print("level ".. level)
        stepLimit = stepLimit + 1
        if calcDownLimit < next and calcDownLimit < level then -- calcDownLimit < currentLevel and
            -- :: find which level range to calculate
            calcUpLimit = level
            if calcUpLimit > next then
                calcUpLimit = next
            end
            if calcUpLimit > currentLevel then
                calcUpLimit = currentLevel
            end
            -- :: calculate size of craft ex. 45 to 50 = 5
            size = calcUpLimit - calcDownLimit
            -- print("downlimit ", calcDownLimit, " uplimit ", calcUpLimit, "size ", size)
            -- :: add to total with multiplier
            -- print(size, " ", type(size), (size > 0))
            if size > 0 then
                total = total + (round(amount * (size * multipliers[stepLimit])))
            end
            calcDownLimit = calcUpLimit
        end
    end
    return total
end

local function createResourceList()
    calcProfLimitByLevel()
    resourceList = {}
    prevItemTargetLevel = 0
    for level, dataItem in spairs(guide) do
        if profLimitByLevel > level then
            for mat, matData in spairs(dataItem['mats']) do
                if resourceList[mat] == nil then
                    resourceList[mat] = {0, 0}
                end
                if resourceList[mat] ~= nil then
                    resourceList[mat][1] = resourceList[mat][1] +
                                               calcTotalMaterial(mat, matData[1], prevItemTargetLevel, level,
                            dataItem['levels'])
                end
            end
            prevItemTargetLevel = level
        end
    end
end

local function calcMatAmount(amount)
    local difference = 1 -- targetLevel - currentLevel
    local multiplier = 1
    return difference * multiplier * amount
end

-- :: ace one line arguments
local function drawHead(name, parent)
    local heading = AceGUI:Create('Heading')
    heading:SetText(name)
    heading:SetRelativeWidth(1)
    parent:AddChild(heading)
end

local function setFramePos()
    local a, b, c, d, e = Arch_guiFrame:GetPoint()
    A.global.guideFrame = {a, c, d, e}
end

local function drawBtn(name, width, parent)
    local btn = AceGUI:Create("Button")
    btn:SetText(name)
    -- btn:SetValue(name)
    btn:SetRelativeWidth(width)
    btn:SetCallback("OnClick", function(self, value)
        setFramePos()
        adaptResourceList()
        if name == "Material List" then
            tabMode = "resource"
            drawRepeat()
        elseif name == "Craft Guide" then
            tabMode = "craft"
            drawRepeat()
        end
    end)
    parent:AddChild(btn)
end

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

adaptResourceList = function()
    -- :: itemlari listeye cek
    -- for step, item in spairs(Arch_guide_tailor_resources) do
    --     if step > currentLevel then
    --         adaptedList = deepcopy(Arch_guide_tailor_resources[step])
    --         break
    --     end
    -- end
    -- for k, v in pairs(resourceList) do
    --     for j,h in pairs(v)    do
    --     print(j, " ", h)
    --     end
    -- end
    -- do return end
    -- :: adapted resource list
    createResourceList()
    adaptedList = deepcopy(resourceList)
    -- :: select profession level 300, 350, 440
    prevItemTargetLevel = 0
    for itemTargetLevel, dataItem in spairs(guide) do
        -- :: select item to create
        -- if itemTargetLevel < currentLevel then
        -- :: for each material
        for mat, dataMat in spairs(dataItem['mats']) do
            if adaptedList[mat] then
                -- print(profession)
                local removed = calcTotalDiffMaterial(mat, dataMat[1], prevItemTargetLevel, itemTargetLevel,
                    dataItem['levels'])
                adaptedList[mat][1] = adaptedList[mat][1] - removed
                if adaptedList[mat][1] == 0 then
                    table.remove(adaptedList, mat)
                end
            end
        end
        -- end
        prevItemTargetLevel = itemTargetLevel
    end
    -- prevItemTargetLevel = 0
    -- -- :: conversions
    -- for mat, matData in spairs(adaptedList) do
    --     if conversion[mat] then
    --         local amount = conversion[mat][2]
    --         local t1Material = conversion[mat][1]
    --         local t2Material = mat
    --         adaptedList[t1Material][1] = adaptedList[t1Material][1] + (adaptedList[t2Material][1] * amount)
    --         adaptedList[t2Material][1] = 0
    --     end
    -- end
end

drawLbl = function(content, width, parent)
    local editbox = AceGUI:Create("Label")
    editbox:SetText(content)
    editbox:SetRelativeWidth(width)
    parent:AddChild(editbox)
end

drawSectionResourceList = function()
    adaptResourceList()
    -- ::  heading
    local heading = AceGUI:Create('Heading')
    heading:SetText('Material List')
    heading:SetRelativeWidth(1)
    Arch_guiFrame:AddChild(heading)
    -- :: adding target text
    drawLbl(Arch_trivialColor("Have"), 0.15, Arch_guiFrame)
    -- :: adding target text
    drawLbl(Arch_trivialColor("Need (±)"), 0.15, Arch_guiFrame)
    -- :: adding target text
    drawLbl(Arch_trivialColor("Diff"), 0.15, Arch_guiFrame)
    -- :: adding target text
    drawLbl(Arch_trivialColor("Material"), 0.5, Arch_guiFrame)
    -- :: material
    local artikel = 0
    for item, data in spairs(adaptedList) do
        local countBags = GetItemCount(item)
        local countTotal = GetItemCount(item, true)
        local have = countBags .. " (" .. countTotal .. ")"
        local miss = data[1] + data[2] - countTotal
        local need = data[1] -- .. " ± " .. data[2]
        if need > 0 then
            artikel = artikel + 1
            if artikel <= 16 then
                -- :: how many items have
                drawLbl(have, 0.15, Arch_guiFrame)
                -- :: adding target text
                drawLbl(need, 0.15, Arch_guiFrame)
                -- :: adding target text
                if miss <= 0 then
                    miss = Arch_trivialColor(0)
                else
                    miss = Arch_focusColor(miss)
                end
                drawLbl(miss, 0.15, Arch_guiFrame)
                -- :: adding target text
                drawLbl(select(2, GetItemInfo(item)), 0.5, Arch_guiFrame)
            end
        else
            -- -- :: how many items have
            -- local have = countBags .. " (" .. countTotal .. ")"
            -- drawLbl(Arch_trivialColor(have), 0.15, Arch_guiFrame)
            -- -- :: adding target text
            -- local need = data[1] --.. " ± " .. data[2]
            -- drawLbl(Arch_trivialColor(need), 0.15, Arch_guiFrame)
            -- -- :: adding target text
            -- if miss <= 0 then
            --     miss = Arch_trivialColor("None")
            -- else
            --     miss = Arch_focusColor(Arch_trivialColor(miss))
            -- end
            -- drawLbl(Arch_trivialColor(miss), 0.15, Arch_guiFrame)
            -- -- :: adding target text
            -- drawLbl(Arch_trivialColor(GetItemInfo(item)), 0.5, Arch_guiFrame)
        end
    end
end

drawSectionGuide = function()
    -- :: select text
    selectTargetLevel()
    -- :: defesnive
    if targetData == nil then
        do
            return
        end
    end
    -- :: header
    local heading = AceGUI:Create('Heading')
    heading:SetText('Crafting Guides')
    heading:SetRelativeWidth(1)
    Arch_guiFrame:AddChild(heading)
    -- :: adding target text
    local editbox = AceGUI:Create("Label")
    if targetItem then
        editbox:SetText(Arch_trivialColor("| Craft \n") .. targetItem .. "\n\n")
    else
        editbox:SetText(Arch_trivialColor("| Craft \n") .. "Skip to next item" .. "\n\n")
    end
    editbox:SetRelativeWidth(0.7)
    Arch_guiFrame:AddChild(editbox)
    -- :: adding target text
    local editbox = AceGUI:Create("Label")
    editbox:SetText(Arch_trivialColor("| Materials"))
    editbox:SetRelativeWidth(0.9)
    Arch_guiFrame:AddChild(editbox)
    -- :: adding target text
    local editbox = AceGUI:Create("Label")
    editbox:SetText(Arch_trivialColor("Have"))
    editbox:SetRelativeWidth(0.22)
    Arch_guiFrame:AddChild(editbox)
    -- :: adding target text
    local editbox = AceGUI:Create("Label")
    editbox:SetText(Arch_trivialColor("Need (1)"))
    editbox:SetRelativeWidth(0.22)
    Arch_guiFrame:AddChild(editbox)
    -- -- :: adding target text
    -- local editbox = AceGUI:Create("Label")
    -- editbox:SetText(Arch_trivialColor("Miss"))
    -- editbox:SetRelativeWidth(0.15)
    -- Arch_guiFrame:AddChild(editbox)
    -- :: adding target text
    local editbox = AceGUI:Create("Label")
    editbox:SetText(Arch_trivialColor("Material"))
    editbox:SetRelativeWidth(0.5)
    Arch_guiFrame:AddChild(editbox)
    -- :: material
    for k, v in pairs(targetData['mats']) do
        local countBags = GetItemCount(k)
        local countTotal = GetItemCount(k, true)
        -- :: how many items have
        local have = countBags .. " (" .. countTotal .. ")"
        local labelbox = AceGUI:Create("Label")
        labelbox:SetText(have)
        labelbox:SetRelativeWidth(0.22)
        Arch_guiFrame:AddChild(labelbox)
        -- :: parametric need text
        local need = calcMatAmount(v[1])
        local labelbox = AceGUI:Create("Label")
        labelbox:SetText(need)
        labelbox:SetRelativeWidth(0.22)
        Arch_guiFrame:AddChild(labelbox)
        -- :: adding target text
        local miss = calcMatAmount(v[1]) - countTotal
        if miss <= 0 then
            miss = Arch_trivialColor("None")
        else
            miss = Arch_focusColor(miss)
        end
        -- local labelbox = AceGUI:Create("Label")
        -- labelbox:SetText(miss)
        -- labelbox:SetRelativeWidth(0.15)
        -- Arch_guiFrame:AddChild(labelbox)
        -- :: adding target text
        local editbox = AceGUI:Create("Label")
        editbox:SetText(select(2, GetItemInfo(k)))
        editbox:SetRelativeWidth(0.5)
        Arch_guiFrame:AddChild(editbox)
    end
end

drawMainFrame = function()
    -- :: create frame
    Arch_guiFrame:SetWidth(440)
    Arch_guiFrame:SetHeight(420)
    Arch_guiFrame:ClearAllPoints()
    -- :: remembering the position of frame
    guideFramePos = A.global.guideFrame
    if A.global.guideFrame == {} then
        Arch_guiFrame:SetPoint("CENTER", 0, 0)
    else
        Arch_guiFrame:SetPoint(guideFramePos[1], guideFramePos[3], guideFramePos[4])
    end
    Arch_guiFrame:ReleaseChildren()
    -- :: heading 
    drawHead("Crafting Assistant", Arch_guiFrame)
    -- :: guide selector
    local dd = AceGUI:Create('Dropdown')
    local guideType = {
        [tai] = tai,
        [eng] = eng
    }
    dd:SetList(guideType)
    dd:SetValue(A.global.selectedGuide)
    dd:SetFullWidth(true)
    dd:SetCallback("OnValueChanged", function(widget, event, selection)
        setFramePos()
        if guide_Assoc[selection] then
            A.global.selectedGuide = selection
            profession = selection
            guide = guide_Assoc[selection]
            selectTargetLevel()
            adaptResourceList()
            drawRepeat()
        end
    end)
    Arch_guiFrame:AddChild(dd)
    -- :: draw tabs
    drawBtn("Material List", 0.5, Arch_guiFrame)
    drawBtn("Craft Guide", 0.5, Arch_guiFrame)
end

drawRepeat = function()
    drawMainFrame()
    if tabMode == "resource" then
        drawSectionResourceList()
    else
        drawSectionGuide()
    end
end
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

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- :: position
    if not A.global.guideFrame then
        A.global.guideFrame = {"CENTER", "CENTER", 0, 0}
    end
    if not A.global.selectedGuide then
        A.global.selectedGuide = tai
    end
    if not profession then
        profession = A.global.selectedGuide
    end
    A.global.selectedGuide = tai
    -- :: apply guide
    if guide_Assoc[A.global.selectedGuide] then
        guide = guide_Assoc[A.global.selectedGuide]
    end
    -- :: simdiki leveli belirle
    selectTargetLevel()
    -- module:RegisterEvent("PLAYER_REGEN_ENABLED")
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods
function Arch_craftGuidesGUI()
    drawMainFrame()
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function main(msg)
    Arch_setGUI(moduleName)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
function module:TRADE_SKILL_UPDATE()
    local newSkill = currentLevel
    learnCurrentLevel()
    if currentLevel > newSkill then
        if targetData ~= nil then
            Arch_setGUI(moduleName, true)
            if tabMode == "resource" then
                drawSectionResourceList()
            else
                drawSectionGuide()
            end
        end
    end
end

function module:BAG_UPDATE()
    module:TRADE_SKILL_UPDATE()
end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_cra1 = "/cra" -- todo change the key later
SlashCmdList["cra"] = function(msg)
    main(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

------------------------------------------------------------------------------------------------------------------------
-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
    module:RegisterEvent("TRADE_SKILL_UPDATE")
    -- module:RegisterEvent("BAG_UPDATE")
end
A:RegisterModule(module:GetName(), InitializeCallback)
