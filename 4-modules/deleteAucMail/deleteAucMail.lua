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

    local current;
    local deleted = 0;
    for ii = 1, GetInboxNumItems(), 1 do
        current = GetInboxInvoiceInfo(ii)
        if current == "seller_temp_invoice" then
            print(GetInboxText(ii));
            DeleteInboxItem(ii);
            deleted = deleted + 1;
        end
    end
    if deleted ~= 0 then
        self:Print(deleted .. ' auction mails deleted')
    end

end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)
