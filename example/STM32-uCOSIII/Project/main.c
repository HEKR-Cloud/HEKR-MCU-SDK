#include "stm32f10x.h"                  // Device header
#include "uart.h"
#include "includes.h"
#include "task.h"
#include "LED.h"
#include "delay.h"

void BSP_init(void);

u8 UserValidLen = 9;
unsigned char ProdKey[16] = {0x01,0x36,0xA6,0x6C,0x12,0x75,0x4E,0xE8,0x2F,0xFF,0x88,0x04,0xB7,0xFA,0xA5,0x3C};         //产品秘钥设置,共16个字节,当前示例ProdKey值对应LED多彩灯体验页面。ProdKey的获取和设置方法可参考:http://docs.hekr.me/v4/resourceDownload/protocol/uart/#44prodkey

int main()
{  
	OS_ERR err;
	CPU_SR_ALLOC();
	BSP_init();
	
	OSInit(&err); 
	OS_CRITICAL_ENTER();
	OSTaskCreate((OS_TCB 	* )&StartTaskTCB,		//任务控制块
				 (CPU_CHAR	* )"start task", 		//任务名字
                 (OS_TASK_PTR )start_task, 			//任务函数
                 (void		* )0,					//传递给任务函数的参数
                 (OS_PRIO	  )START_TASK_PRIO,     //任务优先级
                 (CPU_STK   * )&START_TASK_STK[0],	//任务堆栈基地址
                 (CPU_STK_SIZE)START_STK_SIZE/10,	//任务堆栈深度限位
                 (CPU_STK_SIZE)START_STK_SIZE,		//任务堆栈大小
                 (OS_MSG_QTY  )0,					//任务内部消息队列能够接收的最大消息数目,为0时禁止接收消息
                 (OS_TICK	  )0,					//当使能时间片轮转时的时间片长度，为0时为默认长度，
                 (void   	* )0,					//用户补充的存储区
                 (OS_OPT      )OS_OPT_TASK_STK_CHK|OS_OPT_TASK_STK_CLR, //任务选项
                 (OS_ERR 	* )&err);				//存放该函数错误时的返回值
	OS_CRITICAL_EXIT();
	OSStart(&err);
	
	while(1){}
}

/*********************HEKR USER API*********************/

/*******************************************************/
//#define USER_MAX_LEN 0x64u
//使用前要确定用户所需要的最大数组 默认为100 大于100需要自行修改
//数组大小可以自行修改为最长长度
//如果有多条不等长命令，取最长长度 此处长度指用户数据长度 非整帧长度
/*******************************************************/


/*******************************************************/
//void HekrInit(void (*fun)(unsigned char));
//eg:  HekrInit(UART_SendChar);   
//HekrInit函数:
//传入参数为用户串口发送一个byte函数的函数名
//Hekr 协议初始化
//使用Hekr协议前需要完成初始化
//初始化需要用户有串口发送一个byte的程序
/*******************************************************/


/*******************************************************/
//eg:  void UART_SendChar(u8 ch); 传输参数必须只是一个8bit的数
//     该函数需要用户自行在程序中定义
/*******************************************************/


/*******************************************************/
//unsigned char HekrRecvDataHandle(unsigned char* data);
//串口数据接收处理
//返回值见头文件 RecvDataHandleCode
//数据保存在对应数组中 valid_data 和 ModuleStatus 指针
//模块状态值保存在module_status数组中
/*******************************************************/


/*******************************************************/
//void HekrValidDataUpload(unsigned char len);
//上传用户有效数据
//数据存放在valid_data数组中,len 为用户数据长度,非整帧长度
/*******************************************************/


//协议修改日期 2016.06.23 
//协议网址  http://docs.hekr.me/v4/resourceDownload/protocol/uart/
//BUG 反馈  zejun.zhao@hekr.me
//					387606503@qq.com
/*******************************************************/

void BSP_init(void)
{
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 
	Uart3_init();
	delay_init();  
	LED_init();
	HekrInit(UART3_SendChar);
	
	/*************模块操作函数************/
  HekrValidDataUpload(UserValidLen);
	Module_State_Function();               //模块状态查询
  /*
	Module_Soft_Reboot_Function();         //模块软重启
	Module_Factory_Reset_Function();       //模块恢复出厂设置
	Hekr_Config_Function();                //模块进入一键配置模式
	Module_Set_Sleep_Function();           //模块进入休眠
	Module_Weakup_Function();              //模块休眠唤醒
	Module_Firmware_Versions_Function();   //模块版本查询
	Module_ProdKey_Get_Function();         //模块产品秘钥ProdKey查询
	Module_Factory_Test_Function();        //模块进入厂测模式
	Set_ProdKey(ProdKey);                  //模块ProdKey设置,用户根据从console平台获取的ProdKey值设置产品秘钥数组ProdKey[16]
	*/
}


//	

