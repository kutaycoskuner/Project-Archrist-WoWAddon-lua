----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = LibStub("AceLocale-3.0"):GetLocale("Archrist") -- :: translations usage: L['<data>']
----------------------------------------------------------------------------------------------------------

local assist_groupCooldowns = {
    name = "",
    type = "group",
    order = 1,
    inline = true,
    args = {
        title = {
            name = "Group Cooldown Tracker",
            order = 1,
            type = "header"
        },
        options = {
            name = "",
            type = "group",
            order = 2,
            inline = true,
            args = {
                desc = {
                    name = "Allow you to track selected cooldowns for your group\n\n|cfff7882f /cr |r shows the cooldown tracker frame\n|cfff7882f /cr lock |r locks window\n|cfff7882f /cr move |r activates window dragging \n\n",
                    type = "description",
                    order = 1,
                    width = "full"
                },
                opt_skills_druid = {
                    name = "Skills",
                    type = "group",
                    order = 2,
                    width = "full",
                    desc = "",
                    args = {
                        opt_enable = {
                            name = "Innervate",
                            type = "toggle",
                            width = 1.5,
                            order = 1,
                            set = function(info, val)
                                A.global.assist.groupCooldown.spells["Innervate"] = val
                                A:GetModule("CRIndicator", true):scanGroup()
                            end,
                            get = function(info)
                                return A.global.assist.groupCooldown.spells["Innervate"]
                            end
                        },
                        opt_enable2 = {
                            name = "Rebirth",
                            type = "toggle",
                            width = 1.5,
                            order = 1,
                            set = function(info, val)
                                A.global.assist.groupCooldown.spells["Rebirth"] = val
                                A:GetModule("CRIndicator", true):scanGroup()
                            end,
                            get = function(info)
                                return A.global.assist.groupCooldown.spells["Rebirth"]
                            end
                        },
                        opt_enable3 = {
                            name = "Soulstone Resurrection",
                            type = "toggle",
                            width = 1.5,
                            order = 1,
                            set = function(info, val)
                                A.global.assist.groupCooldown.spells["Soulstone Resurrection"] = val
                                A:GetModule("CRIndicator", true):scanGroup()
                            end,
                            get = function(info)
                                return A.global.assist.groupCooldown.spells["Soulstone Resurrection"]
                            end
                        },
                        opt_enable4 = {
                            name = "Misdirection",
                            type = "toggle",
                            width = 1.5,
                            order = 1,
                            set = function(info, val)
                                A.global.assist.groupCooldown.spells["Misdirection"] = val
                                A:GetModule("CRIndicator", true):scanGroup()
                            end,
                            get = function(info)
                                return A.global.assist.groupCooldown.spells["Misdirection"]
                            end
                        },
                        opt_enable5 = {
                            name = "Reincarnation",
                            type = "toggle",
                            width = 1.5,
                            order = 1,
                            set = function(info, val)
                                A.global.assist.groupCooldown.spells["Reincarnation"] = val
                                A:GetModule("CRIndicator", true):scanGroup()
                            end,
                            get = function(info)
                                return A.global.assist.groupCooldown.spells["Reincarnation"]
                            end
                        },
                    }
                },
                -- opt_msg = {
                --     name = "Enter message you want to display",
                --     desc = "",
                --     width = "full",
                --     type = "input",
                --     order = 4,
                --     set = function(_, msg)
                --         A.global.utility.posture.text = msg
                --     end,
                --     get = function()
                --         return A.global.utility.posture.text
                --     end
                -- }
            }
        }
    }
}

local util_postureCheck = {
    name = "",
    type = "group",
    order = 1,
    inline = true,
    args = {
        title = {
            name = "Posture Check",
            order = 1,
            type = "header"
        },
        options = {
            name = "",
            type = "group",
            order = 2,
            inline = true,
            args = {
                opt_enable = {
                    name = "Enable",
                    desc = "Enables / disables the module",
                    type = "toggle",
                    order = 1,
                    width = "half",
                    set = function(info, val)
                        A.global.utility.posture.isEnabled = val
                    end,
                    get = function(info)
                        return A.global.utility.posture.isEnabled
                    end
                },
                desc = {
                    name = "Sends you messages for interval to check your posture",
                    type = "description",
                    order = 1,
                    width = 2
                },
                opt_size = {
                    type = "select",
                    order = 2,
                    values = {15, 30, 45, 60},
                    style = 'dropdown',
                    -- disabled = function() return asdfasdf end,
                    name = function()
                        return 'Intervals (Min)'
                    end,
                    -- desc = function()
                    --     return "Some Stuff";
                    -- end,
                    get = function()
                        return A.global.utility.posture.timeInMin
                    end,
                    set = function(_, key)
                        A.global.utility.posture.timeInMin = key
                    end
                },
                opt_announceType = {
                    type = "select",
                    order = 2,
                    values = {"Self", "Party", "Raid"},
                    style = 'dropdown',
                    name = function()
                        return 'Channel'
                    end,
                    get = function()
                        return A.global.utility.posture.announceType
                    end,
                    set = function(_, key)
                        A.global.utility.posture.announceType = key
                    end
                },
                opt_msg = {
                    name = "Enter message you want to display",
                    desc = "",
                    width = "full",
                    type = "input",
                    order = 4,
                    set = function(_, msg)
                        A.global.utility.posture.text = msg
                    end,
                    get = function()
                        return A.global.utility.posture.text
                    end
                }
            }
        }
    }
}

local util_lootFilter = {
    name = "",
    type = "group",
    order = 1,
    inline = true,
    args = {
        title = {
            name = "Loot Filter",
            order = 1,
            type = "header"
        },
        options = {
            name = "",
            type = "group",
            order = 2,
            inline = true,
            args = {
                opt_enable = {
                    name = "Enable",
                    desc = "Enables / disables the module",
                    type = "toggle",
                    order = 1,
                    width = "half",
                    set = function(info, val)
                        A.global.utility.lootFilter.isEnabled = val
                    end,
                    get = function(info)
                        return A.global.utility.lootFilter.isEnabled
                    end
                },
                desc = {
                    name = "Filters out greed log entries on chat for more clean",
                    type = "description",
                    order = 1,
                    width = 2
                }
            }
        }
    }
}

local macro_disench = {
    name = "",
    type = "group",
    order = 1,
    inline = true,
    args = {
        title = {
            name = "Disenchanting",
            order = 1,
            type = "header"
        },
        options = {
            name = "",
            type = "group",
            order = 2,
            inline = true,
            args = {
                opt_enable = {
                    name = "Enable",
                    desc = "Enables / disables the module",
                    type = "toggle",
                    order = 1,
                    width = "full",
                    set = function(info, val)
                        if A.global.macros.disenchanting.isEnabled then
                            UIParent:Hide()
                            print(L["archrist"] .. ' Deleting macro for disenchanting')
                            DeleteMacro(" Disenchanting")
                            UIParent:Show()
                            ShowMacroFrame()
                        else
                            UIParent:Hide()
                            print(L["archrist"] .. ' Creating macro for disenchanting')
                            CreateMacro(" Disenchanting", "inv_enchant_disenchant",
                                "/run setdisenchantButton()\n/click disenchantButton", nil)
                            UIParent:Show()
                            ShowMacroFrame()
                        end
                        A.global.macros.disenchanting.isEnabled = val
                    end,
                    get = function(info)
                        return A.global.macros.disenchanting.isEnabled
                    end
                },
                opt_desc = {
                    name = "\nEnabling will create a macro for you. You can alter the name and icon afterwards but turn off your macro screen before creating or removing a macro\n",
                    type = "description",
                    order = 1,
                    width = "full"
                },
                -- opt_macro = {
                --     name = "",
                --     type = "input",
                --     order = 2,
                --     multiline = true,
                --     width = "full",
                --     set = function(info, val)
                --         return "|cffbf4aa8/run setdisenchantButton()\n/click disenchantButton|r"
                --     end,
                --     get = function(info)
                --         return "|cffbf4aa8/run setdisenchantButton()\n/click disenchantButton|r"
                --     end
                -- },
                opt_range1 = {
                    name = "Min Item Level",
                    type = "range",
                    order = 3,
                    width = 1,
                    min = 1,
                    max = 400,
                    step = 1,
                    set = function(info, val)
                        A.global.macros.disenchanting.min = val
                    end,
                    get = function(info)
                        return A.global.macros.disenchanting.min
                    end
                },
                opt_range2 = {
                    name = "Max Item Level",
                    type = "range",
                    order = 3,
                    width = 1,
                    min = 1,
                    max = 400,
                    step = 1,
                    set = function(info, val)
                        A.global.macros.disenchanting.max = val
                    end,
                    get = function(info)
                        return A.global.macros.disenchanting.max
                    end
                },
                opt_rarity = {
                    type = "select",
                    order = 3,
                    values = {"Common", "Uncommon", "Rare", "Epic", "Legendary"},
                    style = 'dropdown',
                    name = function()
                        return 'Rarity Uplimit'
                    end,
                    get = function()
                        return A.global.macros.disenchanting.maxRarity
                    end,
                    set = function(_, key)
                        A.global.macros.disenchanting.maxRarity = key
                    end
                }
            }
        }
    }
}

---------------------------------------------------------------------------------------------------
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
                        }
                    }
                }
            }

        },
        Assistance = {
            name = "Assistance",
            desc = "Desc",
            type = "group",
            order = 2,
            args = {
                groupCooldowns = assist_groupCooldowns
            }

        },
        -- Guide = {
        --     name = "Guide",
        --     desc = "Desc",
        --     type = "group",
        --     order = 3,
        --     args = {
        --         intro1 = {
        --             name = "",
        --             type = "description",
        --             order = 1,
        --             fontSize = "medium"
        --         }
        --     }

        -- },
        Utility = {
            name = "Utility",
            type = "group",
            order = 4,
            args = {
                postureCheck = util_postureCheck,
                lootFilter = util_lootFilter
            }

        },
        -- ExternalMemory = {
        --     name = "External Memory",
        --     desc = "Desc",
        --     type = "group",
        --     order = 5,
        --     args = {
        --         intro1 = {
        --             name = "",
        --             type = "description",
        --             order = 1,
        --             fontSize = "medium"
        --         }
        --     }
        -- },
        ExtendedMacros = {
            name = "Extended Macros",
            desc = "Desc",
            type = "group",
            order = 6,
            args = {
                disench = macro_disench
            }

        }
    }
}
