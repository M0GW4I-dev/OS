
movl %cr0, %eax
orl $0x00000001, %eax
movl %eax, %cr0

.code32
Pmode_start:
    movw $DATA_DESC, %ax
    # 全部データセグメントを指すようにする
    mov %ax, %ss
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ds

    movl $90000, %esp
