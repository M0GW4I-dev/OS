#include "port.h"

void outPortByte(unsigned short address, unsigned char value)
{
	/* __asm__ ("アセンブラ" : 出力オペランド : 入力オペランド: ワークレジスタ)
	 * 簡潔に言うと
	 * __asm__ __volatile__ ("アセンブラ" : 実行後に行う処理 : 実行前に行う処理 : 退避するレジスタ
	 * 出力オペランド, 入力オペランドの記法
	 * "a" : eax レジスタ
	 * "b" : ebx レジスタ
	 * "c" : ecx レジスタ
	 * "d" : edx レジスタ
	 * "s" : esi レジスタ
	 * "D" : EDI レジスタ
	 * "q" : 汎用レジスタから空いているレジスタ
	 * "r" : 汎用レジスタ + 上記のレジスタを自動で割り当て
	 * "g" : 汎用レジスタかメモリを自動で割り当て
	 * "m" : メモリの割り当て
	 * "0", "1", ...
	 */
	__asm__ __volatile__("out %%al, %%dx" : : "d"(address), "a"(value));
}

unsigned char inPortByte(unsigned short address)
{
	unsigned char data;
	__asm__ __volatile__("in %%dx, %%al":"=a"(data):"d"(address));
	return data;
}

