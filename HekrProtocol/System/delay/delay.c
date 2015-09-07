#include "delay.h"
volatile unsigned char  fac_us=0;
//CLK 系统时钟 24/16/8/2 M 
void delay_init(unsigned char clk)
{
	if(clk>16)
		fac_us=(16-4)/4;//24Mhz时,stm8大概19个周期为1us
	else if(clk>4)
		fac_us=(clk-4)/4; 
	else 
		fac_us=1;
}

void delay_us(unsigned int nus)
{  
	#asm
	PUSH A            //1T,压栈
	DELAY_XUS:         
	LD A,_fac_us      //1T,fac_us加载到累加器A
	DELAY_US_1:      
	NOP               //1T,nop延时
	DEC A             //1T,A--
	JRNE DELAY_US_1   //不等于0,则跳转(2T)到DELAY_US_1继续  执行,若等于0,则不跳转(1T).
	NOP               //1T,nop延时 
	DECW X            //1T,x--
	JRNE DELAY_XUS    // 不等于0,则跳转(2T)到DELAY_XUS继续  执行,若等于0,则不跳转(1T).
	POP A             //1T,出栈
	#endasm
}

void delay_ms(unsigned int nms) 
{ 
	unsigned char t; 
	if(nms>65) 
	{ 
		t=nms/65; 
		while(t--)delay_us(65000); 
		nms=nms%65; 
	} 
	delay_us(nms*1000); 
}
