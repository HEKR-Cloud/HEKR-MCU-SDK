#HEKR-MCU-SDK 说明文档
----
##0.主要内容
*	SDK简介
*	Hekr_Protocol 目录结构
*	氦氪HEKR模块透传协议示例
*	协议移植说明
*	移植样例
*	更新历史
*	相关链接及反馈

##1. SDK简介
*	开发平台 STM8S103F3P
*	开发环境 STVD V3.6.5.2
*	开发工具 ST-LINK V2
*	通信方式 UART 参数 9600-8-N-1
*	通信协议 氦氪HEKR模块透传协议

##2. Hekr_Protocol 目录结构

	├── App
	├── Chip
	├── Project
	└── System

####App
氦氪HEKR模块透传协议

*    Hekr_Protocol.h ： 数据结构定义及User API声明
*    Hekr_Protocol.c ： 具体函数实现  

####Chip
STM8S 芯片驱动

*	stm8_uart.h
*	stm8_uart.c

####Project
工程主目录

*	main.c ： Hekr协议使用样板
*	stm8_interrupt_vector.c ： STM8中断向量表


####System
STM8 系统时钟等相关配置与定义


##3. 氦氪HEKR模块透传协议示例
协议数据发送示例

	// 主动上传用户数据（数据保存在Valid_Data数组里）
	Hekr_ValidData_Upload();
	// 查询 Hekr模块当前状态
	Hekr_Module_Control(Module_Query);
	// 配置Hekr模块进入Hekr_Config模式
	Hekr_Module_Control(Hekr_Config);

协议接收处理示例

	if(Date_Handle_Flag)
	{
		temp = Hekr_RecvData_Handle(Recv_Buffer);
		if(Valid_Data_Update == temp)
		{
			//用户数据更新
			//接收的数据保存在 Valid_Data 数组里
			//User Code
		}
		if(Hekr_Module_State_Update == temp)
		{
			//Hekr 模块状态改变及查询反馈
			//接收的数据保存在 Module_Status 数组里
			//User Code
		}
		Date_Handle_Flag = 0;			
	}		

##4.协议移植说明
Hekr MCU SDK中的协议可快速移植到其他单片机中

####4.1 添加
把App文件夹下的Hekr_Protocol.h Hekr_Protocol.c 添加到对应工程中

####4.2 修改
修改 Hekr_Protocol.h 中的头文件

	//将此处头文件替换成对应平台的串口头文件
	#include "stm8_uart.h"
	
修改 Hekr_Protocol.c 的函数

	static void Hekr_Send_Byte(unsigned char ch)
	{
		//将此函数替换成对应平台的串口调用函数即可
		UART1_SendChar(ch);
	}

####4.3 使用
参照 3.氦氪HEKR模块透传协议示例 加入协议处理部分即可正常使用

##5.移植样例
example 文件夹下是移植完成的MCU-SDK

####5.1 STM32的hekr协议SDK 
具体参数如下

*	开发平台 STM32F103C8T6
*	开发环境 MDK5.13
*	开发工具 Jlink , Jlink-OB , ST-LINK V2
*	通信方式 UART3 参数 9600-8-N-1
*	通信协议 氦氪HEKR模块透传协议


##6.更新历史
* 2015.7.30 STM8 SDK及Readme.md文档编写
* 2015.8.07 增加STM32 SDK移植样例 Readme.md文档补充
* 2015.8.13 修复收到的有效数据缺位错误

##7.相关链接及反馈

SDK 获取 ：  https://github.com/HEKR-Cloud/HEKR-MCU-SDK.git

氦氪HEKR模块透传协议 ： http://docs.hekr.me/protocol/

Bug反馈 ： pengyu.zhang@hekr.me   或者 965006619@qq.com



