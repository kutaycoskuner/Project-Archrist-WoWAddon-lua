------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'VoA';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local channelKey -- channel key is for giving number of announcechannel
local diverseRaid = {
    {["Tank"] = {["Tank I"] = "tank", ["Tank II"] = "tank"}}, {
        ["Heal"] = {
            ["Paladin"] = "hpal",
            ["Druid"] = "dru",
            ["Priest"] = "pri",
            ["Shaman"] = "sha"

        }
    }, {
        ["MDPS"] = {
            ["Warrior"] = "war",
            ["Paladin"] = "ret",
            ["Death Knight"] = "dk",
            ["Rogue"] = "rog",
            ["Enhancement"] = "enh",
            ["Feral"] = "feral"
        }
    }, {
        ["RDPS"] = {
            ["Mage"] = "mage",
            ["Warlock"] = "lock",
            ["Hunter"] = "hunt",
            ["Elemental"] = "ele",
            ["Balance"] = "bala",
            ["Shadow"] = "sha"
        }
    }
}
local announce = "LFM VoA18 [Koralon&Emalon] Need "
local roles = {["Tank"] = "", ["Heal"] = "", ["MDPS"] = "", ["RDPS"] = ""}

local tank = ""
local heal = ""
local mdps = ""
local rdps = ""
local count = " " .. tostring(GetNumRaidMembers()) .. "/18"

-- -- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getRaidScore)

-- ==== Methods
local function handleCommand(msg)
    -- local raid = return_diverseRaid()
    Arch_setGUI('DiverseRaid', true)
    for ii = 1, #diverseRaid do
        for key in pairs(diverseRaid[ii]) do
            roles[key] = ""
            for subkey in pairs(diverseRaid[ii][key]) do
                if not (return_diverseRaid()[1][ii][key][subkey]) then
                    roles[key] = roles[key] .. diverseRaid[ii][key][subkey] ..
                                     " "
                end
            end
        end
    end
    if (roles["Tank"] ~= "") then
        tank = "Tank "
        if (roles["MDPS"] ~= "") or (roles["RDPS"] ~= "") or
            (roles["Heal"] ~= "") then tank = tank .. "& " end
    else
        tank = ""
    end
    if (roles["Heal"] ~= "") then
        heal = "Heals: " .. roles["Heal"]
        if (roles["MDPS"] ~= "") or (roles["RDPS"] ~= "") then
            heal = heal .. "& "
        end
    else
        heal = ""
    end
    if (roles["MDPS"] ~= "") then
        mdps = "MDPS: " .. roles["MDPS"]
        if (roles["RDPS"] ~= "") then mdps = mdps .. "& " end
    else
        mdps = ""
    end
    if (roles["RDPS"] ~= "") then
        rdps = "RDPS: " .. roles["RDPS"]
    else
        rdps = ""
    end
    if (type(tonumber(return_diverseRaid()[2])) == "number") then
        count = " " .. tostring(GetNumRaidMembers()) .. "/18"
        if GetNumRaidMembers() > 10 then
            SendChatMessage(announce .. tank .. heal .. mdps .. rdps .. count,
                            "channel", nil, return_diverseRaid()[2]);
        else
            SendChatMessage(announce .. tank .. heal .. mdps .. rdps, "channel",
                            nil, return_diverseRaid()[2]);
        end
    else
        SELECTED_CHAT_FRAME:AddMessage(
            announce .. tank .. heal .. mdps .. rdps .. count)
    end

end

-- ==== Start
function module:Initialize()
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
SLASH_voa1 = "/voa"
SlashCmdList["voa"] = function(msg) handleCommand(msg) end

-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[]]

-- ==== UseCase
--[[]]
