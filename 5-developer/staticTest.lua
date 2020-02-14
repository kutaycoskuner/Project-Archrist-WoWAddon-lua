-- ------------------------------------------------------------------------------------------
-- -- Orthplate
-- local Arch, L, V, P, G = unpack(select(2, ...)); -- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB
-- ------------------------------------------------------------------------------------------

-- local options = {
--     name = "Archrist",
--     handler = Arch,
--     type = "group",
--     args = {
--         msg = {
--             type = "input",
--             name = "Message",
--             desc = "The message text to be displayed",
--             usage = "<Your message here>",
--             get = "GetMessage",
--             set = "SetMessage"
--         },
--         showInChat = {
--             type = "toggle",
--             name = "Show in Chat",
--             desc = "Toggles the display of the message in the chat window.",
--             get = "IsShowInChat",
--             set = "ToggleShowInChat"
--         },
--         showOnScreen = {
--             type = "toggle",
--             name = "Show on Screen",
--             desc = "Toggles the display of the message on the screen.",
--             get = "IsShowOnScreen",
--             set = "ToggleShowOnScreen"
--         }
--     }
-- }

-- local defaults = {
--     profile = {
--         message = "Welcome Home!",
--         showInChat = false,
--         showOnScreen = true
--     }
-- }
-- Arch.showInChat = false
-- Arch.showOnScreen = true

-- function Arch:OnInitialize()
--     -- Called when the addon is loaded
--     self.db = LibStub("AceDB-3.0"):New("testDB", defaults, true)

--     LibStub("AceConfig-3.0"):RegisterOptionsTable("Arch", options)
--     self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
--                             "Arch", "Archrist")
--     self:RegisterChatCommand("ar", "ChatCommand")
--     self:RegisterChatCommand("archrium", "ChatCommand")
-- end

-- function Arch:OnEnable()
--     -- Called when the addon is enabled
--     self:RegisterEvent("CHAT_MSG_SAY")
-- end

-- function Arch:OnDisable()
--     -- Called when the addon is disabled
-- end

-- function Arch:CHAT_MSG_SAY()
--     if self.db.profile.showInChat then self:Print(self.db.profile.message); end

--     if self.db.profile.showOnScreen then
--         UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
--     end
-- end

-- function Arch:ChatCommand(input)
--     if not input or input:trim() == "" then
--         InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
--     else
--         LibStub("AceConfigCmd-3.0"):HandleCommand("ar", "Arch", input)
--     end
-- end

-- function Arch:GetMessage(info) return self.db.profile.message end

-- function Arch:SetMessage(info, newValue)
--     self.db.profile.message = newValue
-- end

-- function Arch:IsShowInChat(info) return self.db.profile.showInChat end

-- function Arch:ToggleShowInChat(info, value)
--     self.db.profile.showInChat = value
-- end

-- function Arch:IsShowOnScreen(info) return self.db.profile.showOnScreen end

-- function Arch:ToggleShowOnScreen(info, value)
--     self.db.profile.showOnScreen = value
-- end


----------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------
-- local A, L, V, P, G, N = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, AddonName
-- local module = A:GetModule('test');
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true
--     -- :: Register some events
--     module:RegisterEvent("CHAT_MSG_SAY");
-- end

-- -- ==== Methods
-- function module:CHAT_MSG_SAY()

--     print('test')

-- end

-- -- ==== End
-- local function InitializeCallback() module:Initialize() end
-- A:RegisterModule(module:GetName(), InitializeCallback)

