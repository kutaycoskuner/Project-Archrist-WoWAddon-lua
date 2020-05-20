------------------------------------------------------------------------------------------------------------------------
-- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'Warrior';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local shield = ''
local onehand = ''
local twohand = ''
local offhand = ''

local setShield = CreateFrame("CheckButton", "shieldButton", UIParent,
                              "SecureActionButtonTemplate")
setShield:SetAttribute("type", "macro")
local setOnehand = CreateFrame("CheckButton", "onehandButton", UIParent,
                               "SecureActionButtonTemplate")
setOnehand:SetAttribute("type", "macro")
local setTwohand = CreateFrame("CheckButton", "twohandButton", UIParent,
                               "SecureActionButtonTemplate")
setTwohand:SetAttribute("type", "macro")
local setOffhand = CreateFrame("CheckButton", "offhandButton", UIParent,
                               "SecureActionButtonTemplate")
setOffhand:SetAttribute("type", "macro")

-- ==== Methods
local function handleShield(msg)
    if msg ~= '' and msg ~= ' ' and msg ~= nil then shield = GetItemInfo(msg) end
    A.global.warrior.shield = shield
    print(A.global.warrior.shield)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current shield is ' ..
                                       msg)
    shieldButton:SetAttribute("macrotext", --
    "/equip " .. shield)
end

local function handleOnehand(msg)
    if msg ~= '' and msg ~= ' ' and msg ~= nil then
        onehand = GetItemInfo(msg)
    end
    A.global.warrior.onehand = onehand
    print(A.global.warrior.onehand)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current onehand is ' ..
                                       msg)
    onehandButton:SetAttribute("macrotext", --
    "/equip " .. onehand)
end

local function handleTwohand(msg)
    if msg ~= '' and msg ~= ' ' and msg ~= nil then
        twohand = GetItemInfo(msg)
    end
    A.global.warrior.twohand = twohand
    print(A.global.warrior.twohand)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current twohand is ' ..
                                       msg)
    twohandButton:SetAttribute("macrotext", --
    "/equip " .. twohand)
end

local function handleOffhand(msg)
    if msg ~= '' and msg ~= ' ' and msg ~= nil then
        offhand = GetItemInfo(msg)
    end
    A.global.warrior.offhand = offhand
    print(A.global.warrior.offhand)
    SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current offhand is ' ..
                                       msg)
    offhandButton:SetAttribute("macrotext", --
    "/equip " .. offhand)
end

-- ==== Start
function module:Initialize()
    if UnitClass('player') == 'Warrior' then
        self.initialized = true
        --
        if A.global.warrior == nil then
            A.global.warrior = {
                shield = '',
                onehand = '',
                twohand = '',
                offhand = ''
            }
        end
        --
        shield = A.global.warrior.shield
        onehand = A.global.warrior.onehand
        twohand = A.global.warrior.twohand
        offhand = A.global.warrior.offhand
        handleShield('')
        handleOnehand('')
        handleTwohand('')
        handleOffhand('')
    end
    -- :: Register some events
end

-- ==== Event Handlers

-- ==== Slash Handlersd
SLASH_shield1 = "/shield"
SlashCmdList["shield"] = function(msg) handleShield(msg) end
SLASH_onehand1 = "/onehand"
SlashCmdList["onehand"] = function(msg) handleOnehand(msg) end
SLASH_twohand1 = "/twohand"
SlashCmdList["twohand"] = function(msg) handleTwohand(msg) end
SLASH_offhand1 = "/offhand"
SlashCmdList["offhand"] = function(msg) handleOffhand(msg) end

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- -- ==== End
local function InitializeCallback(msg) module:Initialize(msg) end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo

-- ==== UseCase
