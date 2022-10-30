----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    --!! In use by Eat&Drink
        Class {Spell{ID,cd}}

]]
----------------------------------------------------------------------------------------------------------
Arch_consumables = {
    -- ==== Edibles
    ["foods"] = {
        43523,          -- 80 Conjured Mana Strudel
        35953,          -- 75 mead basted caribou
        39691,          -- 70 succulent orca stew
        33452,          -- 65 Honey-Spiced Lichen
        33443,          -- 65 sour goat cheese
        33454,          -- 65 salted venison
        1487,           -- 25 conjured pumpernickel
        1114,           -- 15 conjured rye
        4593,           -- 15 bristle whisker catfish
        4606,           -- 15 spongy morel
        3663,           -- 15 murloc fin soup
        1113,           -- 5 conjured bread
        422,            -- 5 dwarven mild
        414,            -- 5 dalaran sharp
        733,            -- 5 westfall stew
        724,            -- 5 goretusk liver pie
        24072,          -- 5 sand pear pie
        2287,           -- 5 haunch of meat
        4541,           -- 5 freshly baked bread
        4542,           -- 0 most cornbread
        117,            -- 0 tough jerky
        4536,           -- 0 shiny red apple
        23756,          -- 0 cookie's jumbo gumboca
        20389,          -- 0 candy corn
        7097,           -- 0 leg meat
        5057,           -- 0 ripe watermelon
        20516,          -- 0 bobbing apple
    },    
    -- ==== Drinkables
    ["drinks"] = {
        43523,          -- 80 Conjured Mana Strudel
        33445,          -- 75 honeymint tea
        33444,          -- 70 pungent seal whey
        8766,           -- 45 morning glory dew
        1645,           -- 35 moonberry juice
        3772,           -- 25 conjured spring water
        1708,           -- 25 sweet nectar
        2136,           -- 15 conjured purified water
        1205,           -- 15 melon juice
        2288,           -- 5 conjured fresh water
        4605,           -- 5 red-speckled mushroom
        1179,           -- 5 ice cold milk
        5350,           -- 0 conjured water
        159,            -- 0 refreshing spring water
    },
    -- ==== Pet Food

}
-- local foods = {
--     "Ripe Watermelon",
--     "Bobbing Apple",
-- }
