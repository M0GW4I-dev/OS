OUTPUT_FORMAT("binary")

SECTIONS
{
	. = 0xc200;
	.boot : { 
		haribote.o(.text);
	}
}