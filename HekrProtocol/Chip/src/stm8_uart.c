#include "stm8s103f.h"
#include "stm8_uart.h"
#include "stdio.h"

// BaudRate=16m/
//  BaudRate_Mantissa=16000000/BaudRate;
//  2400 :  16000000/6666=0x1a0a   brr2=0x1a,brr1=0xa0
//  4800 :  16000000/3333=0x0d05   brr2=0x05,brr1=0xd0
//  9600 :  16000000/1666=0x0682   brr2=0x02,brr1=0x68
//  19200 : 16000000/833=0x0341    brr2=0x01,brr1=0x34
//  38400 : 16000000/416=0x01a0    brr2=0x00,brr1=0x1a
//  115200 :16000000/139=0x008b    brr2=0x0b,brr1=0x08

// 9600
// USART_BRR2 =0x02;   //bit[7-4] = band[bit15;bit12] bit[3-0]=band[bit3-0]
// USART_BRR1 = 0x68;  //bot[7-0] = band[bit11-4]

void  UART1_Init(void)
{   
		UART1_CR1 = 0x00; //8bit
		UART1_CR2 = 0x00;
		UART1_CR3 = 0x00;//1 stop bit
		// 设置波特率，必须注意以下几点：
		// (1) 必须先写BRR2
		// (2) BRR1存放的是分频系数的第11位到第4位，
		// (3) BRR2存放的是分频系数的第15位到第12位，和第3位
		// 到第0位
		// 例如对于波特率位9600时，分频系数=2000000/9600=208 2M
		// 对应的十六进制数为00D0，BBR1=0D,BBR2=00
		
		//16M  9600
		#ifdef Baud_9600
		UART1_BRR2=0x02;
		UART1_BRR1=0x68;
		#endif
		
		//16M 115200
		#ifdef Baud_115200
		UART1_BRR2=0x0b;
		UART1_BRR1=0x08;
		#endif
		UART1_CR2 = 0x2C;//enable REN and RIEN
}

void UART1_SendChar(unsigned char ch)
{
	while((UART1_SR & 0x80) == 0x00);	//  若发送寄存器不空，则等待
		UART1_DR = ch;										 // 将要发送的字符送到数据寄存器
}

char putchar(char ch)
{
		UART1_SendChar(ch);
		return ch;
}
