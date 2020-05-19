------------------------------------------------------------------------------------------------------------------------
-- :: Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'test';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local args = {}
local playerInfo = {}
local isPlayerExists = false
local mod = 'checkplayer'

-- ==== Start
function module:Initialize()
    self.initialized = true
    -- :: Register some events
    module:RegisterEvent("WHO_LIST_UPDATE");
end

-- ==== Methods
-- :: Argumanlari ayirip bas harflerini buyutuyor
local function fixArgs(msg)
    -- :: this is separating the given arguments after command
    local sep = "";
    if sep == nil then sep = "%s" end
    local args = {};
    for str in string.gmatch(msg, "([^" .. sep .. "]+)") do
        table.insert(args, str)
    end
    return args;

end

local function handleCommand(msg)
    if UnitName('target') then
        local Name = UnitName('target') -- GameTooltip:GetUnit();
        args[1] = Name
        SetWhoToUI(1)
        SendWho('n-"' .. Name .. '"')
    end
end

-- ==== Event Handlers
function module:WHO_LIST_UPDATE() -- CHAT_MSG_SYSTEM()
    if mod == 'checkplayer' then
        for ii = 1, GetNumWhoResults() do
            if GetWhoInfo(ii) == args[1] then
                playerInfo[1], playerInfo[2] = GetWhoInfo(ii)
                break
            end
        end
    end

    if playerInfo[2] == GetGuildInfo('player') then
        for ii = 1, GetNumGuildMembers() do
            if GetGuildRosterInfo(ii) == playerInfo[1] then
                GuildRosterSetPublicNote(ii, Archrist_PlayerDB_calcRaidScore(
                                             playerInfo[1]))
            end
        end
    end
end

-- ==== Slash Handlersd
SLASH_test1 = "/test"
SlashCmdList["test"] = function(msg) handleCommand(msg) end

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- -- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo

-- ==== UseCase
