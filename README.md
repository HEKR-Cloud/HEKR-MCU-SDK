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

*    hekr_protocol.h ： 数据结构定义及User API声明
*    hekr_protocol.c ： 具体函数实现  

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

####透传协议示例
定义用户需要的最长长度
	
	// 使用前要定义用户所需要的最大数组  
	// 如果有多条不等长命令  取最长长度 为用户数据长度  非整帧长度
	#define USER_MAX_LEN  0x0F
	
协议数据发送示例

	// 主动上传用户数据（数据保存在valid_data数组里）
	// UserValidLen  为用户数据长度  非整帧长度
	HekrValidDataUpload(UserValidLen);
	// 查询 Hekr模块当前状态
	HekrModuleControl(ModuleQuery);
	// 配置Hekr模块进入Hekr_Config模式
	HekrModuleControl(HekrConfig);

协议接收处理示例

	if(DateHandleFlag)
	{
		temp = HekrRecvDataHandle(RecvBuffer);
		if(ValidDataUpdate == temp)
		{
			//接收的数据保存在 valid_data 数组里
			//User Code
			UART1_SendChar(valid_data[0]);
		}
		if(HekrModuleStateUpdate == temp)
		{
			//接收的数据保存在 ModuleStatus 指针里
			//User Code
			UART1_SendChar(ModuleStatus->CMD);
		}
		DateHandleFlag = 0;			
	}		

####对于用户数据多种或不等长补充说明
####接收
*	如果有多条不等长命令可以正常接收 
*	接收的数据保存在 valid_data 数组里
*	用户需要自行判断命令是哪一种

####上传
*	把数据保存到 valid_data 中
*	传入参数为对应命令长度 即可正常上传

##4.协议移植说明
Hekr MCU SDK中的协议可快速移植到其他单片机中

####4.1 添加
把App文件夹下的Hekr_Protocol.h Hekr_Protocol.c 添加到对应工程中

####4.2 修改
修改 Hekr_Protocol.h 中的头文件

	//将此处头文件替换成对应平台的串口头文件
	#include "stm8_uart.h"
	
修改 Hekr_Protocol.c 的函数

	static void HekrSendByte(unsigned char ch)
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
* 2015.7.30 STM8-SDK及Readme.md文档编写
* 2015.8.07 增加STM32-SDK移植样例 Readme.md文档补充
* 2015.8.13 修复收到的有效数据缺位错误
* 2015.8.14 增加用户不等长命令描述 Readme.md文档补充
* 2015.8.26 完善帧序号,模块状态改为指针,优化代码结构
* 2015.8.26 更新STM32-SDK
* 2015.8.26 更新STM32-uCOSIII-SDK

 
##7.相关链接及反馈

SDK 获取 ：  https://github.com/HEKR-Cloud/HEKR-MCU-SDK.git

氦氪HEKR模块透传协议 ： http://docs.hekr.me/protocol/

Bug反馈 ： pengyu.zhang@hekr.me   或者 965006619@qq.com



