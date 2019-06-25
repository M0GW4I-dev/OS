OUTPUT_FORMAT("binary")

ENTRY("Main")

SECTIONS {
    . = 0x280000;
    .text : {
        bootpack.o(.text)
        func.o(.text)
    }
}
