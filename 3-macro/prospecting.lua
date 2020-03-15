------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'prospecting';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- local DT = E:GetModule("DataTexts")
-- source https://www.curseforge.com/wow/addons/millbutton
--[[
#showtooltip milling
/run setMillButton() 
/click prospectButton  
--]]
-- ==== Macro
local prospect = CreateFrame("CheckButton", "prospectButton", UIParent, "SecureActionButtonTemplate")
prospect:SetAttribute("type", "macro")


local function findMineInBag()
    local function findItem(bag, slot)
    -- print(GetItemInfo(GetContainerItemLink(bag, slot)))
    return (select(1, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Thorium Ore" or 
           select(1, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Fel Iron Ore" or
           select(1, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Cobalt Ore" or
           select(1, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) == "Adamantite Ore") and 
           select(2, GetContainerItemInfo(bag, slot)) >= 5
    end
    --
    for i = 0, 4 do
        for j = 1, GetContainerNumSlots(i) do
            if findItem(i, j) then return i, j end
        end
    end
end

function setProspectButton()
    local bag, slot = findMineInBag()
    if (not bag or not slot) or LootFrame:IsVisible() or
        CastingBarFrame:IsVisible() or UnitCastingInfo("player") then
        -- do nothing if no herb, if looting or casting
        prospectButton:SetAttribute("macrotext", "")
        -- print('test') --for i = GetNumLootItems(), 1, -1 do LootSlot(i) end
        if not bag then print(moduleAlert .. "No more ore in stacks of 5 or more.") end
    else
        module:RegisterEvent("LOOT_OPENED")
        prospectButton:SetAttribute("macrotext", --
                                "/cast prospecting\n/use " .. bag .. " " .. slot)
    end
end
 
function module:LOOT_OPENED()
    for i = GetNumLootItems(), 1, -1 do LootSlot(i) end
    module:UnregisterEvent("LOOT_OPENED")
    module:UnregisterAllEvents()

end

