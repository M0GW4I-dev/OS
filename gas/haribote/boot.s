.code16gcc
.global init
/* start from address 0x7c00 */
/* init ラベルがないと詰む */
.text
init:
jmp entry
.byte 0x90
.ascii "HELLOIPL"
.word 512
.byte 1
.word 1
.byte 2
.word 224
.word 2880 //ドライブの大きさ
.byte 0xf0
.word 9
.word 18
.word 2
.int 0
.int 2880
.byte 0
.byte 0
.byte 0x29
.int 0xffffffff
.ascii "HELLO-OS   "
.ascii "FAT12   "

.skip 18

entry:
    mov $0x0000, %ax
    mov %ax, %ss
    mov $0x7c00, %sp
    mov %ax, %ds
    mov %ax, %es
    sti
    movb %dl, (boot_dev)
    mov $msg, %si

putloop:
    movb (%si), %al
    addw $0x0001, %si
    cmpb $0x00, %al
    je load_sector
    movb $0x0e, %ah
    movw $0x000f, %bx
    int $0x10
    jmp putloop

load_sector:
    clc # フラグクリアしておく
    movw $0x0820, %ax
    mov %ax, %es
    movb $0x00, %ch # シリンダ$0x00
    movb $0x00, %dh # ヘッド $0x00
    movb $0x02, %cl # セクタ $0x02
    movw $0x0000, %si # 失敗回数記録用
retry:
    movb $0x02, %ah # ハンドラ番号 $0x02はディスク読み込み
    movb $0x01, %al # 1 セクタ
    movw $0x0000, %bx
    movb (boot_dev), %dl # A ドライブ
    int $0x13
    jnc fin
    addw $0x0001, %si
    cmp $0x0005, %si
    jae error
    movb $0x00, %ah
    movb $0x00, %dl
    int $0x13
    jmp retry

fin:
    hlt
    jmp fin

/* function print: print string, set ptr of stringz to %si */
error:
    movw $error_msg, %si
    call print
    jmp fin

/* print_ax: %ax(16 bit) の内容を出力する */
/* dependency label: decode_4bit, _print_ax_buf */
/* 更新日 2019/05/23 */

print_ax:
	push %ax
	push %si
	mov $_print_ax_buf, %si
	add $0x0a, %si
	call decode_4bit
	shr $0x04, %ax
	dec %si
	call decode_4bit
	shr $0x04, %ax
	dec %si
	call decode_4bit
	shr $0x04, %ax
	dec %si
	call decode_4bit
	mov $_print_ax_buf, %si
	call print
	pop %si
	pop %ax
	ret

_print_ax_buf:
	.asciz "%ax=$0x0000\n\r"

/* function end */

/* function decode: %axの下位 4 桁をデコードして、%siのアドレスにぶち込む */
decode_4bit:
	push %si
	push %ax
	and $0x000F, %ax
	cmp $0x000a, %ax
	jge _decode_4bit
_decode_4bit_ret: # 戻って来る用のラベル
	add $0x0030, %ax
	movb %al, (%si)
	pop %ax
	pop %si
	ret

_decode_4bit: # ax が 0x000a 以上 だった
	add $0x0007, %ax
	jmp _decode_4bit_ret
/* end function */

print:
	push %ax
	push %bx
 	mov $0x0e, %ah
 	mov $0x00, %bh
 	mov $0x0f, %bl
print_char:
 	lodsb
 	cmp $0, %al
 	je done
 	int $0x10
 	jmp print_char
done:
	pop %bx
	pop %ax
	ret
/* end func */

error_msg:
    .asciz "ERROR\n\r"
boot_dev:
    .byte 0x00
msg:
    .asciz "\n\r\n\rhello, world\n\r"

    .fill 510 - (. - init), 1, 0

.word 0xAA55
