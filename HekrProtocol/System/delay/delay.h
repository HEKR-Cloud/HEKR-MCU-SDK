#ifndef  __DELAY_H
#define  __DELAY_H


void delay_init(unsigned char clk); //延时函数初始化
void delay_us(unsigned int nus);  //us级延时函数,最大65536us
void delay_ms(unsigned int nms);  //ms级延时函数

#endif
