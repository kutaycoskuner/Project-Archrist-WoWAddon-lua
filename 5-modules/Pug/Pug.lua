------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Pug';
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
    - create command [x]
    - understand command arguments
]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local pugFramePos
local UpdateInterval = 1.0; -- How often the OnUpdate code will run (in seconds)
local announceChannel
local channelKey -- channel key is for giving number of announcechannel
local raidText, need, counter, notes
local structure = {{
    ['Tank'] = false
}, {
    ['Heal'] = false
}, {
    ['MDPS'] = false
}, {
    ['RDPS'] = false
}}
local pugDelimeter = " - "
local pugRaidType
local pugShowCounter = false
--
local focus = Arch_focusColor
local fixArgs = Arch_fixArgs

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    if not A.global.pugRaid then
        A.global.pugRaid = {
            ["raidType"] = {},
            ["raidText"] = "",
            ["needData"] = {{
                ['Tank'] = false
            }, {
                ['Heal'] = false
            }, {
                ['MDPS'] = false
            }, {
                ['RDPS'] = false
            }},
            ["additionalNote"] = "",
            ["delimeter"] = " - ",
            ["showCounter"] = false,
            ["channelKey"] = {}
        }
    end
    if not A.global.pugFrame then
        A.global.pugFrame = {"CENTER", "CENTER", 0, 0}
    end
    --
    self.initialized = true
    -- :: Database Connection
    -- :: Register some events
    -- module:RegisterEvent("COMBAT_LOG_EVENT");
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function handleCommand(msg)
    if msg == "1" then
        Arch_gui_pugRaid_announce()
    else
        Arch_setGUI('pugRaid')
    end
end

local function pugRaid_VariableTest()
    if not raidText then
        raidText = ""
    end
    if not need then
        need = ""
    end
    if not notes then
        notes = ""
    end
    if not counter then
        counter = ""
    end
    if not pugRaidType then
        pugRaidType = 25
    end
end

local function pugRaid_textChange(isAnnouncement)
    -- :: RaidText
    local lastRaidText = (raidText or "  ")
    -- SELECTED_CHAT_FRAME:AddMessage(need)
    local lastNeed = need
    local lastNotes = notes
    local lastCounter = counter
    if (need ~= "" or notes ~= "" or counter ~= "") and string.sub(lastRaidText, -1) ~= " " then
        lastRaidText = raidText .. pugDelimeter
        -- print(string.sub(lastRaidText, -5,-5))
        if string.sub(lastRaidText, -5, -5) == "}" then
            lastRaidText = raidText .. " "
        end
    end
    -- :: Need
    if (notes ~= "" or (pugShowCounter)) and string.sub(lastNeed or " ", -1) ~= " " then
        lastNeed = need .. pugDelimeter
    end
    if UnitInRaid('player') then
        counter = tostring((GetNumGroupMembers() or 0)) .. '/' .. tostring(pugRaidType)
    elseif UnitInParty('player') then

        counter = tostring((GetNumGroupMembers() or 0)) .. '/' .. tostring(pugRaidType)
    else
        -- SELECTED_CHAT_FRAME:AddMessage(focus("Announcing: ") .. lastRaidText .. (lastNeed or "") .. lastNotes)
        -- print(moduleAlert .. 'You are not in group')
        counter = tostring(0) .. '/' .. tostring(pugRaidType)
    end

    if notes ~= "" and string.sub(counter or " ", -1) ~= " " then
        lastCounter = counter .. pugDelimeter
    end
    --
    if pugShowCounter then
        if isAnnouncement and announceChannel and announceChannel ~= "" then
            SendChatMessage(lastRaidText .. lastNeed .. lastCounter .. lastNotes, "channel", nil, announceChannel)
            SELECTED_CHAT_FRAME:AddMessage(focus("Announcing: ") .. lastRaidText .. (lastNeed or "") ..
                                               (tostring(lastCounter) or "") .. lastNotes)
        else
            SELECTED_CHAT_FRAME:AddMessage(lastRaidText .. (lastNeed or "") .. (tostring(lastCounter) or "") ..
                                               lastNotes)
        end
    else
        if isAnnouncement and announceChannel and announceChannel ~= "" then
            SendChatMessage(lastRaidText .. lastNeed .. lastNotes, "channel", nil, announceChannel)
            SELECTED_CHAT_FRAME:AddMessage(focus("Announcing: ") .. lastRaidText .. (lastNeed or "") .. lastNotes)
        else
            SELECTED_CHAT_FRAME:AddMessage(lastRaidText .. (lastNeed or "") .. lastNotes)
        end
    end
end

local function pugRaid_calcNeed()
    pugRaid_VariableTest()
    -- SELECTED_CHAT_FRAME:AddMessage(need)
    if need ~= 'Need All' then
        need = "Need "
        for ii = 1, #structure do
            for key in pairs(structure[ii]) do
                if structure[ii][key] then
                    if structure[ii][key] == true or structure[ii][key] == '' then
                        -- :: ekliyor
                        need = need .. tostring(key)
                    else
                        need = need .. structure[ii][key]
                    end
                    -- :: mdps, rdps ikisi birden varsa dps olarak kisaltiyor
                    if structure[3]["MDPS"] and structure[4]["RDPS"] then
                        need = string.gsub(need, "MDPS, RDPS", "Damage")
                    end
                    -- need = string.gsub(need, "MDPS", "MDPS")
                    -- need = string.gsub(need, "RDPS", "Range")
                end
                -- :: virgul ekleme
                if structure[ii][key] then
                    local last = true
                    for yy = ii + 1, #structure do
                        for subkey in pairs(structure[yy]) do
                            if structure[yy][subkey] then
                                last = false
                                break
                            end
                        end
                    end
                    if last then
                        need = need
                    else
                        need = need .. ", "
                    end
                end
            end
        end
    end
end

function Arch_gui_pugRaid_announce()
    notes = notes or ""
    pugRaid_calcNeed()
    pugRaid_textChange(true)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods
function Arch_pugRaidGUI()
    pugFramePos = A.global.pugFrame
    raidText = A.global.pugRaid.raidText
    pugRaidType = A.global.pugRaid.raidType
    structure = A.global.pugRaid.needData
    pugShowCounter = A.global.pugRaid.showCounter
    pugDelimeter = A.global.pugRaid.delimeter
    notes = A.global.pugRaid.additionalNote
    announceChannel = A.global.pugRaid.channelKey
    
    Arch_guiFrame:SetWidth(280)
    Arch_guiFrame:SetHeight(576)
    Arch_guiFrame:ClearAllPoints()
    if A.global.pugFrame == {} then
        Arch_guiFrame:SetPoint("CENTER", 0, 0)
    else
        Arch_guiFrame:SetPoint(pugFramePos[1], pugFramePos[3], pugFramePos[4])
    end
    local heading = AceGUI:Create('Heading')
    heading:SetText('PuG Raid Organizer')
    heading:SetRelativeWidth(1)
    Arch_guiFrame:ReleaseChildren()
    Arch_guiFrame:AddChild(heading)
    -- -- :: Main Raid Note [required]
    local raidType = AceGUI:Create('Dropdown')
    local rt = {
        ["5"] = 5,
        ["10"] = 10,
        ["20"] = 20,
        ["25"] = 25,
        ["40"] = 40
    }
    raidType:SetList(rt)
    raidType:SetValue(A.global.pugRaid.raidType)
    -- raidType:SetText('Raid Type')
    raidType:SetFullWidth(true)
    raidType:SetHeight(25)
    -- raidType:SetLabel('Raid Type')
    raidType:SetCallback("OnValueChanged", function(widget, event, text)
        pugRaidType = text
        A.global.pugRaid.raidType = pugRaidType
    end)
    Arch_guiFrame:AddChild(raidType)
    -- -- :: Main Raid Note [required]
    local raidName = AceGUI:Create('EditBox')
    raidName:SetLabel('Main Raid Text')
    raidName:SetText(raidText or 'Set your main announce here')
    raidName:SetFullWidth(true)
    raidName:SetCallback("OnEnterPressed", function(widget, event, text)
        raidText = text
        A.global.pugRaid.raidText = raidText
        pugRaid_VariableTest()
        pugRaid_textChange(false)
    end)
    Arch_guiFrame:AddChild(raidName)
    -- -- LFM EoE 25 - Need All | x/18 | no more balance please
    -- -- [Raid Text] | [Need] | [Counter] | [Notes]
    -- -- :: Needed Roles [required]
    for ii = 1, #structure do
        for key in pairs(structure[ii]) do
            local roleBox = AceGUI:Create('CheckBox')
            local roleData = AceGUI:Create('EditBox')
            roleBox:SetLabel(key)
            roleBox:SetValue(structure[ii][key])
            roleBox:SetCallback("OnValueChanged", function(self, value)
                if structure[ii][key] ~= false then
                    structure[ii][key] = false
                    roleData:SetText('')
                else
                    structure[ii][key] = true
                end
                pugRaid_calcNeed()
                -- :: Check if all needed
                local all = true
                for ii = 1, #structure do
                    for key in pairs(structure[ii]) do
                        if structure[ii][key] == false then
                            all = false
                            break
                        end
                    end
                end
                if all then
                    need = 'Need All'
                else
                    need = ""
                end
                pugRaid_textChange(false)
                -- A.global.pugRaid.needData = structure
            end)
            Arch_guiFrame:AddChild(roleBox)
            --
            if type(structure[ii][key]) == 'string' then
                roleData:SetText(structure[ii][key] or '')
            else
                roleData:SetText('')
            end
            roleData:SetFullWidth(true)
            roleData:SetCallback("OnEnterPressed", function(widget, event, text)
                if text ~= '' then
                    structure[ii][key] = tostring(key) .. ": " .. text
                else
                    structure[ii][key] = false
                    roleBox:SetValue(structure[ii][key])
                end
                pugRaid_VariableTest()
                pugRaid_calcNeed()
                pugRaid_textChange(false)
                -- A.global.pugRaid.needData = structure
            end)
            Arch_guiFrame:AddChild(roleData)
        end
    end
    -- -- :: Additional Notes
    local additional = AceGUI:Create('EditBox')
    additional:SetLabel('Additional Notes')
    -- print(type(notes))
    if type(notes) == 'string' then
        additional:SetText(notes)
    end
    -- additional:SetText(notes)
    additional:SetFullWidth(true)
    additional:SetCallback("OnEnterPressed", function(widget, event, text)
        pugRaid_VariableTest()
        if text then
            notes = text
            A.global.pugRaid.additionalNote = notes
        end
        pugRaid_textChange(false)
    end)
    Arch_guiFrame:AddChild(additional)
    -- -- :: Delimeter key
    local delimeter = AceGUI:Create('EditBox')
    delimeter:SetLabel('Raid Delimeter')
    delimeter:SetText(pugDelimeter or 'Set delimeter here')
    delimeter:SetFullWidth(true)
    delimeter:SetCallback("OnEnterPressed", function(widget, event, text)
        pugDelimeter = " " .. text .. " "
        A.global.pugRaid.delimeter = pugDelimeter
        pugRaid_textChange(false)
    end)
    Arch_guiFrame:AddChild(delimeter)
    -- :: Show Counter?
    local showCounter = AceGUI:Create('CheckBox')
    showCounter:SetLabel('Show people in raid')
    showCounter:SetValue(A.global.pugRaid.showCounter)
    showCounter:SetCallback("OnValueChanged", function(self, value)
        pugShowCounter = not pugShowCounter
        A.global.pugRaid.showCounter = pugShowCounter
    end)
    Arch_guiFrame:AddChild(showCounter)
    -- :: Announce Channel key
    local channel = AceGUI:Create('EditBox')
    channel:SetLabel('Set announce channel key here')
    channel:SetFullWidth(true)
    channel:SetCallback("OnEnterPressed", function(widget, event, text)
        announceChannel = text
        A.global.pugRaid.channelKey = announceChannel
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Announce Channel is now: " .. announceChannel)
    end)
    Arch_guiFrame:AddChild(channel)
    -- :: AnnounceButton
    local annButton = AceGUI:Create('Button')
    annButton:SetText('Announce')
    annButton:SetFullWidth(true)
    annButton:SetCallback("OnClick", function(widget, event, text)
        Arch_gui_pugRaid_announce()
    end)
    Arch_guiFrame:AddChild(annButton)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function main(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
function module:COMBAT_LOG_EVENT(event, _, eventType, _, srcName, _, _, dstName, _, spellId, spellName, _, ...)
    -- print(event .. ' ' .. eventType .. ' ' .. srcName  .. ' ' .. dstName  .. ' ' .. spellId  .. ' ' .. spellName)
    -- print('test')
end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_pug1 = "/pug"
SlashCmdList["pug"] = function(msg)
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

end
A:RegisterModule(module:GetName(), InitializeCallback)
