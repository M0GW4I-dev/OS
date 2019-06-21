.set CYLS, 0x0ff0 # シリンダーの数が記録されているアドレス
.set LEDS, 0x0ff1
.set VMODE, 0x0ff2 # カラー情報が入っているアドレス
.set SCRNX, 0x0ff4 # screen x
.set SCRNY, 0x0ff6 # screen y
.set VRAM, 0x0ff8 # グラフィックバッファの開始番地

.code16gcc
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
    mov %al, (LEDS)
fin:
    hlt
    jmp fin
