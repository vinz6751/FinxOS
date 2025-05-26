#ifndef SHIFTER_I
#define SHIFTER_I

# if defined(SHIFTER_IMPL)
	.public shifter_init
	.public shifter_set_fb
	.public shifter_set_palette
	.public shifter_default_palette
	.public shifter_get_fb_size
# else
	.extern shifter_init
	.extern shifter_set_fb
	.extern shifter_set_palette
	.extern shifter_default_palette
	.extern shifter_get_fb_size
# endif

SHIFTER_BASE    .equ 0xffff8200
SHIFTER_PALETTE .equ (SHIFTER_BASE+0x40)
SHIFTER_FB_SIZE .equ 32000

#endif
