# This is a Makefile for GNU Make, to build finxos

CPU=68040

# Voir http://vincent.riviere.free.fr/soft/m68k-atari-mint/
TOOLCHAIN=m68k-atari-mint-

AS=$(TOOLCHAIN)gcc -c
ASFLAGS=-m$(CPU)
CC=$(TOOLCHAIN)gcc
# My GenX has 68LC060 (no FPU) so need to use soft-float (until we write something that can leverage the Foenix' math copro!)
CFLAGS=-m$(CPU) -O2 -msoft-float
LD = $(CC) -nostartfiles -nostdlib
LDFLAGS =
OBJCOPY=$(TOOLCHAIN)objcopy
LIBS = -lgcc
SOURCES=startup.S finxos.c
OBJS=$(patsubst %.c,%.o,$(patsubst %.S,%.o,$(SOURCES)))
CP=cp

.PHONY: clean

default: finxos.bin

finxos.bin: $(OBJS)
	$(LD) $(LDFLAGS) -Wl,-T,finxos.ld -Wl,-Map,finxos.map -o $@ $(OBJS)
#       Ajoute 4 octets pour être sur que FoenixMgr ne va pas les bouffer pour des pb d'alignement
#       Ne marche pas...
#	$(shell truncate -s $(expr $(stat --format=%s $@) + 4) $@)

finxos.s28: $(OBJS)
# Ne marche pas avec la chaîne m68k-atari-mint car elle ne supporte pas le ELF
# Il faut utiliser la toolchain plus récente
	$(LD) $(LDFLAGS) -Wl,-T,finxos.ld -Wl,-Map,finxos.map -o finxos.elf $^
	$(OBJCOPY) -O srec finxos.elf $@

finxos-atari-rom.img: finxos.bin
# Attention, pour créer une image ROM valide, les émulateurs (STEEM, hatari..)
# attendent un en-tête avec la version du TOS etc. Ceci est commenté dans startup.S
	$(CP) $^ $@
#	$(LD) $(LDFLAGS) -Wl,-T,finxos-atari-rom.ld -Wl,-Map,finxos.map -o $@ $^
#       262144 (256Ko) c'est la taille de la ROM du STE. Pour STf c'est 192K.
	truncate -s 262144 $@

%.o:%.S
# This allows us to use //-style comments
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJS) finxos.s28 finxos.elf finxos.bin finxos.map finxos-atari-rom.img
