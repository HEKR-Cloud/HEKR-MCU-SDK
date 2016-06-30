#include <reg52.h>        
#include "hekr_protocol.h"

#define USER_REV_BUFF_MAX_LEN		20	// 根据实际情况调整接收buffer大小

void InitUART(void);
void SendByte(unsigned char dat);
unsigned char xdata Recv_Buffer[USER_REV_BUFF_MAX_LEN];
unsigned char Recv_STA = 0;

unsigned char idata ProdKey[16] = {0x01,0x36,0xA6,0x6C,0x12,0x75,0x4E,0xE8,0x2F,0xFF,0x88,0x04,0xB7,0xFA,0xA5,0x3C};         //产品秘钥设置，共16个字节,当前示例ProdKey值对应LED多彩体验页面。ProdKey的获取和设置方法可参考：http://docs.hekr.me/v4/resourceDownload/protocol/uart/#44prodkey

/*------------------------------------------------
                    主函数
------------------------------------------------*/
void main (void)
{
	unsigned char temp = 0,UserValidLen = 9;
	InitUART();
	HekrInit(SendByte);
	HekrValidDataUpload(UserValidLen);
	
	/*************模块操作函数************/

	/*
	Module_State_Function();               //模块状态查询
	Module_Soft_Reboot_Function();         //模块软重启
	Module_Factory_Reset_Function();       //模块恢复出厂设置
	Hekr_Config_Function();                //模块进入一键配置
	Module_Set_Sleep_Function();           //模块进入休眠
	Module_Weakup_Function();              //模块休眠唤醒
	Module_Firmware_Versions_Function();   //模块版本查询
	Module_ProdKey_Get_Function();         //模块产品秘钥ProdKey查询
	Module_Factory_Test_Function();        //模块进入厂测模式
	Set_ProdKey(ProdKey);                  //模块ProdKey设置，用户根据从console平台获取的ProdKey值设置产品秘钥数组ProdKey[16]
  */
	
	while(1)
	{
		if(Recv_STA)
		{
			temp = HekrRecvDataHandle(Recv_Buffer);
			if(ValidDataUpdate == temp)
			{
				//接收的产品业务数据保存在 valid_data 数组里
				/************产品业务数据操作用户代码********/
				SendByte(valid_data[0]);
				/********************************************/
			}
			if(HekrModuleStateUpdate == temp)
			{
				//接收的模块状态取值保存在 ModuleStatus 指针里
				/*************模块状态操作用户代码************/
				SendByte(ModuleStatus->Mode);           //打印模块工作模式指示字节
				SendByte(ModuleStatus->WIFI_Status);    //打印模块WIFI状态指示字节
				SendByte(ModuleStatus->CloudStatus);    //打印模块云连接状态指示字节
				SendByte(ModuleStatus->SignalStrength); //打印模块状态查询应答帧保留字节
				/*************模块状态取值参考：http://docs.hekr.me/v4/resourceDownload/protocol/uart/#42  **********/
			}
			Recv_STA = 0;		
		}
	}
}

void InitUART(void)
{
	SCON  = 0x50;		         
  TMOD |= 0x20;              
  //TH1   = 0XF3;   //根据晶振的频率调整串口波特率          
	//TL1   = 0XF3;   //根据晶振的频率调整串口波特率
	TH1   = 0XFA;     //根据晶振的频率调整串口波特率        
	TL1   = 0XFA;     //根据晶振的频率调整串口波特率 
	PCON |= 0X80; 
	TR1   = 1;                                       
  EA    = 1;                  
  ES    = 1;                
}         

void SendByte(unsigned char dat)
{
	SBUF = dat;
	while(!TI);
		TI = 0;
}

void UART_SER (void) interrupt 4 
{
	unsigned char Temp;        
	static unsigned char count,flag = 0;
	
	if (RI)                      
	{
  		RI = 0;                      
		Temp = SBUF;

		if (0 == flag)
		{
			if (HEKR_FRAME_HEADER == Temp)
			{
				count = 0;
				flag = 1;
				Recv_Buffer[count++] = Temp;
			}
		}
		else
		{
			if (USER_REV_BUFF_MAX_LEN > count)
			{
				Recv_Buffer[count++] = Temp;
				if((count > 4) && (count >= Recv_Buffer[1]))
				{
					Recv_STA = 1;
					flag = 0;
					count = 0;
				}
			}
			else
			{
				flag = 0;
				count = 0;
			}
		}
	}
} 
