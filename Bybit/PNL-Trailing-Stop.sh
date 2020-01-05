###
### Trailing Stops / Secure Profits
### This syntax is setting trailing stop orders as the PNL increases to secure profits
### It won't trail back down, only up. Once the PNL decreases it will trigger the stop.
###

e=bybit a=* s=BTCUSD

:check_orders
check=order ifnone=check_pnl_0
check=order id=TP-0 iffound=check_pnl_1
check=order id=TP-1 iffound=check_pnl_2
check=order id=TP-2 iffound=check_pnl_3
check=order id=TP-3 iffound=check_pnl_4
check=order id=TP-4 iffound=abort

:check_pnl_0
check=position minpnl=0.5% maxpnl=1.99% iffound=check_side_tp_0
:check_pnl_1
check=position minpnl=2.00% maxpnl=4.99% iffound=check_side_tp_1
:check_pnl_2
check=position minpnl=5.00% maxpnl=9.99% iffound=check_side_tp_2
:check_pnl_3
check=position minpnl=10.00% maxpnl=14.99% iffound=check_side_tp_3
:check_pnl_4
check=position minpnl=15.00% maxpnl=20% iffound=check_side_tp_4 ifnot=abort

### Check Position Side 

:check_side_tp_0
check=position side=long iffound=place_long_order_0 ifnot=place_short_order_0

:check_side_tp_1
check=position side=long iffound=place_long_order_1 ifnot=place_short_order_1

:check_side_tp_2
check=position side=long iffound=place_long_order_2 ifnot=place_short_order_2

:check_side_tp_3
check=position side=long iffound=place_long_order_3 ifnot=place_short_order_3

:check_side_tp_4
check=position side=long iffound=place_long_order_4 ifnot=place_short_order_4

### Place Stop Loss Orders 

:place_long_order_0
cancel=order
updateprice
close=position side=long sl=-75 pr=last t=market return=1 id=TP-0
skip=-1

:place_short_order_0
cancel=order
updateprice
close=position side=short sl=75 pr=last t=market return=1 id=TP-0
skip=-1

### Place Trailing Stop Profit Orders

:place_long_order_1
cancel=order
updateprice
close=position side=long sl=-15 pr=last t=market return=1 id=TP-1
skip=-1

:place_short_order_1
cancel=order
updateprice
close=position side=short sl=15 pr=last t=market return=1 id=TP-1
skip=-1

:place_long_order_2
cancel=order
updateprice
close=position side=long sl=-15 pr=last t=market return=1 id=TP-2
skip=-1

:place_short_order_2
cancel=order
updateprice
close=position side=short sl=15 pr=last t=market return=1 id=TP-2
skip=-1

:place_long_order_3
cancel=order
updateprice
close=position side=long sl=-15 pr=last t=market return=1 id=TP-3
skip=-1

:place_short_order_3
cancel=order
updateprice
close=position side=short sl=15 pr=last t=market return=1 id=TP-3
skip=-1

:place_long_order_4
cancel=order
updateprice
close=position side=long sl=-15 pr=last t=market return=1 id=TP-4
skip=-1

:place_short_order_4
cancel=order
updateprice
close=position side=short sl=15 pr=last t=market return=1 id=TP-4
skip=-1