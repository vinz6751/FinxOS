OUTPUT_FORMAT(binary)

MEMORY
{
  RAM (rwx)  : ORIGIN = 0x00000000, LENGTH = 4M
  ROM (rx)   : ORIGIN = 0x00E00000, LENGTH = 1M
}

SECTIONS
{
  .vectors :
  {
    . = 0x400; /* 68k vectors take 1KB */
  } > RAM

  .stack : {
    _stack_bottom = .;
    . += 2K;   /* Define stack size */
    _stack_top = .;
  } > RAM

  .text : {
    *(.text*)
  } > ROM

  .data : {
    *(.data*)
  } > ROM

  /* Zone BSS : données non initialisées, doit être zéroée au démarrage */
  .bss : {
    __bss_start = .;
    *(.bss)
    *(.bss.*)
    . = ALIGN(4);
    __bss_end = .;
  } > RAM


  /DISCARD/ : {
    *(.comment)
    *(.note*)
  }
}
