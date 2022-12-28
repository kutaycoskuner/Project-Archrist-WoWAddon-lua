--------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Announcer';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then
    return
end
----------------------------------------------------------------------------------------------------------------------
-- ==== Variables

-- -- ==== GUI
-- ==== Methods
local function sendGroupMessage(msg)
    if UnitInRaid('player') then
        SendChatMessage(msg, "raid", nil, "channel")
    elseif UnitInParty('player') then
        SendChatMessage(msg, "party", nil, "channel")
    else
        SendChatMessage(msg, "say")
    end
end

-- ==== Start
function module:Initialize()
    self.initialized = true

end

-- ==== Event Handlers
function module:COMBAT_LOG_EVENT_UNFILTERED() -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 =
        CombatLogGetCurrentEventInfo()
    local timestamp, eventType, srcName, dstName, spellId, spellName = arg1, arg2, arg5, arg9, arg12, arg13
    -- :: Apply: DK Hysteria
    if srcName == UnitName('player') and spellName == "Hysteria" and eventType == "SPELL_AURA_APPLIED" then
        SendChatMessage(GetSpellLink("Hysteria") .. " is cast on you (+20% dmg -1% hp 30 sec)", "whisper", nil, dstName);
    end

    -- :: Apply: Mage Focus
    if srcName == UnitName('player') and spellName == "Focus Magic" and eventType == "SPELL_CAST_SUCCESS" then
        SendChatMessage(GetSpellLink("Focus Magic") .. " is cast on you (3% spell crit chance)", "whisper", nil, dstName);
    end
    -- :: Receive: Mage Focus
    if dstName == UnitName('player') and spellName == "Focus Magic" and eventType == "SPELL_CAST_SUCCESS" then
        SendChatMessage("Thanks for the " .. GetSpellLink("Focus Magic"), "whisper", nil, srcName);
    end

    -- :: Apply: Priest Power Infusion 
    if srcName == UnitName('player') and spellName == "Power Infusion" and eventType == "SPELL_AURA_APPLIED" then
        SendChatMessage(GetSpellLink("Power Infusion") .. " is cast on you (+20% spell haste, -20% mana cost, 15 sec)",
            "whisper", nil, dstName);
    end

    -- :: Apply: Hunter Misdirection
    if srcName == UnitName('player') and spellId == 34477 and eventType == "SPELL_CAST_SUCCESS" then
        if dstName then
            sendGroupMessage(GetSpellLink("Misdirection") .. " is on >> " .. dstName .. " <<")
        end
    end
    -- :: Portal to dalaran
    if srcName == UnitName('player') and spellId == 53142 and eventType == "SPELL_CAST_START" then
        sendGroupMessage("Casting " .. GetSpellLink("Portal: Dalaran"))
    end
end

-- ==== End
local function InitializeCallback()
    module:Initialize()

    -- :: Register events
    module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[]]
