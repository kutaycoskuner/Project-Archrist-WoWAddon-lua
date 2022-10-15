------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'EatDrink';
local moduleAlert = M .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local drinks = {"Conjured Purified Water","Conjured Mana Strudel","Pungent Seal Whey","Honeymint Tea", "Morning Glory Dew", "Moonberry Juice", "Sweet Nectar","Melon Juice","Ice Cold Milk"}
-- drinks[5] = "Ice Cold Milk"
-- drinks[15] = "Melon Juice"
-- drinks[25] = "Sweet Nectar"
-- drinks[35] = "Moonberry Juice"
-- drinks[45] = "Morning Glory Dew"
-- drinks[60] = "Filtered Draenic Water"

local foods = {"Conjured Mana Strudel","Honey-Spiced Lichen", "Sour Goat Cheese","Salted Venison", "Succulent Orca Stew", "Mead Basted Caribou"}
local foodClass = {"Warrior", 'Rogue', 'Death Knight', 'Hunter'}

-- ==== Macro
--[[
/run setFeedButton() 
/click feedButton  
]]

-- ==== Methods
local feed = CreateFrame("CheckButton", "feedButton", UIParent,
                         "SecureActionButtonTemplate")
feed:SetAttribute("type", "macro")

local function findConsumableInBag()
    local function findItem(bag, slot)
        local consumable = GetItemInfo(GetContainerItemLink(bag, slot) or 0)
        local class = UnitClass("player")
        local search 
        --
        for ii=1, #foodClass do
            if class == foodClass[ii] then
                search = foods
                break
            else
                search = drinks
            end
        end
        --
        for ii = 1, #search do
            if consumable == search[ii] then
                return select(1, consumable)
            end
        end
    end
    --
    for ii = 4, 0, -1 do
        for jj = GetContainerNumSlots(ii), 1, -1 do
            if findItem(ii, jj) then 
                local item = GetContainerItemLink(ii, jj)
                print(moduleAlert .. "Consuming " .. item .. " (" .. GetItemCount(item) .. ")")
                return ii, jj 
            end
        end
    end
end

function setFeedButton()
    local bag, slot = findConsumableInBag()
    if (not bag or not slot) then
        -- do nothing if no herb, if looting or casting
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Could not find any food")
    else
        feedButton:SetAttribute("macrotext", --
        "#showtooltip \n/use " .. bag .. " " .. slot)
    end
end

-- ==== Start
function module:Initialize() self.initialized = true end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[]]
