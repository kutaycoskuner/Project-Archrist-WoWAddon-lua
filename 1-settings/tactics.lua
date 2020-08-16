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
        --==== Pre-Raid Check
        ["genel"] = {
            "! Log dosyasini sil combat log ac",
            "! Pot ve flask al",
        },
        --==== Dungeons
        --:: Utgarde Pinnacle
        ["skadi"] = {
            "=1 {triangle} LEFT {triangle}",
            '=2 {triangle} RIGHT {triangle}',
            '=4 {triangle} Use Harpoons {triangle}',
        },
        --==== Raids
        --:: VoA
        ["koralon"] = {
            "",
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
        --:: Ulduar
        ["algalon"] = {

        },
        --:: ToGC
        ["beasts"] = {
            '1- Do not stand in fire',
            '2- If you got Snobold in your head get in melee range',
            '3- DPS hardswitch on Snobold as soon as it in melee range',
            '4- [Shaman] Hero at worms [H] / Hero at first charge of Icehowl  [N]',
            '5- RDPS and Heal stay 20yard away from boss to be not silenced',
            "= focus marked snobold",
            "= RDPS and Heals stack on stations",
        },
        ["jarraxus"] = {
            '1- [Interrupter] Interrupt Jarraxus\'s cast',
            '2- Hardswitch on adds as soon as they spawn',
            '3- [Mage] Steal Nether Power buff from Jarraxus with haste',
            '! set interrupter',
            '! say hero at volcano, burst cd at gate',
        },
        ["faction"] = {
            '! 1- [Warlock] Banish/Fear Druid Healer',
            '! 2- [Paladin] Turn evil if warlock\'s pet exists',
            '! 3- [Mage] Poly Paladin/Resto Shaman',
            '! 4- [MT] keep warrior/dk away from raid',
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
        },
        --:: Onyxia
        ["onyxia"] = {
            "1- [Melee] Stay in max range",
            "2- Avoid tail and head hit from side",
            "3- Avoid cracks",
            "4- All ranged on boss All mdps on adds",
            "5- Mdps interrupt big adds big ads ccleave and prio",
            "6- Phase 2 starts at 65% Heroism should be just just before",
            "7- [Tanks] 3 tank east west adds",
            "! ON p2 leave path of the boss",
            "! 65 p2 40 p3",
        },
        --:: ICC
        --:: RS

        --==== Battlegrounds
        ["strand"] = {
            '1- Protect Demos',
            '2- RDPS get in turret slot',
            '3- Get Bombs'
        },
}