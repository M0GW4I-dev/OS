
#ifndef __PORT_H__
#define __PORT_H__

/* address で指定されたポートアドレスに value を書き込む関数 */
void outPortByte(unsigned short address, unsigned char value);

/* address で指定されたポートアドレスから読み込む関数 */
unsigned char inPortByte(unsigned short address);
#endif
