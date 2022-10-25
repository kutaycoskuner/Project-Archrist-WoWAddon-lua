------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'EatDrink';
local moduleAlert = M .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local drinks = {
    "Conjured Mana Strudel",            --80 conjured all
    "Pungent Seal Whey",                --80
    "Honeymint Tea",                    --80
    "Morning Glory Dew",                --45
    "Moonberry Juice",                  --35
    "Conjured Spring Water",            --25 conjured
    "Sweet Nectar",                     --25
    "Conjured Purified Water",          --15 conjured
    "Melon Juice",                      --15
    "Conjured Fresh Water",             --5 conjured
    "Conjured Water",                   --5 conjured
    "Refreshing Spring Water",          --5 
    "Ice Cold Milk",                    --5
}

local foods = {
    "Conjured Mana Strudel",            --90 conjured all
    "Honey-Spiced Lichen",              --80
    "Sour Goat Cheese",                 --80
    "Salted Venison",                   --80
    "Succulent Orca Stew",              --80
    "Mead Basted Caribou",              --80
    "Conjured Pumpernickel",            --25 conjured333333
    "Conjured Rye",                     --15 conjured
    "Conjured Bread",                   --5 conjured
    "Tough Jerky",                      --5
    "Shiny Red Apple",                  --5
    "Dalaran Sharp",                    --5
    "Westfall Stew",                    --5
    "Goretusk Liver Pie",               --5
    "Cookie's Jumbo Gumbo",
    "Candy Corn",
    "Leg Meat",
    "Freshly Baked Bread",
    "Ripe Watermelon",
    "Bobbing Apple",
}
--
local foodClass = {
    ["Warrior"] = 1, 
    ['Rogue'] = 1, 
    ['Death Knight'] = 1, 
    ['Hunter'] = nil
}

local relateFoodType = {
    ['drink'] = drinks,
    ['food'] = foods
}
-- ==== Macro
--[[
/run setFeedButton('drink') 
/click feedButton  
/run setFeedButton('food') 
/click feedButton
]]

-- ==== Methods
local feed = CreateFrame("CheckButton", "feedButton", UIParent,
                         "SecureActionButtonTemplate")
feed:SetAttribute("type", "macro")
--
local level = UnitLevel('player')
local class = UnitClass("player")

local function findConsumableInBag(foodType)
    local healthPercentage =  UnitHealth('player') / UnitHealthMax('player')
    local powerPercentage = UnitPower('player') / UnitPowerMax('player')
    -- print(healthPercentage .. ' ' .. powerPercentage)
    -- do return end
    -- Find item
    local isFound = false
    local function findItem(bag, slot)
        local consumable = GetItemInfo(GetContainerItemLink(bag, slot) or 0)
        local search 
        if relateFoodType[foodType] then
            search = relateFoodType[foodType]
        else
            do return end
        end
        for ii = 1, #search do
            if consumable == search[ii] then
                return select(1, consumable)
            end
        end
    end
    -- :: eger hp ve can full ise otur bir sey yemeden otur
    if healthPercentage == 1 and powerPercentage == 1 then
        return nil, nil, nil, true
    end
    -- :: Return items' bag coordinates
    for ii = 4, 0, -1 do
        for jj = GetContainerNumSlots(ii), 1, -1 do
            if findItem(ii, jj) then 
                local item = GetContainerItemLink(ii, jj)
                -- :: class / hp conditionals
                if foodType=='food' and foodClass[class] and (healthPercentage~=1) then
                    print(moduleAlert .. "Consuming " .. item .. " (" .. GetItemCount(item) .. ")")
                    return ii, jj, true
                elseif foodType=='food' and foodClass[class]==nil and (healthPercentage~=1) then
                    print(moduleAlert .. "Consuming " .. item .. " (" .. GetItemCount(item) .. ")")
                    return ii, jj, true
                elseif foodType=='drink' and foodClass[class]==nil and (powerPercentage~=1) then
                    print(moduleAlert .. "Consuming " .. item .. " (" .. GetItemCount(item) .. ")")
                    return ii, jj, true
                else    
                    isFound = true
                    break
                end
            end
        end
    end
    --
    return nil, nil, isFound
end

function setFeedButton(foodType)
    local bag, slot, noPrint, full = findConsumableInBag(foodType)
    if full then
        feedButton:SetAttribute("macrotext", --
        "/sit")
        -- SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "You are already full " .. foodType)
    elseif not noPrint then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Could not find any " .. foodType)
    elseif bag==nil and noPrint then
        do return end
    elseif bag and slot then
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
