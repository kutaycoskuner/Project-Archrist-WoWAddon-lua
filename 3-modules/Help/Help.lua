------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'Help', "Help";
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
]]

-- theory / calculation ------------------------------------------------------------------------------------------------
--[[
        help i data haline geetir
        - special key = to open ui
        - print outs
        - conditional print outs
]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local Arch_focusColor = Arch_focusColor
local fCol = Arch_focusColor
local Arch_commandColor = Arch_commandColor
local cCol = Arch_commandColor


--[[
    template =
    ["key"] = {
        ["type"] = 
    },
]]

local help_content = Arch_help_content
-- ==== GUI

-- ==== Methods
local function shouldRender(par)
    return A:GetModule(par, true) ~= nil
end

local function printTable(table)
    if table ~= nil then
        if #table > 0 then
            for ii = 1, #table do
                aprint(table[ii])
            end
        end
    end
end

local function decideHelpFromParameter(table)
    if help_content[table] ~= nil then
        local t = help_content[table]
        -- :: title
        if t["title"] ~= "" then
            aprint(fCol(" :: " .. t["title"] .. " :: "))
        end
        
        -- :: desc
        if #t["desc"] > 0 then
            for ii=1, #t["desc"] do
                aprint(t["desc"][ii])
            end
        end
        -- :: conditionals
        for k,v in pairs(t["conditionals"]) do
            if shouldRender(k) then
                aprint(fCol(k) .. " " .. v)
            end
        end
        -- :: commands
        if #t["commands"] > 0 then
            for ii=1, #t["commands"] do
                aprint(t["commands"][ii])
            end
        end
        -- :: functions
        if #t["functions"] > 0 then
            for ii=1, #t["functions"] do
                t["functions"][ii]()
            end
        end
    end
end

local function handleCommand(msg)
    if help_content[msg] ~= nil then
        decideHelpFromParameter(msg)
    else
        aprint('help content is not found')
    end
end

-- ==== Start
function module:Initialize()
    module.initialized = true
end

-- ==== Event Handlers

-- ==== Slash Handlersd
SLASH_archrist1 = "/arch"
SLASH_archrist2 = "/archrist"
SlashCmdList["archrist"] = function(msg)
    handleCommand(msg)
end

-- ==== End
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Todo
--[[
    
]]

-- ==== UseCase
--[[]]
