------------------------------------------------------------------------------------------
local main, L, V, P, G = unpack(select(2, ...)); -- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB
local module = main:GetModule('test');
------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.initialized = true

    print('test.lua working')
    module:RegisterEvent("CHAT_MSG_SAY");
end

function module:CHAT_MSG_SAY()

    -- print("yay")
    UIErrorsFrame:AddMessage('test', 1.0, 1.0, 1.0, 5.0)
end

local function InitializeCallback()
    module:Initialize()
end

-- :: InitializeCallback
main:RegisterModule(module:GetName(), InitializeCallback)