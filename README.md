#HEKR-MCU-SDK 说明文档
----
##0.主要内容
*	SDK简介
*	Hekr_Protocol 目录结构
*	氦氪HEKR模块透传协议示例
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
	
	// 使用前要定义用户所需要的最大数组  默认为100 大于100需要自行修改
	//数组大小可以自行修改为最长长度  
	// 如果有多条不等长命令  取最长长度 为用户数据长度  非整帧长度
	#define USER_MAX_LEN  0x64u
	
Hekr 协议初始化

	//Hekr 协议初始化
	//使用Hekr协议前需完成初始化
	//初始化需要用户有串口发送一个byte的程序
	//eg:  void UART_SendChar(u8 ch); 传输参数必须只是一个8bit的数
	//     该函数需要用户自行在程序中定义
	//HekrInit函数:
	//传入参数为用户串口发送一个byte函数的函数名
	//void HekrInit(void (*fun)(unsigned char));
	HekrInit(UART_SendChar);   


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


##4.移植样例
example 文件夹下是移植完成的MCU-SDK

####4.1 STM32的hekr协议SDK 
具体参数如下

*	开发平台 STM32F103C8T6
*	开发环境 MDK5.13
*	开发工具 Jlink , Jlink-OB , ST-LINK V2
*	通信方式 UART3 参数 9600-8-N-1
*	通信协议 氦氪HEKR模块透传协议

####4.2 STM32-uCOSIII 的hekr协议SDK 
具体参数如下

*	开发平台 STM32F103C8T6
*	开发环境 MDK5.13
*	开发工具 Jlink , Jlink-OB , ST-LINK V2
*	通信方式 UART3 参数 9600-8-N-1
*	通信协议 氦氪HEKR模块透传协议
*	uCOSIII  Version : V3.03.00

####4.3 Arduino 的hekr协议SDK 
具体参数如下

*	开发平台 mega328p
*	开发环境 Arduino IDE 1.6.5
*	开发工具 UART模块
*	通信方式 UART 参数 9600-8-N-1
*	通信协议 氦氪HEKR模块透传协议

注意： 提供的Arduino库文件是.cpp 仅仅是后缀不同，内容相同，详细描述在对应文件夹下的Readme.txt中

####4.4 C51 的hekr协议SDK 
具体参数如下

*	开发平台 STC89C52
*	开发环境 Keil  4.72.90
*	开发工具 UART模块
*	通信方式 UART 参数 9600-8-N-1
*	通信协议 氦氪HEKR模块透传协议

注意： 提供的51的库文件在使用是要定义一个宏,头文件中有描述

##5.更新历史
* 2015.7.30 STM8-SDK及Readme.md文档编写
* 2015.8.07 增加STM32-SDK移植样例 Readme.md文档补充
* 2015.8.13 修复收到的有效数据缺位错误
* 2015.8.14 增加用户不等长命令描述 Readme.md文档补充
* 2015.8.26 完善帧序号,模块状态改为指针,优化代码结构
* 2015.8.26 更新STM32-SDK
* 2015.8.26 更新STM32-uCOSIII-SDK
* 2015.9.01 增加Arduino-SDK
* 2015.9.06 更新STM8-SDK
* 2015.9.06 更新STM32-SDK
* 2015.9.06 更新STM32-uCOSIII-SDK
* 2015.9.07 增加51-SDK

##6.相关链接及反馈

SDK 获取 ：  https://github.com/HEKR-Cloud/HEKR-MCU-SDK.git

氦氪HEKR模块透传协议 ： http://docs.hekr.me/protocol/

Bug反馈 ： pengyu.zhang@hekr.me   或者 965006619@qq.com



