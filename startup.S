    .extern main
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
// En-tête du système d'exploitation
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

    .text
// hello
/*    .section .vectors */
    /* Vector Table */
    .dc.l _stack_top
    .dc.l start

    /* Entry Point (start is where we jump after reset) */
start:
    move.l #_stack_top,%sp
    /* Call main function */
    jsr     main

    /* Infinite loop to prevent program from running out of control */
hang:
    jmp     hang

    

    .bss
