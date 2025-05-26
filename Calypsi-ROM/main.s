#include "ikbd.i"
#include "irq.i"
#include "midi.i"
#include "mfp.i"
#include "memory.i"
#include "shifter.i"

#ifndef BUILD_DATE
# define BUILD_DAY 31
# define BUILD_MONTH 10
# define BUILD_YEAR 2024
#endif
#define STRINGIFY(arg) STRINGIFY_(arg)
#define STRINGIFY_(arg) #arg
#define ID(arg) arg

#define myexample(x,y,z) x##y##z
; move.l myexample(BUILD_DAY,BUILD_MONTH,BUILD_YEAR),d0

;STRINGIFY(ID(BUILD_DAY)ID(BUILD_MONTH)ID(BUILD_YEAR)) 

	.section sstack
	.section rodata,rodata
	.section startup, root, noreorder

#ifdef __CALYPSI_DATA_MODEL_SMALL__
	.extern _NearBaseAddress
#endif

	.public __program_root_section
__program_root_section: ; Point d'entrée

; En-tête du système d'exploitation
_os_header:
os_entry:	bra.s   __program_start      // Branch to _main
os_version:	.word   0x203 // TOS version
reset_handler:	.long   __program_root_section       // pointer to reset handler
os_beg:		.long   _os_header  // base of OS = _sysbase
os_end:		.long   0 // end of VDI BSS
os_res1:		.long   0 // reserved
os_magic:	.long   0 // pointer to main UI's GEM_MUPB
;os_date:		.long   STRINGIFY(ID(BUILD_DAY)ID(BUILD_MONTH)ID(BUILD_YEAR))   // Date of system build
os_date .long 0x31102024
os_conf:		.word   (2 << 1) + 1 // Flag for PAL version + country. 2 c'est la France
os_dosdate:	.word   (BUILD_DAY + BUILD_MONTH * 32 + (BUILD_YEAR - 1980) * 512)  // Date of system build in GEMDOS format
os_root:		.long   0      // Pointer to the GEMDOS mem pool
os_kbshift:	.long   0      // Pointer to the keyboard shift keys states
os_run:		.long   0      // Pointer to a pointer to the actual basepage
os_dummy:	.ascii  "FTOS" // _main should start at offset 0x30, shouldn't it?


__program_start: ; Indique au débugger où le programme démarre vraiment
	move.w	#0x2700,sr ; Pas d'interruptions

#ifdef __CALYPSI_DATA_MODEL_SMALL__
	lea.l	_NearBaseAddress.l,a4
#endif

	lea	.sectionEnd sstack+1,sp ; Configure la pile

	bsr	memory_init  ; Configure la mémoire
	bsr	mfp_init     ; Configure le MFP, c'est important pour les timers et la sortie série de debug
	bsr	irq_init     ; Configure les interruptions
	bsr	shifter_init ; Configure l'écran
	bsr	ikbd_init    ; Initialise le processeur clavier
	bsr	midi_init    ; Initialise le MIDI
	
	move.w	#0x2300,sr   ; Comment le traitement des interruptions
	
rien$:	jmp 	rien$
