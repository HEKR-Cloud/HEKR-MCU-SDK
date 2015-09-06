#include "stm32f10x.h"                  // Device header
#include "uart.h"
#include "hekr_protocol.h"

// HEKR USER API **************************************************************

//使用前要确定用户所需要的最大数组  默认为100 大于100需要自行修改
//数组大小可以自行修改为最长长度  
//如果有多条不等长命令  取最长长度  为用户数据长度  非整帧长度
//#define USER_MAX_LEN 0x64u

//Hekr 协议初始化
//使用Hekr协议前需完成初始化
//初始化需要用户有串口发送一个byte的程序
//eg:  void UART_SendChar(u8 ch); 传输参数必须只是一个8bit的数
//     该函数需要用户自行在程序中定义
//HekrInit函数:
//传入参数为用户串口发送一个byte函数的函数名
//void HekrInit(void (*fun)(unsigned char));
//eg:  HekrInit(UART_SendChar);   

//传入串口接收的数据数组  
//返回值见头文件 RecvDataHandleCode
//数据保存在对应数组中 valid_data 和 ModuleStatus 指针
//unsigned char HekrRecvDataHandle(unsigned char* data);

//配置及查询hekr模块状态 传入码值见头文件 HekrModuleControlCode
//状态值保存在module_status数组中
//void HekrModuleControl(unsigned char data);


//上传用户有效数据
//数据存放在valid_data数组中 len 为用户数据长度  非整帧长度
//void HekrValidDataUpload(unsigned char len);

//协议修改日期 2015.09.01 
//协议网址  http://docs.hekr.me/protocol/
//BUG 反馈  pengyu.zhang@hekr.me
//					965006619@qq.com
//*****************************************************************************

u8 DateHandleFlag = 0;

void System_Init(void);

int main()
{
	u8 temp;
	u8 UserValidLen = 9;
	System_Init();
	HekrInit(UART3_SendChar);
	
	HekrValidDataUpload(UserValidLen);
  	HekrModuleControl(HekrConfig);
	while (1)
	{
		
		if(Uart3_Recv_STA && !DateHandleFlag)
		{
			DateHandleFlag = 1;
			Uart3_Recv_STA = 0;
		}
		if(DateHandleFlag)
		{ 
			temp = HekrRecvDataHandle(Uart3_Recv_Buffer);
			if(ValidDataUpdate == temp)
			{
				//接收的数据保存在 valid_data 数组里
				//User Code
				UART3_SendChar(valid_data[0]);
			}
			if(HekrModuleStateUpdate == temp)
			{
				//接收的数据保存在 ModuleStatus 指针里
				//User Code.
				UART3_SendChar(ModuleStatus->CMD);
			}
			DateHandleFlag = 0;			
		}			
	} 
	return 0;
}



void System_Init(void)
{
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 
	Uart3_init();
}

