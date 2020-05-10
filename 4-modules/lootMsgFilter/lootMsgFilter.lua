-- ==== Credit
-- fremion, Brad Morgan
------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'lootMsgFilter';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------

-- ===== Loot Msg Filter
local minRarity = 1 -- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
local minRarityName = "Common"
local eliminateGreed = true;

function module:Initialize()
    self.initialized = true

    if A.global.minRarity == nil then
        A.global.minRarity = 0
    end

    if A.global.minRarityName == nil then
        A.global.minRarityName = "|cff9d9d9dPoor|r"
    end

    if A.global.eliminateGreed == nil then
        A.global.eliminateGreed = false
    end

    minRarity = A.global.minRarity
    minRarityName = A.global.minRarityName
    eliminateGreed = A.global.eliminateGreed
    
    -- :: Register some events
end

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
            A.global.minRarity, minRarity = 0, 0
            A.global.minRarityName, minRarityName = "|cff9d9d9dPoor|r", "|cff9d9d9dPoor|r"
        elseif (command == "common" or command == "1") then
            A.global.minRarity, minRarity = 1, 1
            A.global.minRarityName, minRarityName = "|cffffffffCommon|r", "|cffffffffCommon|r"
        elseif (command == "uncommon" or command == "2") then
            A.global.minRarity, minRarity = 2, 2
            A.global.minRarityName, minRarityName = "|cff1eff00Uncommon|r", "|cff1eff00Uncommon|r"
        elseif (command == "rare" or command == "3") then
            A.global.minRarity, minRarity = 3, 3
            A.global.minRarityName, minRarityName = "|cff0070ddRare|r", "|cff0070ddRare|r"
        elseif (command == "epic" or command == "4") then
            A.global.minRarity, minRarity = 4, 4
            A.global.minRarityName, minRarityName = "|cffa335eeEpic|r", "|cffa335eeEpic|r"
        elseif (command == "legendary" or command == "5") then
            A.global.minRarity, minRarity = 5, 5
            A.global.minRarityName, minRarityName = "|cffff8000Legendary|r", "|cffff8000Legendary|r"
        elseif (command == "artifact" or command == "6") then
            A.global.minRarity, minRarity = 6, 6
            A.global.minRarityName, minRarityName = "|cff00ccffArtifact|r", "|cff00ccffArtifact|r"
        elseif (command == "heirloom" or command == "7") then
            A.global.minRarity, minRarity = 7, 7
            A.global.minRarityName, minRarityName = "|cffe6cc80Heirloom|r", "|cffe6cc80Heirloom|r"
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffLootFilter|r : " ..
                                          tostring(minRarityName))
        UIErrorsFrame:AddMessage("|cff00ccffLootFilter|r : " ..
                                     tostring(minRarityName))
    end
end

-- ==== Roll Filter 

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
            A.global.eliminateGreed, eliminateGreed = false, false
        elseif (command == "true" or command == "1") then
            A.global.eliminateGreed, eliminateGreed = true, true
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffRollFilter|r : " ..
                                          tostring(eliminateGreed))
        UIErrorsFrame:AddMessage("|cff00ccffRollFilter|r : " ..
                                     tostring(eliminateGreed))
    end
end

-- :: true false donuyor
local function rollfilter(self, event, msg)
	if (eliminateGreed == true and (string.find(msg, "Greed") or string.find(msg, "passed") or string.find(msg, "Disenchant"))) then
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
SLASH_rollFilter1 = "/rollfilter" --:: true false
SlashCmdList["rollFilter"] = function(msg) rollMsgFilterCmd(msg) end
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", rollfilter)



-- -- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

