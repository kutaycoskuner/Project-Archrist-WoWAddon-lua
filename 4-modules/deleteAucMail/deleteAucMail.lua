------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'deleteAucMail';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Register some events
    module:RegisterEvent("MAIL_INBOX_UPDATE"); -- MAIL_INBOX_UPDATE , MAIL_SHOW
end

-- ==== Methods
function module:MAIL_INBOX_UPDATE()

    local mails, current, deleted, again;
    if deleted == nil then deleted = 0 end
    -- again = 0;
    mails = GetInboxNumItems() or 0;
    -- test
    for ii = 1, mails do
        if GetInboxInvoiceInfo(ii) == "seller_temp_invoice" then
            -- GetInboxText(ii);
            -- print(ii);
            DeleteInboxItem(ii);
            deleted = deleted + 1;
            -- again = 1;
        end
    end
    if deleted ~= 0 then
        UIErrorsFrame:AddMessage(moduleAlert .. "\nclick mailbox again to delete " .. (deleted) .. " info mails")
    else
        -- print(moduleAlert .. "You have " .. mails .. " mails in mailbox")
    end
    -- if again == 1 then module:MAIL_SHOW(); end
    -- test end
end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)
