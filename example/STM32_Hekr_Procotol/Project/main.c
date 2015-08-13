#include "stm32f10x.h"                  // Device header


#include "uart.h"
#include "hekr_protocol.h"
 
u8 Date_Handle_Flag = 0;

void System_init(void);

int main()
{
	u8 temp;
	System_init();
	Hekr_ValidData_Upload();

	while (1)
	{
		if(Uart3_Recv_STA && !Date_Handle_Flag)
		{
			Date_Handle_Flag = 1;
			Uart3_Recv_STA = 0;
		}
		if(Date_Handle_Flag)
		{
			temp = Hekr_RecvData_Handle(Uart3_Recv_Buffer);
			if(Valid_Data_Update == temp)
			{
				//接收的数据保存在 Valid_Data 数组里
				//User Code
				UART3_SendChar(Valid_Data[0]);
			}
			if(Hekr_Module_State_Update == temp)
			{
				//接收的数据保存在 Module_Status 数组里
				//User Code
				UART3_SendChar(Module_Status[1]);
			}
			Date_Handle_Flag = 0;			
		}			
	} 
	return 0;
}



void System_init(void)
{
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 
	Uart3_init();
}

