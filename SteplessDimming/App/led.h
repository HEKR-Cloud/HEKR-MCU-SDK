#ifndef _LED_H_
#define _LED_H_

#include "sys.h"

extern u8 clod_bright_update;
extern u8 warm_bright_update;

extern u16 cur_clod_bright;
extern u16 cur_warm_bright;
extern u16 goal_clod_bright;
extern u16 goal_warm_bright;

extern u8 bright_set;
extern u8 colour_set;

extern u8 led_open_flag;

/*智能照明控制命令码*/
typedef	enum
{
	LED_Query = 0x00,               //查询设备当前状态
	LED_PowerONOFF = 0x02,          //开关灯具
	LED_Bright_Control = 0x03,      //调整亮度到相应值
	LED_Colour_Temperature = 0x06   //调整色温到相应值
	
} LED_Order_Code;



void LED_StateControl(u8 dat);
void UpdateBright(void);
void CurBrighControl(void);
void MCU_ConfigMode(void);

#endif
