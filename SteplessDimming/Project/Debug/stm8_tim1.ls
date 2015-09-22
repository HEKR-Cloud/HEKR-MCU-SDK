   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
2457                     ; 4 void TIM1_Init(void)
2457                     ; 5 {
2459                     	switch	.text
2460  0000               _TIM1_Init:
2464                     ; 6 	TIM1_PSCRH = 0x00;
2466  0000 725f5260      	clr	_TIM1_PSCRH
2467                     ; 7   TIM1_PSCRL = 0x10;
2469  0004 35105261      	mov	_TIM1_PSCRL,#16
2470                     ; 8 	TIM1_ARRH = 0x03;
2472  0008 35035262      	mov	_TIM1_ARRH,#3
2473                     ; 9 	TIM1_ARRL = 0xE7;
2475  000c 35e75263      	mov	_TIM1_ARRL,#231
2476                     ; 10 	TIM1_IER = 0x01;
2478  0010 35015254      	mov	_TIM1_IER,#1
2479                     ; 11 	TIM1_CR1 = 0x01;
2481  0014 35015250      	mov	_TIM1_CR1,#1
2482                     ; 12 }
2485  0018 81            	ret
2498                     	xdef	_TIM1_Init
2517                     	end
