#define IKBD_IMPL
#include "acia.i"
#include "ikbd.i"
#include "irq.i"
#include "mfp.i"

	.section text,text
	
// Support for the Intelligent KeyBoarD controller of the Atari

ikbd_init:
	; Reset et configure l'ACIA
	; Pas de paramètre et ne retourne rien
	; RX IRQ activée, horloge/64, 8D1S pas de parité, RTS bas, pas d'IRQ de TX
	lea 	IKBD_ACIA_BASE+IKBD_ACIA_CTRL,a1
	move.b	#ACIA_RESET,(a0)
	move.b	#(ACIA_RIE|ACIA_RLTID|ACIA_DIV64|ACIA_D8N1S),(a0)

	; Initialise le processeur clavier
	move.w	#0x8001,d0 ; Reset
	bsr	ikbd_write_word

	; Attend le reset, l'IKBD va répondre avec son numéro de version
	move.l	#18,d0 ; Timeout compris entre 300ms/ (1/50 et (1/72) (fréquence VBL)
	bsr.s	ikbd_read_byte
	beq.s	end$ ; Timeout
	
	; Vérifie la version
	andi.b	#0xf0,d0 ; La version d l'IKBD est 0xf0 ou 0xf1
	cmp.b	#0xf0,d0
	bne.s	end$	; version inconnue

	; Lit et ignore tout ce qui était en attente
	moveq	#1,d0
	bsr.s	ikbd_read_byte
	beq.s	end$ ; Timeout
	
	move.w	#LIRQ_KEYBD_RX,d0
	lea	ikbd_byte_received(pc),a0
	jsr	irq_set_lhandler

	move.w	#IRQ_ACIA,d0
	bsr	mfp_irq_enable

end$:	rts


ikbd_byte_received:
	addq.w	#1,.word0 0xFF8240.w
	rts

ikbd_can_write:
	btst	#ACIA_TDRE_BIT,IKBD_ACIA_BASE+IKBD_ACIA_CTRL
	seq	d0
	rts


ikbd_wait_until_can_write:
loop$:	btst	#ACIA_TDRE_BIT,IKBD_ACIA_BASE+IKBD_ACIA_CTRL
	beq.s	loop$
	rts


ikbd_wait_until_can_read:
loop$:	btst.b	#ACIA_RDRF_BIT,IKBD_ACIA_BASE+IKBD_ACIA_CTRL
	beq.s	loop$
	rts


ikbd_read_byte:
	; Lit un octet. Si d0 est non nul, c'est un timeout en nombre de VBL
	; Pourri d0-d1/a0-a1
	lea	.word0 vbl_count.w,a0
	lea	.word0 IKBD_ACIA_BASE.w,a1
	move.l	d0,d1 ; timeout
	add.l	(a0),d1
	move.l	d1,d0 ; d0: vblcount à partir duquel on timeout
loop$:	btst	#ACIA_RDRF_BIT,IKBD_ACIA_CTRL(a1)
	bne.s	read$
	move.l	(a0),d1 ; vblcount
	cmp.l	d0,d1 ; timeout >= vblcount ?
	bmi.s	loop$
timeout$:
	moveq	#-1,d0 ; MSB set = timeout
	rts
read$:	move.b	IKBD_ACIA_DATA(a1),d0
	andi.b	#0x00ff,d0 ; MSB clear = pas de timeout
	rts


ikbd_write_byte:
	bsr.s	ikbd_wait_until_can_write
	move.b	d0,IKBD_ACIA_BASE+IKBD_ACIA_DATA
	rts


ikbd_write_word:
	ror.w	#8,d0 ; MSB d'abord
	bsr.s	ikbd_write_byte
	ror.w	#8,d0 ; LSB ensuite
	bra.s	ikbd_write_byte
	;rts
	
	.section bss,bss
ikbd_iorec:
