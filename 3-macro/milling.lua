------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'milling';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- local DT = E:GetModule("DataTexts")
-- source https://www.curseforge.com/wow/addons/millbutton
--[[
#showtooltip milling
/run setMillButton() 
/click MillButton  
--]]
-- ==== Macro
local mill = CreateFrame("CheckButton", "MillButton", UIParent, "SecureActionButtonTemplate")
mill:SetAttribute("type", "macro")


local function findHerbInBag()
    local function findItem(bag, slot)
    return select(1, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) ~="Frost Lotus" and
           select(7, GetItemInfo(GetContainerItemLink(bag, slot) or 0)) =="Herb" and 
           select(2, GetContainerItemInfo(bag, slot)) >= 5
    end
    --
    for i = 0, 4 do
        for j = 1, GetContainerNumSlots(i) do
            if findItem(i, j) then return i, j end
        end
    end
end

function setMillButton()
    local bag, slot = findHerbInBag()
    if (not bag or not slot) or LootFrame:IsVisible() or
        CastingBarFrame:IsVisible() or UnitCastingInfo("player") then
        -- do nothing if no herb, if looting or casting
        MillButton:SetAttribute("macrotext", "")
        -- print('test') --for i = GetNumLootItems(), 1, -1 do LootSlot(i) end
        if not bag then print(moduleAlert .. "No more herbs in stacks of 5 or more.") end
    else
        module:RegisterEvent("LOOT_OPENED")
        MillButton:SetAttribute("macrotext", --
                                "/cast Milling\n/use " .. bag .. " " .. slot)
    end
end
 
function module:LOOT_OPENED()
    for i = GetNumLootItems(), 1, -1 do LootSlot(i) end
    module:UnregisterEvent("LOOT_OPENED")
    module:UnregisterAllEvents()

end

