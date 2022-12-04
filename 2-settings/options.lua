----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = LibStub("AceLocale-3.0"):GetLocale("Archrist") -- :: translations usage: L['<data>']
----------------------------------------------------------------------------------------------------------

A.options = {
    name = "Archrist",
    type = "group",
    childGroups = "tab",
    args = {
        About = {
            name = "About",
            desc = "Deskripsiyon",
            type = "group",
            order = 1,
            args = {
                description = {
                    name = L["archrist_about_description"],
                    type = "description",
                    order = 1,
                    fontSize = "medium"
                },
                head_modules = {
                    name = "Functions",
                    type = "header",
                    order = 2
                },
                desc_modules = {
                    name = L["archrist_about_modules"],
                    type = "description",
                    order = 3,
                    fontSize = "medium"
                },
                head_info = {
                    name = "",
                    type = "header",
                    order = 4
                },
                desc_info = {
                    name = "",
                    type = "group",
                    inline = true,
                    order = 5,
                    args = {
                        info_11version = {
                            name = L["archrist_about_info_version"] .. A.version,
                            type = "description",
                            order = 1,
                            width = 1.5,
                            fontSize = "medium"
                        },
                        info_21release = {
                            name = L["archrist_about_info_releaseDate"] .. A.releaseDate,
                            type = "description",
                            order = 2,
                            width = 1.5,
                            fontSize = "medium"
                        },
                        info_12author = {
                            name = L["archrist_about_info_author"],
                            type = "description",
                            order = 1,
                            width = 1.5,
                            fontSize = "medium"
                        },
                        info_22discord = {
                            name = L["archrist_about_info_discord"],
                            type = "description",
                            order = 2,
                            width = 1.5,
                            fontSize = "medium"
                        },
                    }
                }
            }

        },
        Macros = {
            name = "Macros",
            desc = "Desc",
            type = "group",
            order = 2,
            args = {
                intro1 = {
                    name = "",
                    type = "description",
                    order = 1,
                    fontSize = "medium"
                }
            }
        },
        Modules = {
            name = "Modules",
            desc = "Desc",
            type = "group",
            order = 3,
            args = {
                intro1 = {
                    name = "",
                    type = "description",
                    order = 1,
                    fontSize = "medium"
                }
            }

        }
        --   enable = {
        -- 	name = "Enable",
        -- 	desc = "Enables / disables the addon",
        -- 	type = "toggle",
        -- 	-- set = function(info,val) MyAddon.enabled = val end,
        -- 	-- get = function(info) return MyAddon.enabled end
        --   },
    }
}
