if count == nil then count = 1 end
mails = GetInboxNumItems()
if count > mails then count = 1 end
curr = GetInboxInvoiceInfo(count)
if curr == "seller_temp_invoice" then
    GetInboxText(count);
    DeleteInboxItem(count)
else
    count = count + 1
end