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
        35947,          -- 75 sparkling frostcap
        35953,          -- 75 mead basted caribou
        43518,          -- 74 conjured mana pie
        39691,          -- 70 succulent orca stew   
        34759,          -- 70 smoken rockfin
        34125,          -- 70 showeltusk soup
        33452,          -- 65 Honey-Spiced Lichen
        29449,          -- 65 bladespire bagel
        33449,          -- 65 crusty flatbread
        33443,          -- 65 sour goat cheese
        33454,          -- 65 salted venison
        41751,          -- 55 black mushroom
        27859,          -- 55 zangar caps
        27854,          -- 55 smoken talbuk venison
        8952,           -- 45 roasted quail
        8076,           -- 45 conjured sweet roll
        21215,          -- 40 graccu's mince meat fruitcake
        8075,           -- 35 conjured sourdough
        1487,           -- 25 conjured pumpernickel
        3729,           -- 25 soothing turtle bisque
        4539,           -- 25 goldenbark appleF
        3771,           -- 25 wild hog shank
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
        5525,           -- 5 boiled clam meat
        4542,           -- 0 most cornbread
        117,            -- 0 tough jerky
        4536,           -- 0 shiny red apple
        23756,          -- 0 cookie's jumbo gumboca
        20389,          -- 0 candy corn
        7097,           -- 0 leg meat
        5057,           -- 0 ripe watermelon
        20516,          -- 0 bobbing apple
        44837,          -- 0 spice bread stuffing
        44836,          -- 0 pumpkin pie
        44840,          -- 0 cranberry chutney
        44838,          -- 0 slow-roasted turkey
    },    
    -- ==== Drinkables
    ["drinks"] = {
        43523,          -- 80 Conjured Mana Strudel
        41731,          -- 75 yeti milk
        33445,          -- 75 honeymint tea
        43518,          -- 74 conjured mana pie
        34759,          -- 70 smoken rockfin
        33444,          -- 70 pungent seal whey
        44750,          -- 65 mountain water
        30703,          -- 60 conjured mountain spring water
        28399,          -- 60 filtered draenic water
        8766,           -- 45 morning glory dewBCBCB
        8078,           -- 45 conjured sparkling water
        21215,          -- 40 graccu's mince meat fruitcake
        8077,           -- 35 conjured mineral water
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
        44837,          -- 0 spice bread stuffing
        44836,          -- 0 pumpkin pie
        44840,          -- 0 cranberry chutney
        44838,          -- 0 slow-roasted turkey
    },
    -- ==== Pet Food

}

Arch_futter = {
    ["meats"] = {
    },
    ["fishes"] = {
        12202,          -- meat tiger meat
        6308,           -- fish raw bristle catfish
        3667,           -- meat zartes krokoliskenfleisch
        12203,          -- red wolf meat
        
    }
}

-- local foods = {
--     "Ripe Watermelon",
--     "Bobbing Apple",
-- }
