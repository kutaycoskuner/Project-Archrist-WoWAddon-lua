# Log
`Started 29-Jul-2020`

# Keys - Discretized Actions 1.5
- org: organization, decisions, notebook changes
- arch: architectural, framework change, tryout

- add: add, insert, data content
    - con: content
    - sty: style/render
    - fun: function

- del: deleted
- fix: fix a bug or problem | compatibility
- upg: update, upgraded, progressed
- chg: stylistic change

- std: study, learn, test
- wip: work in progress
- mix: multiple additions

# Todo
- o: outdated; c: cancelled; x: completed
- [o] 11-Oct-2022 30-Nov-2020 inquiry update
- [o] 11-Oct-2022 29-Nov-2020 migrate databases
- [o] 11-Oct-2022 27-Nov-2020 ingame interface
- [x] 11-Oct-2022 11-Oct-2022 add: Player database kendi frame ini yaratip kullansin
- [x] 12-Oct-2022 11-Oct-2022 add: eat drink macro item link
- [x] 12-Oct-2022 11-Oct-2022 fix: todo gui scale ettiginde numara kayiyor
- [x] 13-Oct-2022 11-Oct-2022 add: help verisini ancak modul aktifse yuklesin ve modul icinden ceksin
- [x] 15-Oct-2022 15-Oct-2022 add: playerdb help
- 11-Oct-2022 add: macro usage icin help yaz
- 13-Oct-2022 fix: help raidwarnings i main ayir kendi icinde distribute et
- 15-Oct-2022 add: new version alert

# Procedures
- check todo
- enter log
- enter time log
- update toc version

# LOG
- 12-Oct-2022 1.22
    - fix: playerdb adding reputation to name problem
    - fun: party function along with raid

- 12-Oct-2022 1.21
    - add: item link to eat macro
    - fix: todo list gui stick problem. Relative widths with expand/shrinking window
    - arch: help redistribution | disabling from archrist.lua

- 11-Oct-2022 1.2   
    - org: Upgrade base to version 3.4.0 original; 
    - fix: PlayerDB Gearscorelite Dependency is broken. Showing own values.
    - fix: CRIndicator SetBackdrop apisi degistigi icin frame renderlayamiyordu. Yeni apiye uyarladim. 60-72

[1.12]
05-Dec-2020 readme update
05-Dec-2020 disable: LootMsgFilter
04-Dec-2020 fix: CRIndicator; soulstone cd correction
02-Dec-2020 add: CRIndicator; deadcheck mechanism
[1.11]
29-Nov-2020 todo: 29-Nov-2020 crindicator lock save
29-Nov-2020 todo: 28-Nov-2020 CRIndicator biraktigin yeri hatirlama / position resset
29-Nov-2020 alter: raidwarnings adding triangles bottom ends of warning and proper case
29-Nov-2020 fix: crindicator combatta da acilip kapatilabiliyor
29-Nov-2020 todo: 17-Oct-2020 girilmeyen moduller icin help yaz
29-Nov-2020 todo: 27-Nov-2020 crindicator combat komutlari
29-Nov-2020 todo: 26-Nov-2020 crindicator ikonlari goster
[1.1.0]
27-Nov-2020 fix: CRIndicator; alone prune bug
27-Nov-2020 CRIndicator alpha
[1.0.1]
26-Nov-2020 test: CRIndicator WIP
25-Nov-2020 test: CRIndicator WIP
20-Nov-2020 fix: Announcer; misdirection, focus magic bugs
14-Nov-2020 add: Announcer; hysteria, focus magic, power infusion announces
[1.0.0]
08-Nov-2020 playerDB; raidRepCheck bugfix
[0.9.9]
04-Nov-2020 playerDB; raidupdate spam fix
30-Oct-2020 pug; fix: need all
30-Oct-2020 playerDB; rep in yanina dogrudan not yazabilme
28-Oct-2020 playerDB; no message if nobody in blacklist
28-Oct-2020 discarded; warrior, attendance
26-Oct-2020 playerDB; raide biri girince negatif puani varsa alert veriyor
[0.9.8]
17-Oct-2020 help, reworked with modules
17-Oct-2020 tactics, RaidWarnings moved to Raidcommands
17-Oct-2020 disabled commands moved to !disabled
17-Oct-2020 tactics for icc10 until lk added
[0.9.7]
30-Sep-2020 pug, fixed text left when searchbox unticked
30-Sep-2020 discord, giriste nickname ve auth uyarisi
30-Sep-2020 tactics, icc taktikleri 7, bosa kadar
25-Sep-2020 tactics, siralama duzeltemedim
19-Sep-2020 raidalerts, taktik datbase inde olmayan bosslar icin uyari verme ayarlandi
25-Aug-2020 Warrior, equip items fix
23-Aug-2200 PuG, save values on database
23-Aug-2020 VoA, reset, save values on database
[0.9.6]
23-Aug-2020 Tactics, string presentation fix
22-Aug-2020 Discord, added vc commands
20-Aug-2020 LootDB, disabled
18-Aug-2020 Attendance, manual adding
17-Aug-2020 Discord, strings seperated to settings
16-Aug-2020 CRIndicator, partial dead tracking mechanism
05-Aug-2020 Added PlayerDB, raidwise reputation
Rework CRIndicator, set database for spells instead of data function
Rework CRIndicator, set class colors for list
Added CRIndicator, remove people who are not in raid anymore
Update CRIndicator, using spell names instead of id
Added CRIndicator, removing bears by tracking mangle spell -- disabled
[0.9.5]
Added PlayerDB whitelist, blacklist
Fixed whitelist, blacklist comma bug
Fixed PlayerDB esc disabling
Added PlayerDB offline player entry with prefix `/`
[0.9.4] 
Added tactics adjustability, raid warnings, silent reminders
[Older]
kimin cani azsa ona atma
eat macro
butun moduller tarafindan kullanilan fonksiyonlari ayirip global yap
help command
update guilds raidscores
table copy yi developerdan alip diger tarafa koy
hangi druidin cs atacagini goster
limit for parameter
get player not on tooltip
core profile da yapilan degisikligi gormuyor
boyle bir fonksiyon yok attempt to call method 'UpdateCooldownSettings' (a nil value)
player reputation system
ufak bi gui
calculate Raidscore
not alma addonu gui icin uygun olur
su ana kadar ki modullerin database etkilesimleri: lootfilter, rollfilter
player reputation system: database etkilesimleri
uniform alerts
playerDB yeni bir database yaratildi
test if settings importing same table name as main `eger degisim olmazsa evet`
database communication
tcopy, twipe komutlarini ogren
SavedVariables: ElvDB, ElvPrivateDB
SavedVariablesPerCharacter: ElvCharacterDB