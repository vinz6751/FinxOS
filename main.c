void main(void) {
    for (;;) {
        *((unsigned volatile long*const)0xFF8240) += 111;
    }
}