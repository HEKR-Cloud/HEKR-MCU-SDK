#include "stm8s103f.h"
#include "stm8_tim2pwm.h"

void TIM2_Init(void)
{
  // 0x3FFF 65535
  // 0x3A98 15000
  // 0x2710 10000
  TIM2_ARRH = 0x27;
  TIM2_ARRL = 0x10;
  
  TIM2_CCMR2 = 0x78;
  TIM2_CCMR3 = 0x78;
  
  TIM2_CCER1 = 0x30;
  TIM2_CCER2 = 0x03;
  
  TIM2_IER = 0;
  TIM2_CR1 = 0x81;
}

void TIM2_CH2_Duty(unsigned char H,unsigned char L)
{
  TIM2_CCR2H = H;
  TIM2_CCR2L = L;	
}

void TIM2_CH3_Duty(unsigned char H,unsigned char L)
{
  TIM2_CCR3H = H;
  TIM2_CCR3L = L;	
}
