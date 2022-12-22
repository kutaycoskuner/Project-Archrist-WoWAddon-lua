----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------

--[[
    --!! In use by Help
    --!! options
    -- Add =  Addon data
    - data
        - tip
        - content
            - title = string
            - desc = table
            - commands = table
            - conditionals = table
            - functions = table

    ]]

local aCol = Arch_addonColor
local fCol = Arch_focusColor
local cCol = Arch_commandColor

Arch_help_content = {
    [""] = {
        ["title"] = "",
        ["desc"] = {'Archrist is multi-purpose asisstant addon with various functionalities for \n' ..
            aCol("Wrath of the Lich King") .. " expansion pack."},
        ["commands"] = {'Use ' .. Arch_commandColor('/arch help') .. ' command to see modules',
                        'Use ' .. Arch_commandColor('/arch config') .. ' command to see interface options'},
        ["conditionals"] = {},
        ["functions"] = {}
    },
    ["v"] = {
        ["title"] = "",
        ["desc"] = {"version: " .. Arch_focusColor(A.version) .. " release date: " .. Arch_focusColor(A.releaseDate)},
        ["commands"] = {},
        ["conditionals"] = {},
        ["functions"] = {}
    },
    ["config"] = {
        ["title"] = "",
        ["desc"] = {},
        ["commands"] = {},
        ["conditionals"] = {},
        ["functions"] = {A.OpenInterfaceConfig}
    },
    ["help"] = {
        ["title"] = "Help",
        ["desc"] = {},
        ["commands"] = {cCol('/arch <modulename>') .. ' to get detailed information'},
        ["conditionals"] = {
            ["TodoList"] = 'Helps you to create todo list',
            ["PlayerDB"] = 'Player database module for interactions',
            ["Pug"] = 'For creating fast and editable PuG announces',
            ["VoA"] = 'For Creating specific VoA18 spec run announcements',
            ["CRIndicator"] = 'Raid combat res indicator for leading',
            ["RaidCommands"] = 'Work in progress not yet finished',
            ["Macro"] = 'Allows you to create your own macros more than 255 characters with lua',
            ["CraftGuides"] = "Crafting skill guides and material calculator imported from warcrafttavern. Currently only for tailor and engineering.",
            ["GroupOrganizer"] = "Automatic role categorization and sequence announcing for encounters."
            -- Util-PostureCheck
            -- Util-LootFilter
            -- Macro-AutoMount
            -- Macro-Disenchant
            -- Announcer
        },
        ["functions"] = {}
    },
    ["todolist"] = {
        ["title"] = 'Todo List',
        ["desc"] = {'note taking and todo list module'},
        ["commands"] = {cCol('/todo') .. ' to see your current todo list',
                        cCol('/todo <note>') .. ' for creating new todo on console'},
        ["conditionals"] = {},
        ["functions"] = {}
    },
    ["playerdb"] = {
        ["title"] = "Player Database",
        ["desc"] = {'playerscoring and note taking module for your interactions',
                    'quantitative parameters: damage[dmg], strategy[str], reputation[rep], attendance[att], discipline[dsc]', 'qualitative parameters: note[not]'},
        ["commands"] = {Arch_commandColor('/rep') .. ' present player details if existing in database',
                        Arch_commandColor('/rep <number>') .. ' increases or decreases score',
                        Arch_commandColor('/rep <playername> <number>') .. ' non target variant',
                        Arch_commandColor('/not <note>') .. ' taking not for target player',
                        Arch_commandColor('/not <playername> <note>') .. ' non target variant',
                        Arch_commandColor('/rrep') ..
            ' without parameter checks if anyone has negative reputation in your group',
                        Arch_commandColor('/rrep <number>') .. ' gives everyone a given reputation in the group',
                        Arch_commandColor('/rep') ..
            ' adds target person to your database, if target is already added displays data',
            cCol('/dsc ') .. cCol('/str ') .. cCol('/att ') .. cCol('/dmg') .. ' commands will also work same way for other quantitative parameters'
        },
        ["conditionals"] = {},
        ["functions"] = {}

    },
    ["crindicator"] = {
        ["title"] = 'Cooldown Tracker [CRIndicator]',
        ["desc"] = {'simple frame module to inform raid leader how many crucial raid cooldowns are available in raid'},
        ["commands"] = {Arch_commandColor('/cr') .. ' for toggle frame|r',
                        Arch_commandColor('/cr move') .. ' for move frame|r',
                        Arch_commandColor('/cr lock') .. ' for lock frame|r'},
        ["conditionals"] = {},
        ["functions"] = {}
    },
    ["pug"] = {
        ["title"] = "PuG Raid Organizer",
        ["desc"] = {'Helps to creates adaptive raid forming announcements through interface'},
        ["commands"] = {Arch_commandColor('/pug') .. ' to activate frame|r'},
        ["conditionals"] = {},
        ["functions"] = {}

    },
    ["raidcommands"] = {
        ["title"] = "Raid Commands",
        ["desc"] = {},
        ["commands"] = {},
        ["conditionals"] = {},
        ["functions"] = {}
    },
    ["macro"] = {
        ["title"] = 'Extended Macros',
        ["desc"] = {'1. Create your own macro in 3-macro folder in addon',
                    '2. Give it a unique button name ex. feedButton',
                    '3. Create an ingame macro as "/run setFeedButton() /click feedButton"',
                    'Limitations: Due to prevent combat abuse: You cannot dynamically change macros in combat',
                    "Some built in macros you can find below or on " .. fCol("/arch config")},
        ["commands"] = {},
        ["conditionals"] = {},
        ["functions"] = {}
    },
    ["craftguides"] = {
        ["title"] = 'Crafting Guides',
        ["desc"] = {"Helps you to calculate and estimate necessary materials to grind crafting skills up to 400",
                    "By the guides imported from warcrafttavern.com",
                    "Currently only tailor and engineering guides are available."},
        ["commands"] = {cCol('/cra ') .. "to open interface and material list"},
        ["conditionals"] = {},
        ["functions"] = {}
    },
    ["grouporganizer"] = {
        ["title"] = 'Group Organizer',
        ["desc"] = {"This module categorizes people in your group on 4 main roles " .. fCol('tank heal mdps rdps'),
                    "And creates tasks groups of your preference to announce in sequence in encounters"},
        ["commands"] = {cCol('/org ') .. "scans and manifests group",
                        cCol('/org [tank | heal | mdps | rdps]') .. "assigns role to target",
                        cCol('/org tasks') .. " scans and present task groups",
                        cCol('/org focus') .. " creates and announces mage's focus magic link"},
        ["conditionals"] = {},
        ["functions"] = {}
    }
}
