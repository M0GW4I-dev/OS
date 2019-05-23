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
	mov buf, %ax
	call print_ax
	mov $buf, %ax
	call print_ax
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

/* func: decode

/* func: rest_floppy_drive */
reset_floppy_drive:
/* 成功するまでやる */
/*
	push %ax
	push %dx
	movw 0xFFFF, %ax
	movb	0x00, %ah
	movb	0x00, %dl
	int	$0x13
	jnc	_success_reset
	test $0b, %ax
	*/
	
_success_reset:
	pop	%dx
	pop	%ax

_reset_error:
	push %dx
	push %ax
	mov	$fail_msg, %si
	call	print 
	pop	%dx
	pop	%ax
	ret

failure:
	mov	$fail_msg, %si
	call	print 
	pop	%dx
	pop	%ax
	ret
/* end func */

/* func: read_sectors */
read_sectors:
	push	%ax
	push	%bx
	push	%cx
	push	%dx
	call	lba_to_chs
	mov	$0x02, %ah
	mov	$0x01, %al
	movb	(physicalTrack), %ch	
	movb	(physicalSector), %cl
	movb	(physicalHead), %dh
	movb	(BS_DrvNum), %dl
	mov	$0x1000, %dx
	mov %bx, %es
	int	$0x13
	jc	read_failed
	pop	%dx
	pop	%cx
	pop	%bx
	pop	%ax
	ret
read_failed:
	mov	$fail_msg, %si
	call	print
	pop	%dx
	pop	%cx
	pop	%bx
	pop	%ax
	ret
/* end func */

/* func lba_to_chs */
/*
input ax: sector number(LBA)
output ax: quotient, DX remainder
convert physical address to logical address
*/
lba_to_chs:
	xor	%dx, %dx
	divw	(BPB_SecPerTrk)
	inc %dl
	movb	%dl, (physicalSector)
	xor %dx, %dx
	divw (BPB_NumHeads)
	movb %dl, (physicalHead)
	mov %al, (physicalTrack)
	ret 
/* end func */

/* func: load_fat */
/* FATだけをBX_FAT_ADDR に読み込む */
load_fat:
	/* BX_FAT_ADDR はFATを読み込むアドレス */
	movw	(BX_FAT_ADDR), %bx
	addw	(BPB_RsvdSecCnt), %ax
	xchg	%cx, %ax
	/* FAT のサイズを計算する その際、複数ある場合は複数読み込む */
	movw	(BPB_FATSz16), %ax
	mulw	(BPB_NumFATs)
	xchg	%cx, %ax
	/* この時、axには、FAT12のブートセクタの終わりのアドレス, cxにはFATのサイズが入っている */
read_fat:
	call	read_sector2
	addw	(BPB_BytsPerSec), %bx
	inc		%ax
	dec		%cx
	jcxz	fat_loaded
	jmp		read_fat

fat_loaded:
	/* ロードし終わった */
	hlt
/* end func */


/* func: read_sector2 %bx, %ax
%bx: セクタの読み込むアドレス
%ax: 読み込みたいLBAのセクタ番号 */

read_sector2:
	movw	$0x0005, %di
sector_loop:
	push	%ax
	push	%bx
	push	%cx
	/* AXのLBAを物理番号に変換する */
	call	lba_to_chs
	/* ロードする割り込みの準備 */
	movb	$0x02,	%ah
	movb	$0x01,	%al
	movb	(physicalTrack), %ch
	movb	(physicalSector), %cl
	movb	(physicalHead), %dh
	movb	(BS_DrvNum), %dl
	int		$0x13
	/* 読み込み終了 */
	jnc		success
	/* ここからエラー */
	/* ドライブ初期化 */
	xor		%ax, %ax
	int		$0x13
	dec		%di
	pop		%cx
	pop		%bx
	pop		%ax
	jnz		sector_loop
	int		$0x18
success:
	pop		%cx
	pop		%bx
	pop		%ax
	ret
/* end func */


msg: .asciz "Hello world.\n\r"
fail_msg: .asciz "FAILED\n\r"
physicalHead:
	.byte 0x00
physicalSector:
	.byte 0x00
physicalTrack:
	.byte 0x00
BX_FAT_ADDR:
	.word 0x7e00


.fill 510-(.-init), 1, 0 # add zeroes to make it 510 bytes long
.word 0xaa55 # magic bytes that tell BIOS that this is bootable
