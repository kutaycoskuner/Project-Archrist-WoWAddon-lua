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

Arch_tactics = {
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
        "! Remind frost aura or frost resist totem",
        "=4 {triangle} Kill Frozen Orbs! {triangle}",
    },
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
    -- ["vezax"] = {},
    -- ["yogg"] = {},
    -- ["algalon"] = {},
    -- :: ToGC
    ["beasts"] = {
        '1- Do not stand in fire',
        '2- If you got Snobold in your head get in melee range',
        '3- DPS hardswitch on Snobold as soon as it in melee range',
        '4- [Shaman] Hero at worms [H] / Hero at first charge of Icehowl  [N]',
        '5- RDPS and Heal stay 20yard away from boss to be not silenced',
        "= focus marked snobold", "= RDPS and Heals stack on stations"
    },
    ["jarraxus"] = {
        '1- [Interrupter] Interrupt Jarraxus\'s cast',
        '2- Hardswitch on adds as soon as they spawn',
        '3- [Mage] Steal Nether Power buff from Jarraxus with haste',
        '! set interrupter', '! say hero at volcano, burst cd at gate'
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
        '4- Hero after first ability', "! set soakers"
    },
    ["anub"] = {
        '1- [Hunter] Plant ice platforms N, SW, SE',
        '2- Use Holy wrath by order on add casts',
        '3- [Paladin] Use HoP on Phase 2 with given order',
        '4- Platforms will be used as ordered N, SW, SE',
        '5- Hero at start at Phase 3'
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

    },
    ["lady"] = {

    },
    ["gunship"] = {

    },
    ["saurfang"] = {

    },
    ["festergut"] = {

    },
    ["rotface"] = {

    },
    ["professor"] = {

    },
    ["council"] = {

    },
    ["lanathel"] = {

    },
    ["sindragosa"] = {

    },
    ["lichking"] = {

    },
    -- :: RS

    -- ==== Battlegrounds
    ["strand"] = {
        '1- Protect Demos', '2- RDPS get in turret slot', '3- Get Bombs'
    }
}
