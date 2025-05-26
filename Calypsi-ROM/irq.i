#ifndef IRQ_I
#define IRQ_I

// Interruptions matérielles

#define IRQ_TIMER_B        0
#define IRQ_RS232_TX_ERROR 1
#define IRQ_RS232_TX       2
#define IRQ_RS232_RX_ERROR 3
#define IRQ_RS232_RX       4
#define IRQ_TIMER_A        5
#define IRQ_RS232_RING     6
#define IRQ_MONO_DETECT    7
#define IRQ_PARALLEL_PORT  8
#define IRQ_RS232_CARRIER  9
#define IRQ_RS232_CTS     10
#define IRQ_RESERVED_     11
#define IRQ_TIMER_D       12
#define IRQ_TIMER_C       13
#define IRQ_ACIA          14
#define IRQ_FDC_HDC       15
#define IRQ_VBL           16
#define IRQ_HBL           17

// Vecteurs d'interruptions logiques (indépendants du matériel).
// Retourner par rts
#define LIRQ_KEYBD_RX     1
#define LIRQ_KEYBD_RX_ERR 2
#define LIRQ_MOUSE_RX     3
#define LIRQ_VBL          4
#define LIRQ_HBL          5
#define LIRQ_MIDI_RX      6
#define LIRQ_MIDI_RX_ERR  7
#define LIRQ_MIDI_TX      8
#define LIRQ_MIDI_TX_ERR  9
#define LIRQ_COM1_RX      10
#define LIRQ_COM1_TX      11
#define LIRQ_COM1_CD      12
#define LIRQ_COM1_CTS     13
#define LIRQ_COM1_RING    14
#define LIRQ_COM1_RX_ERR  15
#define LIRQ_COM1_TX_ERR  16
#define LIRQ_TIMER_A      17
#define LIRQ_TIMER_B      18
#define LIRQ_TIMER_C      19
#define LIRQ_TIMER_D      20
#define LIRQ_MONO_DETECT  21
#define LIRQ_LPT          22
#define LIRQ_BLITTER      23
#define LIRQ_FDC_HDC      24
#define LIRQ_MAX          24


# if defined(IRQ_IMPL)
	.public irq_init
	.public irq_set_lhandler
	
	.public vbl_count
# else
	; Fonctions
	.extern irq_init
	.extern irq_set_lhandler
	
	; Données
	.extern vbl_count ; Compteur d'interruptions VBL (50 ou 72Hz)
# endif

#endif
