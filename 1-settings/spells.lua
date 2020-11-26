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
    -- ["Hymn of Hope"] = {64901, 360},
    -- ["Flash Heal"] = {48071, 4},
    -- ==== Warlocck
    ["Soulstone Resurrection"] = {47883, 300},
    -- ==== Hunter
    ["Misdirection"] = {34477,30},
    -- ==== Shaman
    -- ["Earthbind Totem"] = {2484, 15},
    ["Reincarnation"] = {20608, 1800},
    ["Lesser Healing Wave"] = {49276, 5}
}
