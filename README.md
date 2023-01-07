# World of Warcraft Study Addon
Archrist is an multi-functional assistance addon with various functionalities for the Wrath of the Lich King expansion pack. Please see below to inspect detailed feature list.

| Project Started | Last Update | Version |
| :-------------- | :---------- | :-----: |
| 25 Jan 2022     | 07 Jan 2023 | 1.46    |

# Table of Contents
1. [Installation and Use](#installation-and-use)
2. [Feature List](#feature-list)
5. [Display](#display)
6. [References and Links](#references-and-links)

# Intallation and Use
- Dependencies
    - World of Warcraft: Wrath of The Lich King Classic 3.4.x
- Installation
    - Download the compatible version from https://www.curseforge.com/wow/addons/archrist/files
    - Extract the Archrist.zip file to your ..\World of Warcraft_classic\Interface\AddOns_ folder.
- Use
    - Open game activate addon from your addons section.
    - You can use following ingame commands for more detailed instructions.
        - `/arch`
        - `/arch config`

# Feature List
- Addon Functions
    - `Assistance`
        - [x] `Group Organizer` Inspecting and categorizing people in your group (raid or party) upon your their specs to four main roles (tank, heal, mdps, rdps). That allows you to track healer's mana, create interrupt or Aura Mastery queues for better syncronization in group.
        - [x] `Cooldown Tracker` Tracks important group spells in your party and presents it within a simple frame.

    - `Utility`
        - [x] `Loot Filter` Filter out greed loots for more clean chat frame.
        - [x] `Posture Check` Reminds you to check your posture with intervals.

    - `Guide`
        - [x] `Crafting Guides` Crafting guides retrieved from warcrafttavern.com. Calculates estimatet material cost for your profession leveling adapted to your current level. And shows you what to craft next.
        - [x] `Guide Maker` Experimental feature that allows you to create your own guides and edit. However not yet fully implemented.

    - `External Memory`
        - [x] `Player Database` Allows you to take notes about people, and grade them with five main quantitative categories. Notes and grades showed upon mouse over. If you have negative grade for someone it warns you when they are in same group with you.
        - [x] `Todo List` Simple todo list that allows you to create take notes to be checked out or completed another time.

    - `Extended Macros`
        - [x] `Auto Mount` A single click macro to select either flying or ground mount of your preference.
        - [x] `Auto Disenchant` A level adjusted single click disenchanting macro that disenchants every item in your backpack with given item range.
 
 - Accessibility | Customizability
    - [x] `Help` Basic text interface how to use module
    - [x] `GUI` Some modules support graphical user interface to provide user a level of customizability

- Work In Progress
    - [ ] `PUG Raid Organizer` Dynamic PUG Raid announcement module  
    - [ ] `Eat and Drink` Using consumables in backpack by given order
    - [ ] `Pet Feed` Aloows you to feed your pet as their happiness decreased.
    - [ ] `Milling` Single click milling macro
    - [ ] `Disenchanting` Single click disenchanting
    - [ ] `Announcer` Announcing booster skills given to other people  
    - [ ] `Raid Commands` Dynamic command interface for repetitive and distinctive warning messages   
    - [ ] `VoA` Vault of Archavon spec run announcement module 
    - [ ] `Tactics` Display tactics of selected raid boss   

# Display
![](-display/v1.23%20Pug%20GUI%202022-10-16.png)
```
Version 1.23 Pug
```  
---
![](-display/v1.22%20PlayerDB%20Tooltip%202022-10-16.png)
```
Version 1.22 PlayerDB Tooltip
```  
---
![](-display/v1.22%20PlayerDB%20CLI%202022-10-16.png)
```
Version 1.22 PlayerDB Chat Notifications
```  
---
![](-display/v1.21%20Todolist%202022-10-16.png)
```
Version 1.21 Todolist
```  
---

# References and Links
- Learning
    - Other Addons
        - ElvUI https://www.tukui.org/welcome.php
        - Spy https://www.curseforge.com/wow/addons/spy
        - Weakauras https://addons.wago.io/addons/weakauras
        - TacoTIp https://www.curseforge.com/wow/addons/tacotip-gearscore-talents/files/3964800

    - Tutorials
        - video https://www.youtube.com/watch?v=nfaE7NQhMlc&list=PL3wt7cLYn4N-3D3PTTUZBM2t1exFmoA2G
        - website https://wow.gamepedia.com/WelcomeHome_-_Your_first_Ace3_Addon
        - website http://wowprogramming.com/utils.html
        - collection https://www.reddit.com/r/wowaddons/wiki/index/


    - Ingame Guides / Content
        - icy-veins https://www.icy-veins.com/wotlk-classic/raid-buffs-and-debuffs
        - warcrafttavern https://www.warcrafttavern.com/wotlk/guides/mage-leveling-guide/

    - Documentation | API
        - https://wowwiki-archive.fandom.com/
        - https://wowwiki.fandom.com/
        - https://wowpedia.fandom.com/
        - https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/UIParent.lua
        - https://www.townlong-yak.com/
        - https://www.lua.org/pil/20.2.html

- Libraries
    - Ace3 https://www.wowace.com/projects/ace3
    - LibClassicInspector https://www.curseforge.com/wow/addons/tacotip-gearscore-talents/files/3964800
    - LibSharedMedia 3.0 https://www.curseforge.com/wow/addons/libsharedmedia-3-0
    - LibDetours 1.0

- Distribution
    - CurseForge https://www.curseforge.com/wow/addons/archrist

[Return to top](#world-of-warcraft-study-addon)