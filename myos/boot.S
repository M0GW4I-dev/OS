/* #include "multiboot_def.h" */
.code32
.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1badb002
.set CHECKSUM, -(MAGIC + FLAGS)

.extern kernel_main

.section .multiboot
.align 4
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .bss
.align 16
stack_bottom:
    .skip 16384 # 16KiB
stack_top:

.section .text
.global _start
.type _start, @function

_start:
    /* Multiboot standard */
    mov $stack_top, %esp
    push %ebp # %ebp = multiboot_info pointer
    push %eax # %eax = magic number 0x2BADB002
    call kernel_main
    cli
_infinite_loop:
    hlt
    jmp _infinite_loop

/* デバッグ用 */
.size _start, . - _start
