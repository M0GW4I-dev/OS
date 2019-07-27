/*
 * GDTのセグメントディスクリプター(8バイト)
 */

typedef struct {
	unsigned short limitLo;
	unsigned short baseLo;
	unsigned char baseMid;
	unsigned short flags;
	unsigned char baseHi;
} __attribute__ ((packed)) SEGMENT_DESCRIPTOR;

/* セグメントディスクリプタの数 */

#define NUM_GDT 3

/*
 * セグメントディスクリプタのフラグ
 * 
 * flags
 * bit number
 * 0...15	segment limit low
 * 16...31	base address low
 * 32...39	base address mid
 * 40		access bit		: unaccessed = 0b
 * 					: accessed = 1b
 * 41		read/write bit		: read only = 0b
 * 					: read/write = 1b
 * 42		expansion direction	: up direction = 0b
 * 					: down direction = 1b
 * 43		segment type		: data segment = 0b
 * 					: code segment = 1b
 * 44		descriptor flags	: for system = 0b
 * 					: for code, data = 1b
 * 45...46	descriptor priveledge	: ring0 = 00b
 * 		level			: ring1 = 01b
 * 					: ring2 = 10b
 * 					: ring3 = 11b
 * 47		present bit		: segment is present
 * 48...51	segment limit hi
 * 52		AVL			: free to use by system program
 * 53		reserved
 * 54		d/b			: for 16bit = 0b
 * 					: for 32bit = 1b
 * 55		G			: unit of segment is byte  = 0b
 * 					: unit of segment is 4K = 1b
 * 56...63	base address hi	
 */

/* セグメントの便宜的な番号 */

#define NULL_DESCRIPTOR 0
#define CODE_DESCRIPTOR 1
#define DATA_DESCRIPTOR 2
#define TEMP_DESCRIPTOR 3
#define TASK_CODE_DESCRIPTOR 4
#define TASK_DATA_DESCRIPTOR 5
#define KTSS_DESCRIPTOR 6

/* NULL Descriptorの設定 */

#define DEF_GDT_NULL_LIMIT 0x0000
#define DEF_GDT_NULL_BASELO 0x0000
#define DEF_GDT_NULL_BASEMID 0x00
#define DEF_GDT_NULL_BASEHI 0x00
#define DEF_GDT_NULL_FLAGS 0x0000

/* Code Descriptorの設定 */

#define DEF_GDT_CODE_LIMIT 0xFFFF
#define DEF_GDT_CODE_BASELO 0x0000
#define DEF_GDT_CODE_BASEMID 0x00
#define DEF_GDT_CODE_BASEHI 0x00
#define DEF_GDT_CODE_FLAGS 0xCF9A

/* Data Descriptorの設定 */
#define	DEF_GDT_DATA_LIMIT 0xFFFF
#define	DEF_GDT_DATA_BASELO 0x0000
#define	DEF_GDT_DATA_BASEMID 0x00
#define	DEF_GDT_DATA_BASEHI 0x00
#define	DEF_GDT_DATA_FLAGS 0xCF92

/* GDTR(GDTレジスター) */

typedef struct
{
	unsigned short size;
	SEGMENT_DESCRIPTOR *base;
} __attribute__ ((packed)) GDTR;


/*
 * gdtr.size = NUM_GDT * sizeof(SEMENT_DESCRIPTOR);
 * gdtr.base = (SEGMENT_DESCRIPTOR *)gdt;
 * load_gt();
 */

/* GDTのセットアップ 読み込みはせず、それぞれのフラグや、リミットのみ設定する関数 */

void setupGdt(void);
void load_gdt(void);
