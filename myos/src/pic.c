#include "pic.h"
#include "port.h"

/*
 * PIC(programmable Interrupt Controller) の初期化
 */

void initPic()
{
	__asm__ __volatile__("cli");
	outPortByte(0x20, 0x11); /* ICW1 for master PIC */
	outPortByte(0xA0, 0x11); /* ICW1 for slave PIC */
	outPortByte(0x21, 0x20); /* ICW2 for master PIC */
	outPortByte(0xA1, 0x28); /* ICW2 for slave PIC */
	outPortByte(0x21, 0x04); /* ICW3 for master PIC */
	outPortByte(0xA1, 0x02); /* ICW3 for slave PIC */
	outPortByte(0x21, 0x01); /* ICW4 for master PIC */
	outPortByte(0xA1, 0x01); /* ICW4 for slave PIC */

	/* 1 はIRQが有効 */
	/* IRQ0 と IRQ2 は無効にする */
	outPortByte(PORT_MASTER_PIC_IMR, (~PIC_IMR_MASK_IRQ0) & (~PIC_IMR_MASK_IRQ2));
	/* スレーブは全部有効 */
	outPortByte(PORT_SLAVE_PIC_IMR, PIC_IMR_MASK_ALL);
	__asm__ __volatile__("sti");
}

