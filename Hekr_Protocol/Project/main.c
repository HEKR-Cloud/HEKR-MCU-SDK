/* MAIN.C file
 * 
 * 
 */

#include "stm8s103f.h"
#include "sys.h"
#include "delay.h"
#include "stm8_uart.h"
#include "hekr_protocol.h"

u8 Recv_Flag = 0;
u8 Recv_Count = 0;
u8 Recv_Buffer[20];
u8 Date_Handle_Flag = 0;


void System_init(void);


// Hekr USER API **************************************************************

//传入串口接收的数据数组  
//返回值见头文件 RecvData_Handle_Code
//数据保存在对应数组中 Valid_Data 和 Module_Status
//unsigned char Hekr_RecvData_Handle(unsigned char* data);

//配置及查询hekr模块状态 传入码值见头文件 Hekr_Module_Control_Code
//状态值保存在Module_Status数组中
//void Hekr_Module_Control(unsigned char data);

//上传用户有效数据
//数据存放在Valid_Data数组中
//void Hekr_ValidData_Upload(void);

//如果修改串口则需要修改此函数 及对应头文件
//static void Hekr_Send_Byte(unsigned char ch);

// 协议网址  http://docs.hekr.me/protocol/
// BUG 反馈  pengyu.zhang@hekr.me
//					 965006619@qq.com
//*****************************************************************************

main()
{
	u8 temp;
	System_init();
	
	// 上传有效数据
	Hekr_ValidData_Upload();
	// 配置及查询hekr模块状态
	Hekr_Module_Control(Module_Query);
	
	while (1)
	{
		if(Recv_Flag && !Date_Handle_Flag)
		{
			Date_Handle_Flag = 1;
			Recv_Flag = 0;
		}
		if(Date_Handle_Flag)
		{
			temp = Hekr_RecvData_Handle(Recv_Buffer);
			if(Valid_Data_Update == temp)
			{
				//接收的数据保存在 Valid_Data 数组里
				//User Code
				UART1_SendChar(Valid_Data[0]);
			}
			if(Hekr_Module_State_Update == temp)
			{
				//接收的数据保存在 Module_Status 数组里
				//User Code
				UART1_SendChar(Module_Status[1]);
			}
			Date_Handle_Flag = 0;			
		}			
	}
}


void System_init(void)
{
	System_Clock_init();
	UART1_Init();
	delay_init(16);
	_asm("rim");
}
 
@far @interrupt void UART1_Recv_IRQHandler(void)
{
  unsigned char ch;
	static unsigned char temp_flag = 0;
  ch = UART1_DR;   
	if(ch == Hekr_Frame_Header)
	{
		temp_flag = 1;
		Recv_Count = 0;
	}
	if(temp_flag)
	{
		Recv_Buffer[Recv_Count++] = ch;
		if(Recv_Count > 4 && Recv_Count >= Recv_Buffer[1])
		{
			Recv_Flag = 1;
			temp_flag = 0;
			Recv_Count = 0;
		}
		if(Recv_Count > 15)
		{
			temp_flag = 0;
			Recv_Count = 0;
		}
	}
}
	

