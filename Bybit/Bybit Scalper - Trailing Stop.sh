e=bybit a=bybit1 s=BTCUSD
check=position side=[side] ifnone=abort
updateprice
## Close Position - Limit Order
close=position side=[side] q=10% t=limit id=main retries=3 notify=0
delay=30
check=order id=main ifnone=notify_limit_success_reduce 
## Close Position - Market Order
cancel=order id=main
delay=2
close=position side=[side] q=10% t=market id=market-order retries=3 notify=telegram:"`Scalper Trailing Stop\z`\nMarket Order Filled @ {price}\nPosition Value: {position_value}"
skip=set_tp_sl
## Limit Order Notification
:notify_limit_success_reduce
check=position side=[side] notify=telegram:"`Scalper Trailing Stop\z`\Limit Order Filled @ {price}\nPosition Size: {relSize}"
skip=set_tp_sl

:set_tp_sl
updateprice
cancel=order id=SL-1
delay=3
close=position side=[side] stoploss=[-]0.35% pr=last reduce=1 t=market return=1 onerror=closeside retries=3 id=SL-1 notify=telegram:"`New SL at   \z` {stop_px}"