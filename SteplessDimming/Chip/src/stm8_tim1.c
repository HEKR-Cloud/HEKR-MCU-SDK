#include "stm8_tim1.h"
#include "stm8s103f.h"

void TIM1_Init(void)
{
	TIM1_PSCRH = 0x00;
  TIM1_PSCRL = 0x10;
	TIM1_ARRH = 0x03;
	TIM1_ARRL = 0xE7;
	TIM1_IER = 0x01;
	TIM1_CR1 = 0x01;
}
