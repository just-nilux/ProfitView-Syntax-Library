##
## Monitoring Script with Take Profit, Stop-Loss Adjustment and Re-Entry 
## This script works together with the "Open n Close" script, you find it in this folder.
##
## This alert syntax is checking your open position and if PNL is larger than 2.5% it will trigger several events:
##	- If stop loss order was not hit, then it sets the new stop loss closer/above the current average entry price 
##  - If stop loss was hit and the position reduced by 98%, the script re-enters once the position is in profit again
##	- If PNL is higher than 7.5%, execute a take profit and close 98% of the position
##		- It then adds fund again to this position to still follow the trade. If then the 7.5% PNL is crossed, the procedure repeats and new stop loss orders are set.
##	- If no position is open, disable this alert.
##
## Summary: This monitoring script is following your open positions, it's closing 98% of a position with tight stop and re-entering the position once the trend continues and position is in profit.
## 			It works really great with this indicator: https://www.tradingview.com/script/p1zF813J-Madmex-Trading-Suite-Filters/
## 			The losses are small, the gains are good. With this strategy and alerts I'm consistently on approx. 1.5% - 2.0% ROI daily. 
##
## Important: If you change the leverage, you need to adjust the minpnl= values accordingly higher or lower. 
##			  Also, do not forget to set this alert to be run intervals, example: Set Interval to 7 or 13 minutes if you trade on 15min TF. You gotta try what works best for you.

e=* a=* s=BTCUSD
check=position ifnone=disable_check notify=telegram:"`BTCUSD Side: {side}  \z`\nEntry Price:		{entry_price}\nPosition Value:		{position_value} BTC\n-------------------\nPosition PNL:		{pnl}\nUnrealised PNL:		{unrealised_pnl} BTC\nPNL Total:		{pnlTotal}\n-------------------\nBTC Wallet Balance:		{wallet_balance}"
check=position side=long minpnl=2.5% iffound=set_stops_long 
check=position side=short minpnl=2.5% iffound=set_stops_short ifnone=abort

:set_stops_long
check=order id=SL iffound=new_sl_long
updateprice cachedprice
side=long q=3.5% l=5 t=market id=market-1 retries=3 notify=telegram:"`BTCUSD\z`\nMarket Order Filled @ {price}\nPosition Value: {position_value}"
delay=3
close=position side=long q=98% stoploss=-75 reduce=1 t=market return=1 onerror=closeside retries=3 id=SL-auto notify=telegram:"`New SL at   \z` {stop_px}"
skip=-1

:new_sl_long
check=position side=long minpnl=7.5% iffound=tp_long
cancel=order id=SL
delay=3 updateprice cachedprice
close=position side=long q=98% stoploss=-75 reduce=1 t=market return=1 onerror=closeside retries=3 id=SL-auto notify=telegram:"`New SL at   \z` {stop_px}"
skip=-1

:tp_long
close=position q=98% side=long t=market notify=telegram:"`Reduce Position (Market)  \z`"
cancel=order id=SL
delay=2
jump=set_stops_long

:set_stops_short
check=order id=SL iffound=new_sl_short
updateprice cachedprice
cancel=order id=SL
side=short q=3.5% l=5 t=market id=market-1 retries=3 notify=telegram:"`BTCUSD\z`\nMarket Order Filled @ {price}\nPosition Value: {position_value}"
delay=3
close=position side=short q=98% stoploss=+75 reduce=1 t=market return=1 onerror=closeside retries=3 id=SL-auto notify=telegram:"`New SL at   \z` {stop_px}"
skip=-1

:new_sl_short
check=position side=short minpnl=7.5% iffound=tp_short
cancel=order id=SL
delay=3 updateprice cachedprice
close=position side=short q=98% stoploss=+75 reduce=1 t=market return=1 onerror=closeside retries=3 id=SL-auto notify=telegram:"`New SL at   \z` {stop_px}"
skip=-1

:tp_short
close=position q=98% side=short t=market notify=telegram:"`Reduce Position (Market)   \z`"
cancel=order id=SL
delay=2
jump=set_stops_short

## Here you enter the alert ID of this script. So if there is no position anymore, it disables itself.
:disable_check
cancel=order id=SL
disable=XXXXXXXXXXXX