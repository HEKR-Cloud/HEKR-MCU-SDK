/* MAIN.C file
 * 
 * 
 */

#include "stm8s103f.h"
#include "sys.h"
#include "delay.h"
#include "stm8_uart.h"
#include "hekr_protocol.h"
#include "stm8_eeprom.h"
#include "stm8_tim2pwm.h"
#include "stm8_tim1.h"
#include "led.h"
#include "bright_mode.h"

//串口接收数据
u8 RecvFlag = 0;
u8 RecvCount = 0;
u8 RecvBuffer[20];

//实际所需用户数据长度
u8 UserValidLen = 9;

void System_init(void);
void DataHandle(void);

main()
{
	//系统初始化
	System_init();

	//查询hekr模块状态
	HekrModuleControl(ModuleQuery);
	
	while (1)
	{
		// 透传协议数据处理
    DataHandle();
		
		// 如果ESP模块参数是配置模式 
    // 无级调光灯也是配置模式
    if(ModuleStatus->Mode == HekrConfig_Mode)
		{
			MCU_ConfigMode();
		}
	}
}


void System_init(void)
{
	//系统时钟初始化 内部16M
	System_Clock_init();
  //串口初始化 9600
	UART1_Init();
	//串口发送函数绑定
	HekrInit(UART1_SendChar);
	//16M主频延迟初始化
	delay_init(16);
	//通过上电次数选择模式 必须先初始化延迟 串口
	Bright_ModeInit();

	//PWM 初始化
	TIM2_Init();
	//亮度调整定时器
	TIM1_Init();
	_asm("rim");
}
 
void DataHandle(void)
{
	u8 temp;
  if(RecvFlag)
  {
    temp = HekrRecvDataHandle(RecvBuffer);
		// 处于配置模式下不处理接收到的用户数据
    if(ModuleStatus->Mode != HekrConfig_Mode)
    {
      //用户有效数据更新
      if(ValidDataUpdate == temp)
      {
				switch(valid_data[0])
				{
        // 查询无级调光灯状态
        case LED_Query:
              //保存当前数据
              valid_data[1] = led_open_flag;
              valid_data[3] = bright_set;
              valid_data[4] = colour_set;
              //上传用户数据
              HekrValidDataUpload(UserValidLen);break;
        // 无级调光灯状态开关控制
        case LED_PowerONOFF:
              LED_StateControl(valid_data[1]);break;
        // 总亮度控制
        case LED_Bright_Control:
              bright_set = valid_data[3];
              if(led_open_flag == 1)UpdateBright();
              break;
        // 色温控制
        case LED_Colour_Temperature:
              colour_set = valid_data[4];
              if(led_open_flag == 1)UpdateBright();
              break;
        default:break;
        }
      }
    }
    RecvFlag = 0;			
  }			
}
 

@far @interrupt void TIM1_IRQHandler(void)
{
  static u8 timing_delay = 0;

  if(clod_bright_update || warm_bright_update)
  {
    timing_delay++;
    if(20 == timing_delay) 
    {
      CurBrighControl();
      timing_delay = 0;
    }
  }
  TIM1_SR1 &= (~0x01);   
}
 
@far @interrupt void UART1_Recv_IRQHandler(void)
{
  unsigned char ch;
	static unsigned char TempFlag = 0;
  ch = UART1_DR;   
	if(ch == HEKR_FRAME_HEADER)
	{
		TempFlag = 1;
		RecvCount = 0;
	}
	if(TempFlag)
	{
		RecvBuffer[RecvCount++] = ch;
		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
		{
			RecvFlag = 1;
			TempFlag = 0;
			RecvCount = 0;
		}
	}
}
