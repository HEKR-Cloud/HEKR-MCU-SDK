   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2467                     ; 18 void  UART1_Init(void)
2467                     ; 19 {   
2469                     	switch	.text
2470  0000               _UART1_Init:
2474                     ; 20 		UART1_CR1 = 0x00; //8bit
2476  0000 725f5234      	clr	_UART1_CR1
2477                     ; 21 		UART1_CR2 = 0x00;
2479  0004 725f5235      	clr	_UART1_CR2
2480                     ; 22 		UART1_CR3 = 0x00;//1 stop bit
2482  0008 725f5236      	clr	_UART1_CR3
2483                     ; 33 		UART1_BRR2=0x02;
2485  000c 35025233      	mov	_UART1_BRR2,#2
2486                     ; 34 		UART1_BRR1=0x68;
2488  0010 35685232      	mov	_UART1_BRR1,#104
2489                     ; 42 		UART1_CR2 = 0x2C;//enable REN and RIEN
2491  0014 352c5235      	mov	_UART1_CR2,#44
2492                     ; 43 }
2495  0018 81            	ret
2531                     ; 45 void UART1_SendChar(unsigned char ch)
2531                     ; 46 {
2532                     	switch	.text
2533  0019               _UART1_SendChar:
2535  0019 88            	push	a
2536       00000000      OFST:	set	0
2539  001a               L1261:
2540                     ; 47 	while((UART1_SR & 0x80) == 0x00);	//  若发送寄存器不空，则等待
2542  001a c65230        	ld	a,_UART1_SR
2543  001d a580          	bcp	a,#128
2544  001f 27f9          	jreq	L1261
2545                     ; 48 		UART1_DR = ch;										 // 将要发送的字符送到数据寄存器
2547  0021 7b01          	ld	a,(OFST+1,sp)
2548  0023 c75231        	ld	_UART1_DR,a
2549                     ; 49 }
2552  0026 84            	pop	a
2553  0027 81            	ret
2588                     ; 51 char putchar(char ch)
2588                     ; 52 {
2589                     	switch	.text
2590  0028               _putchar:
2592  0028 88            	push	a
2593       00000000      OFST:	set	0
2596                     ; 53 		UART1_SendChar(ch);
2598  0029 adee          	call	_UART1_SendChar
2600                     ; 54 		return ch;
2602  002b 7b01          	ld	a,(OFST+1,sp)
2605  002d 5b01          	addw	sp,#1
2606  002f 81            	ret
2619                     	xdef	_putchar
2620                     	xdef	_UART1_SendChar
2621                     	xdef	_UART1_Init
2640                     	end
