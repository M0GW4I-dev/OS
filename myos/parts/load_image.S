.code16
load_image:
    movw (cluster), %ax
    popw %bx
    call cluster_lba
    xorw %cx, %cx
    movb BPB_SecPerClus, %cl
    call read_sector
    addw $0x0200, %bx
    pushw %bx
/* 次のクラスタを調べる */
    movw (cluster), %ax
    movw %ax, %cx
    movw %ax, %dx
    shr $0x0001, %dx
    addw %dx, %cx
    movw BX_FAT_ADDR, %bx
    addw %cx, %bx
    movw (%bx), %dx
    test $0x0001, %ax
    jnz odd_cluster
even_cluster:
    andw $0x0FFF, %dx
    jmp local_done
odd_cluster:
    shr $0x0004, %dx
local_done:
    movw %dx, (cluster)
    cmpw $0x0FF0, %dx
    jb load_image
all_done:
    popw %bx
    pushw ES_IMAGE_ADDR
    pushw $0x0000
    retf
    hlt
