#include "multiboot.h"
#include "multiboot_def.h"

void displaySample(char c, unsigned char foreColor, unsigned char backColor, int x, int y);

#define VRAM_TEXTMODE   0x000B8000
#define DEF_COLOR_BLACK 0x00
#define DEF_COLOR_WHITE 0x0F
#define MAX_Y   DEF_MBH_HEIGHT
#define MAX_X   DEF_MBH_WIDTH
#define MAX_XY  (MAX_X * MAX_Y)

static char message[] = "Hello world!";

void kernel_main(UINT32 magic, MULTIBOOT_INFO *info)
{
    int strlen;
    int i;

    strlen = sizeof(message);
    for(i=0; i < strlen; i++) {
        displaySample(message[i], DEF_COLOR_WHITE, DEF_COLOR_BLACK, i, 0);
    }
    for(;;);
}

void displaySample(char c, unsigned char foreColor, unsigned char backColor, int x, int y)
{
    unsigned short *vram_TextMode;
    unsigned short color;
    
    vram_TextMode = (unsigned short *)VRAM_TEXTMODE;
    color = (backColor<<4) | (foreColor & 0x0F);
    vram_TextMode += x+y*MAX_X;
    *vram_TextMode = (color << 8)|c;
}
