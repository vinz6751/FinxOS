#ifndef MIDI_I
#define MIDI_I

MIDI_ACIA_BASE .equ 0xfffffc04
MIDI_ACIA_CTRL .equ 0
MIDI_ACIA_DATA .equ 2

# if defined(MIDI_IMPL)
	.public midi_init
# else
	; Fonctions
	.extern midi_init
# endif


#endif
