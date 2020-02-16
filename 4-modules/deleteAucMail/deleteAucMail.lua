------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, N = unpack(select(2, ...)); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
local module = A:GetModule('deleteAucMail');
------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Register some events
    module:RegisterEvent("MAIL_INBOX_UPDATE");
end

-- ==== Methods
function module:MAIL_INBOX_UPDATE()

    local count, mails, current, deleted;
    if count == nil then count = 1 end
    if deleted == nil then deleted = 0 end
    mails = GetInboxNumItems() or 0;
    if count > mails then count = 1 end
    -- mails = 3;
    -- test
    while count <= mails do
        current = GetInboxInvoiceInfo(count);
        if current == "seller_temp_invoice" then
            GetInboxText(count - deleted);
            DeleteInboxItem(count - deleted);
            deleted = deleted + 1;
        end
        count = count + 1;
    end
    if deleted ~= 0 then
        print("total deleted: " .. deleted .. " total mails count: " .. count)
    end

    -- test end

    -- for ii = 1, GetInboxNumItems(), 1 do
    --     current = GetInboxInvoiceInfo(ii)
    --     if current == "seller_temp_invoice" then
    --         -- print(GetInboxText(ii));
    --         DeleteInboxItem(ii);
    --         -- deleted = deleted + 1;
    --         module:MAIL_INBOX_UPDATE();
    --         -- break;
    --     end
    -- end

end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)
