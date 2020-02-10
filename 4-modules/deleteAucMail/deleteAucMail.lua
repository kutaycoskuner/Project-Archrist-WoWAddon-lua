------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, N = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
------------------------------------------------------------------------------------------------------------------------
local module = A:GetModule('deleteAucMail');
-- ==== Start
function module:Initialize() 

    print('this is auc')
    self:RegisterEvent("MAIL_SHOW")
    -- "MAIL_INBOX_UPDATE"
    
    
    self.Initialized = true
end


function module:MAIL_SHOW() 
    self:Print('thi is asdf')
end

-- ==== Callback & Register [last arg]
local function InitializeCallback()
	module:Initialize()
end

A:RegisterModule(module:GetName(), InitializeCallback)