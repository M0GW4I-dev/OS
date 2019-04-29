.code16 /* 16 bit用コード */
.global init

init:
    cli
    hlt
    jmp init

.fill 510 - (. - init), 1, 0
.word 0xaa55 /* magic number */
