----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    --!! In use by Eat&Drink
    Class {Spell{ID,cd}}
    
    ]]
    ----------------------------------------------------------------------------------------------------------
    Arch_locationswd = {
        ["location"] = {
            ["title"] = "",
            ["desc"] = "",
            -- ["continent"] = "",
            -- ["location"] = "",
            -- ["sublocation"] = "",
            ["map"] = 0,
            ["x"] = 50.00,
            ["y"] = 50.00,
        }
    }

--     AddWaypoint creates a new waypoint. The options are:
-- * title: Required string describing the waypoint
-- * source: Required string describing who is setting the waypoint.
--           This will be displayed when mosuing over the arrow or waypoint.
-- * persistent: Optional boolean saying if the waypoint should persist across logins.
-- * minimap: Optional Boolean that defaults to the profile.minimap.enable
-- * minimap_icon: Optional texture that defaults to profile.minimap.icon
-- * minimap_icon_size: Optional texture that defaults to profile.minimap.icon_size
-- * world: Optional Boolean that defaults to the profile.worldmap.enable
-- * worldmap_icon: Optional Boolean that defaults to the profile.worldmap.icon
-- * worldmap_icon_size: Optional Boolean that defaults to the profile.worldmap.icon_size
-- * crazy: Optional Boolean that defaults to profile.arrow.autoqueue 
-- * cleardistance: Optional number that defaults to profile.persistence.cleardistance
-- * arrivaldistance: Optional number that defaults to profile.arrow.arrival
-- * silent: Optional Boolean that suppresses announcing the creation of the waypoint
-- * callbacks: Overrides for the default callbacks