   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
2459                     ; 4 void TIM2_Init(void)
2459                     ; 5 {
2461                     	switch	.text
2462  0000               _TIM2_Init:
2466                     ; 8   TIM2_ARRH = 0x3A;
2468  0000 353a530f      	mov	_TIM2_ARRH,#58
2469                     ; 9   TIM2_ARRL = 0x98;
2471  0004 35985310      	mov	_TIM2_ARRL,#152
2472                     ; 11   TIM2_CCMR2 = 0x78;
2474  0008 35785308      	mov	_TIM2_CCMR2,#120
2475                     ; 12   TIM2_CCMR3 = 0x78;
2477  000c 35785309      	mov	_TIM2_CCMR3,#120
2478                     ; 14   TIM2_CCER1 = 0x30;
2480  0010 3530530a      	mov	_TIM2_CCER1,#48
2481                     ; 15   TIM2_CCER2 = 0x03;
2483  0014 3503530b      	mov	_TIM2_CCER2,#3
2484                     ; 17   TIM2_IER = 0;
2486  0018 725f5303      	clr	_TIM2_IER
2487                     ; 18   TIM2_CR1 = 0x81;
2489  001c 35815300      	mov	_TIM2_CR1,#129
2490                     ; 19 }
2493  0020 81            	ret
2538                     ; 21 void TIM2_CH2_Duty(unsigned char H,unsigned char L)
2538                     ; 22 {
2539                     	switch	.text
2540  0021               _TIM2_CH2_Duty:
2544                     ; 23   TIM2_CCR2H = H;
2546  0021 9e            	ld	a,xh
2547  0022 c75313        	ld	_TIM2_CCR2H,a
2548                     ; 24   TIM2_CCR2L = L;	
2550  0025 9f            	ld	a,xl
2551  0026 c75314        	ld	_TIM2_CCR2L,a
2552                     ; 25 }
2555  0029 81            	ret
2600                     ; 27 void TIM2_CH3_Duty(unsigned char H,unsigned char L)
2600                     ; 28 {
2601                     	switch	.text
2602  002a               _TIM2_CH3_Duty:
2606                     ; 29   TIM2_CCR3H = H;
2608  002a 9e            	ld	a,xh
2609  002b c75315        	ld	_TIM2_CCR3H,a
2610                     ; 30   TIM2_CCR3L = L;	
2612  002e 9f            	ld	a,xl
2613  002f c75316        	ld	_TIM2_CCR3L,a
2614                     ; 31 }
2617  0032 81            	ret
2630                     	xdef	_TIM2_CH3_Duty
2631                     	xdef	_TIM2_CH2_Duty
2632                     	xdef	_TIM2_Init
2651                     	end
