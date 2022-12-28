------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "test", "test";
local group = "";
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
-- ==== Variables
local switch_register = true
local sourceName = ""
-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- ==== Methods
local function handleCommand(msg)
    -- print(IsPlayerMoving())
    if msg == "" then
        if switch_register == true then
            module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            aprint("spell tracking activated")
        else
            module:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            aprint("spell tracking deactivated")
        end
        switch_register = not switch_register
    else
        sourceName = msg
        if sourceName == "reset" then
            sourceName = ""
        end
        if UnitName("target") ~= nil then
            sourceName = UnitName('target')
        end
        aprint("Tracking set to " .. sourceName)
    end
end
-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Database Connection
    -- :: Register some events
end

-- ==== Event Handlers
function module:CHAT_MSG_SAY()
    -- HideUIPanel("MacroFrame")
    -- :: bu claisiyor
    -- ShowMacroFrame()
    -- ShowUIPanel(MacroFrame)
    -- UIParent:Hide()
    -- UIParent:Show()
    -- HideMacroFrame()
    -- :: hide macro frame
    -- MacroFrame_SaveMacro()
    -- MacroFrame_Show()
    -- print(GetName(select(2, UIParent:GetChildren())))
end

function module:COMBAT_LOG_EVENT_UNFILTERED() -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 =
        CombatLogGetCurrentEventInfo()
    local timestamp, eventType, srcName, dstName, spellId, spellName = arg1, arg2, arg5, arg9, arg12, arg13
    -- :: Print event names
    -- print(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    -- print(timestamp, eventType, srcName, dstName, spellId, spellName)
    -- if eventType == nil then
    if srcName == sourceName then
        print(eventType, srcName, spellId, spellName)
    end
    -- :: stop macro
    -- do
    --     return
    -- end
    -- end
    -- :: Raidde degilse rebirth listesini sifirliyor
    -- if not UnitInRaid('player') then group = {} deadCheck() return end
    -- :: Dead
    -- if eventType == "UNIT_RESURRECT" then
    --     setAlive(dstName, true)
    -- end
end

-- ==== Slash Handlersd
SLASH_test1 = "/test"
SlashCmdList["test"] = function(msg)
    handleCommand(msg)
end

-- ==== End
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[]]
