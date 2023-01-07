----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    !! Used by Tactics Module
    No tag          = Announce Tactics
    [!]             = Self reminders
    [=][number]     = Combat Warnings

    CR order gibi genel seyler icin bir seyler bul
    pots now
    hero now

]]

-- :: this is secondary level is necessary for duplicated keys one is name other is id
local base = {
    -- ==== Pre-Raid Check
    ["genel"] = {
        "! 1- Log dosyasini sil combat log ac", 
        "! 2- Pot ve flask al"
    },
    -- ==== Dungeons
    -- :: Utgarde Pinnacle
    ["skadi"] = {
        "=1 {triangle} LEFT {triangle}", '=2 {triangle} RIGHT {triangle}',
        '=4 {triangle} Use Harpoons {triangle}'
    },
    -- ==== Raids
    -- :: VoA
    ["koralon"] = {
        "1- Do not stand of fire",
        "2- Hero at Start",
        "=3 {circle} Heroism Now {circle}",
    },
    ["emalon"] = {
        '1- Leave mid for healers',
        '2- RDPS spread stairside /range 10 dont use mid',
        '3- MDPS use diagonal way when you move towards adds dont get in range of healers',
        '4- Hero/Bloodlust after add kill if exhaustion otherwise at start',
        '! Set tanks who is add / who is boss'
    },
    ["toravon"] = {
        "1- [Tanks] Face Toravon away from raid",
        "2- [Tanks] Switch between 6 Frostbite stacks",
        "3- [Healers] Stay away from frozen orbs",
        "4- [RDPS] Focus Frozen Orbs as they spawn",
        "5- [MDPS] Cleave if Frozen Orb is close to you",
        "6- Heroism/Bloodlust at start",
        "! Remind frost aura or frost resist totem",
        "=4 {triangle} Kill Frozen Orbs! {triangle}",
    },
    -- :: Naxx
    ["anubrekhan"] = {},
    ["faerlina"] = {},
    ["maexxna"] = {},
    ["noth"] = {},
    ["heigan"] = {},
    ["loatheb"] = {},
    ["razuvious"] = {},
    ["gothik"] = {},
    ["horsemen"] = {},
    ["patchwerk"] = {},
    ["grobbulus"] = {},
    ["gluth"] = {},
    ["thaddius"] = {},
    ["sapphiron"] = {},
    ["kelthuzad"] = {},
    -- :: Ulduar
    ["fl"] = {
        "This is one of the unique raid encounters of WotLK raids due to the whole fight lasts on vehicles",
        "1- Salvaged Demolisher[Driver]: DPS Boss Pyerite skill only should be used during the boss fight, run if boss chases you try to keep 10 stack pyerite",
        "2- Salvaged Demolisher[Cannon]: hit flying pyerite drones to drop them. And fuel demolisher's pyerite stock if it drops under 50. Another expectancy of cannoneers if FL starts to track your demolisher you should boost demolisher's speed with your third skill.",
        "3- Siege Engine: Tank equivalent of vehicles. Using melee range toss skill. Only sieges engines should initiate tank before battle begins otherwise it can stuck in bug. Should assist with DPS. as with its cannoneer.",
        "4- Chopper: Choppers are support vehicles of encounter. Has 3 abilities. Carrying pyerite to close range of Demolishers, Dropping oils to infront of Flame Leviathan for extra damage and assist raid with minimal DPS.",
    },
    ["razorscale"] = {
        "1- Do not stand in fire",
        "2- Do not stand nearby Sentinels",
        "3- Hero when boss down",
        "=1 Boss is coming down be ready for dps!",
        "=3 {Triangle} Heroism Now {Triangle}",
        "! Assign someone for harpoons",
    },
    ["ignis"] = {
        "1- Hero at start",
        "2- Do not stay infront of the boss",
        "3- Stop casting when he cast flame jets",
        "=1 {circle} Stop Casting {circle}",
        "=4 {square} Kill the add {square}",
        "! 1- Set 3 man group to handle adds",
    },
    ["deconstructor"] = {
        "1- If you have Gravity Bomb go to LEFT",
        "2- If you have Searing Light go to RIGHT",
        "3- Hero when the heart exposed",
    },
    ["assembly"] = {
        '1- Run from Dwarf when he casts Overpower',
        '2- Try to stand on blue rune',
        '3- [Tank] keep bosses away from blue rune',
        '4- When he cast rune of death run away from blue rune',
    },
    ["kologarn"] = {
        "1- Start with killing right arm [left side from our pov]",
        "2- After killing right arm switch to body",
        "3- If you are targeted by Eye Beam move away from raid and kite",
        "=1 Switch to Right Arm",
        "=2 Switch to Body",
    },
    ["auriya"] = {
        "1- Kill her adds first",
        "2- Do not stand in black hole",
        "3- ALWAYS stack infront of the boss",
        "4- Shamans use tremor totem",
    },
    ["hodir"] = {
        "1- Move to remove stacks of Biting Cold debuff on you",
        "2- [RDPS] stand near fire when it appeared do not stand too close to it otherwise you may kill it",
        "3- Hero at 30 stack debuff",
        "=1 Kill the FLASH FREEZE",
    },
    ["thorim"] = {
        "",
    },
    -- ["freya"] = {},
    ["mimiron"] = {
        "P1 - MDPS Care mines, RDPS Stay away at second circle",
        "P2 - Spread run away from red marks stack behind the boss when he cast ",
        "P3 - RDPS Stack attack flying boss MDPS Kill adds, run away from bomb bot",
        "P4 - We fight all pieces at once all of them have to die at same time",
        "=1 MDPS SPREAD CARE MINES",
        "=2 GET BEHIND THE BOSS",
        "=3 KILL ASSAULT BOT",
        "=4 KILL ALL PIECES SAME TIME",
    },
    ["vezax"] = {
        '',
        '',
        '',
    },
    ["yogg"] = {
        "1- P1 Pixel stack on first phase under sara",
        "Do not ",
        "2- P2 Stop on big tentacles when asked for it",
        "2- P2 Kill constrictor tentacles fast",
        "3- P2 Check your sanity if its low get under green light",
        "4- P2 On brain phase marked groups will take portals to fight with brain",
        "=4 Get close to portals",
    },
    -- ["algalon"] = {},
    -- :: ToGC
    ["beasts"] = {
        '1- Do not stand in fire',
        '2- If you got Snobold in your head get in melee range',
        '3- DPS hardswitch on Snobold if its on RDPS or Heal as soon as it in melee range',
        '4- [Shaman] Hero at worms [H] / Hero at first charge of Icehowl  [N]',
        '5- RDPS and Heal stay 20yard away from boss to be not silenced',
        "! Assign tanks for worms",
        "=1 focus marked snobold", 
        "=2 RDPS and Heals stack on stations",
    },
    ["jarraxus"] = {
        '1- [Interrupter] Interrupt Jarraxus cast',
        '2- Hardswitch on adds as soon as they spawn',
        '3- [Mage] Steal Nether Power buff from Jarraxus with haste',
        '! set interrupter', 
        '! say hero at volcano, burst cd at gate',
    },
    ["faction"] = {
        '! 1- [Warlock] Banish/Fear Druid Healer',
        '! 2- [Paladin] Turn evil if warlock\'s pet exists',
        '! 3- [Mage] Poly Paladin/Resto Shaman',
        '! 4- [MT] keep warrior/dk away from raid'
    },
    ["valkyr"] = {
        '1- Everyone get dark except soakers and off tank',
        '2- Switch to dark/white when ability cast requires opposite color',
        '3- After ability change your color to dark again and attack to White Valkyr',
        '4- Hero after first ability', 
        "! set soakers",
    },
    ["anub"] = {
        '1- [Hunter] Plant ice platforms N, SW, SE',
        '2- Use Holy wrath by order on add casts',
        '3- [Paladin] Use HoP on Phase 2 with given order',
        '4- Platforms will be used as ordered N, SW, SE',
        '5- Hero at start at Phase 3',
        '=1 Platforms',
        "=2 kill bugs first",
        "=3 {circle} Hero Now {circle}",
        "=4 ",
    },
    -- :: Onyxia
    ["onyxia"] = {
        "1- [Melee] Stay in max range", "2- Avoid tail and head hit from side",
        "3- Avoid cracks", "4- All ranged on boss All mdps on adds",
        "5- Mdps interrupt big adds big ads ccleave and prio",
        "6- Phase 2 starts at 65% Heroism should be just just before",
        "7- [Tanks] 3 tank east west adds",
        "8- [RDPS] Around Onyxia is 45% kill the big adds",
        "! ON p2 leave path of the boss", "! 65 p2 40 p3"
    },
    -- :: ICC
    ["marrowgar"] = {
        "1- Do not stand on fire",
        "2- Kill the bone spikes in priority",
        "3- P1: Everyone stack behind boss except hunter",
        "4- Hero at start",
    },
    ["lady"] = {
        "1- P1: Kill the adds after tanks gather them in the middle",
        "2- P2: Interrupt frostbolt casts of Deathwhisper",
        "3- P2: Run away from ghosts before they catch you",
        "4- Hero at P2",
    },
    ["gunship"] = {
        "! Say everyone to get rocket and equip",
        "! Select cannoneers",
        "! Select jumping tank",
        "1- [Cannoneers] stack energy till 90 with 1 then burst 2",
        "2- DPS and assigned tank jump countership and kill mage when our cannons frozen",
        "3- Wait for Tank to jump fist to take aggro and dont enter cleave range",
        "4- We do not use heroism on this encounter",
    },
    ["saurfang"] = {
        "1- RDPS and Heal /range 12 to avoid blood disease",
        "2- MDPS & Tanks stop AoE when beasts spawn to avoid aggro",
        "3- Kill blood beasts on priority when they spawn",
        "4- Slow down adds if you can Hunter -> trap, Shaman -> totem etc.",
        "5- Hero at 30%",
    },
    ["festergut"] = {
        "! Remind hero at start",
        "1- Boss will spawn 2 spores on people, one spore will stay melee station, other will go to range station",
        "2- People stack with on either mdps or rdps spot to be inaculated",
        "3- After spore explosion RDPS spread /range 12 to avoid epidemic damage",
        "4- [Tank] use defensive cooldowns to survive Blight on 3 stack",
        "5- [Tank switch aggro between 8 stacks of Gastric Bloat",
        "6- Hero at start",
        "=4 {triangle}Stack with spores{triangle}",
        "=2 {triangle}Spread{triangle}",
    },
    ["rotface"] = {
        "! Assign kite and static tank",
        "! Assign dispeller",
        "1- Everyone will stack behind boss, if boss turn to you go behind the boss",
        "2- Boss will be tanked in the middle tank wont move",
        "3- If you got disease called Mutated infection, you ll go out and wait for dispel",
        "4- When you got dispelled a small ooze will follow you this cannot be taunted need to be merged with other ooze",
        "5- If there is Big ooze intersect your path with ooze to merge, otherwise kite it until an ooze spawns",
        "6- On 5 stacks of ooze, Big Ooze will explode we will run towards perimeter of the room",
        "7- Hero at start",
        "=4 {circle} Run toward perimeters {circle}",
    },
    ["professor"] = {
        "! Assign OT for green slug",
        "1- Boss has 3 Phases will change at 80% and 35% hp",
        "2- Boss will respectively spawn, Green and Orange ooze, always start with green",
        "3- All DPS immediately turn to Ooze as they spawn",
        "4- Both ooze will select a target and run towards them",
        "5- Green ooze will freeze its target, if its about to collide stack with its target to split damage and avoid deaths",
        "6- Orange ooze will not freeze its target but if it collides its wipe, target of the Orange needs to be kited while damaged by rest",
        "7- Offtank will absorb slugs and use it to slow down oozes",
        "8- P2: he will start to cast Malleable Goo and Gas avoid them",
        "9- P3: This phase is about dps race, avoid green, goo, tank swap aggro at 4 stacks of Mutated Plague",
        "10- P3: Group will rotate the room counter-clockwise, RDPS and Heal stay close to mid and avoid Goo",
        "11- You can use your cds at start of the encounter otherwise save it for P3, Hero at P3",
    },
    ["council"] = {
        "=4 Kinetic bombs!",
        "! Assign MT OT and RT",
        "1- Valanar casts Empowered Vortex when active you should /range 12 when you see it",
        "2- [RDPS] Prevent kinetic bombs from touching ground by hitting them",
        "3- Telderam casts Inferno flame, targeted player should kite until it exhausts and avoid from other people",
        "4- [RT] Collects floating nucleus to increase resist",
    },
    ["lanathel"] = {
        "1- If linked with Pact of Dark Fallen merge in melee",
        "2- If you are marked with Swarming Shadows to go perimeter of room and move in arc",
        "3- When she starts to come mid spread /range 12",
        "4- If you are bitten you have to bite someone else in last 5 seconds of debuff",
        "5- Get close to target you are going to bite",
    },
    ["valithria"] = {
        "! Assign Portal Healers",
        "=4 Focus on Skeleton",
        "=1 Focus on supressers",
        "1- Assigned healer take the portals and stack buff for healing valithria",
        "2- DPS should kill adds by order skeleton > supresser > lich > zombie > pudge",
        "3- Hero when healer reached 40 stack and no supresser exists",
    },
    ["sindragosa"] = {
        "1- P1: Run away when Sindragosa cast Blistering cold",
        "2- P1: [RDPS&Heal] Stop cast and wait when you have 5 stacks of Instability",
        "3- P1: [MDPS] Stop cast and wait when you have 5 stacks of Chilling to the bone",
        "4- Air Phase: 2 person will marked they will go to designated spots while rest of the raid fall back to stairs",
        "5- Air Phase: Dodge Sindragosa's ice balls by aligning yourself behind the ice tombs keep their health at 20%",
        "6- P3: Sindragosa will land and start and keep marking people with ice tombs",
        "6- P3: Marked people, respectively will stand in designated spots on left and right",
        "7- P3: [MDPS] Will stay opposite side of tomb spot until the marked person frozen",
        "8- P3: People will hide behind and kill the tomb and repeat until the fight is end",
    },
    ["lichking"] = {

    },
    -- :: RS
    ["halion"] = {
        "Fight is consist of 3 phase transitions at 75% and 50%",
        "P1- run away from group if you get Fiery Combustion debuff",
        "P1- Change to other side of Halion if meteor mark in on your side",
        "P2- Enter portal",
        "P2- run away from group if you get Soul Consumption debuff",
        "P2- Tank will rotate the boss periodically to avoid from link",
        "P3- Raid will split into 2 groups half will stay in shadow dimension while others go physical",
        "P3- Fight will continue in two dimensions but Halion health should be decreased equally",
        "=1 {square} Swap to other side {square}",
        "=2 {triangle} Slow inside! {triangle}",
        "=3 {triangle} Slow outside! {triangle}",
        "=4 {circle} Debuff run away! {circle}",
    },
    -- ==== Battlegrounds
    ["strand"] = {
        '1- Protect Demos', '2- RDPS get in turret slot', '3- Get Bombs'
    }
}

Arch_tactics = {
    -- ==== Pre-Raid Check
    ["genel"] = base["genel"],
    -- ==== Dungeons
    -- :: Utgarde Pinnacle
    ["skadi"] = base["skadi"],
    -- ==== Raids
    -- :: VoA
    ["koralon"] = base["koralon"],
    ["emalon"] = base["emalon"],
    ["toravon"] = base["toravon"],
    -- :: Naxx
    ["anubrekhan"] = {},
    ["faerlina"] = {},
    ["maexxna"] = {},
    ["noth"] = {},
    ["heigan"] = {},
    ["loatheb"] = {},
    ["razuvious"] = {},
    ["gothik"] = {},
    ["horsemen"] = {},
    ["patchwerk"] = {},
    ["grobbulus"] = {},
    ["gluth"] = {},
    ["thaddius"] = {},
    ["sapphiron"] = {},
    ["kelthuzad"] = {},
    -- :: Ulduar
    ["fl"] = base["fl"],
    ["razorscale"] = base["razorscale"],
    ["ignis"] = base["ignis"],
    ["deconstructor"] = base["deconstructor"],
    ["assembly"] = base["aseembly"],
    ["kologarn"] = base["kologarn"],
    ["auriya"] = base["auriya"],
    ["hodir"] = base["hodir"],
    ["thorim"] = base["thorim"],
    -- ["freya"] = {},
    ["mimiron"] = base["mimiron"],
    ["vezax"] = base["vezax"],
    ["yogg"] = base["yogg"],
    -- ["algalon"] = {},
    -- :: ToGC
    ["beasts"] = base["beasts"],
    ["jarraxus"] = base["jarraxus"],
    ["faction"] = base["faction"],
    ["valkyr"] = base["valyr"],
    ["anub"] = base["anub"],
    -- :: Onyxia
    ["onyxia"] = base["onyxia"],
    -- :: ICC
    ["marrowgar"] = base["marrowgar"],
    ["lady"] = base["lady"],
    ["gunship"] = base["gunship"],
    ["saurfang"] = base["saurfang"],
    ["festergut"] = base["festergut"],
    ["rotface"] = base["rotface"],
    ["professor"] = base["professor"],
    ["council"] = base["council"],
    ["lanathel"] = base["lanathel"],
    ["valithria"] = base["valithria"],
    ["sindragosa"] = base["sindragosa"],
    ["lichking"] = base["lichking"],
    -- :: RS
    ["halion"] = base["halion"],
    -- ==== Battlegrounds
    ["strand"] = base["strand"],
}
