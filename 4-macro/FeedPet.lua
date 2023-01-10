------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'FeedPet';
local moduleAlert = M .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
-- :: professions
local feedPet = "feed pet"

-- :: localization (language) --
local locale = GetLocale()
if locale == "deDE" then
    feedPet = "tier füttern"
end

local meats = Arch_futter["fishes"]


-- local meats = {
--     "Moongraze Stag Tenderloin",                --meat
--     "Slitherskin Mackarel",                     --fish
--     "Brilliant Smallfish",                      --fish
-- }

-- local fishes = {}
--
local foodClass = {
    ["Warrior"] = 1, 
    ['Rogue'] = 1, 
    ['Death Knight'] = 1, 
    ['Hunter'] = nil
}

-- ==== Macro
--[[
/run setFeedPetButton() 
/click feedPetButton  
]]

-- ==== Methods
local feed = CreateFrame("CheckButton", "feedPetButton", UIParent,
                         "SecureActionButtonTemplate")
feed:SetAttribute("type", "macro")
--
local level = UnitLevel('player')
local class = UnitClass("player")

local function findConsumableInBag()
    local healthPercentage =  UnitHealth('player') / UnitHealthMax('player')
    local powerPercentage = UnitPower('player') / UnitPowerMax('player')
    local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
    -- print(happiness .. ' ' .. damagePercentage .. ' ' .. loyaltyRate)
    if happiness == nil or happiness == 3 then
        return "happy" 
    end
    -- :: Find item
    local isFound = false
    local function findItem(bag, slot)
        local consumable = GetContainerItemID(bag, slot)        
        local search = meats 
        -- if relateFoodType[foodType] then
        --     search = relateFoodType[foodType]
        -- else
            -- do return end
        -- end
        for ii = 1, #search do
            if consumable == search[ii] then
                return select(1, consumable)
            end
        end
    end
    -- :: eger hp ve can full ise otur bir sey yemeden otur
    -- if healthPercentage == 1 and powerPercentage == 1 then
    --     return nil, nil, nil, true
    -- end
    -- :: Return items' bag coordinates
    for ii = 4, 0, -1 do
        for jj = GetContainerNumSlots(ii), 1, -1 do
            if findItem(ii, jj) then 
                local item = GetContainerItemLink(ii, jj)
                -- :: class / hp conditionals
                if item then
                    return ii, jj, item
                end
            end
        end
    end
    --
    return nil
end

function setFeedPetButton()
    local bag, slot, item = findConsumableInBag()
    if bag == "happy" then
        -- :: eger mutluluk fuldeyse beslemiyor macrotexti bos birakiyor
        feedPetButton:SetAttribute("macrotext")
    elseif bag and slot then
        feedPetButton:SetAttribute("macrotext", --
        "#showtooltip \n/cast ".. feedPet .. "\n/use " .. bag .. " " .. slot)
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Feeding pet with " .. item .. " (" .. GetItemCount(item) .. ")")
    else
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. "Could not find any futter")
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
