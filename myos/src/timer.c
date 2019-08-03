/* PIT(Programmable Interval Timer)
 *
 * 8253のハードウェア仕様
 * 3 つの独立したカウンタ
 * カウンタ, CLK, OUT, GATEピンがある
 * PICのIR0にタイマーのINTが接続されている
 * チャンネル 2 はスピーカに使われている チャンネル 0 はPC用
 * 
 * ## モード 0
 * 設定したカウント値から入力クロック毎にカウンタを減らしていく。カウンタが 0 になると、OUTピンが High になる
 * カウンタが 0 になった後は、モードを変更する制御コマンドを書き込むまでOUTピンはHighになったままになる
 * カウンタがカウントダウン中に High から Low するとカウントダウンが止まる
 *
 * ## モード 1 (ワンショットパルス波形生成モード)
 * モード 1 になる制御コマンドを書き込んだ直後に、OUTピンは High になり、カウンタのカウンタ値を設定した後、GATEピンの入力が Low から High になるライジングエッジを検出するとカウントダウンが始まる。
 * カウントが始まると、OUTピンが Low になり、カウンタが 0 になると、High になる
 * ## モード 2 (パルス生成モード)
 * このモードに設定した後は、OUT が High になり、カウンタに設定したカウント値が、1 になると OUT ピンが 1 クロックだけ Low になって、割り込みが発生する。
 *
 * ポートアドレス
 * 0x40 ... counter0 に値を設定するレジスタ
 * 0x41 ... counter1
 * 0x42 ... counter2
 * 0x43 ... Control word (読み込み不可の制御コマンド書き込み用レジスタ)
 */

#include "port.h"
#include "timer.h"
#include "int.h"

/* ポートアドレス */

#define PIT_REG_COUNTER0 0x0040
#define PIT_REG_COUNTER1 0x0041
#define PIT_REG_COUNTER2 0x0042
#define PIT_REG_CONTROL 0x0043

/* Input CLK0 */
#define DEF_PIT_CLOCK 1193181.67

#define	DEF_PIT_COM_MASK_BINCOUNT	0x01
#define	DEF_PIT_COM_MASK_MODE		0x0E
#define	DEF_PIT_COM_MASK_RL		0x30
#define	DEF_PIT_COM_MASK_COUNTER	0xC0

/* binary count */
#define	DEF_PIT_COM_BINCOUNT_BIN	0x00
#define	DEF_PIT_COM_BINCOUNT_BCD	0x01

/* counter mode */
#define	DEF_PIT_COM_MODE_TERMINAL	0x00
#define	DEF_PIT_COM_MODE_PROGONE	0x02
#define	DEF_PIT_COM_MODE_RATEGEN	0x04
#define	DEF_PIT_COM_MODE_SQUAREWAVE	0x06
#define	DEF_PIT_COM_MODE_SOFTTRIG	0x08
#define	DEF_PIT_COM_MODE_HARDTRIG	0x0A

/* data transfer */
#define	DEF_PIT_COM_RL_LATCH		0x00
#define	DEF_PIT_COM_RL_LSBONLY		0x10
#define	DEF_PIT_COM_RL_MSBONLY		0x20
#define	DEF_PIT_COM_RL_DATA		0x30

/* counter	 */
#define DEF_PIT_COM_COUNTER0		0x00
#define	DEF_PIT_COM_COUNTER1		0x40
#define	DEF_PIT_COM_COUNTER2		0x80


#define	DEF_PIT_COM_MASK_BINCOUNT	0x01
#define	DEF_PIT_COM_MASK_MODE		0x0E
#define	DEF_PIT_COM_MASK_RL		0x30
#define	DEF_PIT_COM_MASK_COUNTER	0xC0

/* binary count */
#define	DEF_PIT_COM_BINCOUNT_BIN	0x00
#define	DEF_PIT_COM_BINCOUNT_BCD	0x01

/* counter mode */
#define	DEF_PIT_COM_MODE_TERMINAL	0x00
#define	DEF_PIT_COM_MODE_PROGONE	0x02
#define	DEF_PIT_COM_MODE_RATEGEN	0x04
#define	DEF_PIT_COM_MODE_SQUAREWAVE	0x06
#define	DEF_PIT_COM_MODE_SOFTTRIG	0x08
#define	DEF_PIT_COM_MODE_HARDTRIG	0x0A

/* data transfer */
#define	DEF_PIT_COM_RL_LATCH		0x00
#define	DEF_PIT_COM_RL_LSBONLY		0x10
#define	DEF_PIT_COM_RL_MSBONLY		0x20
#define	DEF_PIT_COM_RL_DATA		0x30

/* counter	 */
#define DEF_PIT_COM_COUNTER0		0x00
#define	DEF_PIT_COM_COUNTER1		0x40
#define	DEF_PIT_COM_COUNTER2		0x80

/*
 * PITを制御する関数 setPicCounter(1000, 0, 002)で 1 mHzごとに割り込みが入るようになる
 */

void setPitCounter(int freq, unsigned char counter, unsigned char mode)
{
	unsigned short count;
	unsigned char command;

	/* 分周パルスの周波数 = CLKの入力クロック周波数/カウンタの値 */
	/* よって、カウンタの値は カウンタの値 = CLKの入力周波数/分周パルスの周波数となる */
	count = (unsigned short)(DEF_PIT_CLOCK/freq);

	command = mode | DEF_PIT_COM_RL_DATA | counter;
	outPortByte(PIT_REG_CONTROL, command);
	outPortByte(PIT_REG_COUNTER0, (unsigned char)(count & 0xFF));
	outPortByte(PIT_REG_COUNTER0, (unsigned char)(count >> 8) & 0xFF);
}

void initPit(void)
{
	setPitCounter(1, DEF_PIT_COM_COUNTER0, DEF_PIT_COM_MODE_PROGONE);
}

static volatile int timer_tick;

void timer_interrupt()
{
	enter_interrupt();
	timer_tick++;
	if(timer_tick >= 100) {
		timer_tick = 0;
		/* ここで何かやる */
	}
	interrupt_done();
	exit_interrupt();
}
