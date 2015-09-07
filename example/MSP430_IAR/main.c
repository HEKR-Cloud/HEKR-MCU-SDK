#include  <msp430x14x.h>
#include "hekr_protocol.h"

unsigned char RecvBuffer[20];
unsigned char Recv_STA = 0;
void SystemInit(void);
void SendChar(unsigned char ch);

void main(void)
{ 
    unsigned char temp,UserValidLen = 9;
    SystemInit();
    HekrInit(SendChar);
    HekrValidDataUpload(UserValidLen);
  	HekrModuleControl(HekrConfig);
    while(1)
    {                   
        LPM1;                                  //进入LPM1模式
        if(Recv_STA)
		{
			temp = HekrRecvDataHandle(RecvBuffer);
			if(ValidDataUpdate == temp)
			{
				//接收的数据保存在 valid_data 数组里
				//User Code
				SendChar(valid_data[0]);
			}
			if(HekrModuleStateUpdate == temp)
			{
				//接收的数据保存在 ModuleStatus 指针里
				//User Code.
				SendChar(ModuleStatus->CMD);
			}
			Recv_STA = 0;		
		}
    }
}

void SystemInit(void)
{
    /*下面六行程序关闭所有的IO口*/
    P1DIR = 0XFF;P1OUT = 0XFF;
    P2DIR = 0XFF;P2OUT = 0XFF;
    P3DIR = 0XFF;P3OUT = 0XFF;
    P4DIR = 0XFF;P4OUT = 0XFF;
    P5DIR = 0XFF;P5OUT = 0XFF;
    P6DIR = 0XFF;P6OUT = 0XFF;
    
    WDTCTL = WDTPW + WDTHOLD;                 // 关闭看门狗
    P6DIR |= BIT2;P6OUT |= BIT2;              //关闭电平转换
    
    P3SEL |= 0x30;                            // 选择P3.4和P3.5做UART通信端口
    ME1 |= UTXE0 + URXE0;                     // 使能USART0的发送和接受
    UCTL0 |= CHAR;                            // 选择8位字符
    UTCTL0 |= SSEL0;                          // UCLK = ACLK
    UBR00 = 0x03;                             // 波特率9600
    UBR10 = 0x00;                             //
    UMCTL0 = 0x4A;                            // Modulation
    UCTL0 &= ~SWRST;                          // 初始化UART状态机
    IE1 |= URXIE0;                            // 使能USART0的接收中断
    _EINT();                                  //打开全局中断
    
}

void SendChar(unsigned char ch)
{
   while (!(IFG1 & UTXIFG0));         //等待以前的字符发送完毕
   TXBUF0 = ch;                       //将收到的字符发送出去 
}

#pragma vector = UART0RX_VECTOR
__interrupt void UART0_RXISR(void)
{
  static unsigned char flag = 0,count = 0;
  LPM1_EXIT;                 //退出低功耗模式
  if(RXBUF0 == HEKR_FRAME_HEADER)
  {
      count = 0;
      flag = 1;
  }
  if(flag == 1)
  {
	RecvBuffer[count++] = RXBUF0;
	if(count > 4 && count >= RecvBuffer[1])
	{
		Recv_STA = 1;
		flag = 0;
		count = 0;
	}    
  }
}


