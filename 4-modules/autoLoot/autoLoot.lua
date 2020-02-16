-- ------------------------------------------------------------------------------------------------------------------------
-- local A, L, V, P, G, N = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
-- local module = A:GetModule('autoLoot');
-- ------------------------------------------------------------------------------------------------------------------------


-- -- ===== Loot Msg Filter
-- local autoLoot = 0 -- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
-- local minRarityName = "Common"
-- -- :: true false donuyor
-- local function lootfilter(self, event, msg)
--     local itemID = select(3, string.find(msg, "item:(%d+):"))
--     local itemRarity = select(3, GetItemInfo(itemID))
--     if (itemRarity < minRarity) and
--         (string.find(msg, "receives") or string.find(msg, "gets") or
--             string.find(msg, "creates")) then
--         return true
--     else
--         return false
--     end
--     return false
-- end

-- local function lootMsgFilterCmd(msg)
--     if msg then
--         local firsti, lasti, command, value = string.find(msg, "(%w+) \"(.*)\"");
--         if (command == nil) then
--             firsti, lasti, command, value = string.find(msg, "(%w+) (%w+)");
--         end
--         if (command == nil) then
--             firsti, lasti, command = string.find(msg, "(%w+)");
--         end
--         if (command ~= nil) then command = string.lower(command); end
--         -- respond to commands
--         -- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
--         if (command == "poor" or command == "0") then
--             minRarity = 0
--             minRarityName = "|cff9d9d9dPoor|r"
--         end
--         DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffLootFilter|r : " ..
--                                           tostring(minRarityName))
--         UIErrorsFrame:AddMessage("|cff00ccffLootFilter|r : " ..
--                                      tostring(minRarityName))
--     end
-- end

-- -- ==== Slash Handlers [last arg]
-- SLASH_lootFilter1 = "/lootfilter"
-- SlashCmdList["lootFilter"] = function(msg) lootMsgFilterCmd(msg) end
-- ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", lootfilter)
-- SLASH_rollFilter1 = "/rollfilter"
-- SlashCmdList["rollFilter"] = function(msg) rollMsgFilterCmd(msg) end
-- ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", rollfilter)


