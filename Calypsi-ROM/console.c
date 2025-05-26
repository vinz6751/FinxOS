// This is a file

#include <stdint.h>

extern  uint8_t * __attribute__((far)) shifter_fb;

void console_cls(void) {
    int16_t i = 100-1;
    uint8_t *b = shifter_fb;
   
    do {
        shifter_fb[i] = 0;
        *b++ = 0;
    } while (--i >= 0);
}

uint32_t truc;

__attribute__((interrupt(0x0070)))
void some_irq_handler(void) {
    *((uint16_t*)0xffff8240) = *((uint16_t*)0xffff8240)+1;
}

void _Stub_close(void) {
    // Do nothing
}
