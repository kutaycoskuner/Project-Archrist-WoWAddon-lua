----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------
--[[
    --!! In use by CRIndicator
        Class {Spell{ID,cd}}

]]

Arch_raidAlerts = {
    ["community"] = {
        ["discord"] = "If you like to be informed about further runs please join https://discord.gg/wQTEexv ",
        ["guild"] = "If you like to be informed about further runs or join guild https://discord.gg/PGAZuj7 ",
    },
    ["vc"] = {
        ["voluntary"] = "Voice Comms is not mandatory but easing stuff to join: https://discord.gg/PGAZuj7",
        ["mandatory"] = "Please join: https://discord.gg/PGAZuj7",
    },
    ["lootrules"] = {
        ["loot"] = "Loot Rules: Armor Prio & MS > OS ",
        ["voa"] = "Loot Rules: Armor Prio & MS > OS & PvP Roll Spec Prio if not indicated otherwise",
        ["warning"] = "Rolling item for selling is forbidden will result you to ban for further raids",
    },
}
