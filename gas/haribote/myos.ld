ENTRY(init)

SECTIONS
{
	. = 0x7c00;
	.boot : { 
		ipl.o(.text);
		. = 0xc200;
		haribote.sys(.text);
	}
}
