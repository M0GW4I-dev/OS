.code16gcc
.text
.global kernel
kernel:
    mov $0x13, %al
    mov $0x00, %ah
    int $0x10
fin:
    hlt
    jmp fin


.fill 10000000, 1, 0
