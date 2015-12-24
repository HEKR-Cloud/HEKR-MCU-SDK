#include <reg52.h>        
#include "hekr_protocol.h"

#define USER_REV_BUFF_MAX_LEN		20	// 根据实际情况调整接收buffer大小

void InitUART(void);
void SendByte(unsigned char dat);
unsigned char xdata Recv_Buffer[USER_REV_BUFF_MAX_LEN];
unsigned char Recv_STA = 0;
/*------------------------------------------------
                    主函数
------------------------------------------------*/
void main (void)
{
	unsigned char temp = 0,UserValidLen = 9;
	InitUART();
	HekrInit(SendByte);
	HekrValidDataUpload(UserValidLen);
  	HekrModuleControl(HekrConfig);
	while(1)
	{
		if(Recv_STA)
		{
			temp = HekrRecvDataHandle(Recv_Buffer);
			if(ValidDataUpdate == temp)
			{
				//接收的数据保存在 valid_data 数组里
				//User Code
				SendByte(valid_data[0]);
			}
			if(HekrModuleStateUpdate == temp)
			{
				//接收的数据保存在 ModuleStatus 指针里
				//User Code.
				SendByte(ModuleStatus->CMD);
			}
			Recv_STA = 0;		
		}
	}
}

void InitUART(void)
{
	SCON  = 0x50;		         
  TMOD |= 0x20;              
  TH1   = 0XF3;             
	TL1   = 0XF3;
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
