------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, N = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
local module = A:GetModule('deleteAucMail');
------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Register some events
    module:RegisterEvent("MAIL_SHOW");
end

-- ==== Methods
function module:MAIL_SHOW()

    local current
    for ii = 1, GetInboxNumItems(), 1 do
        current = GetInboxInvoiceInfo(ii)
        if current == "seller_temp_invoice" then
            print(GetInboxText(ii));
            DeleteInboxItem(ii)
        end
    end

end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)
