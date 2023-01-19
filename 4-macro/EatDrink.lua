------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'EatDrink';
local moduleAlert = M .. ": |r";
local aprint = Arch_print
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local foods = Arch_consumables["foods"]
local drinks = Arch_consumables["drinks"]
local tCol = Arch_trivialColor
local interval = 6
local availableAt = GetServerTime()

--
local foodClass = {
    ["Warrior"] = true, 
    ['Rogue'] = true, 
    ['Death Knight'] = true, 
    -- ['Hunter'] = false
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


local function tprint(msg)
    if GetServerTime() > availableAt then
        aprint(msg)
        availableAt = GetServerTime() + interval
    end
end

local function findConsumableInBag(foodType)
    local healthPercentage =  UnitHealth('player') / UnitHealthMax('player')
    local powerPercentage = UnitPower('player') / UnitPowerMax('player')
    -- www(healthPercentage .. ' ' .. powerPercentage)
    -- do return end
    -- Find item
    local isFound = false
    local function findItem(bag, slot)
        local consumable = C_Container.GetContainerItemID(bag, slot)--GetItemInfo(GetContainerItemLink(bag, slot) or 0)
        local search 
        if relateFoodType[foodType] then
            search = relateFoodType[foodType]
        else
            do return end
        end
        for ii = 1, #search do
            if consumable == search[ii] then
                -- print(consumable, setID, expacID, classID, subclassID)
                return select(1, consumable)
            end
        end
    end
    -- :: eger hp ve can full ise otur bir sey yemeden otur
    if healthPercentage == 1 and powerPercentage == 1 then
        return nil, nil, nil, nil, true
    end
    -- :: Return items' bag coordinates
    for ii = 4, 0, -1 do
        for jj = C_Container.GetContainerNumSlots(ii), 1, -1 do
            if findItem(ii, jj) then 
                local item = C_Container.GetContainerItemLink(ii, jj)
                -- :: class / hp conditionals
                if foodType=='drink' and foodClass[class]==nil and (powerPercentage~=1) then
                    return item, ii, jj, true
                elseif foodType=='food' and foodClass[class] and (healthPercentage~=1) then
                    return item, ii, jj, true
                elseif foodType=='food' and foodClass[class]==nil and (healthPercentage~=1) then
                    return item, ii, jj, true
                else    
                    isFound = true
                    break
                end
            end
        end
    end
    --
    return nil, nil, nil, isFound
end

function setFeedButton(foodType)
    local item, bag, slot, noPrint, full = findConsumableInBag(foodType)
    if full then
        feedButton:SetAttribute("macrotext", --
        "/sit")
        -- SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "You are already full " .. foodType)
    elseif not noPrint then
        tprint("Could not find any " .. foodType)
    elseif bag==nil and noPrint then
        do return end
    elseif bag and slot then
        feedButton:SetAttribute("macrotext", --
        "#showtooltip \n/use " .. bag .. " " .. slot)
        tprint(tCol("Consuming ") .. item .. tCol(" (" .. GetItemCount(item) .. ")"))
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
