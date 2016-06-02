   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
4281                     ; 3 void System_Clock_init(void)
4281                     ; 4 {
4283                     	switch	.text
4284  0000               _System_Clock_init:
4288                     ; 6 	CLK_SWR = 0xE1; 
4290  0000 35e150c4      	mov	_CLK_SWR,#225
4291                     ; 8 	CLK_CKDIVR = 0x00; 
4293  0004 725f50c6      	clr	_CLK_CKDIVR
4294                     ; 10 }
4297  0008 81            	ret
4310                     	xdef	_System_Clock_init
4329                     	end
