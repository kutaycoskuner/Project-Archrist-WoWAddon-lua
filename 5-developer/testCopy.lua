-- ------------------------------------------------------------------------------------------------------------------------
-- -- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
-- local A, L, V, P, G, C, M, N = unpack(select(2, ...));
-- local moduleName = 'test';
-- local moduleAlert = M .. moduleName .. ": |r";
-- local module = A:GetModule(moduleName);
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Variables

-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true
--     -- :: Register some events
--     module:RegisterEvent("CHAT_MSG_SAY");
-- end

-- -- ==== Methods
-- local function handleCommand()
--     print('test')
-- end

-- -- ==== Event Handlers
-- function module:CHAT_MSG_SAY()
--     --print('test')
-- end

-- -- ==== Slash Handlersd
-- -- SLASH_test1 = "/test"
-- -- SlashCmdList["test"] = function() handleCommand() end

-- -- -- ==== End
-- local function InitializeCallback() module:Initialize() end
-- A:RegisterModule(module:GetName(), InitializeCallback)

-- -- ==== Todo

-- -- ==== UseCase