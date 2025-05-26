#define MEMORY_IMPL
#include "memory.i"

	.section text,text

MMU_CONFIG   .equ 0xffff8001 ; Octet

memory_init:
	; Configure la mémoire (4Mo)
	move.b	#0b1010,.word0 MMU_CONFIG.w
	move.l	#0x400000,d0
	move.l	d0,.word0 memory_ram_size.w
	move.l	d0,.word0 memory_tpa_top.w
	rts

memory_reserve:
	; Réserve de l'espace (d0 octets) dans le haut de la mémoire
	; Assure un espace pair
	addq.l	#1,d0
	andi.w	#-2,d0
	lea	.word0 memory_tpa_top.w,a1
	move.l	(a1),d1
	sub.l	d0,d1
	move.l	d1,d0
	move.l	d0,(a1) ; Ecrit la nouvelle memory_tpa_top
	rts

	.section bss,bss
	.align 4
memory_ram_size:	.space 4
memory_tpa_top:	.space 4
