----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    data structure :
    [up to level] = {
        item id to create, 
        {
            [material#1 id] = "{required amount to create one, where to find info}
            ...
        }
    }
]]

-- https://www.warcrafttavern.com/wotlk/guides/tailoring-guide-1-450/

Arch_guide_tailor = {
    -- tailor to 45
    [45] = {
        ['item'] = 2996,       -- bolt of linen cloth
        ['mats'] =
        {
            [2589] = {2, "drops from mobs or buy from ah"}  -- linen cloth     
        },
    },
    -- tailor to 45
    [70] = {
        ['item'] = 4307,       -- heavy linen gloves
        ['mats'] = 
        {
            [2996] = {2, "crafted by tailor or ah"},        -- bolt of linen cloth
            [2320] = {1, "tailor vendor"},                  -- coarse thread     
        },
    },
    [75] = {
        ['item'] = 2580,
        ['mats'] =        -- reinfoced linen cape
        {
            [2996] = {2, "crafted by tailor or ah"},        -- bolt of linen cloth
            [2320] = {3, "tailor vendor"},                  -- coarse thread     
        },
    },
    [100] = {
        ['item'] = 2997,
        ['mats'] =        -- bolt of woolen cloth
        {
            [2592] = {3, "drops from mobs or buy from ah"},  -- wool cloth
        },
    },
    [110] = {
        ['item'] = 10047,       -- simple kilt
        ['mats'] = 
        {
            [2996] = {4, "crafted by tailor or ah"},        -- bolt of linen cloth
            [2321] = {1, "tailor vendor"},                  -- fine thread
        },
    },
    [125] = {
        ['item'] = 4314,       -- double-stitched woolen shoulders
        ['mats'] = 
        {
            [2997] = {3, "crafted by tailor or ah"},        -- bolt of woolen cloth
            [2321] = {2, "tailor vendor"},                  -- fine thread
        },
    },

}
