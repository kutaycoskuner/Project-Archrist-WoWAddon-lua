------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "VoA", "Voult of Archavon";
local group = "assist";
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
    ]]

-- blackboard ------------------------------------------------------------------------------------------------------------
--[[
    constraints:
        - eger feral tank varsa feral mdps alamiyorsun
]]

-- todo ----------------------------------------------------------------------------------------------------------------
--[[
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
local spairs = Arch_sortedPairs
local realmName = GetRealmName()

local framePos

-- local diverseRaid = {
--     {["Tank"] = {
--         ["Tank I"] = "tank", 
--         ["Tank II"] = "tank"}
--     }, {
--         ["Heal"] = {
--             ["Paladin"] = "hpal",
--             ["Druid"] = "druid",
--             ["Priest"] = "priest",
--             ["Shaman"] = "shaman"

--         }
--     }, {
--         ["MDPS"] = {
--             ["Warrior"] = "warrior",
--             ["Paladin"] = "retri",
--             ["Death Knight"] = "dk",
--             ["Rogue"] = "rog",
--             ["Enhancement"] = "enh",
--             ["Feral"] = "feral"
--         }
--     }, {
--         ["RDPS"] = {
--             ["Mage"] = "mage",
--             ["Warlock"] = "lock",
--             ["Hunter"] = "hunt",
--             ["Elemental"] = "ele",
--             ["Balance"] = "bala",
--             ["Shadow"] = "shadow"
--         }
--     }
-- }

local dr = {
    -- RaidRole = {key = {value, short version for text}}
    ["tank"] = {
        ["paladin"] = {false, "pala"},
        ["death knight"] = {false, "dk"},
        ["warrior"] = {false, "war"},
        ["druid"] = {false, "bear"}
    },
    ["heal"] = {
        ["paladin"] = {false, "pal"},
        ["druid"] = {false, "druid"},
        ["priest"] = {false, "priest"},
        ["shaman"] = {false, "shaman"}
    },
    ["mdps"] = {
        ["warrior"] = {false, "war"},
        ["paladin"] = {false, "retri"},
        ["death knight"] = {false, "dk"},
        ["rogue"] = {false, "rog"},
        ["enhancement"] = {false, "enh"},
        ["feral"] = {false, "feral"}

    },
    ["rdps"] = {
        ["mage"] = {false, "mage"},
        ["warlock"] = {false, "lock"},
        ["hunter"] = {false, "hunter"},
        ["shaman"] = {false, "elemental"},
        ["druid"] = {false, "balance"},
        ["priest"] = {false, "shadow"}
    }
}

local announce = "{triangle} LFM VoA18 [Toravon Only] {triangle} Need "
local roles = {
    ["Tank"] = "",
    ["Heal"] = "",
    ["MDPS"] = "",
    ["RDPS"] = ""
}

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
    -- :: announce options
    if A.global[group][m_name].group == nil then
        A.global[group][m_name].group = dr
    end
    dr = A.global[group][m_name].group
    --
    if A.global[group][m_name].params == nil then
        A.global[group][m_name].params = {
            ["channel"] = "",
            ["delimeter"] = "",
            ["showNumber"] = false
        }
    end
    dr = A.global[group][m_name].group
    -- :: gui construct
    if A.global.gui == nil then
        A.global.gui = {}
    end
    if A.global.gui.diverseRaid == nil then
        A.global.gui.diverseRaid = {}
    end
    -- :: initialize frame lock
    if A.global.gui.diverseRaid.frameLock == nil then
        A.global.gui.diverseRaid.frameLock = true
    else
        -- rcFrameLock = A.global.gui.guildeMaker.frameLock
    end
    -- :: initialize gui position
    if A.global.gui.diverseRaid.position == nil then
        A.global.gui.diverseRaid.position = {"CENTER", "CENTER", 0, 0}
    else
        -- A.global.gui.diverseRaid.position = {"CENTER", "CENTER", 0, 0}
        framePos = A.global.gui.diverseRaid.position
    end
    -- :: initialize gui isOpen
    if A.global.gui.diverseRaid.isOpen == nil then
        A.global.gui.diverseRaid.isOpen = false
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function drawHead(name, parent)
    local heading = AceGUI:Create('Heading')
    heading:SetText(name)
    heading:SetRelativeWidth(1)
    parent:AddChild(heading)
end

local function managePosition_GUI()
    framePos = A.global.gui.diverseRaid.position
    Arch_guiFrame:SetPoint(framePos[1], framePos[3], framePos[4])
end

local function set_checkbox_spec()

end

local function draw_widget_spec_checkBox_raidRoles(key, spec, value, width, parent, fxOnValueChanged)
    local widget = AceGUI:Create('CheckBox')
    widget:SetRelativeWidth(width)
    widget:SetUserData("key", key)
    widget:SetUserData("spec", string.lower(spec))
    widget:SetLabel(spec)
    widget:SetValue(value)
    widget:SetCallback("OnValueChanged", function(self, bool_value)
        local role = widget:GetUserData("key")
        local spec = widget:GetUserData("spec")
        if A.global[group][m_name].group[role][spec] then
            local val = A.global[group][m_name].group[role][spec][1]
            if val == true then
                A.global[group][m_name].group[role][spec][1] = false
            elseif val == false then
                A.global[group][m_name].group[role][spec][1] = true
            else
                A.global[group][m_name].group[role][spec][1] = false
            end
            dr = A.global[group][m_name].group
        end
    end)
    parent:AddChild(widget)
end

local function draw_sWidget_checkBox_showNumber(label, value, width, parent)
    local widget = AceGUI:Create('CheckBox')
    widget:SetRelativeWidth(width)
    widget:SetLabel(label)
    widget:SetValue(value)
    widget:SetCallback("OnValueChanged", function(self, bool_value)
        A.global[group][m_name].params.showNumber = not A.global[group][m_name].params.showNumber
    end)
    parent:AddChild(widget)
end

-- local function draw_widget_checkBox(key, spec, value, width, parent, fxOnValueChanged)
--     local widget = AceGUI:Create('CheckBox')
--     widget:SetRelativeWidth(width)
--     widget:SetUserData("key", key)
--     widget:SetUserData("spec", string.lower(spec))
--     widget:SetLabel(spec)
--     widget:SetValue(value)
--     widget:SetCallback("OnValueChanged", function(self, bool_value)

--     end)
--     parent:AddChild(widget)
-- end

local function draw_widget_label(content, width, parent)
    local editbox = AceGUI:Create("Label")
    editbox:SetText(content)
    editbox:SetRelativeWidth(width)
    parent:AddChild(editbox)
end

local function setChannel(channel)
    A.global[group][m_name].params.channel = channel
end

local function setDelimeter(delimeter)
    A.global[group][m_name].params.delimeter = delimeter
end

local function setShowNumber(value)

end

local function draw_widget_editBox(label, content, width, parent, fxEnterPressed)
    local widget = AceGUI:Create('EditBox')
    widget:SetLabel(label)
    widget:SetText(content)
    widget:SetRelativeWidth(width)
    widget:SetCallback("OnEnterPressed", function(widget, event, text)
        fxEnterPressed(text)
    end)
    parent:AddChild(widget)
end

local function announce()
    local announce = "LFM VoA 18 Spec Run Need "
    local channel = A.global[group][m_name].params.channel
    local delimeter = A.global[group][m_name].params.delimeter
    local showNumbers = A.global[group][m_name].params.showNumber
    --
    for key in spairs(dr) do
        --
        local addGroup = false
        for role, v in pairs(dr[key]) do
            if v[1] == false then
                addGroup = true
            end
        end
        local newString = ""
        if addGroup then
            newString = newString .. " " .. delimeter
            newString = newString .. " " .. pCase(key)
        end
        -- 
        if key ~= "tank" then
            for role, v in pairs(dr[key]) do
                local notExists = v[1]
                local spec = v[2]
                if not notExists then
                    newString = newString .. " " .. spec
                end
            end
            announce = announce .. newString
        else
            newString = newString .. " anything"
            local countTank = 0
            for role, v in pairs(dr[key]) do
                local notExists = v[1]
                local spec = v[2]
                if notExists then
                    newString = newString .. " except " .. spec
                    countTank = countTank + 1
                end
            end
            if countTank < 2 then
                announce = announce .. newString
            end
        end
    end
    --

    print(showNumbers, GetNumGroupMembers())
    if showNumbers then
        if GetNumGroupMembers() < 18 then
            announce = announce .. " " .. delimeter .. " " .. GetNumGroupMembers() .. "/18"
        else
            announce = announce .. " " .. delimeter .. " " .. "17/18"
        end
    end
    if type(tonumber(channel)) == "number" then
        SendChatMessage(announce, "channel", "Common", channel);
    end
    aprint(announce)
end

local function draw_widget_button(label, width, parent, fxOnClick)
    local widget = AceGUI:Create('Button')
    widget:SetText('Announce')
    widget:SetFullWidth(true)
    widget:SetCallback("OnClick", function(widget, event, text)
        fxOnClick()
    end)
    parent:AddChild(widget)
end

local function drawMainFrame()
    -- :: reset
    Arch_guiFrame:SetWidth(280)
    Arch_guiFrame:SetHeight(520)
    Arch_guiFrame:ReleaseChildren()
    -- :: set scroll frame
    Arch_guiFrame:SetLayout("Fill") -- Fill will make the first child fill the whole content area
    local frame = AceGUI:Create("ScrollFrame")
    frame:SetLayout("Flow")
    Arch_guiFrame:AddChild(frame)
    -- :: positioning the gui upon close position
    managePosition_GUI()
    -- :: heading | title of module 
    drawHead("Diverse Raid Former", frame)
    -- :: Draw groups
    for role in spairs(dr) do
        draw_widget_label(hCol(pCase(role) .. ": "), 1, frame)
        local raidRole = AceGUI:Create("SimpleGroup")
        raidRole:SetFullWidth(true)
        raidRole:SetLayout("Flow") -- important!
        for person, v in pairs(dr[role]) do
            local person, isExist, shortkey = person, v[1], v[2]
            draw_widget_spec_checkBox_raidRoles(role, pCase(person), isExist, 0.3, raidRole, setSpec)
        end
        frame:AddChild(raidRole)
    end
    -- :: draw Announce Channel
    local channel = A.global[group][m_name].params.channel
    draw_widget_editBox("Channel Key:", channel, 0.5, frame, setChannel)
    -- :: draw Raid Delimeter
    local delimeter = A.global[group][m_name].params.delimeter
    draw_widget_editBox("Delimeter:", delimeter, 0.5, frame, setDelimeter)
    -- :: show people in raid
    local showNumber = A.global[group][m_name].params.showNumber
    draw_sWidget_checkBox_showNumber(hCol("Show people in the Raid"), showNumber, 1, frame)
    -- :: draw announce button
    draw_widget_button("Announce", 1, frame, announce)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods
function Arch_diverseRaid_GUI()
    drawMainFrame()
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)
    if isEnabled then
        -- :: register
        -- module:RegisterEvent("CHAT_MSG_SYSTEM")
        -- if not isSilent or isSilent == nil then
        --     aprint(fCol(m_name2) .. " is enabled")
        -- end
    else
        -- :: deregister
        -- -- module:UnregisterEvent("CHAT_MSG_SYSTEM")
        -- if not isSilent or isSilent == nil then
        --     aprint(fCol(m_name2) .. " is disabled")
        -- end
    end
    if not isSilent then
        isEnabled = not isEnabled
        -- A.global.assist.groupOrganizer.isEnabled = isEnabled
    end
end

local function handleCommand(msg)
    if msg == "" then
        Arch_setGUI(m_name)
    else
        announce()
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
-- function module:PLAYER_REGEN_ENABLED()
--     -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
--     isInCombat = false
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_voa1 = "/voa"
SlashCmdList["voa"] = function(msg)
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
