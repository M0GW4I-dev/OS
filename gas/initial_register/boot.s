.code16
.global init

/* For FAT12 */
init:
                jmp	BOOT		
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

/* BOOT */

BOOT:
	cli
	xor		%ax,	%ax
	mov		%ax,	%ds
	mov 	%ax,	%es
	mov		%ax,	%fs
	mov		%ax,	%gs
	xor		%bx,	%bx
	xor		%cx,	%cx
	xor		%dx,	%dx
/* initialization for stack */
	mov		%ax,	%ss
	mov		$0xfffc,	%sp
	hlt
	
.fill   510 - (. - init), 1, 0

.word 0xAA55
