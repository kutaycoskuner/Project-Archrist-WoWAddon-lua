------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, N = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
------------------------------------------------------------------------------------------------------------------------
local module = A:GetModule('deleteAucMail');
-- ==== Start
function module:Initialize() 

    self.Initialized = true
    print(self)
    print('this is auc')
    self:RegisterEvent("CHAT_MSG_SAY")
    -- "MAIL_INBOX_UPDATE"
    
    
end


function module:CHAT_MSG_SAY() 
    self:Print('thi is asdf')
end

-- ==== Callback & Register [last arg]
local function InitializeCallback()
	module:Initialize()
end

A:RegisterModule(module:GetName(), InitializeCallback)

-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true

--     print('test.lua working')
--     module:RegisterEvent("CHAT_MSG_SAY");
-- end

-- function module:CHAT_MSG_SAY()

--     -- print("yay")
--     UIErrorsFrame:AddMessage('test', 1.0, 1.0, 1.0, 5.0)
-- end

-- local function InitializeCallback()
--     module:Initialize()
-- end

-- -- :: InitializeCallback
-- main:RegisterModule(module:GetName(), InitializeCallback)