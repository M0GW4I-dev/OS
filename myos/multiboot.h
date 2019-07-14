#ifndef __MULTIBOOT_HEADER_H__
#define __MULTIBOOT_HEADER_H__

typedef unsigned int UINT32;
typedef unsigned short UINT16;

typedef struct {
    UINT32 magic;
    UINT32 flags;
    UINT32 checksum;
    /* 1: ここからはMULTIBOOT_AOUT_KCLUDGE が立っている場合のみ使用可能 */
    UINT32 header_addr;
    UINT32 load_addr;
    UINT32 load_end_addr;
    UINT32 bss_end_addr;
    UINT32 entry_addr;
    /* 1: ここまで */
    /* 2: ここからはMULTIBOOT_VIDEO_MODE がセットされている場合のみ有効 */
    UINT32 mode_type;
    UINT32 width;
    UINT32 height;
    UINT32 depth;
    /* 2: ここまで */
}MULTIBOOT_HEADER;

typedef struct
{
    UINT32  flags;          
    /* available memory from BIOS       */
    UINT32  mem_lower;
    UINT32  mem_upper;
    UINT32  boot_device;    /* "root" partition                  */
    UINT32  cmdline;        /* kernel command line               */
    /* Boot-Module list                 */
    UINT32  mods_count;
    UINT32  mods_addr;

    UINT32  syms1;
    UINT32  syms2;
    UINT32  syms3;

    /* memory mapping buffer            */
    UINT32  mmap_length;
    UINT32  mmap_addr;
    /* drive info buffer                */
    UINT32  drives_length;
    UINT32  drives_addr;
    /* ROM configuration table          */
    UINT32  config_table;
    /* bootloader name                  */
    UINT32  boot_loader_name;
    /* Video                            */
    UINT32  vbe_control_info;
    UINT16  vbe_mode_info;
    UINT16  vbe_mode;
    UINT16  vbe_interface_seg;
    UINT16  vbe_interface_off;
    UINT16	vbe_interface_len;
}MULTIBOOT_INFO;

#endif  /* __MULTIBOOT_HEADER_H__ */
