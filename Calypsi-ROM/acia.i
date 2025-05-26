#ifndef ACIA_I
#define ACIA_I

// Selection de la vitesse et reset (Baudrate = clock/factor)
ACIA_DIV1  .equ 0
ACIA_DIV16 .equ 1
ACIA_DIV64 .equ 2
ACIA_RESET .equ 3

// Format des données à transmettre et recevoir
ACIA_D7E2S .equ (0<<2) ; 7 data, parité paire, 2 stop
ACIA_D7O2S .equ (1<<2) ; 7 data, parité impaire, 2 stop
ACIA_D7E1S .equ (2<<2) ; 7 data, parité paire, 1 stop
ACIA_D7O1S .equ (3<<2) ; 7 data, parité impaire, 1 stop
ACIA_D8N2S .equ (4<<2) ; 8 data, no parity, 2 stop
ACIA_D8N1S .equ (5<<2) ; 8 data, no parity, 1 stop
ACIA_D8E1S .equ (6<<2) ; 8 data, parité paire, 1 stop
ACIA_D8O1S .equ (7<<2) ; 8 data, parité impaire, 1 stop

// Contrôle de la transmission
ACIA_RLTID   .equ (0<<5) ; RTS bas, TxINT désactivé
ACIA_RLTIE   .equ (1<<5) ; RTS bas, TxINT activé
ACIA_RHTID   .equ (2<<5) ; RTS haut, TxINT désactivé
ACIA_RLTIDSB .equ (3<<5) ; RTS bas, TxINT désactivé, send break

// Contrôle de la réception
ACIA_RID .equ (0<<7) ; RxINT désactivé
ACIA_RIE .equ (1<<7) ; RxINT activé

// Bits de status
ACIA_RDRF_BIT .equ 0      ; Numéro de bit de Registre de réception plein
ACIA_RDRF     .equ (1<<ACIA_RDRF_BIT) ; Registre de réception plein
ACIA_TDRE_BIT .equ 1      ; Numéro de bit de registre d'envoi vide
ACIA_TDRE     .equ (1<<ACIA_TDRE_BIT) ; Registre d'envoi vide
ACIA_DCD      .equ (1<<2) ; Porteuse détectée (Data Carrier Detect)
ACIA_CTS      .equ (1<<3) ; Prêt à envoyer (Clear To Send)
ACIA_FE       .equ (1<<4) ; Erreur de format (Framing Error)
ACIA_OVRN_BIT .equ 5
ACIA_OVRN     .equ (1<<ACIA_OVRN_BIT) ; Surmenage (Receiver Overrun)

ACIA_PE       .equ (1<<6) ; Erreur de parité (Parity Error)
ACIA_IRQ_BIT  .equ 7      ; Demande d'interruption
ACIA_IRQ      .equ (1<<ACIA_IRQ_BIT) ; Demande d'interruption


#endif
