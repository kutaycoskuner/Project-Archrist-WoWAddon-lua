Message: Interface\FrameXML\GameTooltip.lua:126: WeakAurasTooltipMoneyFrame1:SetPoint(): Couldn't find region named 'WeakAurasTooltipTextLeft9'
Time: 02/09/20 16:29:56
Count: 1
Stack: [C]: in function `SetPoint'
Interface\FrameXML\GameTooltip.lua:126: in function `SetTooltipMoney'
Interface\FrameXML\GameTooltip.lua:88: in function `GameTooltip_OnTooltipAddMoney'
[string "*:OnTooltipAddMoney"]:1: in function <[string "*:OnTooltipAddMoney"]:1>
[C]: in function `SetInventoryItem'
Interface\AddOns\WeakAuras\WeakAuras.lua:4705: in function <Interface\AddOns\WeakAuras\WeakAuras.lua:4704>
Interface\AddOns\WeakAuras\WeakAuras.lua:4730: in function `tenchUpdate'
Interface\AddOns\WeakAuras\WeakAuras.lua:4748: in function `TenchInit'
Interface\AddOns\WeakAuras\Prototypes.lua:2126: in function `init'
Interface\AddOns\WeakAuras\WeakAuras.lua:1436: in function `ConstructFunction'
Interface\AddOns\WeakAuras\WeakAuras.lua:3472: in function `pAdd'
Interface\AddOns\WeakAuras\WeakAuras.lua:3297: in function `Add'
Interface\AddOns\WeakAuras\WeakAuras.lua:3279: in function `load'
Interface\AddOns\WeakAuras\WeakAuras.lua:3284: in function `AddMany'
Interface\AddOns\WeakAuras\WeakAuras.lua:1629: in function <Interface\AddOns\WeakAuras\WeakAuras.lua:1595>

Locals: (*temporary) = WeakAurasTooltipMoneyFrame1 {
 small = 1
 info = <table> {
 }
 staticMoney = 491
 0 = <userdata>
 vadjust = 0
 moneyType = "STATIC"
}
(*temporary) = "LEFT"
(*temporary) = "WeakAurasTooltipTextLeft9"
(*temporary) = "LEFT"
(*temporary) = 4
(*temporary) = 0
