# Where I left
- deletemailauc module
- import default settings for database
- local i pre-load dan cikar altyapi moduulu degil spesifik
https://www.youtube.com/watch?v=0Z3b0SJuvI0&list=PL3wt7cLYn4N-3D3PTTUZBM2t1exFmoA2G&index=7

# Todo
- hangi druidin cs atacagini goster
- player reputation system
- table copy yi developerdan alip diger tarafa koy

# Problems
- player reputation system 
    - database etkilesimleri
- core profile da yapilan degisikligi gormuyor
`boyle bir fonksiyon yok` attempt to call method 'UpdateCooldownSettings' (a nil value)

# Completed
- uniform alerts
- playerDB yeni bir database yaratildi
- test if settings importing same table name as main `eger degisim olmazsa evet`
- database communication
- tcopy, twipe komutlarini ogren
- SavedVariables: ElvDB, ElvPrivateDB
- SavedVariablesPerCharacter: ElvCharacterDB

# Comment Discipline
comment discipline {
    title               :   ==== | "#00c8ff" 
    problem             :   !!   | "#ff6633"
    query               :   ??   | "#33ffff"
    todo                :   >>   | "#99ff33"
    test                :   test | "#ffa100"
    highlight           :   **   | "#8fab21"
    description         :   ::   | "#128EC4"  
    separator line      :   --   | "#001d26"  
    disabledProperty    :  none
}
#0d6991
#128EC4
#262626
#ededed
#ff33ff

# Sources
[1] mayron wow addon creation
https://www.youtube.com/watch?v=nfaE7NQhMlc&list=PL3wt7cLYn4N-3D3PTTUZBM2t1exFmoA2G

# Links
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

# Reminders
Identify What You Want To Do
Research on some events or methods in which to do what you wish
Do it

>> test procedure
- print('test')
- print(object)

# Lua
-- `comment`
`#` `length of table`
{...} `table decleration`
#tabel = `table.length`
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

>> Layers
background, border, artwork, overlay, highlight

>> ExportArtwork
- create shortcut
- add -console to name
- open shortcut press ~
exportInterfaceFiles code
exportInterfaceFiles art

# File Structure

+-- developer
+-- domain
+-- libraries
|   +-- 
+-- modules
+-- settings
+-- Archrist.lua
+-- Archrist.toc

# WoW Console
/console scriptProfile 0

# Notes
- find a tolerance space between unfinished work commit and overstructured one because there is always a risk of messing 

# Release
- delete reference
- delete git
- git.ignore
- error
- notebook
- readme

# UseCase
- Raidscore addon, bir framede insanlari reputation a gore siraya diziyor. Gearscore, reputation, disiplin, strateji, damage, attendance bilgileriyle bir raidscore formulu olusturup burada oncelikli olarak davet ediyorsun ayrica playerlar icin not tutabiliyor. 

# All Slash Commands
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