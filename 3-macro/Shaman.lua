-- ------------------------------------------------------------------------------------------------------------------------
-- -- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
-- local A, L, V, P, G, C, M, N = unpack(select(2, ...));
-- local moduleName = 'Shaman';
-- local moduleAlert = M .. moduleName .. ": |r";
-- local module = A:GetModule(moduleName);
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Variables
-- -- local shield = ''
-- -- local onehand = ''
-- -- local twohand = ''
-- -- local offhand = ''

-- local setEnhacement = CreateFrame("CheckButton", "enchaceButton", UIParent,
--                               "SecureActionButtonTemplate")
-- setEnhacement:SetAttribute("type", "macro")


-- -- ==== Methods
-- local function handleShield(msg)
--     local a, b, _, c, d, _ = GetWeaponEnchantInfo() local x = 900000 if a and b < x then CancelItemTempEnchantment(1) end if c and d < x then CancelItemTempEnchantment(2) end
--     -- CastSpell(58790)
--     -- if msg ~= '' and msg ~= ' ' and msg ~= nil then shield = GetItemInfo(msg) end
--     -- A.global.warrior.shield = shield
--     -- print(A.global.warrior.shield)
--     -- SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'Your current shield is ' ..
--     --                                    msg)
--     if mod == 1 then
--     enchaceButton:SetAttribute("macrotext", --
--     "#showtooltip
--     /cast [spec:1] Windfury Weapon
--     /cast [spec:2] Windfury Weapon
--     /use 16")
    

-- end

-- -- ==== Start
-- function module:Initialize()
--     if UnitClass('player') == 'Shaman' then
--         self.initialized = true
--         --
--         -- if A.global.warrior == nil then
--         --     A.global.warrior = {
--         --         shield = '',
--         --         onehand = '',
--         --         twohand = '',
--         --         offhand = ''
--         --     }
--         -- end
--         -- --
--         -- shield = A.global.warrior.shield
--         -- onehand = A.global.warrior.onehand
--         -- twohand = A.global.warrior.twohand
--         -- offhand = A.global.warrior.offhand
--         -- handleShield('')
--         -- handleOnehand('')
--         -- handleTwohand('')
--         -- handleOffhand('')
--     end
--     -- :: Register some events
-- end

-- -- ==== Event Handlers

-- -- ==== Slash Handlersd
-- SLASH_test1 = "/test"
-- SlashCmdList["test"] = function(msg) handleShield(msg) end
-- -- SLASH_onehand1 = "/onehand"
-- -- SlashCmdList["onehand"] = function(msg) handleOnehand(msg) end
-- -- SLASH_twohand1 = "/twohand"
-- -- SlashCmdList["twohand"] = function(msg) handleTwohand(msg) end
-- -- SLASH_offhand1 = "/offhand"
-- -- SlashCmdList["offhand"] = function(msg) handleOffhand(msg) end

-- -- -- ==== GUI
-- -- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- -- -- ==== End
-- local function InitializeCallback(msg) module:Initialize(msg) end
-- A:RegisterModule(module:GetName(), InitializeCallback)

-- -- ==== Todo

-- -- ==== UseCase
