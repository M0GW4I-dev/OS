.code16
.global init
/* start from address 0x7c00 */

/* init ラベルがないと詰む */
init:
jmp entry
.byte 0x90
.ascii "HELLOIPL"
.word 512
.byte 1
.word 1
.byte 2
.word 224
.word 2880 //ドライブの大きさ
.byte 0xf0
.word 9
.word 18
.word 2
.int 0
.int 2880
.byte 0
.byte 0
.byte 0x29
.int 0xffffffff
.ascii "HELLO-OS   "
.ascii "FAT12   "

.skip 18

entry:
    mov $0x0000, %ax
    mov %ax, %ss
    mov $0x7c00, %sp
    mov %ax, %ds
    mov %ax, %es
    mov $msg, %si

putloop:
    movb (%si), %al
    addw $0x0001, %si
    cmpb $0x00, %al
    je fin
    movb $0x0e, %ah
    movw $0x000f, %bx
    int $0x10
    jmp putloop

fin:
    hlt
    jmp fin

msg:
    .asciz "\n\r\n\rhello, world\n\r"
    .fill 510 - (. - init), 1, 0

.word 0xAA55

