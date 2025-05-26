; Timers

	.section text,text
	
timer_init:
	;move.l	#vbl_handler,.word0 0x70
	;move.w	#0x2400,sr
	rts

hbl_handler:
	rte

vbl_handler:
	;add.l	#1,.word0 0xFF8240
	rte


	.section bss,bss
	
