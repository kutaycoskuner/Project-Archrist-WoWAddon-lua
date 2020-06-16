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
local item, count, link, tradeTarget, rarity, name, type
local blocker = false
local args = {}
local fixArgs = Arch_fixArgs
local focus = Arch_focusColor
-- local setGUI = Arch_setGUI

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- ==== Methods
local function getItem(msg)

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
          itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
        GetItemInfo(msg)

    -- if itemName and (itemType == 'Weapon' or itemType == 'Armor') then
    item = itemLink:match("item:(%d+):")

    itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
        GetItemInfo(item)

    rarity = itemRarity
    link = itemLink
    count = GetItemCount(item, nil, nil)
    name = itemName
    type = itemType
    -- end

    -- print(itemEquipLoc .. ' ' .. itemSubType .. ' ' .. itemType)

end

local function insertLoot(player, stuff, rarity)
    -- :: Rarity check
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
                            -- test
                            if not A.loot[realmName][player] then
                                A.loot[realmName][player] = {}
                            end
                            -- :: item daha once eklenmisse kabul etmiyor
                            for jj = 1, #A.loot[realmName][player] do
                                if A.loot[realmName][player][jj][3] == stuff and
                                    A.loot[realmName][player][jj][1] ==
                                    date("%d-%m-%y") then
                                    SELECTED_CHAT_FRAME:AddMessage(
                                        moduleAlert .. link ..
                                            ' already exists on ' .. player)
                                    return
                                end
                            end
                            -- >> 
                            -- if type == 'Weapon' or type == 'Armor' then
                            -- end
                            -- >>
                            local loot = {}
                            loot = {date("%d-%m-%y"), name, stuff}
                            table.insert(A.loot[realmName][player], 1, loot)
                            SELECTED_CHAT_FRAME:AddMessage(
                                moduleAlert .. link .. ' added to ' .. player)
                            -- test
                            return
                        end
                    end
                end
            end
        end
    end
end

local function handleCommand(msg)
    if msg == 'x' then
        Arch_setGUI('LootDatabasePrune', true)
    elseif msg == 'wipe' then
        A.loot[realmName] = {}
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert ..
                                           'your loot database has been wiped.')
    elseif msg ~= '' then
        msg = fixArgs(msg)
        if msg[2] then
            local args = msg
            local player, loot
            local legit = false
            -- :: defensive argumanlar var mi 
            if args[1] then player = args[1] end
            if args[2] then loot = args[2] end
            -- :: player gercekten var mi kontrolu
            for ii = 1, GetNumGuildMembers() do
                local isExists = GetGuildRosterInfo(ii)
                if isExists == player then
                    legit = true
                    break
                end
            end
            --
            if legit then
                if not A.loot[realmName][player] then
                    A.loot[realmName][player] = {}
                end
                local core = {}
                getItem(loot)
                core = {date("%d-%m-%y"), name, item}
                table.insert(A.loot[realmName][player], 1, core)
                SELECTED_CHAT_FRAME:AddMessage(
                    moduleAlert .. link .. ' added to ' .. player)
                GUI_insertPerson(args[1], true)
            end
            return
        end
        msg = msg[1]
        if A.loot[realmName][msg] then
            GUI_insertPerson(msg)
        else
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. focus(msg) .. ' is not found in your database')
        end
    else
        Arch_setGUI('LootDatabase')
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
    local itemCount
    --
    if GetItemCount(item, nil, nil) == nil then
        itemCount = 0
    else
        itemCount = GetItemCount(item, nil, nil)
    end
    --
    if count == nil then count = 0 end
    --
    if (count > itemCount) and blocker == false then
        blocker = true
        insertLoot(tradeTarget, item, rarity)
    end
end

function module:TRADE_SHOW()
    blocker = false
    count = 0
    tradeTarget = UnitName('npc')
    if UnitInRaid('player') then
        -- SELECTED_CHAT_FRAME:AddMessage(moduleAlert ..
        --                                    'Please give raid loot one by one to ' ..
        --                                    tradeTarget)
    end
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
        if tradeTarget has same guild with player
        if traded item is epic

    3 -->>  if trade succeed between two characters register person

]]
