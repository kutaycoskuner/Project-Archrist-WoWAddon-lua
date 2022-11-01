----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    data structure :
    [up to level] = {
        item id to create, 
        {
            [material#1 id] = "{required amount to create one, where to find info, skill contribution levels }
            ...
        }
    }
]]

-- https://www.warcrafttavern.com/wotlk/guides/tailoring-guide-1-450/
-- https://www.warcrafttavern.com/wotlk/guides/engineering-guide-1-450/

Arch_guide_engineer = {
    -- step 1
    [30] = {
        -- rough blasting powder
        ['item'] = 4357,
        ['howtolearn'] = "trainer",
        ["levels"] = {1, 20, 30, 40},
        ['mats'] = {
            -- rough blasting powder
            [2835] = {1, "mining"}
        }
    },
    -- step 2
    [50] = {
        -- handful of copper bolts
        ['item'] = 4359,
        ['howtolearn'] = "trainer",
        ["levels"] = {30, 45, 52, 60},
        ['mats'] = {
            -- copper bar
            [2840] = {1, "mining"}
        }
    },
    -- step 3
    [51] = {
        -- arclight spanner
        ['item'] = 6219,
        ['howtolearn'] = "trainer",
        ["levels"] = {50, 70, 80, 90},
        ['mats'] = {
            -- copper bar
            [2840] = {6, "mining"}
        }
    },
    -- step 2
    [75] = {
        -- rough copper bomb
        ['item'] = 4360,
        ['howtolearn'] = "trainer",
        ["levels"] = {30, 60, 75, 90},
        ['mats'] = {
            -- copper bar
            [2840] = {1, "mining"},
            -- handful of copper bolts
            [4359] = {1, "engineering craft"},
            -- rough blasting powder
            [4357] = {2, "engineering craft"},
            -- linen cloth
            [2589] = {1, "drop"}
        }
    },
    [90] = {
        -- coarse blasting powder
        ['item'] = 4364,
        ['howtolearn'] = "trainer",
        ["levels"] = {75, 85, 90, 95},
        ['mats'] = {
            -- coarse stone
            [2836] = {1, "mining"},
        }
    }
}
