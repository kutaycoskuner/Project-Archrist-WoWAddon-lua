-- ------------------------------------------------------------------------------------------------------------------------
-- -- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
-- local A, L, V, P, G, C, M, N = unpack(select(2, ...));
-- local moduleName = 'test';
-- local moduleAlert = M .. moduleName .. ": |r";
-- local module = A:GetModule(moduleName);
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Variables
-- local args = {}
-- local isPlayerExists = false

-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true
--     -- :: Register some events
--     -- module:RegisterEvent("CHAT_MSG_SYSTEM");
--     module:RegisterEvent("WHO_LIST_UPDATE");
--     -- module:SetScript("OnEvent", function(self, event, message, sender, ...)
--     --     print('core')
--     -- end)
-- end

-- -- ==== Methods
-- -- :: Argumanlari ayirip bas harflerini buyutuyor
-- local function fixArgs(msg)
--     -- :: this is separating the given arguments after command
--     local sep;
--     if sep == nil then sep = "%s" end
--     local args = {};
--     for str in string.gmatch(msg, "([^" .. sep .. "]+)") do
--         table.insert(args, str)
--     end

--     -- :: this capitalizes first letters of each given string
--     for ii = 1, #args, 1 do
--         args[ii] = args[ii]:lower()
--         if ii == 1 then args[ii] = args[ii]:gsub("^%l", string.upper) end
--     end

--     return args;
-- end

-- function module:WHO_LIST_UPDATE() -- CHAT_MSG_SYSTEM()

--     for ii = 1, GetNumWhoResults() do
--         if GetWhoInfo(ii) == args[1] then
--         --    print(args[1])
--            print('this person exists')
--            isPlayerExists = true
--            break
--         end
--    end
-- --    FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE");

--     if isPlayerExists then
--         print('test succceeed')
--         isPlayerExists = false
--     else
--         print('test failed')
--     end
    
--     FriendsFrame:Hide()
--     -- FriendsFrame:RegisterEvent("WHO_LIST_UPDATE");

-- end

-- local function handleCommand(msg)

--     args = fixArgs(msg)
--     if args[1] then
--         SetWhoToUI(1)
--         SendWho('n-"' .. args[1] .. '"')
--     end

-- end

-- function module:CHAT_MSG_SYSTEM() -- CHAT_MSG_SYSTEM()
--     -- local nomen = arg1:match("%[(%a+)%]")
--     -- if nomen ~= nil then
--     --     print(nomen)
--     --     -- print(GetWhoInfo(1))
--     -- end
--     -- 17048 https://www.townlong-yak.com/framexml/live/GlobalStrings.lua
-- end

-- -- ==== Slash Handlersd
-- SLASH_test1 = "/test"
-- SlashCmdList["test"] = function(msg) handleCommand(msg) end

-- -- -- ==== End
-- local function InitializeCallback() module:Initialize() end
-- A:RegisterModule(module:GetName(), InitializeCallback)

-- -- ==== Todo

-- -- ==== UseCase
