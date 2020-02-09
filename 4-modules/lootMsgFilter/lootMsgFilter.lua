-- ==== Credit
-- fremion, Brad Morgan
------------------------------------------------------------------------------------------
local main, L, V, P, G = unpack(select(2, ...)); -- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB
local module = main:GetModule('lootMsgFilter');
------------------------------------------------------------------------------------------
-- ===== Loot Msg Filter
local minRarity = 1 -- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
local minRarityName = "Common"
-- :: true false donuyor
local function lootfilter(self, event, msg)
    local itemID = select(3, string.find(msg, "item:(%d+):"))
    local itemRarity = select(3, GetItemInfo(itemID))
    if (itemRarity < minRarity) and
        (string.find(msg, "receives") or string.find(msg, "gets") or
            string.find(msg, "creates")) then
        return true
    else
        return false
    end
    return false
end

local function lootMsgFilterCmd(msg)
    if msg then
        local firsti, lasti, command, value = string.find(msg, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(msg, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(msg, "(%w+)");
        end
        if (command ~= nil) then command = string.lower(command); end
        -- respond to commands
        -- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
        if (command == "poor" or command == "0") then
            minRarity = 0
            minRarityName = "|cff9d9d9dPoor|r"
        elseif (command == "common" or command == "1") then
            minRarity = 1
            minRarityName = "|cffffffffCommon|r"
        elseif (command == "uncommon" or command == "2") then
            minRarity = 2
            minRarityName = "|cff1eff00Uncommon|r"
        elseif (command == "rare" or command == "3") then
            minRarity = 3
            minRarityName = "|cff0070ddRare|r"
        elseif (command == "epic" or command == "4") then
            minRarity = 4
            minRarityName = "|cffa335eeEpic|r"
        elseif (command == "legendary" or command == "5") then
            minRarity = 5
            minRarityName = "|cffff8000Legendary|r"
        elseif (command == "artifact" or command == "6") then
            minRarity = 6
            minRarityName = "|cff00ccffArtifact|r"
        elseif (command == "heirloom" or command == "7") then
            minRarity = 7
            minRarityName = "|cffe6cc80Heirloom|r"
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffLootFilter|r : " ..
                                          tostring(minRarityName))
        UIErrorsFrame:AddMessage("|cff00ccffLootFilter|r : " ..
                                     tostring(minRarityName))
    end
end

-- ==== Roll Filter 
local eliminateGreed = false

local function rollMsgFilterCmd(msg)
    if msg then
        local firsti, lasti, command, value = string.find(msg, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(msg, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(msg, "(%w+)");
        end
        -- :: komut varsa
        if (command ~= nil) then command = string.lower(command); end
        --
        if (command == "false" or command == "0") then
            eliminateGreed = false
        elseif (command == "true" or command == "1") then
            eliminateGreed = true
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffRollFilter|r : " ..
                                          tostring(eliminateGreed))
        UIErrorsFrame:AddMessage("|cff00ccffRollFilter|r : " ..
                                     tostring(eliminateGreed))
    end
end

-- :: true false donuyor
local function rollfilter(self, event, msg)
	if (eliminateGreed == true and (string.find(msg, "Greed") or string.find(msg, "passed") or string.find(msg, "disenchant"))) then
        return true
    else
        return false
    end
    return false
end

-- ==== Slash Handlers [last arg]
SLASH_lootFilter1 = "/lootfilter"
SlashCmdList["lootFilter"] = function(msg) lootMsgFilterCmd(msg) end
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", lootfilter)
SLASH_rollFilter1 = "/rollfilter"
SlashCmdList["rollFilter"] = function(msg) rollMsgFilterCmd(msg) end
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", rollfilter)


