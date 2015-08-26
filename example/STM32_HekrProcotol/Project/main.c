#include "stm32f10x.h"                  // Device header
#include "uart.h"
#include "hekr_protocol.h"
 
u8 DateHandleFlag = 0;

void System_Init(void);

int main()
{
	u8 temp;
	u8 UserValidLen = 9;
	System_Init();
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

