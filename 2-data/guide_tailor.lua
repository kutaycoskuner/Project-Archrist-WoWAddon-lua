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

-- Arch_guide_tailor_resources = {
--     -- ==== [itemID] = {amount required, minus/plus, how to acqure}
--     [300] = {
--         -- :: cloths 300
--         -- linen cloth
--         [2589] = {184, 54, "drop"},
--         -- wool cloth
--         [2592] = {90, 0, "drop"},
--         -- silk cloth
--         [4306] = {796, 8, "drop"},
--         -- mageweave cloth
--         [4338] = {340, 4, "drop"},
--         -- runecloth
--         [14047] = {704, 64, "drop"},
--         -- :: vendor items 300
--         -- coarse thread
--         [2320] = {49, 9, "vendor"},
--         -- fine thread
--         [2321] = {123, 3, "vendor"},
--         -- silken thread
--         [4291] = {20, 0, "vendor"},
--         -- heavy silken thread
--         [8343] = {65, 2, "vendor"},
--         -- blue dye
--         -- rune thread
--         [14341] = {66, 6, "vendor"},
--         [6260] = {32, 2, "vendor"},
--         -- bleach
--         [2324] = {10, 0, "vendor"},
--         -- red dye
--         [2604] = {60, 0, "vendor"},
--         -- orange dye
--         [6261] = {5, 0, "vendor"},
--         -- :: other professions 300
--         -- rugged leather
--         [8170] = {40, 4, "skinner"}
--     },
--     [350] = {
--         -- :: cloths 350
--         -- netherweave cloth
--         [21877] = {925, 0, "drop"},
--         -- :: vendor items 350
--         -- rune thread
--         [14341] = {35, 0, "vendor"},
--         -- netherweave robe
--         [21896] = {1, 0, "vendor"},
--         -- :: other profession 350
--         -- arcane dust
--         [22445] = {10, 0, "enchanter"},
--         -- :: knothide leather 350
--         [21887] = {10, 0, "skinner"}
--     },
--     [440] = {
--         -- :: cloths
--         -- frostweave cloth
--         [33470] = {2340, 240, "drop"},
--         -- :: vendor items
--         -- netherweave robe
--         [38426] = {130, 10, "vendor"},
--         -- :: other profesions
--         -- infinite dust
--         [34054] = {40, 0, "enchanter"},
--     }
-- }

-- Arch_guide_tailor_conversions = {
--     -- [t2 material] = {t1 material, amount}
--     -- bolt of linen cloth
--     [2996] = {2589, 2},
--     -- bolt of silk cloth
--     [4305] = {4306, 4}
-- }

Arch_guide_tailor = {
    -- tailor to 45
    [45] = {
        -- bolt of linen cloth
        ['item'] = 2996,
        ['howtolearn'] = "trainer",
        ["levels"] = {1, 25, 37, 50},
        ['mats'] = {
            -- linen cloth
            [2589] = {2, "drop"}
        },
        ["raw"] = { 
            [2589] = 184+54, 
        }
    },
    -- tailor to 45
    [70] = {
        -- heavy linen gloves
        ['item'] = 4307,
        ['howtolearn'] = "trainer",
        ["levels"] = {35, 60, 77, 95},
        ['mats'] = {
            -- bolt of linen cloth
            [2996] = {2, "crafted by tailor or ah"},
            -- coarse thread 
            [2320] = {1, "tailor vendor"}
        }
    },
    [75] = {
        -- reinfoced linen cape
        ['item'] = 2580,
        ['howtolearn'] = "trainer",
        ["levels"] = {60, 85, 102, 120},
        ['mats'] = {
            -- bolt of linen cloth
            [2996] = {2, "crafted by tailor or ah"},
            -- coarse thread
            [2320] = {3, "tailor vendor"}
        }
    },
    [100] = {
        -- bolt of woolen cloth
        ['item'] = 2997,
        ['howtolearn'] = "trainer",
        ["levels"] = {75, 90, 97, 105},
        ['mats'] = {
            -- wool cloth
            [2592] = {3, "drops from mobs or buy from ah"}
        }
    },
    [110] = {
        -- simple kilt
        ['item'] = 10047,
        ['howtolearn'] = "trainer",
        ["levels"] = {75, 100, 117, 135},
        ['mats'] = {
            -- bolt of linen cloth
            [2996] = {4, "crafted by tailor or ah"},
            -- fine thread
            [2321] = {1, "tailor vendor"}
        }
    },
    [125] = {
        -- double-stitched woolen shoulders
        ['item'] = 4314,
        ['howtolearn'] = "trainer",
        ["levels"] = {110, 135, 152, 170},
        ['mats'] = {
            -- bolt of woolen cloth
            [2997] = {3, "crafted by tailor or ah"},
            -- fine thread
            [2321] = {2, "tailor vendor"}
        }
    },
    [145] = {
        -- bolt of silk cloth
        ['item'] = 4305,
        ['howtolearn'] = "trainer",
        ["levels"] = {125, 135, 140, 145},
        ['mats'] = {
            -- silk cloth
            [4306] = {4, "drop"}
        }
    },
    [160] = {
        -- azure silk hood
        ['item'] = 7048,
        ['howtolearn'] = "trainer",
        ["levels"] = {145, 155, 160, 165},
        ['mats'] = {
            -- bolt of silk cloth
            [4305] = {2, "tailor craft"},
            -- blue dye
            [6260] = {2, "tailor vendor"},
            -- fine thread    
            [2321] = {1, "tailor vendor"}
        }
    },
    [170] = {
        -- silk headband
        ['item'] = 7050,
        ['howtolearn'] = "trainer",
        ["levels"] = {160, 170, 175, 180},
        ['mats'] = {
            -- bolt of silk cloth
            [4305] = {3, "tailor craft"},
            -- fine thread
            [2321] = {2, "tailor vendor"}
        }
    },
    [175] = {
        -- formal white shirt
        ['item'] = 4334,
        ['howtolearn'] = "trainer",
        ["levels"] = {170, 180, 185, 190},
        ['mats'] = {
            -- bolt of silk cloth
            [4305] = {3, "tailor craft"},
            -- bleach
            [2324] = {2, "tailor vendor"},
            -- fine thread  
            [2321] = {1, "tailor vendor"}
        }
    },
    [185] = {
        -- bolt of mageweave
        ['item'] = 4339,
        ['howtolearn'] = "trainer",
        ["levels"] = {175, 180, 182, 185},
        ['mats'] = {
            -- mageweave cloth
            [4338] = {4, "drop"}
        }
    },
    [205] = {
        -- crimson silk vest
        ['item'] = 7058,
        ['howtolearn'] = "trainer",
        ["levels"] = {185, 205, 215, 225},
        ['mats'] = {
            -- bolt of silk cloth
            [4305] = {4, "tailor craft"},
            -- red dye
            [2604] = {2, "tailor vendor"},
            -- fine thread
            [2321] = {2, "tailor vendor"}
        }
    },
    [215] = {
        -- crimson silk pantaloons
        ['item'] = 7062,
        ['howtolearn'] = "trainer",
        ["levels"] = {195, 215, 225, 235},
        ['mats'] = {
            -- bolt of silk cloth
            [4305] = {4, "tailor craft"},
            -- red dye
            [2604] = {2, "tailor vendor"},
            -- silken thread
            [4291] = {2, "tailor vendor"}
        }
    },
    [220] = {
        -- orange mageweave shirt
        ['item'] = 7062,
        ['howtolearn'] = "trainer",
        ["levels"] = {195, 215, 225, 235},
        ['mats'] = {
            -- bolt of silk cloth
            [4305] = {4, "tailor craft"},
            -- red dye
            [2604] = {2, "tailor vendor"},
            -- silken thread
            [4291] = {2, "tailor vendor"}
        }
    },
    [230] = {
        -- black mageweave gloves
        ['item'] = 10003,
        ['howtolearn'] = "trainer",
        ["levels"] = {215, 230, 245, 260},
        ['mats'] = {
            -- bolt of silk cloth
            [4339] = {2, "tailor craft"},
            -- heavy silken thread
            [8343] = {2, "tailor vendor"}
        }
    },
    [250] = {
        -- black mageweave shoulders
        ['item'] = 10027,
        ['howtolearn'] = "trainer",
        ["levels"] = {230, 245, 260, 275},
        ['mats'] = {
            -- bolt of silk cloth
            [4339] = {3, "tailor craft"},
            -- heavy silken thread
            [8343] = {2, "tailor vendor"}
        }
    },
    [260] = {
        -- bolt of runecloth
        ['item'] = 14048,
        ['howtolearn'] = "trainer",
        ["levels"] = {250, 255, 257, 260},
        ['mats'] = {
            -- rune cloth
            [14047] = {4, "drop"}
        }
    },
    [280] = {
        -- Runecloth Bag
        ['item'] = 14046,
        ['howtolearn'] = "trainer",
        ["levels"] = {260, 275, 290, 305},
        ['mats'] = {
            -- bolt of runecloth
            [14048] = {5, "tailor craft"},
            -- rugged leather
            [8170] = {2, "skinning, ah"},
            -- bolt of runecloth
            [14341] = {1, "tailor vendor"}
        }
    },
    [300] = {
        -- Runecloth Gloves
        ['item'] = 13863,
        ['howtolearn'] = "trainer",
        ["levels"] = {275, 290, 300, 320},
        ['mats'] = {
            -- bolt of runecloth
            [14048] = {5, "tailor craft"},
            -- bolt of runecloth
            [14341] = {2, "tailor vendor"}
        }
    },
    [325] = {
        -- Bolt of Netherweave
        ['item'] = 21840,
        ['howtolearn'] = "trainer",
        ["levels"] = {300, 305, 315, 325},
        ['mats'] = {
            -- bolt of runecloth
            [21877] = {5, "tailor craft"}
        }
    },
    [330] = {
        -- Bolt of Imbued Netherweave
        ['item'] = 21842,
        ['howtolearn'] = "trainer",
        ["levels"] = {325, 330, 335, 340},
        ['mats'] = {
            -- bolt of netherweave
            [21840] = {3, "tailor craft"},
            -- bolt of netherweave
            [22445] = {2, "disenchanting"}
        }
    },
    [335] = {
        -- netherweave pants
        ['item'] = 26772,
        ['howtolearn'] = "trainer",
        ["levels"] = {325, 335, 340, 345},
        ['mats'] = {
            -- bolt of netherweave
            [21840] = {6, "tailor craft"},
            -- rune thread
            [14341] = {1, "vendor"},
        }
    },
    [340] = {
        -- netherweave boots
        ['item'] = 26772,
        ['howtolearn'] = "trainer",
        ["levels"] = {335, 345, 350, 355},
        ['mats'] = {
            -- bolt of netherweave
            [21840] = {6, "tailor craft"},
            -- knothide leather
            [21887] = {2, "skinning"},            
            -- rune thread
            [14341] = {1, "vendor"},
        }
    },
    [350] = {
        -- netherweave robe
        ['item'] = 21854,
        ['howtolearn'] = "trainer",
        ["levels"] = {340, 350, 355, 360},
        ['mats'] = {
            -- bolt of netherweave
            [21840] = {8, "tailor craft"},
            -- rune thread
            [14341] = {2, "vendor"},
        }
    },
    [375] = {
        -- bolt of frostweave
        ['item'] = 41510,
        ['howtolearn'] = "trainer",
        ["levels"] = {350, 370, 372, 375},
        ['mats'] = {
            -- frostweave cloth
            [33470] = {5, "drop"},
        }
    },
    [380] = {
        -- frostwoven belt
        ['item'] = 41522,
        ['howtolearn'] = "trainer",
        ["levels"] = {370, 380, 390, 400},
        ['mats'] = {
            -- bolt of frostweave
            [41510] = {3, "tailor"},
            -- eternium thread
            [38426] = {1, "vendor"},
        }
    },
    [385] = {
        -- frostwoven boots
        ['item'] = 41520,
        ['howtolearn'] = "trainer",
        ["levels"] = {375, 385, 395, 405},
        ['mats'] = {
            -- bolt of frostweave
            [41510] = {4, "tailor"},
            -- eternium thread
            [38426] = {1, "vendor"},
        }
    },
    [395] = {
        -- frostwoven cowl
        ['item'] = 41521,
        ['howtolearn'] = "trainer",
        ["levels"] = {380, 390, 400, 410},
        ['mats'] = {
            -- bolt of frostweave
            [41510] = {5, "tailor"},
            -- eternium thread
            [38426] = {1, "vendor"},
        }
    },
    [400] = {
        -- duskweave belt
        ['item'] = 41543,
        ['howtolearn'] = "trainer",
        ["levels"] = {395, 400, 405, 410},
        ['mats'] = {
            -- bolt of frostweave
            [41510] = {7, "tailor"},
            -- eternium thread
            [38426] = {1, "vendor"},
        }
    }
}
