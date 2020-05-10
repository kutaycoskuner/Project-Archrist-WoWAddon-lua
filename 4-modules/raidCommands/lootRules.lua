------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'lootRules';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = true
local string1 = "Loot Rules: Armor Prio & MS > OS & 10 point decrease next roll for every acquired item"

-- ==== Body
local function announceTank()
    if isEnabled then
        SendChatMessage(string1, "RAID_WARNING") -- RAID_WARNING, SAY
        -- "channel", nil, "5")
        -- "RAID_WARNING")
    end
end

-- ==== Slash commands [last arg]
SLASH_LOOTRULES1 = "/loot"
SlashCmdList["LOOTRULES"] = function(msg) announceTank() end