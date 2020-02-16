local count, mails, current;
if count == nil then count = 1 end
mails = GetInboxNumItems()
if count > mails then count = 1 end
current = GetInboxInvoiceInfo(count)
if current == "seller_temp_invoice" then
    GetInboxText(count);
    DeleteInboxItem(count)
else
    count = count + 1
end

-- ==== Metadata
local A, L, V, P, G = unpack(select(2, ...)) -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local module = A:GetModule('raidWarnings');

-- ==== Macros

-- ==== delete grays
local i, n = 0;
for b = 0, 4 do
    for s = 1, GetContainerNumSlots(b) do
        ClearCursor();
        i = {GetContainerItemInfo(b, s)};
        n = i[7];
        if n and string.find(n, "9d9d9d") then
            PickupContainerItem(b, s);
            DeleteCursorItem()
        end
    end
end
