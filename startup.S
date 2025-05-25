    .extern main
    .extern _stktop
    .global start
    .global hang
    
    .text
// hello
/*    .section .vectors */
    /* Vector Table */
    .dc.l _stack_top
    .dc.l start

    /* Entry Point (start is where we jump after reset) */
start:
    nop
    nop
    /* Call main() function */
    jsr     main

    /* Infinite loop to prevent program from running out of control */
hang:
    jmp     hang

    

    .bss
