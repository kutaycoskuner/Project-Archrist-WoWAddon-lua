------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'LootDB';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local realmName = GetRealmName()
local mod = 'patates' -- rep / not
local isPlayerExists = false
local loot = {} -- 1-itemName, 2-date
local item, count, link, target, rarity
local args = {}
local fixArgs = Arch_fixArgs
-- local setGUI = Arch_setGUI

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- ==== Methods
local function handleCommand(msg)
    if msg == 'x' then
        -- print('a')
        Arch_setGUI('LootDatabasePrune')
    elseif msg ~= '' then
        msg = fixArgs(msg)
        msg = msg[1]
        if A.loot[realmName][msg] then GUI_insertPerson(msg) end
    else
        Arch_setGUI('LootDatabase')
    end
end

local function getItem(msg)

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
          itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
        GetItemInfo(msg)

    if itemName and (itemType == 'Weapon' or itemType == 'Armor') then
        item = itemLink:match("item:(%d+):")
        rarity = itemRarity
        link = itemLink
        count = GetItemCount(item, nil, nil)
    end

    -- print(itemEquipLoc .. ' ' .. itemSubType .. ' ' .. itemType)

end

local function insertLoot(player, stuff, rarity)
    -- :: Rarity check
    if rarity then
        if rarity >= 4 then
            -- :: Guild check
            if UnitInRaid('player') then
                for ii = 1, GetNumGuildMembers() do
                    local playerName = GetGuildRosterInfo(ii)
                    if playerName == player then
                        -- :: Raid check
                        for yy = 1, GetNumRaidMembers() do
                            local playerName = GetRaidRosterInfo(yy)
                            if playerName == player then
                                -- :: Insert
                                local db = A.loot[realmName]
                                if not db[player] then
                                    db[player] = {}
                                end
                                for ii = 1, #db[player] do
                                    if db[player][ii][1] == stuff then
                                        if stuff ~= "Fragment of Val'anyr" then
                                            return
                                        end
                                    end
                                end
                                loot[1] = stuff
                                loot[2] = date("%d-%m-%y")
                                table.insert(db[player], 1, loot)
                                SELECTED_CHAT_FRAME:AddMessage(
                                    moduleAlert .. link .. ' added to ' ..
                                        target)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Database Connection
    if not A.loot[realmName] then A.loot[realmName] = {} end
    -- :: Register some events
    -- "TRADE_ACCEPT_UPDATE"
    -- module:RegisterEvent("WHO_LIST_UPDATE")
    module:RegisterEvent("TRADE_SHOW")
    module:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED")
    module:RegisterEvent("TRADE_CLOSED")
    -- https://wowwiki.fandom.com/wiki/Events/Trade
    -- module:RegisterEvent("CHAT_MSG_SAY");
end

-- ==== Event Handlers
function module:TRADE_PLAYER_ITEM_CHANGED()
    if GetTradePlayerItemLink(arg1) then
        item = GetTradePlayerItemLink(arg1)
        getItem(item)
    end
end

function module:TRADE_CLOSED()
    if (count > GetItemCount(item, nil, nil)) then
        print('test')
        insertLoot(target, item, rarity)
    end
end

function module:TRADE_SHOW()
    target = UnitName('target')
    if GetTradePlayerItemLink(1) then
        item = GetTradePlayerItemLink(1)
        getItem(item)
    end
    if GetTradePlayerItemLink(7) then
        item = GetTradePlayerItemLink(7)
        getItem(item)
    end
end

-- ==== Slash Handlersd
SLASH_lootdb1 = "/lootdb"
SlashCmdList["lootdb"] = function(msg) handleCommand(msg) end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[
    Name: LootDatabase
    1 -->> Creates a database to track who got item in raid
        data structure = {
            [playerName] = {
                {item: , date: },
                {item: , date: },
                {item: , date: },
            }
        }

    2 -->> Trigger with event trade event
        if player is in raid
        if target has same guild with player
        if traded item is epic

    3 -->>  if trade succeed between two characters register person

]]
