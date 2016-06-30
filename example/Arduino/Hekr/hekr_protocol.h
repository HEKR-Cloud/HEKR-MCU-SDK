#ifndef	_HEKR_PROTOCOL_H_
#define	_HEKR_PROTOCOL_H_


/*********************HEKR USER API*********************/

/*******************************************************/
//#define USER_MAX_LEN 0x64u
//使用前要确定用户所需要的最大数组 默认为100 大于100需要自行修改
//数组大小可以自行修改为最长长度  
//如果有多条不等长命令  取最长长度  为用户数据长度  非整帧长度
/*******************************************************/


/*******************************************************/
//void HekrInit(void (*fun)(unsigned char));
//eg:  HekrInit(UART_SendChar);   
//HekrInit函数:
//传入参数为用户串口发送一个byte函数的函数名
//Hekr 协议初始化
//使用Hekr协议前需完成初始化
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
//数据存放在valid_data数组中，len 为用户数据长度，非整帧长度
/*******************************************************/


//协议修改日期 2016.06.23 
//协议网址  http://docs.hekr.me/v4/resourceDownload/protocol/uart/
//BUG 反馈  zejun.zhao@hekr.me
//          387606503@qq.com
/*******************************************************/



#define USER_MAX_LEN 0x64u
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
   Module_Statue		          = 0x01,    //状态查询
   Module_Soft_Reboot             = 0x02,    //模块软重启
   Module_Factory_Reset           = 0x03,    //恢复出厂
   Hekr_Config                    = 0x04,    //一键配置
   Module_Set_Sleep			      = 0x05,    //进入休眠
   Module_Weakup                  = 0x06,    //休眠唤醒
   Module_Factory_Test            = 0x20,    //进入厂测
   Module_Firmware_Versions       = 0x10,    //版本查询
   Module_ProdKey_Get             = 0x11,    //ProdKey查询
   Module_Set_ProdKey             = 0x21    //ProdKey设置
}Module_Operation_TypeDef;

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
void HekrInit(void (*fun)(unsigned char));
unsigned char HekrRecvDataHandle(unsigned char* data);
void HekrValidDataUpload(unsigned char len);
void HekrSendFrame_outside(unsigned char* data);

//*************************************************************************
//模块操作函数
//*************************************************************************
void Module_State_Function(void);     
void Module_Soft_Reboot_Function(void);
void Module_Factory_Reset_Function(void);
void Hekr_Config_Function(void);
void Module_Set_Sleep_Function(void);
void Module_Weakup_Function(void);
void Module_Factory_Test_Function(void);
void Module_Firmware_Versions_Function(void);
void Module_ProdKey_Get_Function(void);

//*************************************************************************
//模块ProdKey设置函数
//*************************************************************************
void Set_ProdKey(unsigned char *ProdKey_16Byte_Set);

#endif
