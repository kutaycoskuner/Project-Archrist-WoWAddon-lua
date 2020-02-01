-- ------------------------------------------------------------------------------------------
-- local main, L, V, P, G = unpack(select(2, ...)); -- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB
-- local module = main:GetModule('test');
-- ------------------------------------------------------------------------------------------
-- -- ==== Start
-- function module:Initialize()
--     self:RegisterEvent("CHAT_MSG_SAY");
--     self:print(type(module:GetName()));
-- end

-- local function InitializeCallback()
--     module:Initialize()
-- end

-- -- :: InitializeCallback
-- main:RegisterModule(module:GetName(), InitializeCallback)