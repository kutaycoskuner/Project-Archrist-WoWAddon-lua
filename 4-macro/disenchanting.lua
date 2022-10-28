------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Disenchanting';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- local DT = E:GetModule("DataTexts")
-- source https://www.curseforge.com/wow/addons/millbutton
--[[
#showtooltip milling
/run setdisenchantButton();
/click disenchantButton; 
--]]
-- ==== Macro
local disenchant = CreateFrame("CheckButton", "disenchantButton", UIParent,
                               "SecureActionButtonTemplate")
disenchant:SetAttribute("type", "macro")

local function findItemInBag()
    local function findItem(bag, slot)
        -- print(GetItemInfo(GetContainerItemLink(bag, slot)))
        return ((select(6, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Armor" or
                select(6, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Weapon") and -- !! type
                select(4, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) < 200 and -- !! level
                (select(3, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) > 1 and
                select(3, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) < 4) or nil) -- !! rarity

    end
    --
    for i = 0, 4 do
        for j = 1, GetContainerNumSlots(i) do
            if findItem(i, j) then return i, j end
        end
    end
end

function setdisenchantButton()
    local bag, slot = findItemInBag()
    if (not bag or not slot) or LootFrame:IsVisible() or
        CastingBarFrame:IsVisible() or UnitCastingInfo("player") then
        -- do nothing if no herb, if looting or casting
        print(moduleAlert .. "There are no items for autodisenchant [x<200]")
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

function module:LOOT_OPENED()
    for i = GetNumLootItems(), 1, -1 do LootSlot(i) end
    module:UnregisterEvent("LOOT_OPENED")
    module:UnregisterAllEvents()

end

