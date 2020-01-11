e=bybit a=bybit1 s=BTCUSD
## Close Position / Market Order
check=position side=[side] iffound=start
close=position side=[!side] type=market
:start
cancel=order
delay=3 updatebalance
## Open Position - Limit Order
side=[side] q=3.5% l=10 t=limit id=main retries=3 notify=0
delay=90
check=order id=main ifnone=notify_limit_success 
cancel=order updateprice
side=[side] q=3.5% l=10 t=limit id=main retries=3 notify=0
delay=90
check=order id=main ifnone=notify_limit_success 
## Open Position - Market Order
cancel=order
delay=2
side=[side] q=3.5% l=10 t=market id=market-order retries=3 notify=telegram:"`Scalper\z`\nMarket Order Filled @ {price}\nPosition Value: {position_value}"
jump=set_tp_sl
## Limit Order Notification
:notify_limit_success
check=position side=[side] notify=telegram:"`Scalper\z`\Limit Order Filled @ {price}\nPosition Size: {relSize}"
# Place TP and SL Orders
:set_tp_sl
cancel=order id=SL-1
delay=2
updateprice
close=position side=[side] stoploss=[-]1.00% pr=last t=market reduce=1 return=1 onerror=closeside retries=3 id=SL-1 notify=telegram:"`SL at   \z` {stop_px}"
close=position side=[side] price=[+]0.25% pr=last q=10% reduce=1 return=1 retries=3 id=TP-1 notify=telegram:"`TP-1 at   \z` {price}"
close=position side=[side] price=[+]0.35% pr=last q=20% reduce=1 return=1 retries=3 id=TP-2 notify=telegram:"`TP-2 at   \z` {price}"
close=position side=[side] price=[+]0.50% pr=last q=30% reduce=1 return=1 retries=3 id=TP-3 notify=telegram:"`TP-3 at   \z` {price}"
close=position side=[side] price=[+]0.75% pr=last q=30% reduce=1 return=1 retries=3 id=TP-4 notify=telegram:"`TP-4 at   \z` {price}"
close=position side=[side] price=[+]1.00% pr=last q=10% reduce=1 return=1 retries=3 id=TP-5 notify=telegram:"`TP-5 at   \z` {price}"