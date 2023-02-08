----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    --!! In use by CRIndicator
    Class {Spell{ID,cd}}
    
    ]]
Arch_levelingGuide = {
    ["1-10"] = {
        ["Elwynn Forest"] = {
            ["chapters"] = {
                [1] = {
                    ["name"] = "To Goldshire",
                    ["steps"] = {
                        [1] = {
                            ["quest"] = 783,
                            ["questName"] = "A Threat Within",
                            ["task"] = "accept",
                            ["desc"] = "Accept the |cffcc9933[A Threat Within]|r",
                            ["coords"] = {
                                ["x"] = 48.06,
                                ["y"] = 43.65
                            }
                        },
                        [2] = {
                            ["quest"] = 783,
                            ["questName"] = "A Threat Within",
                            ["task"] = "complete",
                            ["desc"] = "Complete |cffcc9933[A Threat Within]|r",
                            ["coords"] = {
                                ["x"] = 48.88,
                                ["y"] = 41.66
                            }
                        },
                        [3] = {
                            ["quest"] = 7,
                            ["questName"] = "Kobold Camp Cleanup",
                            ["task"] = "accept", -- kill | collect
                            ["desc"] = "Accept |cffcc9933[Kobold Camp Cleanup]|r",
                            ["coords"] = {
                                ["x"] = 48.88,
                                ["y"] = 41.66
                            }
                        },
                        [4] = {
                            ["quest"] = 5261,
                            ["questName"] = "Eagan Peltskinner",
                            ["task"] = "accept", -- kill | collect
                            ["desc"] = "Accept |cffcc9933[Eagan Peltskinner]|r",
                            ["coords"] = {
                                ["x"] = 48.07,
                                ["y"] = 43.43
                            }
                        },
                        [5] = {
                            ["quest"] = 5261,
                            ["questName"] = "Eagan Peltskinner",
                            ["task"] = "complete", -- kill | collect
                            ["desc"] = "Complete |cffcc9933[Eagan Peltskinner]|r",
                            ["coords"] = {
                                ["x"] = 48.86,
                                ["y"] = 40.16
                            }
                        }
                        ,
                        [6] = {
                            ["quest"] = 5261,
                            ["questName"] = "Eagan Peltskinner",
                            ["task"] = "complete", -- kill | collect
                            ["desc"] = "Complete |cffcc9933[Eagan Peltskinner]|r",
                            ["coords"] = {
                                ["x"] = 48.86,
                                ["y"] = 40.16
                            }
                        }
                    }
                }
                -- [2] = {}
            }
        }
    }
}
