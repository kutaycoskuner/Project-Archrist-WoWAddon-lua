-- ------------------------------------------------------------------------------------------------------------------------
-- -- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
-- local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
-- local moduleName = 'DeathKnight';
-- local moduleAlert = M .. moduleName .. ": |r";
-- local module = A:GetModule(moduleName);
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Variables
-- local shield = ''
-- local onehand = ''
-- local twohand = ''
-- local offhand = ''

-- local setShield = CreateFrame("CheckButton", "shieldButton", UIParent,
--                               "SecureActionButtonTemplate")
-- setShield:SetAttribute("type", "macro")
-- local setOnehand = CreateFrame("CheckButton", "onehandButton", UIParent,
--                                "SecureActionButtonTemplate")
-- setOnehand:SetAttribute("type", "macro")
-- local setTwohand = CreateFrame("CheckButton", "twohandButton", UIParent,
--                                "SecureActionButtonTemplate")
-- setTwohand:SetAttribute("type", "macro")
-- local setOffhand = CreateFrame("CheckButton", "offhandButton", UIParent,
--                                "SecureActionButtonTemplate")
-- setOffhand:SetAttribute("type", "macro")

-- -- ==== Methods
-- local function handleShield(msg)
--     if msg ~= '' and msg ~= ' ' and msg ~= nil then shield = GetItemInfo(msg) end
--     A.global.deathKnight.shield = shield
--     print(A.global.deathKnight.shield)
--     SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current shield is ' ..
--                                        msg)
--     shieldButton:SetAttribute("macrotext", --
--     "/equip " .. shield)
-- end

-- local function handleOnehand(msg)
--     if msg ~= '' and msg ~= ' ' and msg ~= nil then
--         onehand = GetItemInfo(msg)
--     end
--     A.global.deathKnight.onehand = onehand
--     print(A.global.deathKnight.onehand)
--     SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current onehand is ' ..
--                                        msg)
--     onehandButton:SetAttribute("macrotext", --
--     "/equip " .. onehand)
-- end

-- local function handleTwohand(msg)
--     if msg ~= '' and msg ~= ' ' and msg ~= nil then
--         twohand = GetItemInfo(msg)
--     end
--     A.global.deathKnight.twohand = twohand
--     print(A.global.deathKnight.twohand)
--     SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current twohand is ' ..
--                                        msg)
--     twohandButton:SetAttribute("macrotext", --
--     "/equip " .. twohand)
-- end

-- local function handleOffhand(msg)
--     if msg ~= '' and msg ~= ' ' and msg ~= nil then
--         offhand = GetItemInfo(msg)
--     end
--     A.global.deathKnight.offhand = offhand
--     print(A.global.deathKnight.offhand)
--     SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current offhand is ' ..
--                                        msg)
--     offhandButton:SetAttribute("macrotext", --
--     "/equip " .. offhand)
-- end

-- -- ==== Start
-- function module:Initialize()
--     if UnitClass('player') == 'Death Knight' then
--         self.initialized = true
--         --
--         if A.global.deathKnight == nil then
--             A.global.deathKnight = {
--                 shield = '',
--                 onehand = '',
--                 twohand = '',
--                 offhand = ''
--             }
--         end
--         --
--         shield = A.global.deathKnight.shield
--         onehand = A.global.deathKnight.onehand
--         twohand = A.global.deathKnight.twohand
--         offhand = A.global.deathKnight.offhand
--         handleShield('')
--         handleOnehand('')
--         handleTwohand('')
--         handleOffhand('')
--     end
--     -- :: Register some events
-- end

-- -- ==== Event Handlers

-- -- ==== Slash Handlersd
-- SLASH_dkonehand1 = "/onehand"
-- SlashCmdList["dkonehand"] = function(msg) handleOnehand(msg) end
-- SLASH_dktwohand1 = "/twohand"
-- SlashCmdList["dktwohand"] = function(msg) handleTwohand(msg) end
-- SLASH_dkoffhand1 = "/offhand"
-- SlashCmdList["dkoffhand"] = function(msg) handleOffhand(msg) end

-- -- -- ==== GUI
-- -- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- -- -- ==== End
-- local function InitializeCallback(msg) module:Initialize(msg) end
-- A:RegisterModule(module:GetName(), InitializeCallback)

-- -- ==== Todo

-- -- ==== UseCase
