------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "EncounterStopwatch", "Encounter Stopwatch";
local group = "assist";
local module = A:GetModule(m_name, true);
local moduleAlert = M .. m_name2 .. ": |r";
local mprint = function(msg)
    print(moduleAlert .. msg)
end
local aprint = Arch_print
if module == nil then return end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------

-- use case ------------------------------------------------------------------------------------------------------------
--[[
    ]]

-- blackboard ------------------------------------------------------------------------------------------------------------
--[[
]]

-- todo ----------------------------------------------------------------------------------------------------------------
--[[
]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local b_isTesting = false
local isEnabled = true
-- :: global Functions
local fCol = Arch_focusColor
local cCol = Arch_commandColor
local mCol = Arch_moduleColor
local tCol = Arch_trivialColor
local classCol = Arch_classColor
local realmName = GetRealmName()

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
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function reset()
    DEFAULT_CHAT_FRAME.editBox:SetText("/sw reset") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end

local function play()
    DEFAULT_CHAT_FRAME.editBox:SetText("/sw play") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end

local function pause()
    DEFAULT_CHAT_FRAME.editBox:SetText("/sw pause") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end
------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)
    if isEnabled then
        -- :: register
        -- module:RegisterEvent("CHAT_MSG_SAY")
        module:RegisterEvent("ENCOUNTER_START")
        module:RegisterEvent("ENCOUNTER_END")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is enabled")
        end
    else
        -- :: deregister
        module:UnregisterEvent("ENCOUNTER_START")
        module:UnregisterEvent("ENCOUNER_END")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is disabled")
        end
    end
    -- :: 
    if not isSilent then
        isEnabled = not isEnabled
        A.global[group][m_name].isEnabled = isEnabled
    end
end
module.toggleModule = toggleModule


local function handleCommand(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
function module:ENCOUNTER_START()
    aprint("Encounter stopwatch activated.")
    reset()
    play()
end

function module:ENCOUNTER_END()
    aprint("Encounter stopwatch stopped.")
    pause()
end

function module:CHAT_MSG_SAY()
    if b_isTesting then
        reset()
        play()
    else
        pause()    
    end
    b_isTesting = not b_isTesting
end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
-- SLASH_reputation1 = "/rep"
-- SlashCmdList["reputation"] = function(msg)
--     handleCommand(msg)
-- end

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
