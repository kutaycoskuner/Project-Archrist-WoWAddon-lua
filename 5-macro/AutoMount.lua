------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'AutoMount', "Auto Mount";
local moduleAlert = M .. moduleName2 .. ": |r";
local module = A:GetModule(moduleName1, true);
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - variables - isenabled, time, announce type, custom text
    - [x] 07.12.2022 discrete customizability in times 15,30,45,60
    - [x] 07.12.2022 custom text
    3. custom message type print / whisper / party etc.    
        - print, none, raid frame, party, raid
]]

--[[
/run setAutoMountButton() 
/click AutoMount
]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local mounts = {
    -- spellid = { isflyable(bool), speed} 
    -- speed: 1= ground 60, 2= ground 100, 3= fly 150, 4-fly 300, 5-fly 310
    [6648] = {false, 1},
    [32235] = {true, 3},
    [23229] = {false, 2},
    [32228] = {false, 2},
    [48778] = {false, 2}
}

------------------------------------------------------------------------------------------------------------------------

-- ==== Local Methods
local macro = CreateFrame("CheckButton", moduleName1, UIParent,
                         "SecureActionButtonTemplate")
macro:SetAttribute("type", "macro")
--  

function setAutoMountButton()
    local mount, zone, speed, speedLimit = "", "", 0, 0
    -- print(type(GetMinimapZoneText()), GetMinimapZoneText()=="Krasus' Landing")
    -- :: select zone
    if not IsFlyableArea() then
        zone = "Ground"
    else
        if GetZoneText() == "Dalaran" and GetMinimapZoneText() ~= "Krasus' Landing" then
            zone = "Ground"
        elseif GetMinimapZoneText() == "Krasus' landing" then
            zone = "Flying"
        else
            zone = "Flying"
        end
    end
    --
    -- :: get mount
    for i = 1, GetNumCompanions("MOUNT") do
        local itemId,name,spellId,_,_,typeID,typeString = GetCompanionInfo("mount", i)
        if zone == "Ground" then speedLimit = 2 else speedLimit = 5 end 
        if mounts[spellId] then
            if mounts[spellId][2] >= speed and mounts[spellId][2] <= speedLimit then
                mount = name
                speed = mounts[spellId][2]
            end
        end
    end
    -- print(mount, speed, speedLimit, zone, GetZoneText(), GetMinimapZoneText(), "|")
    -- :: set button
    macro:SetAttribute("macrotext", --
        "/cast [nomounted]" .. mount .. "\n/dismount [mounted]")
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize() self.initialized = true end

------------------------------------------------------------------------------------------------------------------------
-- ==== End
local function InitializeCallback() module:Initialize() end
A:RegisterModule(module:GetName(), InitializeCallback)