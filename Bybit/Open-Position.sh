### Bybit Long/Short ###

# If necessary uncomment the following line to set exchange & symbol
#exchange=bybit-testnet symbol=xbtusd

# Optionally for multi accounts uncomment the following and fill in your accounts
#parallel=acc1,acc2,acc3

# Cancel all orders ..if none found jump ahead to main order
cancel=order ifnone=main
# Close open positions on the opposite side at market
# ..if no matching position is found, skip the delay and jump to main order
close=position side=[!side] type=market ifnone=main
# Give closing order time to execute
delay=5

# Place main position order at market
# error=abort : Abort/skip rest on error (after retries)
# retries=3   : Give up after 3 retries in case of overload
:main
side=[side] quantity=YOUR_BUY_IN% leverage=YOUR_LEVERAGE type=market error=abort retries=3 notify=discord:1

# Give main order time to execute
delay=3

# Add market stop loss order
# return=1        : Expect to place an order (needed in case main order takes longer to fill)
# error=closeside : If we can't place SL, cancel orders, close position & abort
close=position side=[side] stoploss=[-]YOUR_STOP_LOSS% t=market return=1 error=closeside retries=10 id=SL notify=discord:"`SL at   \z` {stop_px}"

# Add limit take profit (reduce/close only) order
close=position side=[side] price=[+]YOUR_TAKE_PROFIT% reduce return=1 error=closeside retries=10 id=TP notify=discord:"`TP at   \z` {price}"