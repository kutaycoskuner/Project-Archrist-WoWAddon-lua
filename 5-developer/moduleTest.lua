-- ------------------------------------------------------------------------------------------------------------------------
-- local A, L, V, P, G, N = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
-- local module = A:GetModule('test');
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true
--     -- :: Register some events
--     module:RegisterEvent("CHAT_MSG_SAY");
-- end

-- -- ==== Methods
-- function module:CHAT_MSG_SAY()

--     print('test')

-- end

-- -- ==== End
-- local function InitializeCallback() module:Initialize() end
-- A:RegisterModule(module:GetName(), InitializeCallback)