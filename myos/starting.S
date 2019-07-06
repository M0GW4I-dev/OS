.code16
#include "print.h"
/* org 0x500 */

jmp main2

main2:
/* 汎用レジスタの初期化 */
    xor %ax, %ax
    xor %bx, %bx
    xor %cx, %cx
    xor %dx, %dx
/* セグメントの初期化 */
    mov %ax, %ds
    mov %ax, %es
    call print
    hlt
