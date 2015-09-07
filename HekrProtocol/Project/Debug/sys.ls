   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4270                     ; 3 void System_Clock_init(void)
4270                     ; 4 {
4272                     	switch	.text
4273  0000               _System_Clock_init:
4277                     ; 6 	CLK_SWR = 0xE1; 
4279  0000 35e150c4      	mov	_CLK_SWR,#225
4280                     ; 8 	CLK_CKDIVR = 0x00; 
4282  0004 725f50c6      	clr	_CLK_CKDIVR
4283                     ; 10 }
4286  0008 81            	ret
4299                     	xdef	_System_Clock_init
4318                     	end
