#define IRQ_IMPL
#include "acia.i"
#include "ikbd.i"
#include "irq.i"
#include "mfp.i"
#include "midi.i"

#define LVECTOR(x) (irq_user_handlers+4*x)

; Gestion des interruptions
; Cette parte est dépendante du matériel, et fournit des vecteurs indépendants du matériel
; On installe nos routines

 .public ikbdsys
 .public midisys

	.section text,text

irq_init:
	; Met en place les routines d'interruption physiques et logiques
	; Pourri d0/a0-a2
	clr.l	.word0 vbl_count.w
	; Interruptions physiques
	lea	irq_to_vector,a0
	lea	irq_to_handler,a1
	moveq	#(irq_to_handler-irq_to_vector)/2-1-1,d0 ; taille du tableau de word
loopp$:	movea.w	(a0)+,a2
	move.l	(a1)+,(a2)
	dbra	d0,loopp$
	; Interruptions logiques (par défaut, rts. Chaque sous-système installe ses routines plus tard)
	lea	irq_user_handlers,a0
	lea	end$,a1
	move.w	#LIRQ_MAX-1,d0
loopl$:	move.l	a1,(a0)+
	dbra	d0,loopl$
	; Active les interruptions MFP/VBL
	move.w	#6,d0
	bsr	mfp_irq_enable
	move.w	#0x2300,sr
end$:	rts


irq_set_lhandler:
	; Installe le gestionnnaire d'interruption logique.
	; Ne fait rien si numéro de d'interruption loqique farfelu
	; d0.w: numéro a0: adresse de la routine qui doit se terminer par rts
	; d0.w,a0-a1
	lea	irq_user_handlers,a1
	add.w	d0,d0
	bmi.s	wrong$ ; pas 100% sûr si d0 overflow mais bon...
	cmpi.w	#LIRQ_MAX*2,d0
	bgt.s	wrong$
	add.w	d0,d0 ; index en mots long
	move.l	d0,(a1)
wrong$:	rts


irq_enable:
	; Active l'interruption dont le numéro standardisé est passé en d0.w
	; Pourri d0
	cmpi.w	#IRQ_FDC_HDC,d0 ; Numéro le plus haut d'interruption MFP
	bgt.s	hbl_or_vbl$
mfp$:	; Si IPL >= 6 ramène à 5
	; Sur l'Atari ST, ça active AUSSI les interruptions MFP et VBL
	move.w	sr,d0
	andi.w	#0xf0ff,d0
	cmpi.w	#0x0500,d0
	blt.s	end1$
	ori.w	#0x0500,d0 ; IPL5
	move.w	d0,sr
end1$:	rts
hbl_or_vbl$:
	cmpi.w	#IRQ_HBL,d0
	beq.s	hbl$
vbl$:	; Si IPL >= 4 ramène à 3
	; Sur l'Atari ST, ça active AUSSI les interruptions MFP (niveau 6)
	move.w	sr,d0
	btst	#11,d0 ; >= 0x0400 ?
	beq.s	end2$
	andi.w	#0xf0ff,d0
	ori.w	#0x0300,d0 ; IPL3
	move.w	d0,sr
end2$:	rts
hbl$:	cmpi.w	#IRQ_HBL,d0
	bne.s	end3$ ; Numéro d'IRQ invalide
	; Si IPL >= 2 ramène à 1
	; Sur l'Atari ST, ça active AUSSI les interruptions MFP et VBL
	move.w	sr,d0
	andi.w	#0xf0ff,d0
	cmpi.w	#0x0200,d0
	blt.s	end3$
	ori.w	#0x0100,d0 ; IPL 1
	move.w	d0,sr
end3$:	rts


; Gestionnaires d'interruptions

; Gestionnaires MFP. Ils sauvent d0-d2/a0-a2 et acquittent le "interruption in service"
irq_timer_b_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_TIMER_B),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b00000001,.word0 (MFP_BASE+MFP_ISRA).w
	rte


irq_rs232_tx_error_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_COM1_TX_ERR),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#~0b00000010,.word0 (MFP_BASE+MFP_ISRA).w
	rte


irq_rs232_tx_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_COM1_TX),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#~0b00000100,.word0 (MFP_BASE+MFP_ISRA).w
	rte


irq_rs232_rx_error:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_COM1_RX_ERR),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#~0b00010000,.word0 (MFP_BASE+MFP_ISRA).w
	rte


irq_rs232_rx_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_COM1_RX),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#~0b00100000,.word0 (MFP_BASE+MFP_ISRA).w
	rte


irq_timer_a_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_TIMER_A),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b01000000,.word0 (MFP_BASE+MFP_ISRA).w
	rte


irq_monochrome_detect_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_MONO_DETECT),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b10000000,.word0 (MFP_BASE+MFP_ISRA).w
	rte


irq_centronics_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_LPT),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b00000001,.word0 (MFP_BASE+MFP_ISRB).w
	rte


irq_rs232_carrier_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_COM1_CD),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b00000010,.word0 (MFP_BASE+MFP_ISRB).w
	rte


irq_rs232_cts_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_COM1_CTS),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b00000100,.word0 (MFP_BASE+MFP_ISRB).w
	rte


irq_blitter_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_BLITTER),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b00001000,.word0 (MFP_BASE+MFP_ISRB).w
	rte


irq_timer_d_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_TIMER_D),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b00010000,.word0 (MFP_BASE+MFP_ISRB).w
	rte


irq_timer_c_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_TIMER_C),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b00100000,.word0 (MFP_BASE+MFP_ISRB).w
	rte


irq_acia_handler:
	movem.l d0-d2/a0-a2,-(sp)
loop$:	; Traitement des interruptions des ACIA clavier et MIDI
	bsr.s	midisys
	bsr.s	ikbdsys
	lea	.word0 MFP_BASE.w,a1
	btst.b	#4,MFP_GPIP(a1) ; Test MFP_GPIP_KBD_MIDI pour voir si autre IRQ ACIA en attente
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b01000000,MFP_ISRB(a1)
	rte
midisys: ; Regarde si interruption MIDI et traite la
	; Pourri d0,a2
	lea	.word0 MIDI_ACIA_BASE.w,a3
	move.b	MIDI_ACIA_CTRL(a3),d0
	bpl.s	rts$                    ; pas une interruption de l'ACIA MIDI si ACIA_IRQ_BIT le plus significant est à 0
	btst	#ACIA_RDRF_BIT,d0
	beq.s	tx$                     ; rien n'est reçu -> c'est une interruption TX
	; Octet reçu
	move.w	d0,-(sp)                ; save status byte across midivec call
	move.b	MIDI_ACIA_DATA(a3),d0
	move.l	LVECTOR(LIRQ_MIDI_RX),a0
	jsr	(a0)                    ; appelle le gestionnaire
	move.w	(sp)+,d0                ; d0 = status byte
	; Overrun (surmenage)
	btst	#ACIA_OVRN_BIT,d0       ; overrun ?
	beq.s	rts$                    ; non
	move.b	MIDI_ACIA_DATA(a3),d0   ; récupère octet
	move.l	LVECTOR(LIRQ_MIDI_RX_ERR),a0
	jmp	(a0)                    ; appelle le gestionnaire
rts$:	rts
tx$:	; Interruption TX
	move.l	LVECTOR(LIRQ_MIDI_TX),a0
	jmp	(a0)
	; rts
ikbdsys: ; Regarde si interruption IKBD et traite la
	lea	.word0 IKBD_ACIA_BASE.w,a3
	move.b	IKBD_ACIA_CTRL(a3),d0
	bpl.s	rts$
	btst	#ACIA_RDRF_BIT,d0
	beq.s	rts$                   ; on ne gère pas les interruptions TX
	move.w	d0,-(sp)               ; save status byte across ikbdraw call
	move.b	IKBD_ACIA_DATA(a3),d0
	add.l	#1,.word0 0xFF8240
	move.l	LVECTOR(LIRQ_KEYBD_RX),a0
	jsr	(a0)                   ; appelle le gestionnaire
	move.w	(sp)+,d0               ; d0 = status byte
	btst	#ACIA_OVRN_BIT,d0      ; overrun ?
	beq.s	rts$                   ; non// no, done
	move.b	IKBD_ACIA_DATA(a3),d0   ; récupère octet
	move.l	LVECTOR(LIRQ_KEYBD_RX_ERR),a0
	jmp	(a0)                   ; appelle le gestionnaire
rts$:	rts


irq_fdc_hdc_handler:
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_FDC_HDC),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
	move.b	#0b10000000,.word0 (MFP_BASE+MFP_ISRB).w
	rte


 .public irq_vbl_handler
irq_vbl_handler:
	addq.l	#1,.word0 vbl_count.w
	movem.l	d0-d2/a0-a2,-(sp)
	move.l	LVECTOR(LIRQ_VBL),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d2/a0-a2
_rte:	rte


irq_hbl_handler:
	; On ne sauve pas les registres parce que ça prend trop de temps
	; L'utilisateur doit le faire
	pea	_rte
	move.l	LVECTOR(LIRQ_HBL),-(sp)
	rts
	; rte


	.section rodata,rodata
irq_to_vector:
	; Correspondance entre numero d'interruption normalisé et vecteur d'interruption
	.word 0x120,0x124,0x128,0x12C,0x130,0x134,0x138,0x13C
	.word 0x100,0x104,0x108,0x10C,0x110,0x114,0x118,0x11C
	.word 0x70, 0x68 ; VBL et HBL

irq_to_handler:
	; Correspondance entre numeros d'interruption normalisé et gestionnaire par défaut
	.long irq_timer_b_handler, irq_rs232_tx_error_handler, irq_rs232_tx_handler, irq_rs232_rx_error
	.long irq_rs232_rx_handler, irq_timer_a_handler, irq_monochrome_detect_handler, irq_monochrome_detect_handler
	.long irq_centronics_handler, irq_rs232_carrier_handler, irq_rs232_cts_handler, irq_blitter_handler
	.long irq_timer_d_handler, irq_timer_c_handler, irq_acia_handler, irq_acia_handler
	.long irq_vbl_handler, irq_hbl_handler


	.section bss,bss
vbl_count: .space 4
irq_user_handlers:
	.space LIRQ_MAX*4 ; Vecteurs d'interruptions logiques
