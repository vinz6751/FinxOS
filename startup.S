    .extern _finxos
    .extern _stktop
    .global start
    .global hang

#ifndef BUILD_DATE
# define BUILD_DAY 31
# define BUILD_MONTH 10
# define BUILD_YEAR 2024
#endif
#define STRINGIFY(arg) STRINGIFY_(arg)
#define STRINGIFY_(arg) #arg
#define ID(arg) arg

    .text
#if 0 /* A décommenter si on veut construire une image ROM Atari */
// En-tête du système d'exploitation ATARI TOS
_os_header:
os_entry:	bra.s   start      // Branch to main
os_version:	.word   0x203 // TOS version
reset_handler:	.long   start       // pointer to reset handler
os_beg:		.long   _os_header  // base of OS = _sysbase
os_end:		.long   0 // end of VDI BSS
os_res1:	.long   0 // reserved
os_magic:	.long   0 // pointer to main UI's GEM_MUPB
//os_date:		.long   STRINGIFY(ID(BUILD_DAY)ID(BUILD_MONTH)ID(BUILD_YEAR))   // Date of system build
os_date:        .long 0x31102024
os_conf:	.word   (2 << 1) + 1 // Flag for PAL version + country. 2 c'est la France
os_dosdate:	.word   (BUILD_DAY + BUILD_MONTH * 32 + (BUILD_YEAR - 1980) * 512)  // Date of system build in GEMDOS format
os_root:	.long   0      // Pointer to the GEMDOS mem pool
os_kbshift:	.long   0      // Pointer to the keyboard shift keys states
os_run:		.long   0      // Pointer to a pointer to the actual basepage
os_dummy:	.ascii  "FTOS" // main should start at offset 0x30, shouldn't it?
#endif

    /* Vecteurs reset (seront copié au début de la RAM par le hardware) */
    .dc.l _stack_top
    .dc.l start

    /* Entry Point (start is where we jump after reset) */
start:
    /* Bipb bip et change la couleur de la bordure */
    move.l #16,0xfec00000
    not.l 0xfec80008
.w1:  move.l #1000000,d0
.w11: nop
    subq.l #1,d0
    bne.s .w11
    move.l #0,0xfec00000
    not.l 0xfec80008
.w2:  move.l #1000000,d0
.w22: nop
    subq.l #1,d0
    bne.s .w22


    
    move.l #_stack_top,%sp
    bra.s start
    /* Appel fonction principale en C */
    jbsr   _finxos

    /* On n'est pas sensé retourner de finxos */
hang:
    stop #2700
    jbra hang

   
    .bss
