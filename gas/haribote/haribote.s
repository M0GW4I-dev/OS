.equ CYLS, 0x0ff0 # シリンダーの数が記録されているアドレス
.equ LEDS, 0x0ff1
.equ VMODE, 0x0ff2 # カラー情報が入っているアドレス
.equ SCRNX, 0x0ff4 # screen x
.equ SCRNY, 0x0ff6 # screen y
.equ VRAM, 0x0ff8 # グラフィックバッファの開始番地

.equ BOTPAK, 0x00280000 # bootpack をロードするアドレス
.equ DSKCAC, 0x00100000 # ディスクキャッシュ の場所
.equ DSKCAC0, 0x00008000 # ディスクキャッシュの場所 (リアルモード)

.code16
.text

entry:
    mov $0x13, %al # w320*h200*color8bit
    mov $0x00, %ah
    int $0x10
    movw $8, (VMODE)
    movw $320, (SCRNX)
    movw $200, (SCRNY)
    movl $0x000a0000, (VRAM)

    movb $0x02, %ah
    int $0x16
    movb %al, (LEDS)

    # pic の割り込み禁止
    movb $0xff, %al
    outb %al, $0x21
    nop
    outb %al, $0xa1

    # クリアインタラプト
    cli

    /* CPU から 1 MB 以上のメモリにアクセスできるように、A20GATE を設定 */
    call waitkbdout
    movb $0xd1, %al
    out %al, $0x64
    call waitkbdout
    movb $0xdf, %al # A20 を有効にする
    out %al, $0x60
    call waitkbdout

/* プロテクトモードへの移行 */
.arch i486
    lgdtl (GDTR0)
    movl %cr0, %eax
    andl $0x7fffffff, %eax
    orl $0x00000001, %eax
    movl %eax, %cr0
    jmp pipelineflush
pipelineflush:
    movw $1*8, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

.equ VAL1, 512*1024/4

    movl $bootpack, %esi
    movl $BOTPAK, %edi
    movl $VAL1, %ecx
    call memcpy

    movl $0x7c00, %esi
    movl $DSKCAC, %edi

.equ VAL2, 512/4

    movl $VAL3, %ecx
    call memcpy

    movl $DSKCAC0+512, %esi
    movl $DSKCAC+512, %edi
    movl $0, %ecx
    movb (CYLS), %cl

.equ VAL3, 512*18*2/4

    imull $VAL3, %ecx

.equ VAL4, 512/4

    subl $VAL4, %ecx
    call memcpy

    /* bootpack の起動 */
    movl $BOTPAK, %ebx
    movl 16(%ebx), %ecx
    addl $3, %ecx
    shrl $2, %ecx
    jz skip
    movl 20(%ebx), %esi
    addl %ebx, %esi
    movl 12(%ebx), %edi
    call memcpy

skip:
    movl 12(%ebx), %esp

.equ VAL5, 2*8
.equ VAL6, 0x0000001b
    ljmpl $VAL5, $VAL6

waitkbdout:
    inb $0x64, %al
    andb $0x02, %al
    jnz waitkbdout
    ret

memcpy:
    movl (%esi), %eax
    addl $4, %esi
    movl %eax, (%edi)
    addl $4, %edi
    subl $1, %ecx
    jnz memcpy
    ret

.align 16

GDT0:
    .space 8, 0x00
    .word 0xffff, 0x0000, 0x9200, 0x00cf
    .word 0xffff, 0x0000, 0x9a28, 0x0047
    .word 0

GDTR0:
    .word 8*3-1
    .long GDT0

.align 16

bootpack:
