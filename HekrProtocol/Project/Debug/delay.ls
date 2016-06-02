   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  15                     	bsct
  16  0000               _fac_us:
  17  0000 00            	dc.b	0
  58                     ; 4 void delay_init(unsigned char clk)
  58                     ; 5 {
  60                     	switch	.text
  61  0000               _delay_init:
  63  0000 88            	push	a
  64       00000000      OFST:	set	0
  67                     ; 6 	if(clk>16)
  69  0001 a111          	cp	a,#17
  70  0003 2506          	jrult	L72
  71                     ; 7 		fac_us=(16-4)/4;//24Mhz时,stm8大概19个周期为1us
  73  0005 35030000      	mov	_fac_us,#3
  75  0009 201c          	jra	L13
  76  000b               L72:
  77                     ; 8 	else if(clk>4)
  79  000b 7b01          	ld	a,(OFST+1,sp)
  80  000d a105          	cp	a,#5
  81  000f 2512          	jrult	L33
  82                     ; 9 		fac_us=(clk-4)/4; 
  84  0011 7b01          	ld	a,(OFST+1,sp)
  85  0013 5f            	clrw	x
  86  0014 97            	ld	xl,a
  87  0015 1d0004        	subw	x,#4
  88  0018 a604          	ld	a,#4
  89  001a cd0000        	call	c_sdivx
  91  001d 01            	rrwa	x,a
  92  001e b700          	ld	_fac_us,a
  93  0020 02            	rlwa	x,a
  95  0021 2004          	jra	L13
  96  0023               L33:
  97                     ; 11 		fac_us=1;
  99  0023 35010000      	mov	_fac_us,#1
 100  0027               L13:
 101                     ; 12 }
 104  0027 84            	pop	a
 105  0028 81            	ret
 139                     ; 14 void delay_us(unsigned int nus)
 139                     ; 15 {  
 140                     	switch	.text
 141  0029               _delay_us:
 145                     ; 17 	PUSH A            //1T,压栈
 148  0029 88            PUSH A            //1T,压栈
 150                     ; 18 	DELAY_XUS:         
 153  002a               DELAY_XUS:         
 155                     ; 19 	LD A,_fac_us      //1T,fac_us加载到累加器A
 158  002a b600          LD A,_fac_us      //1T,fac_us加载到累加器A
 160                     ; 20 	DELAY_US_1:      
 163  002c               DELAY_US_1:      
 165                     ; 21 	NOP               //1T,nop延时
 168  002c 9d            NOP               //1T,nop延时
 170                     ; 22 	DEC A             //1T,A--
 173  002d 4a            DEC A             //1T,A--
 175                     ; 23 	JRNE DELAY_US_1   //不等于0,则跳转(2T)到DELAY_US_1继续  执行,若等于0,则不跳转(1T).
 178  002e 26fc          JRNE DELAY_US_1   //不等于0,则跳转(2T)到DELAY_US_1继续  执行,若等于0,则不跳转(1T).
 180                     ; 24 	NOP               //1T,nop延时 
 183  0030 9d            NOP               //1T,nop延时 
 185                     ; 25 	DECW X            //1T,x--
 188  0031 5a            DECW X            //1T,x--
 190                     ; 26 	JRNE DELAY_XUS    // 不等于0,则跳转(2T)到DELAY_XUS继续  执行,若等于0,则不跳转(1T).
 193  0032 26f6          JRNE DELAY_XUS    // 不等于0,则跳转(2T)到DELAY_XUS继续  执行,若等于0,则不跳转(1T).
 195                     ; 27 	POP A             //1T,出栈
 198  0034 84            POP A             //1T,出栈
 200                     ; 29 }
 203  0035 81            	ret
 247                     ; 31 void delay_ms(unsigned int nms) 
 247                     ; 32 { 
 248                     	switch	.text
 249  0036               _delay_ms:
 251  0036 89            	pushw	x
 252  0037 88            	push	a
 253       00000001      OFST:	set	1
 256                     ; 34 	if(nms>65) 
 258  0038 a30042        	cpw	x,#66
 259  003b 2521          	jrult	L77
 260                     ; 36 		t=nms/65; 
 262  003d 90ae0041      	ldw	y,#65
 263  0041 65            	divw	x,y
 264  0042 01            	rrwa	x,a
 265  0043 6b01          	ld	(OFST+0,sp),a
 266  0045 02            	rlwa	x,a
 268  0046 2005          	jra	L501
 269  0048               L101:
 270                     ; 37 		while(t--)delay_us(65000); 
 272  0048 aefde8        	ldw	x,#65000
 273  004b addc          	call	_delay_us
 275  004d               L501:
 278  004d 7b01          	ld	a,(OFST+0,sp)
 279  004f 0a01          	dec	(OFST+0,sp)
 280  0051 4d            	tnz	a
 281  0052 26f4          	jrne	L101
 282                     ; 38 		nms=nms%65; 
 284  0054 1e02          	ldw	x,(OFST+1,sp)
 285  0056 90ae0041      	ldw	y,#65
 286  005a 65            	divw	x,y
 287  005b 51            	exgw	x,y
 288  005c 1f02          	ldw	(OFST+1,sp),x
 289  005e               L77:
 290                     ; 40 	delay_us(nms*1000); 
 292  005e 1e02          	ldw	x,(OFST+1,sp)
 293  0060 90ae03e8      	ldw	y,#1000
 294  0064 cd0000        	call	c_imul
 296  0067 adc0          	call	_delay_us
 298                     ; 41 }
 301  0069 5b03          	addw	sp,#3
 302  006b 81            	ret
 326                     	xdef	_fac_us
 327                     	xdef	_delay_ms
 328                     	xdef	_delay_us
 329                     	xdef	_delay_init
 330                     	xref.b	c_x
 349                     	xref	c_imul
 350                     	xref	c_sdivx
 351                     	end
