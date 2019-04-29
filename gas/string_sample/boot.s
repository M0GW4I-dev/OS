.code16 /* 16 bit用コード */
.global init

init:
    mov $msg, %si
    mov $0xe, %ah
print_char:
    lodsb
    cmp $0, %al
    je done
    int $0x10
    jmp print_char
done:
    hlt

msg: .asciz "Hello world!"

.fill 510 - (. - init), 1, 0
.word 0xaa55 /* magic number */
