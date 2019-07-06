.code32

.global io_hlt, io_cli
.global io_in8, io_in16, io_in32
.global io_out8, io_out16, io_out32
.global io_load_eflags, io_store_eflags

.text

io_hlt:
    hlt
    ret

io_cli:
    cli
    ret

io_sti:
    sti
    ret

io_stihlt:
    sti
    hlt
    ret

io_in8:
    mov 4(%esp), %edx
    mov $0, %eax
    in %dx, %al
    ret

/*
srcで指定されたI/Oポートから読み取った値をdistにコピーする
*/

io_in16:
    mov 4(%esp), %edx
    mov $0, %eax
    in %dx, %ax
    ret

io_in32:
    mov 4(%esp), %edx
    in %dx, %eax
    ret

/*
Intel syntax:
out imm8 al
al のバイト値をポートアドレスimm8に出力
*/

io_out8:
    movl 4(%esp), %edx
    movl 8(%esp), %eax
    outb %al, %dx
    ret

io_out16:
    movl 4(%esp), %edx
    movl 8(%esp), %eax
    outw %ax, %dx
    ret

io_out32:
    movl 4(%esp), %edx
    movl 8(%esp), %eax
    outl %eax, %dx
    ret

io_load_eflags:
    /* eflags レジスタ を一回積んで %eax に復元する */
    pushfl
    pop %eax
    ret

io_store_eflags:
    /* 引数を積んで戻す */
    mov 4(%esp), %eax
    push %eax
    popfl
    ret
