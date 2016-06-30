#include "hekr_protocol.h"

//*************************************************************************
//Hekr 具体码值
//*************************************************************************

//通用帧头格式 
typedef struct
{
	unsigned char header;
	unsigned char length;
	unsigned char type;
	unsigned char number;
}GeneralHeader;


//Hekr各帧长度
typedef	enum
{
	ModuleQueryFrameLength = 0x07,
	ModuleResponseFrameLength = 0x0B,
	ErrorFrameLength = 0x07,
	ProdKeyLenth = 0x16
}AllFrameLength;

//Hekr各帧类型
typedef	enum
{
	DeviceUploadType = 0x01,
	ModuleDownloadType = 0x02,
	ModuleOperationType = 0xFE,
	ErrorFrameType = 0xFF
}AllFrameType;


//Hekr错误码取值
typedef	enum
{
	ErrorOperation = 0x01,
	ErrorSumCheck = 0x02,
	ErrorDataRange = 0x03,
	ErrorNoCMD = 0xFF
}AllErrorValue;



//模块查询帧格式
typedef struct
{
	//通用帧头
	GeneralHeader header;
	//有效数据
	unsigned char CMD;
	unsigned char Reserved;
	//和校验
	unsigned char SUM;
}ModuleQueryFrame; 


//错误帧格式
typedef struct
{
	//通用帧头
	GeneralHeader header;
	//有效数据
	unsigned char ErrorCode;
	unsigned char Reserved;
	//和校验
	unsigned char SUM;
}ErrorFrame; 

//*************************************************************************
//Hekr 定义变量
//*************************************************************************

// 内部数据
static unsigned char DATA_AREA hekr_send_buffer[USER_MAX_LEN+HEKR_DATA_LEN] = {0};
static unsigned char module_status[10] = {0};
static unsigned char frame_no = 0;
static void (*hekr_send_btye)(unsigned char);

// 提供用户使用
ModuleStatusFrame  *ModuleStatus = (ModuleStatusFrame*)&module_status;
unsigned char DATA_AREA valid_data[USER_MAX_LEN] = {0};

//*************************************************************************
//Hekr 内部函数申明 
//*************************************************************************

// Static Function
static void HekrSendByte(unsigned char ch);
static void HekrSendFrame(unsigned char DATA_AREA *dat);
static unsigned char SumCheckIsErr(unsigned char DATA_AREA *dat);
static void ErrResponse(unsigned char dat);
static unsigned char SumCalculate(unsigned char DATA_AREA *dat);
static void HekrValidDataCopy(unsigned char DATA_AREA *dat);
static void HekrModuleStateCopy(unsigned char DATA_AREA *dat);

//*************************************************************************
//Hekr 函数定义
//*************************************************************************

// 用户函数
void HekrInit(void (*fun)(unsigned char))
{	
	hekr_send_btye = fun;
}

unsigned char HekrRecvDataHandle(unsigned char DATA_AREA *dat)
{
	//检查和校验
	if(SumCheckIsErr(dat))
	{
		ErrResponse(ErrorSumCheck);
		return RecvDataSumCheckErr;
	}
	//确认帧类型
	switch(dat[2])
	{
	case DeviceUploadType://MCU上传信息反馈 不需要处理 
	                        return MCU_UploadACK;
	case ModuleDownloadType://WIFI下传信息
	                        HekrSendFrame(dat);
	                        HekrValidDataCopy(dat);
	                        return ValidDataUpdate;
	case ModuleOperationType://Hekr模块状态
													if(dat[1] != ModuleResponseFrameLength)
														return MCU_ControlModuleACK;
	                        HekrModuleStateCopy(dat);
	                        return HekrModuleStateUpdate;
	case ErrorFrameType://上一帧发送错误	
	                        return LastFrameSendErr;
	default:ErrResponse(ErrorNoCMD);break;
	}
	return RecvDataUseless;
}

void HekrValidDataUpload(unsigned char len)
{
	unsigned char i;
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = len + 5;
	hekr_send_buffer[2] = DeviceUploadType;
	hekr_send_buffer[3] = frame_no++;
	for(i = 0; i < len ; i++)
		hekr_send_buffer[i+4] = valid_data[i];
	HekrSendFrame(&hekr_send_buffer[0]);
}

//模块状态查询函数
void Module_State_Function(void)
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Statue;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//模块软复位函数
void Module_Soft_Reboot_Function(void)
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Soft_Reboot;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//模块恢复出厂设置函数
void Module_Factory_Reset_Function()
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Factory_Reset;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//模块进入配置模式函数
void Hekr_Config_Function()
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Hekr_Config;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//模块睡眠函数
void Module_Set_Sleep_Function()
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Set_Sleep;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//模块睡眠唤醒函数
void Module_Weakup_Function()
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Weakup;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//模块产测使能函数
void Module_Factory_Test_Function()
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Factory_Test;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//固件版本查询函数
void Module_Firmware_Versions_Function()
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Firmware_Versions;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//ProductKey查询函数
void Module_ProdKey_Get_Function()
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_ProdKey_Get;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

//产品秘钥设置函数
void Set_ProdKey(unsigned char *ProdKey_16Byte_Set)
{
	unsigned char i;
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ProdKeyLenth;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Set_ProdKey;

	for(i=0;i<16;i++)						                            
			 hekr_send_buffer[i+5]=*(ProdKey_16Byte_Set+i);
	
	HekrSendFrame(hekr_send_buffer);
}

// 内部函数
static void HekrSendByte(unsigned char ch)
{
	hekr_send_btye(ch);
}


static void HekrSendFrame(unsigned char DATA_AREA *dat)
{
	unsigned char len = dat[1];
	unsigned char i = 0;
	dat[len-1] = SumCalculate(dat);
	for(i = 0 ; i < len ; i++)
	{
		HekrSendByte(dat[i]);
	}
}

static unsigned char SumCheckIsErr(unsigned char DATA_AREA *dat)
{
	unsigned char temp = SumCalculate(dat);
	unsigned char len = dat[1] - 1;

	if(temp == dat[len])
		return 0;
	return 1;
}

static unsigned char SumCalculate(unsigned char DATA_AREA *dat)
{
	unsigned char temp;
	unsigned char i;
	unsigned char len = dat[1] - 1;

	for(temp = 0,i = 0;i < len; i++)
	{
		temp += dat[i];
	}

	return temp;
}

static void ErrResponse(unsigned char dat)
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ErrorFrameLength;
	hekr_send_buffer[2] = ErrorFrameType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = dat;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

static void HekrValidDataCopy(unsigned char DATA_AREA *dat)
{
	unsigned char len,i;
	len = dat[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		valid_data[i] = dat[i+4];
}

static void HekrModuleStateCopy(unsigned char DATA_AREA *dat)
{
	unsigned char len,i;
	len = dat[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		module_status[i] = dat[i+4];
}


