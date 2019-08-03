#include "int.h"
#include "port.h"

/* 割り込みハンドラの入り口で、まず最初に実行する */

void enter_interrupt()
{
	__asm__ __volatile__ ("pushal");
}

/* IRQ による割り込みの時のみ、EOIを書き込んで終了を伝える */

void interrupt_done()
{
	outPortByte(0x20, 0x20);
	outPortByte(0xA0, 0x20);
}

/* 割り込みハンドラの出口 */
void exit_interrupt()
{
	__asm__ __volatile__ ("popal");
	__asm__ __volatile__("iretl");
}

