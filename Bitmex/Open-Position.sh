e=bitmex a=acc1 s=XBTUSD
check=position side=[side] ifopen=abort
close=position side=[!side] type=market ifnone=limitEntry notify=0

:limitEntry
updateprice
side=[side] q=1000 l=0 id=limit maxtime=120 iferror=marketEntry notify=0
delay=15
cancel=order id=limit ifnone=end
check=position side=[side] minsize=1000 iffound=end ifnone=limitEntry

:marketEntry
check=position side=[side] iffound=end
side=[side] q=1000 l=0 type=market retries=20 notify=0
delay=5

:end
