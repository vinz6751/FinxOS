// Le MFP fournit les services de timer, de RS232, et est aussi une
// source d'interruption (IPL6) pour tous les périphériques du ST

#define MFP_IMPL
#include "irq.i"
#include "mfp.i"

	.section text,text

mfp_init:
	; Initialise le MFP
	lea	.word0 (MFP_BASE+MFP_TSR+1).w,a0
	; Efface tout sauf le registre de données à envoyer à la RS232
	move.w	#MFP_TSR/2,d0
	clr.w	d1
loop$:	move.w	d1,-(a0)
	dbra	d0,loop$
	move.b	#0x48,MFP_VR(a0) ; Vectors 0x40 à 0x4F, Software End of Interrupt
	rts

mfp_timer:
;xbtimer(2, 0x50, 192, (LONG)int_timerc);
; Pour test on setup just timer C 200Hz
	lea	.word0 MFP_BASE.w,a1
	move.b	MFP_TCDCR(a1),d1
	andi.b	#0x0f,d1
	move.b	#192,MFP_TCDR(a1)
	move.b	#0x50,d1
	andi.b	#0xf0,d1
	or.b	d1,MFP_TCDCR(a1)
	rts

mfp_irq_enable:
	; Active l'interruption MFP d0.w (si 0-7)
	; Pourri d1,a0
	lea	.word0 MFP_BASE.w,a0
	moveq	#0,d1
	andi.l	#0x0f,d0 ; n° d'interruption >= 8 ?
	cmpi.b	#8,d0
	bmi.s	irq07$
irq8f$:	subq.b	#8,d0
	bset	d0,d1
	or.b	d1,MFP_IMRA(a0)
	or.b	d1,MFP_IERB(a0)
	rts
irq07$:	bset	d0,d1
	or.b	d1,MFP_IMRB(a0)
	or.b	d1,MFP_IERB(a0)
	rts

mfp_irq_disable:
	; Désactive l'interruption d0.w (si 0-7).
	; Pourri d1.b,a0
	lea	.word0 MFP_BASE.w,a0
	move.b	#0xff,d1
	andi.l	#0x0f,d0 ; n° d'interruption >= 8 ?
	cmpi.b	#8,d0
	bmi.s	irq07$
irq8f$:	subq.b	#8,d0
	bclr	d0,d1
	and.b	d1,MFP_IMRA(a0)
	and.b	d1,MFP_IERA(a0)
	rts
irq07$:	bclr	d0,d1
	and.b	d1,MFP_IMRB(a0)
	and.b	d1,MFP_IERB(a0)
	rts


mfp_irq_mask_all:
	; Masque toutes les interruptions
	; Retourne dans d0.w IMRA et IMRB pour que ça puisse être restauré plus tard avec mfp_irq_unmask
	move.b	.word0 (MFP_BASE+MFP_IMRA).w,d0
	lsl.w	#8,d0
	move.b	.word0 (MFP_BASE+MFP_IMRB).w,d0
	rts


mfp_irq_unmask:
	; Restore les interruptions précédemment masquées
	; d0: IMRA IMRB
	move.b	d0,.word0 (MFP_BASE+MFP_IMRB).w
	lsr.w	#8,d0
	move.b	d0,.word0 (MFP_BASE+MFP_IMRA).w
	rts
