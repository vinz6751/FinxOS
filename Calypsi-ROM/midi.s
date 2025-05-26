#define MIDI_IMPL
#include "midi.i"

	.section text, text

midi_init:
	; Initialise le système MIDI
	rts


midi_byte_received:
	; Traite la réception d'un octet reçu depuis l'interface MIDI, traité en d0
	rts

