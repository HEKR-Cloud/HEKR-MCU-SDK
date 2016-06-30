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


//模块操作指令定义
typedef enum																					
{
	   Module_Statue			            = 0x01,    //状态查询
	   Module_Soft_Reboot             = 0x02,    //模块软重启
		 Module_Factory_Reset           = 0x03,    //恢复出厂
	   Hekr_Config                    = 0x04,    //一键配置
	   Module_Set_Sleep			          = 0x05,    //进入休眠
	   Module_Weakup                  = 0x06,    //休眠唤醒
		 Module_Factory_Test            = 0x20,    //进入厂测
	   Module_Firmware_Versions       = 0x10,    //版本查询
	   Module_ProdKey_Get             = 0x11,    //ProdKey查询
	   Module_Set_ProdKey             = 0x21    //ProdKey设置
			
}Module_Operation_TypeDef;


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
static unsigned char hekr_send_buffer[USER_MAX_LEN+HEKR_DATA_LEN];
static unsigned char module_status[10];
static unsigned char frame_no = 0;
static void (*hekr_send_btye)(unsigned char);

// 提供用户使用
ModuleStatusFrame *ModuleStatus = (ModuleStatusFrame*)&module_status;
unsigned char valid_data[USER_MAX_LEN];

//*************************************************************************
//Hekr 内部函数申明
//*************************************************************************

// Static Function
static void HekrSendByte(unsigned char ch);
static void HekrSendFrame(unsigned char *data);
static unsigned char SumCheckIsErr(unsigned char* data);
static void ErrResponse(unsigned char data);
static unsigned char SumCalculate(unsigned char* data);
static void HekrValidDataCopy(unsigned char* data);
static void HekrModuleStateCopy(unsigned char* data);

//*************************************************************************
//Hekr 函数定义
//*************************************************************************

// 用户函数
void HekrInit(void (*fun)(unsigned char))
{	
	hekr_send_btye = fun;
}

unsigned char HekrRecvDataHandle(unsigned char* data)
{
	//检查和校验
	if(SumCheckIsErr(data))
	{
		ErrResponse(ErrorSumCheck);
		return RecvDataSumCheckErr;
	}
	//确认帧类型
	switch(data[2])
	{
	case DeviceUploadType://MCU上传信息反馈 不需要处理 
	                        return MCU_UploadACK;
	case ModuleDownloadType://WIFI下传信息
	                        HekrSendFrame(data);
	                        HekrValidDataCopy(data);
	                        return ValidDataUpdate;
	case ModuleOperationType://Hekr模块状态
													if(data[1] != ModuleResponseFrameLength)
														return MCU_ControlModuleACK;
	                        HekrModuleStateCopy(data);
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

//模块状态查询函数
void Module_State_Function(void)
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_Statue;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//模块软复位函数
void Module_Soft_Reboot_Function(void)
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_Soft_Reboot;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//模块恢复出厂设置函数
void Module_Factory_Reset_Function()
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_Factory_Reset;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//模块进入配置模式函数
void Hekr_Config_Function()
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Hekr_Config;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//模块睡眠函数
void Module_Set_Sleep_Function()
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_Set_Sleep;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//模块睡眠唤醒函数
void Module_Weakup_Function()
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_Weakup;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//模块产测使能函数
void Module_Factory_Test_Function()
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_Factory_Test;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//固件版本查询函数
void Module_Firmware_Versions_Function()
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_Firmware_Versions;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//ProductKey查询函数
void Module_ProdKey_Get_Function()
{
	unsigned char CheckSum=0;
	unsigned char i;
	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};

	Frame_Data[3] = frame_no++;
	Frame_Data[4] = Module_ProdKey_Get;
			 
	for(i=0;i<6;i++)
			 CheckSum=CheckSum + Frame_Data[i];
	
	Frame_Data[6] = CheckSum;	
	
	HekrSendFrame(Frame_Data);
}

//产品秘钥设置函数
void Set_ProdKey(unsigned char *ProdKey_16Byte_Set)
{
	unsigned char CheckSum=0;
	unsigned char i;
  hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ProdKeyLenth;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = Module_Set_ProdKey;
	
	for(i=0;i<16;i++)						                            
			 hekr_send_buffer[i+5]=*(ProdKey_16Byte_Set+i);
			 
	for(i=0;i<21;i++)
			 CheckSum=CheckSum + hekr_send_buffer[i];
	
	hekr_send_buffer[21] = CheckSum;	
	
	HekrSendFrame(hekr_send_buffer);
}


// 内部函数
static void HekrSendByte(unsigned char ch)
{
	hekr_send_btye(ch);
}


static void HekrSendFrame(unsigned char *data)
{
	unsigned char len = data[1];
	unsigned char i = 0;
	data[len-1] = SumCalculate(data);
	for(i = 0 ; i < len ; i++)
	{
		HekrSendByte(data[i]);
	}
}

static unsigned char SumCheckIsErr(unsigned char* data)
{
	unsigned char temp = SumCalculate(data);
	unsigned char len = data[1] - 1;
	if(temp == data[len])
		return 0;
	return 1;
}

static unsigned char SumCalculate(unsigned char* data)
{
	unsigned char temp;
	unsigned char i;
	unsigned char len = data[1] - 1;
	temp = 0;
	for(i = 0;i < len; i++)
	{
			temp += data[i];
	}
	return temp;
}

static void ErrResponse(unsigned char data)
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ErrorFrameLength;
	hekr_send_buffer[2] = ErrorFrameType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = data;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

static void HekrValidDataCopy(unsigned char* data)
{
	unsigned char len,i;
	len = data[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		valid_data[i] = data[i+4];
}

static void HekrModuleStateCopy(unsigned char* data)
{
	unsigned char len,i;
	len = data[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		module_status[i] = data[i+4];
}


