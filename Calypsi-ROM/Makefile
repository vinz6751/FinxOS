# Makefile for raw image for Calypsi
AS=as68k
CC=cc68k
LD=ln68k
ASFLAGS=
CFLAGS=-l --speed -O2
LDFLAGS=--output-format raw --list-file $(addsuffix .map,$(basename $@))
LINKER_FILE=linker.scm
OBJS=main.o ikbd.o irq.o shifter.o memory.o mfp.o midi.o timer.o console.o

# OS-specific utilities
ifeq ($(OS),Windows_NT)
  CP=copy
  MV=ren
  RM=del /Q /F
else
  CP=cp
  MV=mv
  # GNU Make defines RM by default
endif

tos.img: $(OBJS)
	$(LD) $(LDFLAGS) -o $(addsuffix .elf,$(basename $@)) $(OBJS) $(LINKER_FILE)
	$(RM) $@
	$(CP) tos.raw tos.img
	fsutil file seteof $@ 262144


.PHONY: clean

clean:
	$(RM) *.o *.elf *.raw *.img *.map