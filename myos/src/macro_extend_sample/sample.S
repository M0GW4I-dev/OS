.code32
#include "sample.h"

FUNCTION(abc)
	push %eax

1:
	.macro sample
	push %eax
	push %ebx
	.endm

	sample

	jmp 1b

	jmp 1f

1:
	nop
	
