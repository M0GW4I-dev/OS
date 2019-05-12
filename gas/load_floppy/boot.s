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
	/* フロッピードライブの初期化 */
	call	reset_floppy_drive 
	mov $2000, %ax
	call	read_sectors
	/* $ をつけないとそのファイル内での位置が入れられてしまうので注意する */
	mov $msg, %si
	call print
_hlt:
	hlt
	jmp	_hlt


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

/* func: rest_floppy_drive */
reset_floppy_drive:
	push	%ax
	push	%dx
	mov	0x00, %ah
	mov	0x00, %dl
	int	$0x13
	jc	failure
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


msg: .asciz "Hello world.\n\r"
fail_msg: .asciz "FAILED\n\r"
physicalHead:
	.byte 0x00
physicalSector:
	.byte 0x00
physicalTrack:
	.byte 0x00

.fill 510-(.-init), 1, 0 # add zeroes to make it 510 bytes long
.word 0xaa55 # magic bytes that tell BIOS that this is bootable
