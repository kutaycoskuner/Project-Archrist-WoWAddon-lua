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
            [2836] = {1, "mining"}
        }
    },
    [100] = {
        -- coarse dynamite
        ['item'] = 4365,
        ['howtolearn'] = "trainer",
        ["levels"] = {75, 90, 97, 105},
        ['mats'] = {
            -- coarse blasting powder
            [4364] = {3, "engineering"},
            -- linen cloth
            [2589] = {1, "drop"}
        }
    },
    [105] = {
        -- silver contact
        ['item'] = 4404,
        ['howtolearn'] = "trainer",
        ["levels"] = {90, 110, 125, 140},
        ['mats'] = {
            -- silver bar
            [2842] = {1, "mining"}
        }
    },
    [125] = {
        -- bronze tube
        ['item'] = 4371,
        ['howtolearn'] = "trainer",
        ["levels"] = {105, 105, 130, 155},
        ['mats'] = {
            -- bronze bar
            [2841] = {2, "mining"},
            -- weak flux
            [2880] = {1, "vendor"}
        }
    },
    [140] = {
        -- heavy blasting powder
        ['item'] = 4377,
        ['howtolearn'] = "trainer",
        ["levels"] = {125, 125, 135, 145},
        ['mats'] = {
            -- heavy stone
            [2838] = {1, "mining"}
        }
    },
    [150] = {
        -- whirring bronze gizmo
        ['item'] = 4375,
        ['howtolearn'] = "trainer",
        ["levels"] = {125, 125, 150, 175},
        ['mats'] = {
            -- bronze bar
            [2841] = {2, "mining"},
            -- wool cloth
            [2592] = {3, "drop"}
        }
    },
    [160] = {
        -- bronze framework
        ['item'] = 4382,
        ['howtolearn'] = "trainer",
        ["levels"] = {145, 145, 170, 195},
        ['mats'] = {
            -- bronze bar
            [2841] = {2, "mining"},
            -- wool cloth
            [2592] = {3, "drop"},
            -- medium leather
            [2319] = {1, "skinning"}
        }
    },
    [175] = {
        -- explosive sheep
        ['item'] = 4384,
        ['howtolearn'] = "trainer",
        ["levels"] = {150, 175, 187, 200},
        ['mats'] = {
            -- bronze framework
            [4382] = {1, "engineering"},
            -- whirring bronze gizmo
            [4375] = {1, "engineering"},
            -- medium leather
            [4377] = {2, "engineering"},
            -- wool cloth
            [2592] = {2, "drop"}
        }
    },
    [176] = {
        -- gyromatic micro-adjustor
        ['item'] = 10498,
        ['howtolearn'] = "trainer",
        ["levels"] = {175, 175, 195, 215},
        ['mats'] = {
            -- steel bar
            [3859] = {4, "mining"}
        }
    },
    [195] = {
        -- solid blasting powder
        ['item'] = 10505,
        ['howtolearn'] = "trainer",
        ["levels"] = {175, 175, 185, 195},
        ['mats'] = {
            -- solid stone
            [7912] = {2, "mining"}
        }
    },
    [200] = {
        -- mithril tube
        ['item'] = 10559,
        ['howtolearn'] = "trainer",
        ["levels"] = {195, 195, 215, 235},
        ['mats'] = {
            -- mithril bar
            [3860] = {3, "mining"}
        }
    },
    [215] = {
        -- unstable trigger
        ['item'] = 10560,
        ['howtolearn'] = "trainer",
        ["levels"] = {200, 200, 220, 240},
        ['mats'] = {
            -- mithril bar
            [3860] = {1, "mining"},
            -- mageweave cloth
            [4338] = {1, "drop"},
            -- solid blasting powder
            [10505] = {1, "engineering"}
        }
    },
    [235] = {
        -- mithril casing
        ['item'] = 10561,
        ['howtolearn'] = "trainer",
        ["levels"] = {215, 215, 235, 255},
        ['mats'] = {
            -- mithril bar
            [3860] = {3, "mining"}
        }
    },
    [250] = {
        -- hi-explosive bombs
        ['item'] = 10562,
        ['howtolearn'] = "trainer",
        ["levels"] = {235, 235, 255, 275},
        ['mats'] = {
            -- mithril casing
            [10561] = {2, "engineering"},
            -- unstable trigger
            [10560] = {1, "engineering"},
            -- solid blasting powder
            [10505] = {2, "engineering"}
        }
    },
    [260] = {
        -- dense blasting powder
        ['item'] = 15992,
        ['howtolearn'] = "trainer",
        ["levels"] = {250, 250, 255, 260},
        ['mats'] = {
            -- dense stone
            [12365] = {2, "mining"}
        }
    },
    [285] = {
        -- thorium widget
        ['item'] = 15994,
        ['howtolearn'] = "trainer",
        ["levels"] = {260, 280, 290, 300},
        ['mats'] = {
            -- thorium bar
            [12359] = {3, "mining"},
            -- runecloth
            [14047] = {1, "drop"}
        }
    },
    [300] = {
        -- thorium shells
        ['item'] = 15997,
        ['howtolearn'] = "trainer",
        ["levels"] = {285, 295, 300, 305},
        ['mats'] = {
            -- thorium bar
            [12359] = {2, "mining"},
            -- dense blasting powder
            [15992] = {1, "engineering"}
        }
    },
    [310] = {
        -- handful of fel iron bolts
        ['item'] = 23783,
        ['howtolearn'] = "trainer",
        ["levels"] = {300, 300, 305, 310},
        ['mats'] = {
            -- fel iron bar
            [23445] = {1, "mining"},
        }
    },
    [320] = {
        -- fel iron casing
        ['item'] = 23782,
        ['howtolearn'] = "trainer",
        ["levels"] = {300, 300, 310, 320},
        ['mats'] = {
            -- fel iron bar
            [23445] = {3, "mining"},
        }
    },
    [330] = {
        -- fel iron bomb
        ['item'] = 23736,
        ['howtolearn'] = "trainer",
        ["levels"] = {300, 320, 330, 340},
        ['mats'] = {
            -- fel iron casing
            [23782] = {1, "engineering"},
            -- handful of fel iron bolts
            [23783] = {2, "engineering"},
            -- elemental blasting powder
            [23781] = {1, "engineering"},                    
        }
    },
    [335] = {
        -- adamantite grenade
        ['item'] = 23737,
        ['howtolearn'] = "trainer",
        ["levels"] = {300, 320, 330, 340},
        ['mats'] = {
            -- fel iron casing
            [23446] = {4, "mining"},
            -- handful of fel iron bolts
            [23783] = {2, "engineering"},
            -- elemental blasting powder
            [23781] = {1, "engineering"},                    
        }
    },
    [350] = {
        -- white-smoke flare
        ['item'] = 23768,
        ['howtolearn'] = "trainer",
        ["levels"] = {335, 335, 345, 355},
        ['mats'] = {
            -- netherweave cloth
            [21877] = {1, "drop"},
            -- elemental blasting powder
            [23781] = {1, "engineering"},                    
        }
    },
    [375] = {
        -- handful of cobalt bolts
        ['item'] = 39681,
        ['howtolearn'] = "trainer",
        ["levels"] = {350, 360, 370, 380},
        ['mats'] = {
            -- cobalt bar
            [36916] = {2, "mining"},                    
        }
    },
    [380] = {
        -- overcharged capacitor
        ['item'] = 39682,
        ['howtolearn'] = "trainer",
        ["levels"] = {375, 380, 385, 390},
        ['mats'] = {
            -- cobalt bar
            [36916] = {4, "mining"},                    
            -- crystallized earth
            [37701] = {1, "drop"},        
        }
    },
    [390] = {
        -- explosive decoy
        ['item'] = 40536,
        ['howtolearn'] = "trainer",
        ["levels"] = {375, 385, 390, 395},
        ['mats'] = {
            -- frostweave cloth
            [33470] = {1, "drop"},                    
            -- volatile blasting trigger
            [39690] = {3, "engineering"},        
        }
    },
    [400] = {
        -- froststeel tube
        ['item'] = 39683,
        ['howtolearn'] = "trainer",
        ["levels"] = {390, 395, 400, 405},
        ['mats'] = {
            -- cobalt bar
            [36916] = {8, "mining"},                    
            -- crystallized water
            [37705] = {1, "drop"},        
        }
    }
}
