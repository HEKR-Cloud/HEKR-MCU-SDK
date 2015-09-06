   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
   4                     	bsct
   5  0000               _fac_us:
   6  0000 00            	dc.b	0
  47                     ; 4 void delay_init(unsigned char clk)
  47                     ; 5 {
  49                     	switch	.text
  50  0000               _delay_init:
  52  0000 88            	push	a
  53       00000000      OFST:	set	0
  56                     ; 6 	if(clk>16)
  58  0001 a111          	cp	a,#17
  59  0003 2506          	jrult	L72
  60                     ; 7 		fac_us=(16-4)/4;//24Mhz时,stm8大概19个周期为1us
  62  0005 35030000      	mov	_fac_us,#3
  64  0009 201c          	jra	L13
  65  000b               L72:
  66                     ; 8 	else if(clk>4)
  68  000b 7b01          	ld	a,(OFST+1,sp)
  69  000d a105          	cp	a,#5
  70  000f 2512          	jrult	L33
  71                     ; 9 		fac_us=(clk-4)/4; 
  73  0011 7b01          	ld	a,(OFST+1,sp)
  74  0013 5f            	clrw	x
  75  0014 97            	ld	xl,a
  76  0015 1d0004        	subw	x,#4
  77  0018 a604          	ld	a,#4
  78  001a cd0000        	call	c_sdivx
  80  001d 01            	rrwa	x,a
  81  001e b700          	ld	_fac_us,a
  82  0020 02            	rlwa	x,a
  84  0021 2004          	jra	L13
  85  0023               L33:
  86                     ; 11 		fac_us=1;
  88  0023 35010000      	mov	_fac_us,#1
  89  0027               L13:
  90                     ; 12 }
  93  0027 84            	pop	a
  94  0028 81            	ret
 128                     ; 14 void delay_us(unsigned int nus)
 128                     ; 15 {  
 129                     	switch	.text
 130  0029               _delay_us:
 134                     ; 17 	PUSH A            //1T,压栈
 137  0029 88            PUSH A            //1T,压栈
 139                     ; 18 	DELAY_XUS:         
 142  002a               DELAY_XUS:         
 144                     ; 19 	LD A,_fac_us      //1T,fac_us加载到累加器A
 147  002a b600          LD A,_fac_us      //1T,fac_us加载到累加器A
 149                     ; 20 	DELAY_US_1:      
 152  002c               DELAY_US_1:      
 154                     ; 21 	NOP               //1T,nop延时
 157  002c 9d            NOP               //1T,nop延时
 159                     ; 22 	DEC A             //1T,A--
 162  002d 4a            DEC A             //1T,A--
 164                     ; 23 	JRNE DELAY_US_1   //不等于0,则跳转(2T)到DELAY_US_1继续  执行,若等于0,则不跳转(1T).
 167  002e 26fc          JRNE DELAY_US_1   //不等于0,则跳转(2T)到DELAY_US_1继续  执行,若等于0,则不跳转(1T).
 169                     ; 24 	NOP               //1T,nop延时 
 172  0030 9d            NOP               //1T,nop延时 
 174                     ; 25 	DECW X            //1T,x--
 177  0031 5a            DECW X            //1T,x--
 179                     ; 26 	JRNE DELAY_XUS    // 不等于0,则跳转(2T)到DELAY_XUS继续  执行,若等于0,则不跳转(1T).
 182  0032 26f6          JRNE DELAY_XUS    // 不等于0,则跳转(2T)到DELAY_XUS继续  执行,若等于0,则不跳转(1T).
 184                     ; 27 	POP A             //1T,出栈
 187  0034 84            POP A             //1T,出栈
 189                     ; 29 }
 192  0035 81            	ret
 236                     ; 31 void delay_ms(unsigned int nms) 
 236                     ; 32 { 
 237                     	switch	.text
 238  0036               _delay_ms:
 240  0036 89            	pushw	x
 241  0037 88            	push	a
 242       00000001      OFST:	set	1
 245                     ; 34 	if(nms>65) 
 247  0038 a30042        	cpw	x,#66
 248  003b 251e          	jrult	L77
 249                     ; 36 		t=nms/65; 
 251  003d a641          	ld	a,#65
 252  003f 62            	div	x,a
 253  0040 01            	rrwa	x,a
 254  0041 6b01          	ld	(OFST+0,sp),a
 255  0043 02            	rlwa	x,a
 257  0044 2005          	jra	L501
 258  0046               L101:
 259                     ; 37 		while(t--)delay_us(65000); 
 261  0046 aefde8        	ldw	x,#65000
 262  0049 adde          	call	_delay_us
 264  004b               L501:
 267  004b 7b01          	ld	a,(OFST+0,sp)
 268  004d 0a01          	dec	(OFST+0,sp)
 269  004f 4d            	tnz	a
 270  0050 26f4          	jrne	L101
 271                     ; 38 		nms=nms%65; 
 273  0052 1e02          	ldw	x,(OFST+1,sp)
 274  0054 a641          	ld	a,#65
 275  0056 62            	div	x,a
 276  0057 5f            	clrw	x
 277  0058 97            	ld	xl,a
 278  0059 1f02          	ldw	(OFST+1,sp),x
 279  005b               L77:
 280                     ; 40 	delay_us(nms*1000); 
 282  005b 1e02          	ldw	x,(OFST+1,sp)
 283  005d 90ae03e8      	ldw	y,#1000
 284  0061 cd0000        	call	c_imul
 286  0064 adc3          	call	_delay_us
 288                     ; 41 }
 291  0066 5b03          	addw	sp,#3
 292  0068 81            	ret
 316                     	xdef	_fac_us
 317                     	xdef	_delay_ms
 318                     	xdef	_delay_us
 319                     	xdef	_delay_init
 338                     	xref	c_imul
 339                     	xref	c_sdivx
 340                     	end
