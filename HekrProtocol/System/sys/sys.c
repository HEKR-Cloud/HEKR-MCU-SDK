#include "sys.h"

void System_Clock_init(void)
{
	//设定HSI 16M
	CLK_SWR = 0xE1; 
	//CPU 0 分频 系统 0分频
	CLK_CKDIVR = 0x00; 

}
