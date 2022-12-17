------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'DatabaseAdapter', "Database Adapter";
local moduleAlert = M .. moduleName2 .. ": |r";
local module = A:GetModule(moduleName1, true);
local aprint = Arch_print
local mprint = function(msg)
    print(moduleAlert .. msg)
end
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - create command [x]
    - understand command arguments
]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local realmName = GetRealmName()

local impressions = {
    ["reputation"] = 0,
    ["strategy"] = 0,
    ["attendance"] = 0,
    ["discipline"] = 0,
    ["damage"] = 0,
    ["note"] = ""
}
local organization = {
    ["role"] = "",
    ["tasks"] = {}
}
local categories = {
    ["impressions"] = impressions,
    ["organization"] = organization
}
------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    if not A.people[realmName] then
        A.people[realmName] = {}
    end
    for player in pairs(A.people[realmName]) do
        -- :: remove other servers
        if string.find(player, "-") then
            A.people[realmName][player] = nil
        end
        -- :: category 1 yoksa yarat

        for cat, subcat in pairs(categories) do
            if not A.people[realmName][player][cat] then
                A.people[realmName][player][cat] = {}
            end
            for key, val in pairs(subcat) do
                if not A.people[realmName][player][cat][key] then
                    A.people[realmName][player][cat][key] = val
                end
            end

        end
        -- :: player database tasi
        for cat, subcat in pairs(categories) do
            for key in pairs(subcat) do
                if A.people[realmName][player][key] then
                    A.people[realmName][player][cat][key] = A.people[realmName][player][key]
                    A.people[realmName][player][key] = nil
                end
            end
        end
        -- -- :: task i sil
        -- if A.people[realmName][player]["organization"] ~= nil then
        --     if A.people[realmName][player]["organization"]["task"] ~= nil then
        --         A.people[realmName][player]["organization"]["task"] = nil
        --     end
        -- end
    end
    for player in pairs(A.people[realmName]) do
        for key, value in pairs(A.people[realmName][player]["organization"]) do
            if A.people[realmName][player]["organization"][key] then
                if type(A.people[realmName][player]["organization"][key]) == "string" then
                    A.people[realmName][player]["organization"][key] = string.lower(
                        A.people[realmName][player]["organization"][key])
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function main(msg)
end

local function handleCommand(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
-- function module:PLAYER_REGEN_ENABLED()
--     -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
--     isInCombat = false
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
-- SLASH_reputation1 = "/rep"
-- SlashCmdList["reputation"] = function(msg)
--     handleCommand(msg)
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

------------------------------------------------------------------------------------------------------------------------
-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)
