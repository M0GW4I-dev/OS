/*
 * IDTのゲートデスクリプタ
 */

typedef struct {
	unsigned short baseLo;
	unsigned short selector;
	unsigned char reserved;
	unsigned char flags;
	unsigned short baseHi;
} __attribute__ ((packed)) GATE_DESCRIPTOR;

/*
 * IDTR(IDTレジスタ)。LIDTで使用する。
 */

typedef struct {
	unsigned short size;
	GATE_DESCRIPTOR* base;
} __attribute__ ((packed)) IDTR;

/*
 * IDT ディスクリプタの数
 */


#define NUM_IDT 256


/*
 * ゲートディスクリプタのフラグ(32 bit OSの場合)
 *
 * flags
 * bit number	description
 * 0...4	interrupt gate		: 01110b = 32bit
 * 					: 00110b = 16bit
 * 		task gate		: must be 00101b
 * 		trap gate		: 01111b = 32 bit
 * 5...6	desctiptor priveledge	: ring0 = 00b
 * 		level			: ring1 = 01b
 * 					: ring2 = 10b
 * 					: ring3 = 11b
 * 7		present bit		: SEgment is present
 *
 */

#define DEF_IDT_FLAGS_TASKGATE_32BIT 0x05
#define DEF_IDT_FLAGS_INTGATE_16BIT 0x06
#define DEF_IDT_FLAGS_TRAPGATE_16BIT 0x07
#define DEF_IDT_FLAGS_INTGATE_32BIT 0x0E
#define DEF_IDT_FLAGS_TRAPGATE_32BIT 0x0F
#define DEF_IDT_FLAGS_DPL_LV0 0x00
#define DEF_IDT_FLAGS_DPL_LV1 0x20
#define DEF_IDT_FLAGS_DPL_LV2 0x40
#define DEF_IDT_FLAGS_DPL_LV3 0x60
#define DEF_IDT_FLAGS_DPL_PRESENT 0x80

#define DEF_IDT_INT_SELECTOR 0x08

/* 割り込みハンドラの設定関数 */

void setupInterruptGate(int int_num, void *interrupt_handler);

/* IDTディスクリプタを割り込み用として設定す関数 */

void setupGateDescriptor(int int_num, int base, unsigned short selector, unsigned char flags);


/* IDTのロード 関数として呼び出せない */

#define load_idt() ({ __asm__ __volatile__ ("lidt idtr"); })


