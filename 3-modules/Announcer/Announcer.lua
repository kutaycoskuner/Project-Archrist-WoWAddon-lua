------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = "Announcer", "Announcer";
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
-- todo ----------------------------------------------------------------------------------------------------------------
--[[

    - announcing certain skills
        - add level of customizability

    - [x] resting event
        - time delay ekle
        - [x] reminder
            - buy food and drink
            - buy reagents
            - repair your gear
            - give back completed quests
]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[
        - Guide addon and material calculator for efficient profession grinding.
            - Calculates adaptive material requirements for your level
            - Suggests item to create to progress on crafting profession        
        ]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
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

-- :: module variables
local b_isEnabled_restingAnnounce = false



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
function module:ZONE_CHANGED_NEW_AREA() -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    if b_isEnabled_restingAnnounce then
        local b_isNotResting = IsResting()
        if not b_isNotResting then
            aprint("You are resting now. don't forget to")
            aprint(fCol("1") .. "Repair your equipment")
            aprint(fCol("2") .. "Buy reagents")
            aprint(fCol("3") .. "Buy food and drinks")
            aprint(fCol("4") .. "Clean your bags")
            aprint(fCol("5") .. "Return completed quests")
        end
    end
end

function module:COMBAT_LOG_EVENT_UNFILTERED() -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 =
        CombatLogGetCurrentEventInfo()
    local timestamp, eventType, srcName, dstName, spellId, spellName = arg1, arg2, arg5, arg9, arg12, arg13
    -- :: Apply: DK Hysteria
    if srcName == UnitName('player') and spellName == "Hysteria" and eventType == "SPELL_AURA_APPLIED" then
        SendChatMessage(GetSpellLink("Hysteria") .. " is cast on you (+20% dmg -1% hp 30 sec)", "whisper", nil, dstName);
    end

    if srcName == UnitName('player') and spellName == "Hysteria" and eventType == "SPELL_AURA_APPLIED" then
        SendChatMessage(GetSpellLink("Unholy Frenzy") .. " is cast on you (+20% dmg -1% hp 30 sec)", "whisper", nil, dstName);
    end

    -- :: Apply: Mage Focus
    if srcName == UnitName('player') and spellName == "Focus Magic" and eventType == "SPELL_CAST_SUCCESS" then
        SendChatMessage(GetSpellLink("Focus Magic") .. " is cast on you (3% spell crit chance)", "whisper", nil, dstName);
    end
    -- :: Receive: Mage Focus
    if dstName == UnitName('player') and spellName == "Focus Magic" and eventType == "SPELL_CAST_SUCCESS" then
        -- SendChatMessage("Thanks for the " .. GetSpellLink("Focus Magic"), "whisper", nil, srcName);
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
    module:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[]]
