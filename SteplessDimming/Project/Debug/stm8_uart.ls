   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
2456                     ; 18 void  UART1_Init(void)
2456                     ; 19 {   
2458                     	switch	.text
2459  0000               _UART1_Init:
2463                     ; 20 		UART1_CR1 = 0x00; //8bit
2465  0000 725f5234      	clr	_UART1_CR1
2466                     ; 21 		UART1_CR2 = 0x00;
2468  0004 725f5235      	clr	_UART1_CR2
2469                     ; 22 		UART1_CR3 = 0x00;//1 stop bit
2471  0008 725f5236      	clr	_UART1_CR3
2472                     ; 33 		UART1_BRR2=0x02;
2474  000c 35025233      	mov	_UART1_BRR2,#2
2475                     ; 34 		UART1_BRR1=0x68;
2477  0010 35685232      	mov	_UART1_BRR1,#104
2478                     ; 42 		UART1_CR2 = 0x2C;//enable REN and RIEN
2480  0014 352c5235      	mov	_UART1_CR2,#44
2481                     ; 43 }
2484  0018 81            	ret
2520                     ; 45 void UART1_SendChar(unsigned char ch)
2520                     ; 46 {
2521                     	switch	.text
2522  0019               _UART1_SendChar:
2524  0019 88            	push	a
2525       00000000      OFST:	set	0
2528  001a               L1261:
2529                     ; 47 	while((UART1_SR & 0x80) == 0x00);	//  若发送寄存器不空，则等待
2531  001a c65230        	ld	a,_UART1_SR
2532  001d a580          	bcp	a,#128
2533  001f 27f9          	jreq	L1261
2534                     ; 48 		UART1_DR = ch;										 // 将要发送的字符送到数据寄存器
2536  0021 7b01          	ld	a,(OFST+1,sp)
2537  0023 c75231        	ld	_UART1_DR,a
2538                     ; 49 }
2541  0026 84            	pop	a
2542  0027 81            	ret
2577                     ; 51 char putchar(char ch)
2577                     ; 52 {
2578                     	switch	.text
2579  0028               _putchar:
2581  0028 88            	push	a
2582       00000000      OFST:	set	0
2585                     ; 53 		UART1_SendChar(ch);
2587  0029 adee          	call	_UART1_SendChar
2589                     ; 54 		return ch;
2591  002b 7b01          	ld	a,(OFST+1,sp)
2594  002d 5b01          	addw	sp,#1
2595  002f 81            	ret
2608                     	xdef	_putchar
2609                     	xdef	_UART1_SendChar
2610                     	xdef	_UART1_Init
2629                     	end
