#ifndef MEMORY_I
#define MEMORY_I

# if defined(MEMORY_IMPL)
	.public memory_init
	.public memory_ram_size
	.public memory_reserve
# else
	.extern memory_init
	.extern memory_ram_size
	.extern memory_reserve
# endif

#endif
