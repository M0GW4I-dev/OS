/*
 * PICとポートアドレスの対応
 */

#ifndef __PIC_H__
#define __PIC_H__

#define PORT_MASTER_PIC_COMMAND 0x0020
#define PORT_MASTER_PIC_STATUS 0x0020
#define PORT_MASTER_PIC_DATA 0x0020
#define PORT_MASTER_PIC_IMR 0x0020
#define PORT_SLAVE_PIC_COMMAND 0x00A0
#define PORT_SLAVE_PIC_STATUS 0x00A0
#define PORT_SLAVE_PIC_DATA 0x00A1
#define PORT_SLAVE_PIC_IMR 0x00A1




#define PIC_IMR_MASK_IRQ0 0x01
#define PIC_IMR_MASK_IRQ1 0x02
#define PIC_IMR_MASK_IRQ2 0x04
#define PIC_IMR_MASK_IRQ3 0x08
#define PIC_IMR_MASK_IRQ4 0x10
#define PIC_IMR_MASK_IRQ5 0x20
#define PIC_IMR_MASK_IRQ6 0x40
#define PIC_IMR_MASK_IRQ7 0x80
#define PIC_IMR_MASK_ALL 0xFF

/* PIC(Programmable Interrupt Controller)の初期化関数 */
void initPic();
#endif
