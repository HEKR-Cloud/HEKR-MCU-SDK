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
	ErrorFrameLength = 0x07
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
static unsigned char hekr_send_buffer[USER_MAX_LEN+HEKR_DATA_LEN] = {0};
static unsigned char module_status[10] = {0};
static unsigned char frame_no = 0;
static void (*hekr_send_btye)(unsigned char);

// 提供用户使用
ModuleStatusFrame *ModuleStatus = (ModuleStatusFrame*)&module_status;
unsigned char valid_data[USER_MAX_LEN] = {0};

//*************************************************************************
//Hekr 内部函数申明
//*************************************************************************

// Static Function
static void HekrSendByte(unsigned char ch);
static void HekrSendFrame(unsigned char *dat);
static unsigned char SumCheckIsErr(unsigned char* dat);
static void ErrResponse(unsigned char dat);
static unsigned char SumCalculate(unsigned char* dat);
static void HekrValidDataCopy(unsigned char* dat);
static void HekrModuleStateCopy(unsigned char* dat);

//*************************************************************************
//Hekr 函数定义
//*************************************************************************

// 用户函数
void HekrInit(void (*fun)(unsigned char))
{	
	hekr_send_btye = fun;
}

unsigned char HekrRecvDataHandle(unsigned char* dat)
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
	hekr_send_buffer[1] = len + 5;;
	hekr_send_buffer[2] = DeviceUploadType;
	hekr_send_buffer[3] = frame_no++;
	for(i = 0; i < len ; i++)
		hekr_send_buffer[i+4] = valid_data[i];
	HekrSendFrame(hekr_send_buffer);
}

void HekrModuleControl(unsigned char dat)
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = dat;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}


// 内部函数
static void HekrSendByte(unsigned char ch)
{
	hekr_send_btye(ch);
}


static void HekrSendFrame(unsigned char *dat)
{
	unsigned char len = dat[1];
	unsigned char i = 0;
	dat[len-1] = SumCalculate(dat);
	for(i = 0 ; i < len ; i++)
	{
		HekrSendByte(dat[i]);
	}
}

static unsigned char SumCheckIsErr(unsigned char* dat)
{
	unsigned char temp = SumCalculate(dat);
	unsigned char len = dat[1] - 1;
	if(temp == dat[len])
		return 0;
	return 1;
}

static unsigned char SumCalculate(unsigned char* dat)
{
	unsigned char temp;
	unsigned char i;
	unsigned char len = dat[1] - 1;
	temp = 0;
	for(i = 0;i < len; i++)
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

static void HekrValidDataCopy(unsigned char* dat)
{
	unsigned char len,i;
	len = dat[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		valid_data[i] = dat[i+4];
}

static void HekrModuleStateCopy(unsigned char* dat)
{
	unsigned char len,i;
	len = dat[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		module_status[i] = dat[i+4];
}


