##
## Open/Close Position and Stop Loss
## This script works together with the "Monitoring Script", you also find it in this folder.
##
## This alert syntax is meant to be used for a Trend Following Strategy
## Example: Open your position based on trend signals/alerts, best some higher TF like 30min or more.
##
## The Stop Loss is tight, but it will reduce the position only by 98% so a tiny bit of the position remains open (for a reason, i'll explain why in the Monitoring Script)
##
## If you have questions, ping me on Telegram: nomad5am - I'll help you out!
##
e=XXX a=* s=BTCUSD

## Check for open positions, if there is a trade in the same direction still open, add to this position and increase it.
## If there is a position in the opposite direction, then market close

check=position side=[side] iffound=start
close=position side=[!side] type=market ifnone=start
delay=5 updatebalance 

## Open Position - Try limit order
## Order 1: wait 20 seconds to fill, if order gets filled > send notification

:start
updateprice cachedprice
side=[side] q=3.5% l=10 t=limit id=limit retries=3 notify=0
delay=20
check=order id=limit ifnone=notify_limit_success 
cancel=order

## Order 2: wait 20 seconds to fill, if order gets filled > send notification

delay=3 updateprice cachedprice
side=[side] q=3.5% l=10 t=limit id=limit retries=3 notify=0
delay=20
check=order id=limit ifnone=notify_limit_success 
cancel=order

## Limit orders were not filled, so now do a market order and send notification

delay=3
side=[side] q=3.5% l=10 t=market id=market retries=3 notify=telegram:"`BTCUSD\z`\nMarket Order Filled @ {price}\nPosition Value: {position_value}"
jump=set_stoploss

## Limit Order Notification

:notify_limit_success
check=position side=[side] notify=telegram:"`BTCUSD\z`\Limit Order Filled @ {price}\nPosition Size: {relSize}"

## Place Stop Loss

:set_stoploss
cancel=order id=SL
delay=3 updateprice cachedprice
close=position side=[side] stoploss=[-]0.10% q=98% reduce=1 t=market return=1 onerror=closeside retries=3 id=SL-auto notify=telegram:"`SL set at   \z` {price}"

##
## IMPORTANT: Here you need to put the alert ID of the Monitoring Script
## See where you can find the alert ID: https://imgur.com/OE22cdu
##

enable=XXXXXXXXXXXX