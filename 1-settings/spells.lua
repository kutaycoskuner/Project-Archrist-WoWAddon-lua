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
    ["Innervate"] = {29166, 180},
    -- ==== Priest
    ["Hymn of Hope"] = {64901, 360},
    -- ==== Warlocck
    ["Soulstone Resurrection"] = {},
    -- ==== Hunter
    ["Misdirection"] = {},
    -- ==== Shaman
    ["Earthbind Totem"] = {2484, 15},
    ["Lesser Healing Wave"] = {49276, 5}
}
