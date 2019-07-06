.code16

print:
    push %ax
    push %bx
start_print:
    lodsb
    or %al, %al
    jz print_done
    mov $0x0e, %ah
    mov $0x00, %bh
    mov $0x07, %bl
    int $0x10
    jmp start_print
print_done:
    pop %bx
    pop %ax
    ret
