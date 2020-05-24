-- ------------------------------------------------------------------------------------------------------------------------
-- -- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
-- local A, L, V, P, G, C, M, N = unpack(select(2, ...));
-- local moduleName = 'test';
-- local moduleAlert = M .. moduleName .. ": |r";
-- local module = A:GetModule(moduleName);
-- ------------------------------------------------------------------------------------------------------------------------
-- -- ==== Variables
-- -- Areana CC Tracker




-- -- -- ==== GUI
-- -- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- -- ==== Methods
-- local function handleCommand(msg)
--     local start, duration, enabled = GetSpellCooldown(48477)
--     local cooldownMS, gcdMS = GetSpellBaseCooldown(48477)
--     -- print(start .. ' ' .. duration ..' ' .. enabled )
--     SELECTED_CHAT_FRAME:AddMessage(start .. ' ' .. duration ..' ' .. enabled)
--     SELECTED_CHAT_FRAME:AddMessage(cooldownMS .. ' ' .. gcdMS)
-- end



-- -- ==== Start
-- function module:Initialize()
--     self.initialized = true
--     -- :: Register some events
--     -- module:RegisterEvent("CHAT_MSG_SAY");
-- end

-- -- ==== Event Handlers
-- -- function module:CHAT_MSG_SAY()
-- --     --print('test')
-- -- end

-- -- ==== Slash Handlersd
-- SLASH_test1 = "/test"
-- SlashCmdList["test"] = function(msg) handleCommand(msg) end

-- -- ==== End
-- local function InitializeCallback() module:Initialize() end
-- A:RegisterModule(module:GetName(), InitializeCallback)

-- -- ==== Todo
-- --[[
--     warrior = ['']
--     paladin = {'repentance', 'hammer of the wrath'}
--     warlock = {'fear'}
--     priest = {'psychic scream', 'psychic horror'}
--     mage = {'polymorph'}
--     death knight {'stun', ''}
--     rogue = {'sap', 'blind'}
--     hunter = {'frost trap'}
--     shaman = {'hex'}
--     druid = {'cyclone'}
-- ]]

-- -- ==== UseCase
-- --[[
--     1- Check for player classes in party
--     2- Determine defined classes cc skills
--     3- present available cc names
-- ]]