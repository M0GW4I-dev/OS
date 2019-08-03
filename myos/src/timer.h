#ifndef __TIMER_H__
#define __TIMER_H__

void setPitCounter(int freq, unsigned char counter, unsigned char mode);
void initPit(void);
void timer_interrupt();

#endif
