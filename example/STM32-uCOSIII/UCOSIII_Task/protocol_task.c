#include "protocol_task.h"
#include "task.h"
#include "uart.h"
#include "led.h"

//任务控制块
OS_TCB ProtocolTaskTCB;
//任务堆栈	
CPU_STK Protocol_TASK_STK[Protocol_STK_SIZE];

	
void protocol_task(void *p_arg)
{
	OS_ERR err;
	static uint8_t Date_Handle_Flag = 0;
	uint8_t temp = 0;
	p_arg = p_arg;
	while(1)
	{
		if(Uart3_Recv_STA && !Date_Handle_Flag)
		{
			Date_Handle_Flag = 1;
			Uart3_Recv_STA = 0;
		}
		if(Date_Handle_Flag)
		{
			temp = HekrRecvDataHandle(Uart3_Recv_Buffer);
			if(ValidDataUpdate == temp)
			{
				//接收的产品业务数据保存在 valid_data 数组里
				/************产品业务数据操作用户代码********/
				if(valid_data[0] == 0x01)
				{
					LED0 = 1;
					OSTaskSuspend((OS_TCB*)&Led0TaskTCB,&err);
					printf("挂起LED任务\n\r");	
				}
				else
				{
					LED0 = 0;
					OSTaskResume((OS_TCB*)&Led0TaskTCB,&err);
					printf("恢复LED任务\n\r");	
				}
				if(valid_data[1] == 0x01)
				{
					OSTaskDel((OS_TCB*)&FloatTaskTCB,&err);
					printf("删除float任务\n\r");	
				}
				else
				{
										//创建浮点测试任务
						OSTaskCreate((OS_TCB 	* )&FloatTaskTCB,		
									 (CPU_CHAR	* )"float test task", 		
													 (OS_TASK_PTR )float_task, 			
													 (void		* )0,					
													 (OS_PRIO	  )FLOAT_TASK_PRIO,     	
													 (CPU_STK   * )&FLOAT_TASK_STK[0],	
													 (CPU_STK_SIZE)FLOAT_STK_SIZE/10,	
													 (CPU_STK_SIZE)FLOAT_STK_SIZE,		
													 (OS_MSG_QTY  )0,					
													 (OS_TICK	  )0,					
													 (void   	* )0,				
													 (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, 
													 (OS_ERR 	* )&err);		
				}
				/********************************************/
			}
			if(HekrModuleStateUpdate == temp)
			{
				//接收的模块状态取值保存在 ModuleStatus 指针里
				/*************模块状态操作用户代码************/
				printf("ModuleStatus CMD %d \n\r",ModuleStatus->Mode);                //打印模块工作模式指示字节
				printf("ModuleStatus CMD %d \n\r",ModuleStatus->WIFI_Status);         //打印模块WIFI状态指示字节
				printf("ModuleStatus CMD %d \n\r",ModuleStatus->CloudStatus);         //打印模块云连接状态指示字节
				printf("ModuleStatus CMD %d \n\r",ModuleStatus->SignalStrength);      //打印模块状态查询应答帧保留字节
				/*************模块状态取值参考:http://docs.hekr.me/v4/resourceDownload/protocol/uart/#42**********/
			}
			Date_Handle_Flag = 0;		
		}
		OSTimeDlyHMSM(0,0,0,10,OS_OPT_TIME_HMSM_STRICT,&err); //延时10ms
	}
}
