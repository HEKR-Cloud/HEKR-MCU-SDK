#include  <msp430x14x.h>
#include "hekr_protocol.h"

unsigned char RecvBuffer[20];
unsigned char Recv_STA = 0;
void SystemInit(void);
void SendChar(unsigned char ch);
unsigned char ProdKey[16] = {0x01,0x36,0xA6,0x6C,0x12,0x75,0x4E,0xE8,0x2F,0xFF,0x88,0x04,0xB7,0xFA,0xA5,0x3C};         //产品秘钥设置，共16个字节，当前示例ProdKey值对应LED多彩灯体验页面。ProdKey的获取和设置方法可参考:http://docs.hekr.me/v4/resourceDownload/protocol/uart/#44prodkey

void main(void)
{ 
    unsigned char temp,UserValidLen = 9;
    SystemInit();
    HekrInit(SendChar);
    HekrValidDataUpload(UserValidLen);

    /*************模块操作函数************/

    Module_State_Function();               //模块状态查询
    /*
    Module_Soft_Reboot_Function();         //模块软重启
    Module_Factory_Reset_Function();       //模块恢复出厂设置
    Hekr_Config_Function();                //模块进入一键配置模式
    Module_Set_Sleep_Function();           //模块进入休眠
    Module_Weakup_Function();              //模块休眠唤醒
    Module_Firmware_Versions_Function();   //模块版本查询
    Module_ProdKey_Get_Function();         //模块产品秘钥ProdKey查询
    Module_Factory_Test_Function();        //模块进入产测模式
    Set_ProdKey(ProdKey);                  //模块ProdKey设置,用户根据从console平台获取的ProdKey值设置产品秘钥数组ProdKey[16]
    */
    
    while(1)
    {         
        LPM1;                                  //进入LPM1模式
        if(Recv_STA)
		{
			temp = HekrRecvDataHandle(RecvBuffer);
			if(ValidDataUpdate == temp)
			{
                          //接收的产品业务数据保存在 valid data 数组里
                          /************产品业务数据操作用户代码********/
                          SendChar(valid_data[0]);
                          /********************************************/
			}
			if(HekrModuleStateUpdate == temp)
			{
                          //接收的模块状态取值保存在 ModuleStatus 指针里
                          /*************模块状态操作用户代码************/
                          SendChar(ModuleStatus->Mode);           //打印模块工作模式指示字节
                          SendChar(ModuleStatus->WIFI_Status);    //打印模块WIFI状态指示字节
                          SendChar(ModuleStatus->CloudStatus);    //打印模块云链接状态指示字节
                          SendChar(ModuleStatus->SignalStrength); //打印模块状态查询应答帧保留字节
                          /*************模块状态取值参考:http://docs.hekr.me/v4/resourceDownload/protocol/uart/#42  **********/
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


