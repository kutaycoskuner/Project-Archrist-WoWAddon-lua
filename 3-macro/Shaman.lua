------------------------------------------------------------------------------------------------------------------------
-- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'Shaman';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local mod = 1

local setEnhancement = CreateFrame("CheckButton", "enhanceButton", UIParent,
                                   "SecureActionButtonTemplate")
setEnhancement:SetAttribute("type", "macro")

-- ==== Methods
function Arch_shamanWeapons()
    local a, b, _, c, d, _ = GetWeaponEnchantInfo()
    if mod == 4 then mod = 1 end
    if mod == 1 then
        if a then
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. 'clearing enhancements')
            enhanceButton:SetAttribute("macrotext",
                                       "/run CancelItemTempEnchantment(1)")
            mod = mod + 1
            return
        end
        mod = mod + 1
    end
    if mod == 2 then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'applying mainhand')
        enhanceButton:SetAttribute("macrotext", "/cast Windfury Weapon")
        mod = mod + 1
        return
    end
    if mod == 3 then
        SELECTED_CHAT_FRAME:AddMessage(moduleAlert .. 'applying offhand')
        enhanceButton:SetAttribute("macrotext", "/cast Flametongue Weapon")
        mod = mod + 1
        return
    end
end

-- ==== Start
function module:Initialize()
    if UnitClass('player') == 'Shaman' then self.initialized = true end
end

-- -- ==== End
local function InitializeCallback(msg) module:Initialize(msg) end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo

-- ==== UseCase
