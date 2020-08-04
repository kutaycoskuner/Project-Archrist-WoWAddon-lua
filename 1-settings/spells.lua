----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    --!! In use by CRIndicator
        Class {Spell{ID,cd}}

]]

Arch_spells = {
    -- ==== Druid    
    ["Rebirth"] = {48447, 600},
    ["Mangle (Bear)"] = {48564, 6},
    -- ==== Shaman
    ["Earthbind Totem"] = {2484, 15},
    ["Lesser Healing Wave"] = {49276, 5}
}
