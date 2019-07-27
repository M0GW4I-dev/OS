#include "idt.h"

/* IDTR グローバル変数 */

IDTR idtr;

/* IDT グローバル変数 */

GATE_DESCRIPTOR idt[NUM_IDT];

/*
 * 割り込みIDTディスクリプタの設定関数
 * int_num: idtの番号 interrupt_handler: ハンドラのアドレス
 */

void setupInterruptGate(int int_num, void *interrupt_handler)
{
	setupGateDescriptor(int_num, (int)interrupt_handler, DEF_IDT_INT_SELECTOR, DEF_IDT_FLAGS_DPL_PRESENT | DEF_IDT_FLAGS_INTGATE_32BIT);
}

void setupGateDescriptor(int int_num, int base, unsigned short selector, unsigned char flags)
{
	idt[int_num].baseLo = (unsigned short)(base & 0x0000FFFF);
	idt[int_num].selector = selector;
	idt[int_num].reserved = 0x00;
	idt[int_num].flags = flags;
	idt[int_num].baseHi = (unsigned short)((base & 0xFFFF0000) >> 16);
}

/*
 * idtr.size = NUM_IDT * sizeof(GATE_DESCTIPTOR);
 * idtr.base = (GATE_DESCRIPTOR *)idt;
 */


