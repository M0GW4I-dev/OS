.code32

.global write_mem8, io_hlt

.text

io_hlt:
    hlt
    jmp io_hlt

write_mem8: # void write(int *addr, int data)
    movl 4(%esp), %ecx
    movb 8(%esp), %al
    movb %al, (%ecx)
    ret
