#include "led.h"
#include "delay.h"
#include "stm8_tim2pwm.h"


// 当前亮度是否需要更新到目标亮度 置1使能
u8 clod_bright_update = 0;
u8 warm_bright_update = 0;

// 当前亮度和设定亮度
u16 cur_clod_bright = 0;
u16 cur_warm_bright = 0;
u16 goal_clod_bright = 0;
u16 goal_warm_bright = 0;

//亮度色度设定
u8 bright_set = 0;
u8 colour_set = 0;

//灯具打开标志 1为打开 2为关闭 默认上电打开
u8 led_open_flag = 1;

//私有函数申明
static void LED_Close(void);
static void LED_Open(void);
static void UpdateColorTemp(void); 
void LED_WarmWhiteBrightSet(u16 dat);
void LED_ClodWhiteBrightSet(u16 dat);

//设定暖色灯亮度
void LED_WarmWhiteBrightSet(u16 dat)
{
  //cur_warm_bright = dat;
  TIM2_CH2_Duty(dat >> 8,dat);
}

//设定冷色灯亮度
void LED_ClodWhiteBrightSet(u16 dat)
{
  //cur_clod_bright = dat;
  TIM2_CH3_Duty(dat >> 8,dat);
}

//冷暖灯开关控制
void LED_StateControl(u8 dat)
{
  if(1 == dat)
  {
    LED_Open();
    led_open_flag = 1;
  }
  else
  {
    LED_Close();
    led_open_flag = 2;
  }
}

// 关闭LED
// 设置目标亮度为0
// 设置更新成当前亮度
static void LED_Close(void)
{
  goal_clod_bright = 0x0000;
  goal_warm_bright = 0x0000;
  clod_bright_update = 1;
  warm_bright_update = 1;
}

// 打开LED
// 获取亮度色温设定值
// 计算目标亮度
// 设置更新成当前亮度
static void LED_Open(void)
{
  UpdateBright();
}

// 跟据总亮度色温比例
// 计算暖色冷色灯目标亮度
static void UpdateColourTemp(void)            
{
    u16 temp = bright_set;
    u8 colour_temp;
    
    if(colour_set >0x80)
    {
        colour_temp =  0xFF - colour_set;
        if(temp < 0x80)
            temp = temp * colour_temp / 0x80;
        else
            temp = temp / 0x80 * colour_temp ;
        goal_clod_bright = (temp) * (temp);
    }
    else if (colour_set < 0x80)
    {
        colour_temp =  colour_set;
        if(temp < 0x80)
            temp = temp * colour_temp / 0x80;
        else
            temp = temp / 0x80 * colour_temp;
        goal_warm_bright = (temp) * (temp);
    }     
    else
    {
    }
}

// 计算目标总亮度
void UpdateBright(void)             
{
    if(!bright_set)
        return ;
    // 计算目标总亮度
    goal_clod_bright = goal_warm_bright = bright_set * bright_set;
    UpdateColourTemp();
    // 计算暖色冷色灯目标亮度
    clod_bright_update = 1;
    warm_bright_update = 1;
}

void CurBrighControl(void)
{
  u16 temp;
  if(clod_bright_update)
  {
    temp = cur_clod_bright * cur_clod_bright;
    if (temp == goal_clod_bright)
      clod_bright_update = 0;
    else if(temp > goal_clod_bright)
      cur_clod_bright--;
    else
      cur_clod_bright++;
    temp = cur_clod_bright * cur_clod_bright;
    LED_ClodWhiteBrightSet(temp);
  }
  if(warm_bright_update)
  {
    temp = cur_warm_bright * cur_warm_bright;
    if (temp == goal_warm_bright)
      warm_bright_update = 0;
    else if(temp > goal_warm_bright)
      cur_warm_bright--;
    else
      cur_warm_bright++;
    temp = cur_warm_bright * cur_warm_bright;
    LED_WarmWhiteBrightSet(temp);
  }
} 

void MCU_ConfigMode(void)
{
  static flag = 0;
  if(!clod_bright_update && !warm_bright_update)
  {
    delay_ms(300);
    if(flag++%2)
    {
      bright_set = 0x49;
      colour_set = 0xFF;
    }  
    else  
    {
      bright_set = 0x49;
      colour_set = 0x00;
    }
    UpdateBright();
  }
}


