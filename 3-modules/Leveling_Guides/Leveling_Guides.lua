------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "LevelingGuides", "Leveling Guides";
local group = "guide";
local module = A:GetModule(m_name, true);
local moduleAlert = M .. m_name2 .. ": |r";
local mprint = function(msg)
    print(moduleAlert .. msg)
end
local aprint = Arch_print
if module == nil then
    return
end
local guide = Arch_levelingGuide

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------

-- use case ------------------------------------------------------------------------------------------------------------
--[[
    - quest databaseden alarak quest yapmak icin step by step yonergeler sunuyor
    - temel komutlar: 
        - accept:       gorev kabul etme
        - go:           belli bir konuma git
        - complete:     gorev teslim etme
        - do:           gorevi yap

    - gui
        - gui pozisyonu | position
        - acik mi kapali mi hatirlama | isOpen
        - kilitli mi degil mi | isLocked
        - size size
]]

-- blackboard ------------------------------------------------------------------------------------------------------------
--[[
    - frame information
        - level range
        - zone, chapter (sigmazsa alt satira)
        - current quest
        - description

    - quest id
            - coordinates
            - description
]]

-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - hover glow on close and lock icons
    - functionality for close and lock icons
    - remember frame position
    - simple frame with close icon
]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = true
-- :: global Functions
local fCol = Arch_focusColor
local cCol = Arch_commandColor
local mCol = Arch_moduleColor
local tCol = Arch_trivialColor
local classCol = Arch_classColor
local realmName = GetRealmName()
local split = Arch_split

local mainFrame
local defaultFrameSize = {280, 160}
local defaultFramePos = {"CENTER", 0, 0}

-- :: function def
local createFrame
local toggleFrame
local shiftLockButton
local setGuide

-- :: palyer
local completedQuestsList = GetQuestsCompleted()

-- ::
local textPosition = -18
local textPositionShift = -14
local textIndent = 6

local rangeText
local zoneText
local chapterText
local stepText
local questText
local descText

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
    -- :: gui
    if A.global.gui == nil then
        A.global.gui = {}
    end
    if A.global.gui[m_name] == nil then
        A.global.gui[m_name] = {}
    end
    if A.global.gui[m_name].isOpen == nil then
        A.global.gui[m_name].isOpen = false
    end
    if A.global.gui[m_name].isLocked == nil then
        A.global.gui[m_name].isLocked = false
    end
    if A.global.gui[m_name].position == nil then
        A.global.gui[m_name].position = defaultFramePos
    end
    if A.global.gui[m_name].size == nil then
        A.global.gui[m_name].size = defaultFrameSize
    end
    -- :: createFrame
    -- createFrame()
    -- toggleFrame()
    -- setGuide()
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
-- https://www.youtube.com/watch?v=0Z3b0SJuvI0
-- https://www.wowinterface.com/forums/showthread.php?t=48862
-- https://wowwiki-archive.fandom.com/wiki/Making_Draggable_Frames
-- https://wowwiki-archive.fandom.com/wiki/Widget_handlers

toggleFrame = function()
    if A.global.gui[m_name].isOpen then
        mainFrame:Show()
    else
        mainFrame:Hide()
    end
end

-- local function presentStepText(text, x, y, color, variable)
--     rangeText:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
--     rangeText:SetPoint("TOPLEFT", mainFrame, x, y)
--     rangeText:SetText(tCol(text))
--     textPosition = textPosition + textPositionShift
-- end

local function tomtom(x, y, desc)
    TomTom:AddWaypointToCurrentZone(x, y, desc)
end

createFrame = function()
    mainFrame = CreateFrame("Frame", "Archrist_LevelingGuide", UIParent, "BackdropTemplate") -- CreateFrame("frameType"[, "frameName"[, parentFrame[, "inheritsFrame"]]]);
    -- BackdropTemplate
    -- GameTooltipTemplate
    -- f:SetWidth(128) -- Set these to whatever height/width is needed 
    -- f:SetHeight(64) -- for your Texture

    -- local t = f:CreateTexture(nil,"BACKGROUND")
    -- t:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions.blp")
    -- t:SetAllPoints(f)
    -- f.texture = t
    local backdropInfo = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 64,
        edgeSize = 4
        -- insets = {
        --     left = -4,
        --     right = -4,
        --     top = -4,
        --     bottom = -4
        -- }
    }

    mainFrame:SetBackdrop(backdropInfo)
    mainFrame:SetBackdropColor(0, 0, 0, 0.8)
    mainFrame:SetBackdropBorderColor(0, 0, 0, 0.9)
    mainFrame:SetFrameStrata("MEDIUM")
    local s = A.global.gui[m_name].size
    mainFrame:SetSize(s[1], s[2])
    -- mainFrame:SetMinResize(120, 80)
    -- mainFrame:SetMaxResize(400, 400)
    local p = A.global.gui[m_name].position
    mainFrame:SetPoint(p[1], p[2], p[3])

    mainFrame:SetMovable(true)
    mainFrame:SetResizable(true)
    mainFrame:EnableMouse(true)
    -- mainFrame:EnableMouse(true)

    -- :: Resizing --------------------
    local resizeButton = CreateFrame("Button", nil, mainFrame)
    resizeButton:SetSize(16, 16)
    resizeButton:SetPoint("BOTTOMRIGHT")
    resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resizeButton:SetScript("OnMouseDown", function(self, button)
        mainFrame:StartSizing("BOTTOMRIGHT")
        mainFrame:SetUserPlaced(true)
    end)

    resizeButton:SetScript("OnMouseUp", function(self, button)
        mainFrame:StopMovingOrSizing()
        local w, h = mainFrame:GetSize()
        A.global.gui[m_name].size = {w, h}
    end)

    -- :: Dragging --------------------
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", function(self)
        if not A.global.gui[m_name].isLocked then
            self:StartMoving()
        end
    end)
    mainFrame:SetScript("OnDragStop", function(self)
        if not A.global.gui[m_name].isLocked then
            self:StopMovingOrSizing()
        end
        local a, b, c, x, y = mainFrame:GetPoint();
        A.global.gui[m_name].position = {a, x, y}
    end)

    -- :: title
    local frameTextName = mainFrame:CreateFontString(nil, "ARTWORK")
    frameTextName:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    frameTextName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 0)
    frameTextName:SetText(tCol(tCol("Archrist Leveling Guide")))
    frameTextName:Hide()

    -- :: close button
    local closeFrame = CreateFrame("Frame", nil, mainFrame) -- CreateFrame("frameType"[, "frameName"[, parentFrame[, "inheritsFrame"]]]);
    closeFrame:SetSize(14, 14)
    closeFrame:SetPoint("TOPRIGHT", 0, 0)
    closeFrame:Show()
    --
    local closeButton = closeFrame:CreateFontString(nil, "ARTWORK")
    closeButton:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE")
    closeButton:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 0, 0)
    closeButton:SetText(tCol("×"))
    closeButton:Hide()
    --
    closeFrame:SetScript("OnEnter", function(self)
        closeButton:SetText("×")
        closeButton:Show()
    end)
    closeFrame:SetScript("OnLeave", function(self)
        closeButton:SetText(tCol("×"))
        closeButton:Hide()
    end)
    closeFrame:SetScript("OnMouseDown", function(self)
        A.global.gui[m_name].isOpen = not A.global.gui[m_name].isOpen
        mainFrame:Hide()
    end)

    -- :: lock button
    local lockText = "lock"
    local lockFrame = CreateFrame("Frame", nil, mainFrame) -- CreateFrame("frameType"[, "frameName"[, parentFrame[, "inheritsFrame"]]]);
    lockFrame:SetSize(28, 11)
    lockFrame:SetPoint("BOTTOMRIGHT", -16, 2)
    --
    local lockButton = mainFrame:CreateFontString(nil, "ARTWORK")
    lockButton:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    lockButton:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -16, 2)
    lockButton:SetText(tCol(lockText))
    --
    lockFrame:SetScript("OnEnter", function(self)
        lockButton:SetText(lockText)
        lockButton:Show()
    end)
    lockFrame:SetScript("OnLeave", function(self)
        lockButton:SetText(tCol(lockText))
        lockButton:Hide()
    end)
    lockFrame:SetScript("OnMouseDown", function(self)
        A.global.gui[m_name].isLocked = not A.global.gui[m_name].isLocked
        shiftLockButton()
    end)

    -- :: unlock button
    local unlockText = "unlock"
    local unlockFrame = CreateFrame("Frame", nil, mainFrame) -- CreateFrame("frameType"[, "frameName"[, parentFrame[, "inheritsFrame"]]]);
    unlockFrame:SetSize(32, 11)
    unlockFrame:SetPoint("BOTTOMRIGHT", 0, 2)
    --
    local unlockButton = mainFrame:CreateFontString(nil, "ARTWORK")
    unlockButton:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    unlockButton:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", 0, 2)
    unlockButton:SetText(tCol(unlockText))
    --
    unlockFrame:SetScript("OnEnter", function(self)
        unlockButton:SetText(unlockText)
        unlockButton:Show()

    end)
    unlockFrame:SetScript("OnLeave", function(self)
        unlockButton:SetText(tCol(unlockText))
        unlockButton:Hide()
    end)
    unlockFrame:SetScript("OnMouseDown", function(self)
        A.global.gui[m_name].isLocked = not A.global.gui[m_name].isLocked
        shiftLockButton()
    end)
    --
    shiftLockButton = function()
        if not A.global.gui[m_name].isLocked then
            mainFrame:SetMovable(true)
            resizeButton:Show()
            lockFrame:Show()
            lockButton:Show()
            unlockFrame:Hide()
            unlockButton:Hide()
        else
            mainFrame:SetMovable(false)
            resizeButton:Hide()
            lockFrame:Hide()
            lockButton:Hide()
            unlockFrame:Show()
            unlockButton:Show()
        end
    end
    shiftLockButton()
    -- :: mainFrame
    mainFrame:SetScript("OnEnter", function(self)
        closeButton:Show()
        frameTextName:Show()
        if not A.global.gui[m_name].isLocked then
            lockButton:Show()
        else
            unlockButton:Show()
        end
    end)
    mainFrame:SetScript("OnLeave", function(self)
        closeButton:Hide()
        frameTextName:Hide()
        if not A.global.gui[m_name].isLocked then
            lockButton:Hide()
        else
            unlockButton:Hide()
        end
    end)

    --
    local range = "x to y"
    local zone = "Zone Name"
    local chapter = "Chapter i: Chapter Name"
    local step = "a"
    local maxStep = "b"
    local quest = "Quest: |cffcc9933" .. "Quest Name|r"
    local desc = "Description: Description of what to do"
    -- 
    rangeText = mainFrame:CreateFontString(nil, "ARTWORK")
    rangeText:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    rangeText:SetPoint("TOPLEFT", mainFrame, textIndent, textPosition)
    rangeText:SetText(tCol(range))
    textPosition = textPosition + textPositionShift

    zoneText = mainFrame:CreateFontString(nil, "ARTWORK")
    zoneText:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    zoneText:SetPoint("TOPLEFT", mainFrame, textIndent, textPosition)
    zoneText:SetText(tCol(zone))
    textPosition = textPosition + textPositionShift

    chapterText = mainFrame:CreateFontString(nil, "ARTWORK")
    chapterText:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    chapterText:SetPoint("TOPLEFT", mainFrame, textIndent, textPosition)
    chapterText:SetText(tCol(chapter))
    textPosition = textPosition + textPositionShift

    stepText = mainFrame:CreateFontString(nil, "ARTWORK")
    stepText:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    stepText:SetPoint("TOPLEFT", mainFrame, textIndent, textPosition)
    stepText:SetText(tCol(step .. " of " .. maxStep))
    textPosition = textPosition + textPositionShift

    questText = mainFrame:CreateFontString(nil, "ARTWORK")
    questText:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    questText:SetPoint("TOPLEFT", mainFrame, textIndent, textPosition)
    questText:SetText(tCol(quest))
    textPosition = textPosition + textPositionShift

    descText = mainFrame:CreateFontString(nil, "ARTWORK")
    descText:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")
    descText:SetPoint("TOPLEFT", mainFrame, textIndent, textPosition)
    descText:SetText(tCol(desc))
    textPosition = textPosition + textPositionShift

    -- local button = CreateFrame("Button", "next", mainFrame, "UIPanelButtonTempalte")
    -- local button = CreateFrame("Button", "next", mainFrame, "OptionsButtonTemplate")
    -- local button = CreateFrame("Button", "next", mainFrame, "OptionsFrameTabButtonTemplate")
    -- local button = CreateFrame("Button", "next", mainFrame, "UIDropDownMenuButtonTemplate")
    -- local button = CreateFrame("Button", "next", mainFrame, "GameMenuButtonTemplate")
    -- local button = CreateFrame("Button", "next", mainFrame, "UIPanelCloseButton")
    local rightButton = CreateFrame("Button", "next", mainFrame, "UIPanelButtonGrayTemplate")
    rightButton:SetText(">")
    rightButton:SetPoint("TOPRIGHT", -4, -18)
    rightButton:SetSize(16,16)
    rightButton:Show()

    local leftButton = CreateFrame("Button", "next", mainFrame, "UIPanelButtonGrayTemplate")
    leftButton:SetText("<")
    leftButton:SetPoint("TOPRIGHT", -22, -18)
    leftButton:SetSize(16,16)
    leftButton:Show()
    -- 
    -- GetQuestLink(13109)
    -- C_QuestLog.GetQuestInfo(13109)
    -- IsUnitOnQuest(questIndex, "unit") - Determine if the specified unit is on the given quest.
    -- for k, v in pairs({GetQuestsCompleted()}) do
    --         print(k, v)
    --         -- tinsert(QuestIDs, k)
    -- end

    -- desc = completedQuestsList[9973] 
    --

    -- for ra in pairs(guide) do
    --     -- jump1
    --     local range = split(range, "-")
    --     aprint(range[1], range[2])
    --     -- :: level Check
    --     -- :: zone select
    --     -- :: chapter 1 
    --     if  UnitLevel("player") >= tonumber(r[1]) then--and UnitLevel("player") < tonumber(r[2]) then
    --         for zo in pairs(guide[ra]) do

    --         end
    --     end
    -- end 
    -- TomTom:AddWaypointToCurrentZone(48, 43, "guide")

    -- presentStepText(range, textIndent, textPosition, rangeText)
    -- presentStepText(zone, textIndent, textPosition, zoneText)
    -- presentStepText(chapter, textIndent, textPosition, chapterText)
    -- presentStepText("Step: " .. step .. " of " .. maxStep, textIndent, textPosition, stepText)
    -- presentStepText(quest, textIndent, textPosition, questText)
    -- presentStepText(desc, textIndent, textPosition, descText)

    -- :: set frame state 
    -- A.global.gui[m_name].isOpen = true
end

setGuide = function()
    local questline = guide["1-10"]["Elwynn Forest"]["chapters"][1]["steps"]
    local x, y
    local desc
    local steps
    for s in ipairs(questline) do
        steps = s
    end
    for s, data in ipairs(questline) do
        -- get quest if completed go next
        if completedQuestsList[data["quest"]] == nil then
            if data.task == "accept" and GetQuestLink(data.quest) then
            else
                -- print(GetQuestLink())
                questText:SetText("Quest: " .. data["questName"])
                stepText:SetText(s .. " of " .. steps)
                descText:SetText(data.desc)
                x = data.coords.x
                y = data.coords.y
                desc = data.desc
                break
            end
        else 
            aprint("ÿou have completed " .. data.questName)
        end
    end
    if x and y and desc then
        -- todo kontrol: bulundugun harita ile guide zone ayni mi
        tomtom(x, y, desc)
    else
        aprint("Not any coordinates given for next step")
    end

end
-- createFrame()

-- local seconds = 10
-- local total = 0
-- FrameTestFrame:SetScript("OnUpdate", function(self, elapsed)
--   total = total + elapsed
-- 	if total > seconds then
-- 		self:SetScript("OnUpdate", nil)
-- 	end
-- 	local sides = 100 + (100 * (total / seconds))
-- 	self:SetSize(100, 100)
-- end)
-- FrameTestFrame:Show()
-- print(FrameTestFrame)
------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)
    if isEnabled then
        -- :: register
        module:RegisterEvent("CHAT_MSG_SYSTEM")
        module:RegisterEvent("QUEST_LOG_UPDATE")

        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is enabled")
        end
    else
        -- :: deregister
        module:UnregisterEvent("CHAT_MSG_SYSTEM")
        module:uNRegisterEvent("QUEST_LOG_UPDATE")
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
    local par
    if msg then
        par = split(msg, " ")
    end
    -- print(par[1])
    if par[1] == "reset" then
        A.global.gui[m_name].size = defaultFrameSize
        A.global.gui[m_name].position = defaultFramePos
        A.global.gui[m_name].isLocked = false
    elseif par[1] == "test" then
        setGuide()
    end
    if  par[1] == nil  then
        A.global.gui[m_name].isOpen = not A.global.gui[m_name].isOpen
        toggleFrame()
    end
end

function module:handleCommand(msg)
    handleCommand(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
function module:CHAT_MSG_SYSTEM(_, arg1)
    if string.find(arg1, "Quest accepted:") then
        setGuide()
    elseif string.find(arg1, "completed.") then
        setGuide()
    end
end

function module:QUEST_LOG_UPDATE()
    aprint('test')
end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_levelingGuides1 = "/lg"
SlashCmdList["levelingGuides"] = function(msg)
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
    -- toggleModule(true)
end
A:RegisterModule(module:GetName(), InitializeCallback)
