-- source https://www.curseforge.com/wow/addons/millbutton/files/all?filter-game-version=2020709689%3A248
local mill = CreateFrame("CheckButton","MillButton",UIParent,"SecureActionButtonTemplate")
mill:SetAttribute("type","macro")

local function findHerbsInBag()
  local function f(bag,slot)
    return select(7,GetItemInfo(GetContainerItemLink(bag,slot) or 0))=="Herb" and select(2,GetContainerItemInfo(bag,slot))>=5
  end
  for i=0,4 do
    for j=1,GetContainerNumSlots(i) do
      if f(i,j) then
        return i,j
      end
    end
  end
end  

function millHerbs()
  local bag,slot = findHerbsInBag()
  if (not bag or not slot) or LootFrame:IsVisible() or CastingBarFrame:IsVisible() or UnitCastingInfo("player") then
    -- do nothing if no herb, if looting or casting
    MillButton:SetAttribute("macrotext","")
    if not bag then
      print("No more herbs in stacks of 5 or more.")
    end
  else
    MillButton:SetAttribute("macrotext","/cast Milling\n/use "..bag.." "..slot)
  end
end

--[[ 
#showtooltip milling
/run MillButtonSetup() 
/click MillButton 
]]