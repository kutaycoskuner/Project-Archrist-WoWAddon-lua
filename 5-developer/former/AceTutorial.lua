-- ==== Create Variables
local defaults = {
    profile = {
        message = "Welcome Home!",
        showInChat = false,
        showOnScreen = true
    }
}

local options = {
    name = "Archrist",
    handler = Addon, -- :: addon
    type = "group",
    args = {
        msg = {
            type = "input",
            name = L["Message"],
            desc = L["The message to be displayed when you get home."],
            usage = L["<Your message>"],
            get = "GetMessage",
            set = "SetMessage"
        },
        showInChat = {
            type = "toggle",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat"
        },
        showOnScreen = {
            type = "toggle",
            name = "Show on Screen",
            desc = "Toggles the display of the message on the screen.",
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen"
        }
    }
}

-- :: command handler
function Addon:ChatCommand(input)
    if not input or input:trim() == "" then
        -- InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("ar", "Addon", input) -- :: key, addon, input
    end
end

-- :: register an event to addon
function Addon:OnEnable()
    -- if self.people.test then
    --     self.people.test = UnitName("player")
    --   end
end

-- :: response to registered event
function Addon:CHAT_MSG_SAY()
    -- if self.db.profile.showInChat then
    -- self:Print(self.db.message); -- ** aware that P is capital
    -- end

    -- if self.db.profile.showOnScreen then
    --     UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
    -- end
end

function Addon:GetMessage(info) return self.db.message end

function Addon:SetMessage(info, newValue)
    self.db.message = newValue
    self.private.message = newValue
    self.global.message = newValue
    -- self:Print(self.DF.profile.message)
end

function Addon:IsShowInChat(info) return self.DF.profile.showInChat end

function Addon:IsShowOnScreen(info) return self.DF.profile.showOnScreen end

function Addon:ToggleShowInChat(info, value) self.DF.profile.showInChat = value end

function Addon:ToggleShowOnScreen(info, value)
    self.DF.profile.showOnScreen = value
end