--------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Announcer';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module ~= nil then return end
----------------------------------------------------------------------------------------------------------------------
-- ==== Variables

-- -- ==== GUI

-- ==== Methods

-- ==== Start
function module:Initialize()
    self.initialized = true

    -- :: Register events
    module:RegisterEvent("COMBAT_LOG_EVENT")
end

-- ==== Event Handlers
function module:COMBAT_LOG_EVENT(event, _, eventType, _, srcName, isDead, _, dstName, _, spellId, spellName, _, ...) -- https://wow.gamepedia.com/COMBAT_LOG_EVENT
    -- -- :: Print event names [spell name target type ogrenmek icin - silme!]
    -- SELECTED_CHAT_FRAME:AddMessage(event .. ' | ' .. eventType .. ' | ' .. spellId .. ' | ' .. dstName)

    -- :: DK Hysteria Apply
    if srcName == UnitName('player') and spellName == "Hysteria" and eventType == "SPELL_AURA_APPLIED" then
        SendChatMessage(GetSpellLink("Hysteria").." is cast on you (+20% dmg -1% hp 30 sec)" ,"whisper", nil, dstName);
    end

    -- :: Mage Focus Apply
    if srcName == UnitName('player') and spellName == "Focus Magic" and eventType == "SPELL_CAST_SUCCESS" then
        SendChatMessage(GetSpellLink("Focus Magic") .. " is cast on you" ,"whisper", nil, dstName);
    end

    -- :: Priest Power Infusion Apply
    if srcName == UnitName('player') and spellName == "Power Infusion" and eventType == "SPELL_AURA_APPLIED" then
        SendChatMessage(GetSpellLink("Power Infusion") .. " is cast on you (+20% spell haste, -20% mana cost, 15 sec)" ,"whisper", nil, dstName);
    end

    -- :: Hunter Misdirection
    if srcName == UnitName('player') and spellId == 34477 and eventType == "SPELL_CAST_SUCCESS" then
        if dstName then
            SendChatMessage(GetSpellLink("Misdirection") .. " is on >> " .. dstName .. " <<" ,"say", nil, nil);
        end
    end
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
