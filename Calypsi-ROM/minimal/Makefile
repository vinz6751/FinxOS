PRG=hello.elf
SRCS = main.c
OBJS = $(SRCS:%.c=%.o)

LIBS=clib-68000-sc-sd.a

%.o: %.c
	cc68k -g -l --code-model=small $<

$(PRG): $(OBJS)
	ln68k -g linker.scm  $^ -o $@ $(LIBS) -l --cross-reference --rtattr exit=simplified

clean:
	-rm $(OBJS) $(PRG)
