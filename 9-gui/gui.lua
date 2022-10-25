------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'ArchGUI';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------

-- Globals Section
local UpdateInterval = 1.0; -- How often the OnUpdate code will run (in seconds)
local announceChannel
local AceGUI = LibStub("AceGUI-3.0")
local list
local recursive = false
local realmName = GetRealmName()
local textStore
local currentLootList = {}
local focus = Arch_focusColor
local fixArgs = Arch_fixArgs
--
local frame
local frameOpen = false
--
local frame2
local frameOpen2 = false
local frameStopTrack2 = true
--
local lootFramePos
local voaFramePos
--
local pugDelimeter = " - "
local pugRaidType
local pugShowCounter = false
--

local diverseRaid
-- :: PuGRaid Variables
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
        labelIssuer:SetRelativeWidth(0.1)
        frame:AddChild(labelIssuer)
        --
        local labelTodo = AceGUI:Create("Label")
        labelTodo:SetText("Todo")
        labelTodo:SetRelativeWidth(0.7)
        frame:AddChild(labelTodo)
        --
        local labelButton = AceGUI:Create("Label")
        labelButton:SetText("Complete")
        labelButton:SetRelativeWidth(0.2)
        frame:AddChild(labelButton)
        --
        -- :: Set Variable for cache
        local list = A.global.todo
        for ii = 1, #list do
            -- :: her bir todo icin
            local label = AceGUI:Create("Label")
            label:SetText(ii .. "# ")
            label:SetRelativeWidth(0.1)
            frame:AddChild(label)
            --
            local editbox = AceGUI:Create("Label")
            editbox:SetText(list[ii].todo)
            editbox:SetRelativeWidth(0.7)
            frame:AddChild(editbox)
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
            frame:AddChild(button)
        end
        -- :: gui Add Todo
        local newIssuer, newTodo
        --
        local addIssuer = AceGUI:Create("Label")
        addIssuer:SetText(#A.global.todo + 1 .. "# ")
        addIssuer:SetRelativeWidth(0.1)
        frame:AddChild(addIssuer)
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
        frame:AddChild(addTodo)
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
        frame:AddChild(button)
    end
end

local function setPoint(self)
    local scale = self:GetEffectiveScale()
    local x, y = GetCursorPosition()
    self:ClearAllPoints()
    self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / scale, (y + 10) / scale)
end

local function setGameTooltip(widget)
    -- GameTooltip:SetOwner(frame, "ANCHOR_CURSOR", 0, 0);
    -- GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    -- GameTooltip:ClearAllPoints();
    -- GameTooltip:SetPoint("bottomleft", frame, "topright", 0, 0);
    -- GameTooltip:ClearLines()
    -- print(frame)
end

local function diverseRaidGUI()
    frame:SetWidth(280)
    frame:SetHeight(730)
    frame:ClearAllPoints()
    if A.global.voaFrame == {} then
        frame:SetPoint("CENTER", 0, 0)
    else
        frame:SetPoint(voaFramePos[1], voaFramePos[3], voaFramePos[4])
    end
    local heading = AceGUI:Create('Heading')
    heading:SetText('Diverse Raid')
    heading:SetRelativeWidth(1)
    frame:ReleaseChildren()
    frame:AddChild(heading)
    --
    for ii = 1, #diverseRaid do
        for key in pairs(diverseRaid[ii]) do
            local group = AceGUI:Create("SimpleGroup")
            group:SetFullWidth(true)
            group:SetLayout('Flow')
            frame:AddChild(group)
            --
            local groupName = AceGUI:Create("Heading")
            groupName:SetText(key)
            groupName:SetRelativeWidth(1)
            group:AddChild(groupName)
            for subkey in pairs(diverseRaid[ii][key]) do
                local specTick = AceGUI:Create("CheckBox")
                specTick:SetValue(A.global.voaRaid[ii][key][subkey])
                specTick:SetLabel(subkey)
                specTick:SetCallback("OnValueChanged", function(self, value)
                    -- diverseRaid[ii][key][subkey] =
                    --     not diverseRaid[ii][key][subkey]
                    A.global.voaRaid[ii][key][subkey] = not A.global.voaRaid[ii][key][subkey]
                    -- print(diverseRaid[ii][key][subkey])
                end)
                group:AddChild(specTick)
            end
        end
    end
    -- 
    local channel = AceGUI:Create('EditBox')
    channel:SetText(announceChannel or 'Set announce channel key here')
    channel:SetFullWidth(true)
    channel:SetCallback("OnEnterPressed", function(widget, event, text)
        announceChannel = text
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Announce Channel is now: " .. announceChannel)
    end)
    frame:AddChild(channel)
    -- :: AnnounceButton
    local annButton = AceGUI:Create('Button')
    annButton:SetText('Announce')
    annButton:SetFullWidth(true)
    annButton:SetCallback("OnClick", function(widget, event, text)
        VoA_announce(false)
    end)
    frame:AddChild(annButton)
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
        counter = tostring((GetNumRaidMembers() or 0)) .. '/' .. tostring(pugRaidType)
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

local function pugRaidGUI()
    frame:SetWidth(280)
    frame:SetHeight(576)
    frame:ClearAllPoints()
    if A.global.voaFrame == {} then
        frame:SetPoint("CENTER", 0, 0)
    else
        frame:SetPoint(voaFramePos[1], voaFramePos[3], voaFramePos[4])
    end
    local heading = AceGUI:Create('Heading')
    heading:SetText('PuG Raid Organizer')
    heading:SetRelativeWidth(1)
    frame:ReleaseChildren()
    frame:AddChild(heading)
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
    raidType:SetHeight(40)
    -- raidType:SetLabel('Raid Type')
    raidType:SetCallback("OnValueChanged", function(widget, event, text)
        pugRaidType = text
        A.global.pugRaid.raidType = pugRaidType
    end)
    frame:AddChild(raidType)
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
    frame:AddChild(raidName)
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
            frame:AddChild(roleBox)
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
            frame:AddChild(roleData)
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
    frame:AddChild(additional)
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
    frame:AddChild(delimeter)
    -- :: Show Counter?
    local showCounter = AceGUI:Create('CheckBox')
    showCounter:SetLabel('Show people in raid')
    showCounter:SetValue(A.global.pugRaid.showCounter)
    showCounter:SetCallback("OnValueChanged", function(self, value)
        pugShowCounter = not pugShowCounter
        A.global.pugRaid.showCounter = pugShowCounter
    end)
    frame:AddChild(showCounter)
    -- :: Announce Channel key
    local channel = AceGUI:Create('EditBox')
    channel:SetLabel('Set announce channel key here')
    channel:SetFullWidth(true)
    channel:SetCallback("OnEnterPressed", function(widget, event, text)
        announceChannel = text
        A.global.pugRaid.channelKey = announceChannel
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Announce Channel is now: " .. announceChannel)
    end)
    frame:AddChild(channel)
    -- :: AnnounceButton
    local annButton = AceGUI:Create('Button')
    annButton:SetText('Announce')
    annButton:SetFullWidth(true)
    annButton:SetCallback("OnClick", function(widget, event, text)
        Arch_gui_pugRaid_announce()
    end)
    frame:AddChild(annButton)
end

-- ==== raidCooldowns
-- local function raidCooldowns_calcTime(time)
--     local cd = time - GetTime()
--     if cd > 0 then
--         local min = math.floor(cd / 60)
--         local sec = math.floor(cd % 60)
--         --
--         if 10 > sec then
--             sec = "0" .. sec
--         end
--         if 10 > min then
--             min = "0" .. min
--         end
--         --
--         return (min .. ":" .. sec)
--     else
--         return "|cff08cf3dReady|r"
--     end
-- end

-- local function raidCooldownsGUI()
--     -- SELECTED_CHAT_FRAME:AddMessage('TEST')
--     frame2:SetWidth(240)
--     frame2:SetHeight(576)
--     frame2:ClearAllPoints()
--     -- :: todo sonradan yer hatirlama ekleeneccek
--     frame2:SetPoint("CENTER", 0, 0)
--     -- :: varsa onceki frameleri temizle
--     frame2:ReleaseChildren()
--     -- Spellere Gore Sirala
--     for ii = 1, 1 do
--         local heading = AceGUI:Create('Heading')
--         heading:SetText(Arch_trackSpells[ii])
--         heading:SetRelativeWidth(1)
--         frame2:AddChild(heading)
--         --
--         local name = AceGUI:Create("Label")
--         name:SetText(Arch_raidPeople[ii].name)
--         name:SetWidth(160)
--         frame2:AddChild(name)
--         local cd = AceGUI:Create("Label")
--         cd:SetText(raidCooldowns_calcTime(Arch_raidPeople[ii].availableAt))
--         cd:SetWidth(40)
--         frame2:AddChild(cd)
--         raidCooldowns_calcTime(Arch_raidPeople[ii].availableAt)
--     end
--     -- -- :: Main Raid Note [required]
--     for ii = 1, #Arch_raidPeople do
--         if not Arch_raidPeople[ii].spell then
--             frameStopTrack2 = false
--             break
--         end
--         frameStopTrack2 = true
--     end
-- end

-- ==== Core
-- :: Sadece Komutla aciliyor
function toggleGUI(key)
    if not frameOpen then
        frameOpen = true
        frame = AceGUI:Create("Frame")
        frame:SetTitle(N)

        frame:SetCallback("OnClose", function(widget)
            frameOpen = false
            local a, b, c, d, e = frame:GetPoint()
            -- print(a,b,c,d,e)
            A.global.lootFrame = {a, c, d, e}
            A.global.voaFrame = {a, c, d, e}
            lootFramePos = A.global.lootFrame
            voaFramePos = A.global.voaFrame
            -- print(lootFramePos[1], lootFramePos[2], lootFramePos[3], lootFramePos[4])
            -- print(A.global.lootFrame[1].. d)
        end)
        frame:SetLayout("Flow")
        -- test
        if key == 'TodoList' then
            TodoListGUI()
        end
        if key == 'LootDatabase' then
            LootDatabaseGUI()
        end
        if key == 'LootDatabasePrune' then
            currentLootList = {}
            toggleGUI('LootDatabase')
        end
        if key == "DiverseRaid" then
            diverseRaidGUI()
        end
        if key == "pugRaid" then
            pugRaidGUI()
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

-- function toggleGUI_2(key)
--     if not frameOpen2 then
--         frameOpen2 = true
--         frame2 = AceGUI:Create("Frame")
--         -- frame2:SetCallBack("OnUpdate", function(_, elapsed)
--         --     self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

--         --     if (self.TimeSinceLastUpdate > UpdateInterval) then
--         --         Arch_setGUI("raidCooldowns", true)
--         --         self.TimeSinceLastUpdate = 0;
--         --     end

--         -- end)
--         frame2:SetTitle(N)
--         --
--         -- frame2:SetCallback("OnClose", function(widget)
--         --     frameOpen2 = false
--         -- end)
--         frame2:SetLayout("Flow")
--         --
--         if key == 'raidCooldowns' then
--             raidCooldownsGUI()
--         end
--         --
--     elseif recursive then
--         frame2:Release()
--         frameOpen2 = false
--         toggleGUI_2(key)
--     else
--         frame2:Release()
--         frameOpen2 = false
--     end
-- end

function Arch_setGUI(key, isRecursive)
    recursive = false
    if isRecursive then
        recursive = true
    end
    if key ~= 'raidCooldowns' then
        toggleGUI(key)
    else
        -- toggleGUI_2(key)
    end
end

-- function GUI_insertPerson(target, reload)
--     local isPersonExists = false
--     local player = A.loot[realmName][target]
--     -- :: kisi varsa sil
--     -- if target == nil then target = '' end
--     for ii = 1, #currentLootList do
--         if currentLootList[ii][1] == target then
--             table.remove(currentLootList, ii)
--             isPersonExists = true
--         end
--     end
--     -- :: kisi yoksa ekle
--     if not isPersonExists or reload ~= nil then
--         local nominee = {}
--         nominee[1] = target -- name

--         nominee[2] = (#player or 0) -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         -- item count
--         for ii = 1, #player do
--             if GetItemInfo(player[ii][3]) then -- [3] id ye bakiyor
--                 local _, a = GetItemInfo(player[ii][3])
--                 nominee[2 + ii] = {player[ii][1], a}
--             end
--             if ii == 3 then
--                 break
--             end
--         end
--         for ii = 3, 5 do
--             if not nominee[ii] then
--                 nominee[ii] = {nil, nil}
--             end
--         end
--         local previous = #currentLootList or 0
--         table.insert(currentLootList, 1, nominee)
--     end
--     -- :: eger bir onceki listeden farkliysa listeyi guncelle
--     if not frameOpen then
--         Arch_setGUI('LootDatabase')
--     else
--         frame:Release()
--         frameOpen = false
--         Arch_setGUI('LootDatabase')
--     end

-- end

function return_diverseRaid()
    return {diverseRaid, announceChannel}
end

-- Functions Section
function GUI_OnUpdate(self, elapsed)
    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

    if (self.TimeSinceLastUpdate > UpdateInterval) then

        self.TimeSinceLastUpdate = 0;
    end
end

function module:Initialize()
    self.Initialized = true
    if not A.global.lootFrame then
        A.global.lootFrame = {"CENTER", "CENTER", 0, 0}
    end
    lootFramePos = A.global.lootFrame
    diverseRaid = A.global.voaRaid
    --
    if not A.global.voaFrame then
        A.global.voaFrame = {"CENTER", "CENTER", 0, 0}
    end
    voaFramePos = A.global.voaFrame
    -- :: Pug
    -- !! testtest
    raidText = A.global.pugRaid.raidText
    pugRaidType = A.global.pugRaid.raidType
    structure = A.global.pugRaid.needData
    pugShowCounter = A.global.pugRaid.showCounter
    pugDelimeter = A.global.pugRaid.delimeter
    notes = A.global.pugRaid.additionalNote
    announceChannel = A.global.pugRaid.channelKey
    -- :: Register Events
    -- self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
    -- self:RegisterEvent("CHAT_MSG_RAID_WARNING")
    -- "MAIL_INBOX_UPDATE"
end

-- ==== Slash Handlers
-- SLASH_arch1 = "/arch"
-- SlashCmdList["arch"] = function() toggleGUI(false) end

-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)

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
