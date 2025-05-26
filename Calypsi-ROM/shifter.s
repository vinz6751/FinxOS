#define SHIFTER_IMPL
#include "memory.i"
#include "mfp.i"
#include "shifter.i"

	.section text,text

shifter_init:
	; Initialise le shifter
	lea	.word0 SHIFTER_BASE.w,a1
	move.b	#2,0xa(a1)    ; 50Hz (PAL), pas de synchro externe

	; Détecte le type de moniteur. La détection est faite par une broche
	; du port d'entrées/sorties (en fait que des entrées) du MFP
	move.b	.word0 (MFP_BASE+MFP_GPIP).w,d0
	andi.w	#MFP_GPIP_MONO_DETECT,d0
	seq	d0 ; d0: mono ?

	; Choisir la résolution
	andi.w	#0b10,d0 ; Si d0 était 0xff (mono), ça fait 2 (ST-Haute), sinon 0 (ST-Basse)
	bsr.s	shifter_set_rez

	; Charge la palette
	lea	shifter_default_palette,a0
	bsr.s	shifter_set_palette

	; Alloue la mémoire vidéo. On s'assure d'avoir la mémoire alignée
	; sur 256 octets pour la compatibilité avec le STf
	move.l	#SHIFTER_FB_SIZE+256,d0
	bsr	memory_reserve
	clr.b	d0
	move.l	d0,shifter_fb

	; Configure la mémoire écran
	move.l	d0,a0
	bsr.s	shifter_set_fb

cls$:	; Efface l'écran
	move.l	shifter_fb,a0
	moveq	#0,d1
	move.w	#SHIFTER_FB_SIZE/16-1,d0 ; Décompteur pour effaçage d'écran
loop$:	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	dbra	d0,loop$
	rts


shifter_set_rez:
	; Change la résolution donnée dans d0.w
	; Pourri d0.w,d1.w,a0,a1
	lea	.word0 SHIFTER_BASE.w,a0
	move.b	d0,0x60(a0)   ; Résolution
	clr.b	0xf(a0)  ; STe largeur supplémentaire d'une ligne en mots -1
	clr.b	0x65(a0) ; STe horizontal scroll offset
	lsr.w	#3,d0    ; Sizeof une ligne de resolution info
	lea.l	shifter_res_infos,a0
	adda.w	d0,a0
	move.l	d0,shifter_res_info
	rts


shifter_set_fb:
	; Installe la mémoire vidéo pointée par a0
	; Pourrie a1,d0
	lea	.word0 SHIFTER_BASE.w,a1
	move.l	a0,d0      ; 00hhmmll
	swap	d0         ; mmll00hh
	move.b	d0,0x1(a1) 
	rol.l	#8,d0      ; ll00hhmm
	move.b	d0,0x3(a1)
	move.l	a0,d0
	move.b	d0,0xd(a1)
	rts


shifter_set_palette:
	; Charge la palette pointée par a0 (16 words)
	; Pourri d0
	moveq	#16-1,d0
	lea	.word0 SHIFTER_PALETTE.w,a1
loop$:	move.w	(a0)+,(a1)+
	dbra	d0,loop$
	rts


shifter_get_fb_size:
	; Donne la taille de la mémoire vidéo suivant la résolution passée en d0
	move.l	#SHIFTER_FB_SIZE,d0
	rts

shifter_vsync:
	; Attends la prochaine VBL
	


	.section rodata,rodata
shifter_default_palette:
	.align 4
	.word	0x002,0x777,0x070,0x700,0x007,0x077,0x707,0x770
	.word	0x333,0x555,0x040,0x400,0x004,0x044,0x404,0x440

shifter_res_infos: ; x res, y res, plans, couleurs
	.word	320,200,4,16
	.word	640,200,2,4
	.word	640,400,1,2


	.section bss,bss
shifter_res_info:	.space 4 ; Pointe sur le res_info courant
shifter_fb:	.space 4