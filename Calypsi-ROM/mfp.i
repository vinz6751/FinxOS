#ifndef MFP_I
#define MFP_I

MFP_BASE              .equ 0xfffffa00
MFP_GPIP              .equ 0x01
MFP_GPIP_MONO_DETECT  .equ 0x80
MFP_GPIP_RS232_RING   .equ 0x40
MFP_GPIP_FDC_HDC      .equ 0x20
MFP_GPIP_KBD_MIDI     .equ 0x10
MFP_GPIP_RS232_CTS    .equ 0x04
MFP_GPIP_RS232_DCD    .equ 0x02
MFP_GPIP_CENTRONICS   .equ 0x01
MFP_AER               .equ 0x03
MFP_DDR               .equ 0x05
MFP_IERA              .equ 0x07
MFP_IERA_MONO_DETECT  .equ 0x80 ; 13c
MFP_IERA_RS232_RING   .equ 0x40 ; 138
MFP_IERA_DMA_TIMERA   .equ 0x20 ; 134
MFP_IERA_RS232_RX     .equ 0x10 ; 130
MFP_IERA_RS232_RXERR  .equ 0x08 ; 12c
MFP_IERA_RS232_TX     .equ 0x04 ; 128
MFP_IERA_RS232_TXERR  .equ 0x02 ; 124
MFP_IERA_RS232_TIMERB .equ 0x01 ; 120
MFP_IERB              .equ 0x09
MFP_IERB_FDC_HDC      .equ 0x80 ; 11c
MFP_IERB_KBD_MIDI     .equ 0x40 ; 118
MFP_IERB_TIMERC       .equ 0x20 ; 114
MFP_IERB_TIMERD       .equ 0x10 ; 110
MFP_IERB_BLITTER      .equ 0x08 ; 10c
MFP_IERB_RS232_CTS    .equ 0x04 ; 108
MFP_IERB_RS232_DCD    .equ 0x02 ; 104
MFP_IERB_CENTRONICS_BUSY .equ 0x01 ; 100
MFP_IPRA  .equ 0x0b
MFP_IPRB  .equ 0x0d
MFP_ISRA  .equ 0x0f
MFP_ISRB  .equ 0x11
MFP_IMRA  .equ 0x13
MFP_IMRB  .equ 0x15
MFP_VR    .equ 0x17
MFP_TACR  .equ 0x19
MFP_TBCR  .equ 0x1b
MFP_TCDCR .equ 0x1d
MFP_TADR  .equ 0x1f
MFP_TBDR  .equ 0x21
MFP_TCDR  .equ 0x23
MFP_TDDR  .equ 0x25
MFP_SCR   .equ 0x27
MFP_UCR   .equ 0x29
MFP_RSR   .equ 0x2b
MFP_TSR   .equ 0x2d
MFP_UDR   .equ 0x2f

# if defined(MFP_IMPL)
	.public mfp_init
	.public mfp_irq_enable
# else
	.extern mfp_init
	.extern mfp_irq_enable
# endif

#endif
