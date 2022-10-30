------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'CraftGuides';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
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
local guide = Arch_guide_tailor
local profession = "Tailoring"
local currentLevel = 0 
local targetLevel = nil
local targetItem = nil
local targetData = nil

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- module:RegisterEvent("PLAYER_REGEN_ENABLED")
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function learnCurrentLevel()
    for ii=1,  GetNumSkillLines() do
        local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier,
        skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType,
        skillDescription = GetSkillLineInfo(ii)
        if skillName == profession then
            currentLevel = skillRank
            -- print(skillName, skillRank)
        end
    end
end

local function selectTargetLevel()
    learnCurrentLevel()
    for k,v in pairs(guide) do
        if k > currentLevel then
            targetLevel = k
            targetData = guide[k]
            _, targetItem = GetItemInfo(targetData['item'])
            -- print("current target is " .. k)
            break
        end
       end
end

local function calcMatAmount(amount)
    local difference = targetLevel - currentLevel
    local multiplier = 1
    return difference * multiplier * amount
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods
function Arch_craftGuidesGUI()
    -- :: select text
    selectTargetLevel()
    --:: create frame
    Arch_guiFrame:SetWidth(360)
    Arch_guiFrame:SetHeight(200)
    -- Arch_guiFrame:ClearAllPoints()
    -- :: remembering the position of frame
    -- if A.global.voaFrame ==X {} then
    --     frame:SetPoint("CENTER", 0, 0)
    -- else
    --     frame:SetPoint(voaFramePos[1], voaFramePos[3], voaFramePos[4])
    -- end
    local heading = AceGUI:Create('Heading')
    heading:SetText('Crafting Guides')
    heading:SetRelativeWidth(1)
    Arch_guiFrame:ReleaseChildren()
    Arch_guiFrame:AddChild(heading)
    -- :: adding target text
    local editbox = AceGUI:Create("Label")
    editbox:SetText("Craft\n" .. targetItem)
    editbox:SetRelativeWidth(0.7)
    Arch_guiFrame:AddChild(editbox)
    -- :: adding target text
    local editbox = AceGUI:Create("Label")
    editbox:SetText("Needed")
    editbox:SetRelativeWidth(0.7)
    Arch_guiFrame:AddChild(editbox)
    -- :: material
    for k,v in pairs(targetData['mats']) do
        -- :: adding target text
        local editbox = AceGUI:Create("Label")
        editbox:SetText(calcMatAmount(v[1]) .. " x " .. select(2, GetItemInfo(k)))
        editbox:SetRelativeWidth(0.7)
        Arch_guiFrame:AddChild(editbox)
    end

end

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function main(msg)
    Arch_setGUI(moduleName)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
-- function module:PLAYER_REGEN_ENABLED()
--     -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
--     isInCombat = false
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
SLASH_cra1 = "/cra" -- todo change the key later
SlashCmdList["cra"] = function(msg)
    main(msg)
end

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
