/* Fichier principal, appelé depuis startup.S */

#include <stdint.h>

#include "foenix.h"
#include "superio.h"
#include "uart16550.h"

extern void hang(void);

/* Couleur de la bordure */
#define BORDER	   (*(unsigned long*)0xfec00008)


#define BUZZER_ON  ((*(unsigned long*)0xfec00000) |= 16)
#define BUZZER_OFF ((*(unsigned long*)0xfec00000) = 0)


static void  __attribute__((interrupt))  just_rte(void) {
}

void finxos(void) {

	BUZZER_ON;

	/* Initialise les vecteurs du 68k (sauf SP et PC initiaux) */
	long *p = (long)0;
	for (int i=2; i<256; i++)
		p[i] = (long)hang;

	// Masque toutes les interruptions de GAVIN
	(*(unsigned short*)0xfec00100) = 0xffff;
	(*(unsigned short*)0xfec00102) = 0xffff;
	(*(unsigned short*)0xfec00104) = 0xffff;

	BUZZER_OFF;
	
	// Initialise le Super IO
	superio_init();

	BORDER = 0x222222;

#if 1
	// Initialise les UART
	uart16550_init(UART1);
	uart16550_init(UART2);
# if 1
	// Et essaye d'envoyer quelque chose
	for (;;) {
		uart16550_put(UART1,"UART1\r\n",7);
		uart16550_put(UART2,"UART1\r\n",7);
	}
# endif

#endif

	// Si jamais on arrive là, bordure grise et attend
	BORDER = 0x888888;
	hang();
}
