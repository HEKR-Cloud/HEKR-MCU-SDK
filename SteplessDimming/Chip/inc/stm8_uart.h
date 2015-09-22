#ifndef _STM8_UART_H
#define _STM8_UART_H

#define Baud_9600
//#define Baud_115200

void  UART1_Init(void);
void UART1_SendChar(unsigned char ch);

char putchar(char ch);


#endif
