#include "gdt.h"

/* GDT グローバル変数 */

SEGMENT_DESCRIPTOR gdt[NUM_GDT];

/* GDTR グローバル変数 */

GDTR gdtr;

void setupGdt()
{
	/* set up null descriptor */
	gdt[ NULL_DESCRIPTOR			].limitLo	= DEF_GDT_NULL_LIMIT;
	gdt[ NULL_DESCRIPTOR			].baseLo	= DEF_GDT_NULL_BASELO;
	gdt[ NULL_DESCRIPTOR			].baseMid	= DEF_GDT_NULL_BASEMID;
	gdt[ NULL_DESCRIPTOR			].flags		= DEF_GDT_NULL_FLAGS;
	gdt[ NULL_DESCRIPTOR			].baseHi	= DEF_GDT_NULL_BASEHI;
	/* set up code descriptor */
	gdt[ CODE_DESCRIPTOR			].limitLo	= DEF_GDT_CODE_LIMIT;
	gdt[ CODE_DESCRIPTOR			].baseLo	= DEF_GDT_CODE_BASELO;
	gdt[ CODE_DESCRIPTOR			].baseMid	= DEF_GDT_CODE_BASEMID;
	gdt[ CODE_DESCRIPTOR			].flags		= DEF_GDT_CODE_FLAGS;
	gdt[ CODE_DESCRIPTOR			].baseHi	= DEF_GDT_CODE_BASEHI;

	/* set up data descriptor */
	gdt[ DATA_DESCRIPTOR			].limitLo	= DEF_GDT_DATA_LIMIT;
	gdt[ DATA_DESCRIPTOR			].baseLo	= DEF_GDT_DATA_BASELO;
	gdt[ DATA_DESCRIPTOR			].baseMid	= DEF_GDT_DATA_BASEMID;
	gdt[ DATA_DESCRIPTOR			].flags		= DEF_GDT_DATA_FLAGS;
	gdt[ DATA_DESCRIPTOR			].baseHi	= DEF_GDT_DATA_BASEHI;

	/* gdtr の設定 */
	gdtr.size = NUM_GDT * sizeof(SEGMENT_DESCRIPTOR);
	gdtr.base = (SEGMENT_DESCRIPTOR *)gdt;
}

void load_gdt()
{
	__asm__ __volatile__ ("cli");
	__asm__ __volatile__ ("lgdt gdtr");
	__asm__ __volatile__ ("ljmpl $0x08, $_flush_seg");
	__asm__ __volatile__ ("_flush_seg:");
	__asm__ __volatile__ ("mov $0x10, %ax");
	__asm__ __volatile__ ("mov %ax, %ds"); // Data Segment
	__asm__ __volatile__ ("mov %ax, %es");
	__asm__ __volatile__ ("mov %ax, %fs");
	__asm__ __volatile__ ("mov %ax, %gs");
	__asm__ __volatile__ ("sti");

}

