#ifndef	_HEKR_PROTOCOL_H_
#define	_HEKR_PROTOCOL_H_


// HEKR USER API **************************************************************

// 使用前要定义用户所需要的最大数组  
// 如果有多条不等长命令  取最长长度  为用户数据长度  非整帧长度
// #define USER_MAX_LEN 0x0F

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


//如果修改串口则需要修改此函数  及对应头文件
//static void HekrSendByte(unsigned char ch);  hekr_protocol.c 99行
//
// 协议网址  http://docs.hekr.me/protocol/
// BUG 反馈  pengyu.zhang@hekr.me
//					 965006619@qq.com
//*****************************************************************************

#include "uart.h"

#define USER_MAX_LEN 0x09
#define HEKR_DATA_LEN 0x05u
#define HEKR_FRAME_HEADER 0x48u


//*************************************************************************
//
//ModuleStatus 指针 包含内容
//
//*************************************************************************

//模块应答帧格式
typedef struct
{
	//有效数据
	unsigned char CMD;
	unsigned char Mode;
	unsigned char WIFI_Status;
	unsigned char CloudStatus;
	unsigned char SignalStrength;// 0-5 代表信号强度
	unsigned char Reserved;
}ModuleStatusFrame; 


//*************************************************************************
//
//HekrRecvDataHandle  函数返回值
//
//*************************************************************************

typedef	enum
{
	RecvDataSumCheckErr = 0x01,
	LastFrameSendErr = 0x02,
	MCU_UploadACK = 0x03,
	ValidDataUpdate = 0x04,
	RecvDataUseless = 0x05,
	HekrModuleStateUpdate = 0x06,
	MCU_ControlModuleACK = 0x07
}RecvDataHandleCode;



//Hekr模块控制码
typedef	enum
{
	ModuleQuery = 0x01,
	ModuleRestart = 0x02,
	ModuleRecover = 0x03,
	HekrConfig = 0x04
}HekrModuleControlCode;


//*************************************************************************
//
//ModuleStatus 指针中各个有效位具体码值
//
//*************************************************************************

//Hekr模块状态码
typedef	enum
{
	STA_Mode = 0x01,
	HekrConfig_Mode = 0x02,
	AP_Mode = 0x03,
	STA_AP_Mode = 0x04,
	RF_OFF_Mode = 0x05
}HekrModuleWorkCode;

//Hekr WIFI状态码
typedef	enum
{
	RouterConnected = 0x01,
	RouterConnectedFail = 0x02,
	RouterConnecting = 0x03,
	PasswordErr = 0x04,
	NoRouter = 0x05,
	RouterTimeOver = 0x06
}HekrModuleWIFICode;

//Hekr Cloud状态码
typedef	enum
{
	CloudConnected = 0x01,
	DNS_Fail = 0x02,
	CloudTimeOver = 0x03
}HekrModuleCloudCode;


//*************************************************************************
//用户数据区
//*************************************************************************

extern unsigned char valid_data[USER_MAX_LEN];
extern ModuleStatusFrame *ModuleStatus; 


//*************************************************************************
//函数列表
//*************************************************************************

// Hekr USER API 
unsigned char HekrRecvDataHandle(unsigned char* data);
void HekrModuleControl(unsigned char data);
void HekrValidDataUpload(unsigned char len);


#endif
