------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'PaladinBuffs';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = true
local GBOS = nil
local GBOM = nil
local GBOW = nil
local GBOK = nil
local PALA = ""

-- ==== Body
local function announcePaladinBuffs()
    PALA = "";
    if GBOS ~= nil then
        PALA = PALA .. "GBOS " .. GBOS .. " - "
    end
    if GBOM ~= nil then
        PALA = PALA .. "GBOM " .. GBOM .. " - "
    end
    if GBOW ~= nil then
        PALA = PALA .. "GBOW " .. GBOW .. " - "
    end
    if GBOK ~= nil then
        PALA = PALA .. "GBOK " .. GBOK .. " - "
    end
    if string.len( PALA ) > 2 then
    PALA = PALA:sub(1, -3)
    end
    print(PALA);
    if isEnabled then
        SendChatMessage(PALA,"RAID_WARNING",nil) -- RAID_WARNING, SAY
    end
end

-- :: selecting person via slash command
local function selectGBOS()
        if (UnitName('target') ~= nil) then
            GBOS = UnitName('target')
        else
            GBOS = nil
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff128ec4[Archrium] GBOS Handler:|r " ..
                                          tostring(GBOS))
        UIErrorsFrame:AddMessage("|cff128ec4GBOS Handler|r " .. tostring(GBOS))
end

local function selectGBOM()
    if (UnitName('target') ~= nil) then
        GBOM = UnitName('target')
    else
        GBOM = nil
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff128ec4[Archrium] GBOM Handler:|r " ..
                                      tostring(GBOM))
    UIErrorsFrame:AddMessage("|cff128ec4GBOM Handler|r " .. tostring(GBOM))
end

local function selectGBOW()
    if (UnitName('target') ~= nil) then
        GBOW = UnitName('target')
    else
        GBOW = nil
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff128ec4[Archrium] GBOW Handler:|r " ..
                                      tostring(GBOW))
    UIErrorsFrame:AddMessage("|cff128ec4GBOW Handler|r " .. tostring(GBOW))
end

local function selectGBOK()
    if (UnitName('target') ~= nil) then
        GBOK = UnitName('target')
    else
        GBOK = nil
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff128ec4[Archrium] GBOK Handler:|r " ..
                                      tostring(GBOK))
    UIErrorsFrame:AddMessage("|cff128ec4GBOK Handler|r " .. tostring(GBOK))
end

-- ==== Slash commands [last arg]
SLASH_GBOS1 = "/gbos"
SLASH_GBOM1 = "/gbom"
SLASH_GBOW1 = "/gbow"
SLASH_GBOK1 = "/gbok"
SLASH_PALADIN1 = "/pala"
SlashCmdList["GBOS"] = function() selectGBOS() end
SlashCmdList["GBOM"] = function() selectGBOM() end
SlashCmdList["GBOW"] = function() selectGBOW() end
SlashCmdList["GBOK"] = function() selectGBOK() end
SlashCmdList["PALADIN"] = function() announcePaladinBuffs() end