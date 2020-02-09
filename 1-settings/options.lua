----------------------------------------------------------------------------------------------------------
local A, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
----------------------------------------------------------------------------------------------------------

-- function A:CHAT_MSG_SAY()
--     if self.db.profile.showInChat then
--         self:Print(self.db.profile.message); -- ** aware that P is capital
--     end

--     if self.db.profile.showOnScreen then
--         UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
--     end
-- end
