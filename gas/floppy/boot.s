.code16
.global init

/* For FAT12 */
init:
jmp start	
BS_jmpBoot2:    .byte	0x90
BS_OEMName:	    .ascii  "MyOS    "
BPB_BytsPerSec: .word	0x0200		
BPB_SecPerClus:	.byte	0x01		
BPB_RsvdSecCnt:	.word	0x0001		
BPB_NumFATs:	.byte	0x02		
BPB_RootEntCnt:	.word	0x00E0
BPB_TotSec16:	.word	0x0B40
BPB_Media:	    .byte	0xF0
BPB_FATSz16:	.word	0x0009
BPB_SecPerTrk:	.word	0x0012
BPB_NumHeads:	.word	0x0002
BPB_HiddSec:	.int	0x00000000
BPB_TotSec32:	.int	0x00000000

BS_DrvNum:	    .byte	0x00
BS_Reserved1:	.byte	0x00
BS_BootSig:	    .byte	0x29
BS_VolID:	    .int	0x20190502
BS_VolLab:	    .ascii	"MyOS       "
BS_FilSysType:	.ascii	"FAT12   "

/* Initialize segment register */
initial_register:
	cli
	xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	xor %bx, %bx
	xor %cx, %cx
	xor %dx, %dx
	mov %ax, %ss
	mov $0xfffc, %sp
	jmp start

start:
	movw $0x0202, %ax
	movw $0x0201, %cx
	movw $0x0000, %dx
	# es:bx = 0000 なので このまま
	int $0x13
	clc # Clear Carry flag
	movb $0x00, %ah # 初期化モード
	movb %ah, %dl # リセットするドライブ番号
	int $0x13
	jc failure
	hlt
failure:
	pushf
	pop %ax
	call print_ax
	hlt

_hlt:
	hlt
	jmp _hlt

buf:
	.ascii "01234"

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

/* function print: print string, set ptr of stringz to %si */
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


msg: .asciz "Hello world.\n\r"
fail_msg: .asciz "FAILED\n\r"


.fill 510-(.-init), 1, 0 # add zeroes to make it 510 bytes long
.word 0xaa55 # magic bytes that tell BIOS that this is bootable
