------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'LootRules';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then return end

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local raidAlerts = Arch_raidAlerts
local isEnabled = true
local string1 =
    "Loot Rules: Armor Prio & MS > OS & PvP Roll Spec Prio if not indicated otherwise" -- & 10 point decrease next roll for every acquired item
local string2 =
    "Rolling item for selling is forbidden will result you to ban for further raids"

-- ==== Body
local function announceLootRules(msg)
    if isEnabled then
        if msg == '' or msg == nil then
            -- SELECTED_CHAT_FRAME:AddMessage(string1)
            SendChatMessage(raidAlerts.lootrules.loot, "RAID_WARNING") -- RAID_WARNING, SAY
        else
            SendChatMessage(raidAlerts.lootrules[msg], "RAID_WARNING")
        end
        SendChatMessage(raidAlerts.lootrules.warning, "RAID_WARNING")

        if msg == 'voa' then
            -- SendChatMessage(raidAlerts.lootrules.twoboss, "RAID_WARNING")
        elseif msg == 'toc' then
            SendChatMessage(raidAlerts.lootrules.onetrophy, "RAID_WARNING")
        elseif msg == 'icc' then
            SendChatMessage(raidAlerts.lootrules.boe, "RAID_WARNING")
        end
        -- SendChatMessage(string3, "RAID_WARNING") -- RAID_WARNING, SAY
        -- "channel", nil, "5")
        -- "RAID_WARNING")
    end
end

-- ==== Slash commands [last arg]
SLASH_LOOTRULES1 = "/rules"
SlashCmdList["LOOTRULES"] = function(msg) announceLootRules(msg) end
