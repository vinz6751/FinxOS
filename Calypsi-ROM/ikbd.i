#ifndef IKBD_I
#define IKBD_I

IKBD_ACIA_BASE .equ 0xfffffc00
IKBD_ACIA_CTRL .equ 0
IKBD_ACIA_DATA .equ 2

# if defined(IKBD_IMPL)
	.public ikbd_init
# else
	; Fonctions
	.extern ikbd_init
# endif

#endif