------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Test';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local realmName = GetRealmName()

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- ==== Methods
local function handleCommand(msg)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
    itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
        GetItemInfo(msg)
    SELECTED_CHAT_FRAME:AddMessage(itemLink .. ', ' .. date("%d-%m-%y"))
end

-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Database Connection
    if not A.loot[realmName] then A.loot[realmName] = {} end
    -- :: Register some events
    -- "TRADE_ACCEPT_UPDATE"
    -- https://wowwiki.fandom.com/wiki/Events/Trade
    -- module:RegisterEvent("CHAT_MSG_SAY");
end

-- ==== Event Handlers
function module:CHAT_MSG_SAY()
end

-- ==== Slash Handlersd
SLASH_test1 = "/test"
SlashCmdList["test"] = function(msg) handleCommand(msg) end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[

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