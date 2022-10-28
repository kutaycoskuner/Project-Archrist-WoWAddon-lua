------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Pug';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then return end

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local channelKey -- channel key is for giving number of announcechannel

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- ==== Methods
local function handleCommand(msg)
    if msg == "1" then
        Arch_gui_pugRaid_announce()
    else
        Arch_setGUI('pugRaid')
    end
end

-- ==== Start
function module:Initialize()
    if not A.global.pugRaid then
        A.global.pugRaid = {
            ["raidType"] = {},
            ["raidText"] = "",
            ["needData"] = {
                {['Tank'] = false}, {['Heal'] = false}, {['MDPS'] = false},
                {['RDPS'] = false}
            },
            ["additionalNote"] = "",
            ["delimeter"] = " - ",
            ["showCounter"] = false,
            ["channelKey"] = {}
        }
    end
    self.initialized = true
    -- :: Database Connection
    -- :: Register some events
    -- module:RegisterEvent("COMBAT_LOG_EVENT");
end

-- ==== Event Handlers
function module:COMBAT_LOG_EVENT(event, _, eventType, _, srcName, _, _, dstName,
                                 _, spellId, spellName, _, ...)
    -- print(event .. ' ' .. eventType .. ' ' .. srcName  .. ' ' .. dstName  .. ' ' .. spellId  .. ' ' .. spellName)
    -- print('test')
end

-- ==== Slash Handlersd
SLASH_pug1 = "/pug"
SlashCmdList["pug"] = function(msg) handleCommand(msg) end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[]]
