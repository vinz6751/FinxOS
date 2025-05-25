CPU=68040

TOOLCHAIN=m68k-atari-mintelf-

AS=$(TOOLCHAIN)gcc -c
ASFLAGS=-m$(CPU)
CC=$(TOOLCHAIN)gcc
# My GenX has 68LC060 (no FPU) so need to use soft-float (until we write something that can leverage the Foenix' math copro!)
CFLAGS=-m$(CPU) -Os -msoft-float
LD = $(CC) $(MULTILIBFLAGS) -nostartfiles -nostdlib
LDFLAGS = -Wl,-T,finxos.ld
OBJCOPY=$(TOOLCHAIN)objcopy
LIBS = -lgcc
SOURCES=startup.S main.c
OBJS=$(patsubst %.c,%.o,$(patsubst %.S,%.o,$(SOURCES)))

.PHONY: clean

default: finxos.s28

finxos.s28: startup.o main.o
	$(LD) $(LDFLAGS) -nostdlib -Wl,-Map,finxos.map -o finxos.elf $^
	$(OBJCOPY) -O srec finxos.elf $@

%.o:%.S
	# This allows us to use //-style comments
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJS) finxos.s28 finxos.elf finxos.map
