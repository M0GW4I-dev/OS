.code16
.text
.arch i486
# setup gdt
_setup_gdt:
    cli
    pusha # ax, cs, dx, bx, sp, bp, si, di のpush
    ldgt (gdt_toc)
    sti
    popa
    ret

_gdt:
    # Null gdt desctiptor(8バイト)
    .word 0x0000
    .word 0x0000
    .word 0x0000
    .word 0x0000
    # Code descriptor
    .word 0xffff # Segment Limit Low
    .word 0x0000 # Segment Base Address
    .byte 0x00 # Base Address Mid
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x00
    # Data descriptor
    .byte 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x00


gdt_toc:
    .word 8*3 # GDTのサイズ
    .int _gdt # GDTのアドレス