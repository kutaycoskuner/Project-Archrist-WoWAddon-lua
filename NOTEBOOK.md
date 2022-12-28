# Notebook
- recreated 11-Oct-2022


# Where I left
- find a tolerance space between unfinished work commit and overstructured one because there is always a risk of messing 

# Comment Discipline

# Links
- curse project
    - https://authors.curseforge.com/#/projects

- xml ui
    - https://wowwiki-archive.fandom.com/wiki/XML_UI

- wow icons
    - https://wowpedia.fandom.com/wiki/Category:WoW_Icons

- raid buffs and debuffs
    - https://www.icy-veins.com/wotlk-classic/raid-buffs-and-debuffs

- leveling guides
    - class
        - mage
            - https://www.warcrafttavern.com/wotlk/guides/mage-leveling-guide/
    - profession

- libs
    - https://www.wowace.com/projects/herebedragons/pages/api/here-be-dragons-pins-2-0
    - https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation

- blizz interface code
    - https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/UIParent.lua
    - https://wowpedia.fandom.com/wiki/Using_the_Interface_Options_Addons_panel

- lua pattern matching
    - https://www.lua.org/pil/20.1.html

[1] mayron wow addon creation
https://www.youtube.com/watch?v=nfaE7NQhMlc&list=PL3wt7cLYn4N-3D3PTTUZBM2t1exFmoA2G

https://wowwiki.fandom.com/wiki/Portal:Interface_customization
https://wowwiki.fandom.com/wiki/FrameXML
https://wowwiki.fandom.com/wiki/Viewing_Blizzard%27s_WoW_user_interface_code
- framexml 3.3.5
https://www.townlong-yak.com/framexml/3.3.5
- ui
https://www.townlong-yak.com/framexml/live/UI.xsd
- blizzard api
https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentation
- wow event aapi
    https://wowwiki.fandom.com/wiki/Events/Mail
    https://wowpedia.fandom.com/wiki/API_GetNumRaidMembers
- reddit masterpost
https://old.reddit.com/r/classicwow/comments/bvbqo1//epokyf1/
- ace3 gui
https://www.wowace.com/projects/ace3/files/440275
- ace addon tutorial
https://wow.gamepedia.com/WelcomeHome_-_Your_first_Ace3_Addon
- wow addon making book
https://protokolo7.neocities.org/lua/WoW_Addons.pdf
- wow programming website
http://wowprogramming.com/utils.html
- backup and syncronize app
https://github.com/Total-RP/Total-RP-3/wiki/How-to-backup-and-synchronize-your-add-ons-settings-using-a-cloud-service
- lua variable scoping
https://wow.gamepedia.com/Lua_variable_scoping
- reddit index of addon making
https://www.reddit.com/r/wowaddons/wiki/index
- global strings
https://www.townlong-yak.com/framexml/beta/GlobalStrings.lua
- performance efficiency 
https://stackoverflow.com/questions/31888918/how-efficient-am-i-using-these-tables-in-lua
- create slash commands
https://wow.gamepedia.com/Creating_a_slash_command
- why redefine locals
http://lua-users.org/wiki/OptimisingUsingLocalVariables
- lua characters
https://www.lua.org/pil/20.2.html
- interact target
    - https://wowwiki-archive.fandom.com/wiki/API_CheckInteractDistance

# Keywords
- tooltip: mouse u bir seye tuttugunda metadata bilgisini cikaran pop up frame

# Structure
+-- developer
+-- domain
+-- libraries
    +-- * 
+-- modules
+-- settings
+-- Archrist.lua
+-- Archrist.tocsd


# Blackboard
- check addons
    - blt
    - fatality
    - rangedisplay
    - vuhdo

- architecture
    - frame position un belirlenmesi x-gui de oluyor

- customizability levels | levels of customizability | levels of customization
    1. give your data within the logic
    2. split your data from logic in the code
    3. split your data from the logic file
    4. allow user to manipulate data with ingame commands
    5. allow user to manipulate data with ingame interface
        - allow to activate/deactivate
        - allow discrete customization
        - allow to add


- feature list template
    - name, description, how to use, example

- Colors
    #0d6991
    #128EC4
    #262626
    #ededed
    #ff33ff

- Methods
    Identify What You Want To Do
    Research on some events or methods in which to do what you wish
    Do it

- Lua
    -- `comment`
    `#` `length of table`
    {...} `table decleration`
    #table = `table.length`
    self `self referential`
    nil `removes the value`
    --[[]] `multiline comment`
    for startValue, endValue, stepValue do 
    end
    numeric and generic loops

    for local i = 1, 10, 1 do
        --code goes here
    end

    for key, value in pairs, tbl do
        --code goes here
    end

    repeat
    until (condition)

    while (condition) do
    end

- Procedures
    - release
        - delete git
        - git.ignore
        - notebook
        - readme

- slash commands
    SLASH_RELOADUI1 = "/rl"; -- for quicker reload
    SLASH_RELOADUI2 = "/reloadui";
    SLASH_RELOADUI3 = "/re";

    SLASH_RaidWarning1 = "/war"
    SLASH_SelectLeadChannel1 = "/comms"

    SLASH_lootFilter1 = "/lootfilter"
    SLASH_rollFilter1 = "/rollfilter"

    SLASH_reputation1 = "/rep"

    SLASH_DISCORD1 = "/discord"
    SLASH_LOOTRULES1 = "/loot"
    SLASH_GBOS1 = "/gbos"
    SLASH_GBOM1 = "/gbom"
    SLASH_GBOW1 = "/gbow"
    SLASH_GBOK1 = "/gbok"
    SLASH_PALADIN1 = "/pala"
    SLASH_SPREAD1 = "/sp"
    SLASH_SPREAD2 = "/spread"
    SLASH_STACK1 = "/st"
    SLASH_STACK2 = "/stack"
    SLASH_TANK1 = "/tank"

    SLASH_reputation1 = "/rep"
    SLASH_discipline1 = "/dsc"
    SLASH_strategy1 = "/str"
    SLASH_damage1 = "/dmg"
    SLASH_attendance1 = "/att"
    SLASH_note1 = "/not"

- skill lsit
    -  Warrior
        5246 - Intimidating shout

- messenger pattern

- ace gui modules
    - header 
    - group 
    - toggle 
    - slider 
    - drop down
    - description

- config ui tabs
    - External Memory
    - Guide
    - Assistance
    - Utility 
    - Extended Macros
    - About


- concepts
    - guid: globally unique identifier

- serialize | deserialize
    - dosyaya yazarken memoryden alip disariya yazmaya serialize | yeniden okuyup memory de kendi dtasini cekmeye deserialize deniyor

# How to
- <new module>
    - add module to archrist.lua 
    - add any references if any
    - create folder with proper name
    - copy template folder
    - add load to folder name in 4-modules/-load-modules.xml
    - add inner load file xml
    - edit document

- <frame position>
    - frame pos isimli degisken belirle
    - init icine eger yoksa global position holder tutan degisken koy
    - gui draw icine frame pos belirleyen blok koy
    - gui icindeki callback icine kapatma tusuyla kaydeden eklenti koy

- <add new folder>
    - create folder
    - create xml for load
    - add load file to .toc

- <how to print debug lua>
    - SendChatMessage("Hello Bob!", "WHISPER", "Common", UnitName("Player"));

- <disabling and activating modules>
    - comment out archrist.lua module

- <wow layer order Layers>
background, border, artwork, overlay, highlight

- <ExportArtwork>
    - https://wowwiki-archive.fandom.com/wiki/Extracting_WoW_user_interface_files
    - create shortcut
    - add -console to name
    - open shortcut press ~
    exportInterfaceFiles code
    exportInterfaceFiles art

- <accessing and using certain window>
    - learn the name of unit
    - check how to access unit (ex. tooltip)
    - check how to manipulate it

- <activate lua errors>
    - /console scriptErrors 1

- <gui setting up grid expanding and shrinking window>
    - https://www.wowace.com/projects/ace3/pages/ace-gui-3-0-widgets

- <lua tinker break inner function>
    - do return end

# Changed api | version fixes

- GetMapContinents()
    - change with {[1]="Kalimdor", [2]="Eastern Kingdoms", [3]="Outlands", [4]="Northrend"}
- GetMapZones()
    - replace
    - local Zones = {
	--Kalimdor ZoneNames
	[1] = {
		[1] = "Ashenvale",
		[2] = "Azshara",
		[3] = "Azuremyst lsle",
		[4] = "Bloodmyst lsle",
		[5] = "Darkshore",
		[6] = "Darnassus",
		[7] = "Desolace",
		[8] = "Durotar",
		[9] = "Dustwallow Marsh",
		[10] = "Felwood",
		[11] = "Feralas",
		[12] = "Moonglade",
		[13] = "Mulgore",
		[14] = "Orgrimmar",
		[15] = "Silithus",
		[16] = "Stonetalon Mountains",
		[17] = "Tanaris",
		[18] = "Teldrassil",
		[19] = "The Barrens",
		[20] = "The Exodar",
		[21] = "Thousand Needles",
		[22] = "Thunder Bluff",
		[23] = "Un'Goro Crater",
		[24] = "Winterspring",
		},
	--Eastern KingdomsAzeroth
	[2] = {
		[1] = "Alterac Mountains",
		[2] = "Arathi Highlands",
		[3] = "Badlands",	--"Blackrock Mountain"
		[4] = "Blasted Lands",
		[5] = "Burning Steppes",
		[6] = "Deadwind Pass",
		[7] = "Dun Morogh",
		[8] = "Duskwood",
		[9] = "Eastern Plaguelands",
		[10] = "Elwynn Forest",
		[11] = "Eversong Woods",
		[12] = "Ghostlands",
		[13] = "Hilsbrad Foothills",
		[14] = "Ironforge",
		[15] = "Isle of Quel'Danas",
		[16] = "Loch Modan",
		[17] = "Redridge Mountains",
		[18] = "Searing Gorge",
		[19] = "Silvermoon City",
		[20] = "Silverpine Forest",
		[21] = "Stormwind City",
		[22] = "Stranglethorn Vale",
		[23] = "Swamp of Sorrows",
		[24] = "The Hinterlands",
		[25] = "Tirisfal Glades",
		[26] = "Undercity",
		[27] = "Western Plaguelands",
		[28] = "Westfall",
		[29] = "Wetlands",
	},
	--Outland
	[3] = {
		[1] = "Blades Edge Mountains",
		[2] = "Hellfire Peninsula",
		[3] = "Nagrand",
		[4] = "Netherstorm",
		[5] = "Shadowmoon Valley",
		[6] = "Shattrath City",
		[7] = "Terokkar Forest",
		[8] = "Zangarmarsh",
	},
	--Northrend
	[4] = {
		[1] = "Borean Tundra",
		[2] = "Crystalsong Forest",
		[3] = "Dalaran",
		[4] = "Dragonblight",
		[5] = "Grizzly Hills",
		[6] = "Howling Fjord",
		[7] = "Icecrown",
		[8] = "Sholazar Basin",
		[9] = "Storm Peaks",
		[10] = "Wintergrasp",
		[11] = "Zul'Drak",
	},
}
