#ifndef __MULTIBOOT_DEF_H__
/*****************************
Multiboot Header Defines
******************************/

/*****************************
    Magic of Multiboot Header
******************************/
/* Magic number */
#define DEF_MBH_MAGIC 0x1BADB002

/*****************************
    Flags of Multiboot Header
******************************/
/* OSと一緒にロードするモジュールをページ境界に配置するか */
#define DEF_MBH_FLAGS_PAGE_ALIGN    0x00000001
/* ブート情報をOSの引数のブート情報構造体にブート情報をセットして渡すか */
#define DEF_MBH_FLAGS_MEMORY_INFO   0x00000002
/* OSの引数として渡されたブート情報構造体のビデオモードテーブルを使用するか */
#define DEF_MBH_FLAGS_VIDEO_MODE    0x00000004
/* マルチブートヘッダーのオフセット12~28を有効にするか */
#define DEF_MBH_FLAGS_AOUT_KLUDGE   0x00010000

/* elfカーネル用のフラグ */
#define DEF_MBH_FLAGS   (DEF_MBH_FLAGS_PAGE_ALIGN | DEF_MBH_FLAGS_MEMORY_INFO)
/* binaryカーネル用のフラグ */
#define DEF_MBH_FLAGS_BIN   (DEF_MBH_FLAGS_PAGE_ALIGN | DEF_MBH_FLAGS_MEMORY_INFO | DEF_MBH_FLAGS_AOUT_KLUDGE)

/*****************************
    Address Which Kernel Is Loaded To
******************************/
#define DEF_MM_KERNEL_PHY_BASEADDR  0x00100000

/*****************************
    Checksum
******************************/
#define DEF_MBH_CHECKSUM (-(DEF_MBH_MAGIC + DEF_MBH_FLAGS))
#define DEF_MBH_CHECKSUM_BIN (-(DEF_MBH_MAGIC + DEF_MBH_FLAGS_BIN))

/*****************************
    Header Addr
******************************/
/* このフィールドはバイナリカーネルフィールドの起動時のみ使用する */
/* マルチブートヘッダーが置かれるアドレス */
#define DEF_MBH_HEADER_ADDR DEF_MM_KERNEL_PHY_BASEADDR


/*****************************
    Graphic Field
******************************/
#define DEF_MBH_MODE_TYPE   0x00000001
#define DEF_MBH_WIDTH       0x00000050 /* width = 80 */
#define DEF_MBH_HEIGHT      0x00000028 /* width = 40 */
#define DEF_MBH_DEPTH       0x00000000


/*****************************
Magic For Kernel
******************************/
/* 処理がカーネルに移行したときに、%eaxに格納されるマジックナンバーの定義*/
/* この値を確認することで、マルチブート仕様のブートローダーから起動されたことを確認することだできる */
#define DEF_MBH_BL_MAGIC    0x2BADB002

#endif  /* __MULTIBOOT_DEF_H__ */