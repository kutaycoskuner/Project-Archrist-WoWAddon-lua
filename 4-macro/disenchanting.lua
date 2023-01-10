------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'Disenchanting', "Disenchanting";
local moduleAlert = M .. moduleName2 .. ": |r";
local module = A:GetModule(moduleName1, true);
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[
/run setdisenchantButton() 
/click disenchantButton  
]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local disenchant = CreateFrame("CheckButton", "disenchantButton", UIParent, "SecureActionButtonTemplate")
disenchant:SetAttribute("type", "macro")

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true

    -- :: superset construct
    if A.global.macros == nil then
        A.global.macros = {}
    end
    if A.global.macros.disenchanting == nil then
        A.global.macros.disenchanting = {}
    end
    -- :: set variable: is enabled
    if A.global.macros.disenchanting.isEnabled == nil then
        A.global.macros.disenchanting.isEnabled = false
    end
    -- :: set variable: is enabled
    if A.global.macros.disenchanting.min == nil then
        A.global.macros.disenchanting.min = 1
    end
    -- :: set variable: is enabled
    if A.global.macros.disenchanting.max == nil then
        A.global.macros.disenchanting.max = 100
    end
    -- :: set variable: is enabled
    if A.global.macros.disenchanting.maxRarity == nil then
        A.global.macros.disenchanting.maxRarity = 2
    end
    -- module:RegisterEvent("PLAYER_REGEN_ENABLED")
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods

local function findItemInBag()
    local function findItem(bag, slot)
        -- print(GetItemInfo(GetContainerItemLink(bag, slot)))
        return ((select(6, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Armor" or
                   select(6, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Weapon") and -- !! type
                   select(4, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) <= A.global.macros.disenchanting.max and -- !! level
                   select(4, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) >= A.global.macros.disenchanting.min and -- !! level
                   (select(3, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) > 1 and
                       select(3, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) <
                       A.global.macros.disenchanting.maxRarity) or nil) -- !! rarity

    end
    --
    for i = 0, 4 do
        for j = 1, GetContainerNumSlots(i) do
            if findItem(i, j) then
                return i, j
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods
function setdisenchantButton()
    local bag, slot = findItemInBag()
    if (not bag or not slot) or LootFrame:IsVisible() or CastingBarFrame:IsVisible() or UnitCastingInfo("player") then
        -- do nothing if no herb, if looting or casting
        print(moduleAlert .. "There are no items for disenchanting")
        disenchantButton:SetAttribute("macrotext", --
        "/cast disenchant")
        -- print('test') --for i = GetNumLootItems(), 1, -1 do LootSlot(i) end
        -- if not bag then
        --     print(moduleAlert .. "Cant find any item")
        -- end
    else
        print(moduleAlert .. bag .. " " .. slot)
        module:RegisterEvent("LOOT_OPENED")
        disenchantButton:SetAttribute("macrotext", --
        "/cast disenchant\n/use " .. bag .. " " .. slot)
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
function module:LOOT_OPENED()
    for i = GetNumLootItems(), 1, -1 do
        LootSlot(i)
    end
    module:UnregisterEvent("LOOT_OPENED")
    module:UnregisterAllEvents()

end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
-- SLASH_reputation1 = "/rep"
-- SlashCmdList["reputation"] = function(msg)
--     handlePlayerStat(msg, 'reputation')
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)

