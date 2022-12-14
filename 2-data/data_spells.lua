----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    --!! In use by CRIndicator
        Class {Spell{ID,cd}}

]]

Arch_spells = {
    -- ["NameOfSpell"] = {spellId, cdInSeconds, minimumLevel, iconPath}
    -- ==== Druid    
    -- ["Tranquility"] = {},
    ["Rebirth"] = {26994, 600, 20, "spell_nature_reincarnation"},
    ["Innervate"] = {29166, 180, 40, "spell_nature_lightning"},
    -- ==== Priest
    -- ["Hymn of Hope"] = {64901, 360},
    -- ["Flash Heal"] = {48071, 4},
    -- ==== Warlocck
    ["Soulstone Resurrection"] = {47883, 900, 18, "spell_shadow_soulgem"},
    -- ==== Hunter
    ["Misdirection"] = {34477,30, 70, "ability_hunter_misdirection"},
    -- ==== Shaman
    -- ["Earthbind Totem"] = {2484, 15},
    ["Reincarnation"] = {20608, 1800, 30, "spell_nature_reincarnation"},
    -- ==== mage
    -- test
    ["Cone of Cold"] = {10159, 10, 26, "spell_frost_glacier"},
    -- test
}
