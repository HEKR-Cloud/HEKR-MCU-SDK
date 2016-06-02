   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  45                     ; 12 @far @interrupt void NonHandledInterrupt (void)
  45                     ; 13 {
  46                     	switch	.text
  47  0000               f_NonHandledInterrupt:
  51                     ; 17 	return;
  54  0000 80            	iret
  56                     .const:	section	.text
  57  0000               __vectab:
  58  0000 82            	dc.b	130
  60  0001 00            	dc.b	page(__stext)
  61  0002 0000          	dc.w	__stext
  62  0004 82            	dc.b	130
  64  0005 00            	dc.b	page(f_NonHandledInterrupt)
  65  0006 0000          	dc.w	f_NonHandledInterrupt
  66  0008 82            	dc.b	130
  68  0009 00            	dc.b	page(f_NonHandledInterrupt)
  69  000a 0000          	dc.w	f_NonHandledInterrupt
  70  000c 82            	dc.b	130
  72  000d 00            	dc.b	page(f_NonHandledInterrupt)
  73  000e 0000          	dc.w	f_NonHandledInterrupt
  74  0010 82            	dc.b	130
  76  0011 00            	dc.b	page(f_NonHandledInterrupt)
  77  0012 0000          	dc.w	f_NonHandledInterrupt
  78  0014 82            	dc.b	130
  80  0015 00            	dc.b	page(f_NonHandledInterrupt)
  81  0016 0000          	dc.w	f_NonHandledInterrupt
  82  0018 82            	dc.b	130
  84  0019 00            	dc.b	page(f_NonHandledInterrupt)
  85  001a 0000          	dc.w	f_NonHandledInterrupt
  86  001c 82            	dc.b	130
  88  001d 00            	dc.b	page(f_NonHandledInterrupt)
  89  001e 0000          	dc.w	f_NonHandledInterrupt
  90  0020 82            	dc.b	130
  92  0021 00            	dc.b	page(f_NonHandledInterrupt)
  93  0022 0000          	dc.w	f_NonHandledInterrupt
  94  0024 82            	dc.b	130
  96  0025 00            	dc.b	page(f_NonHandledInterrupt)
  97  0026 0000          	dc.w	f_NonHandledInterrupt
  98  0028 82            	dc.b	130
 100  0029 00            	dc.b	page(f_NonHandledInterrupt)
 101  002a 0000          	dc.w	f_NonHandledInterrupt
 102  002c 82            	dc.b	130
 104  002d 00            	dc.b	page(f_NonHandledInterrupt)
 105  002e 0000          	dc.w	f_NonHandledInterrupt
 106  0030 82            	dc.b	130
 108  0031 00            	dc.b	page(f_NonHandledInterrupt)
 109  0032 0000          	dc.w	f_NonHandledInterrupt
 110  0034 82            	dc.b	130
 112  0035 00            	dc.b	page(f_NonHandledInterrupt)
 113  0036 0000          	dc.w	f_NonHandledInterrupt
 114  0038 82            	dc.b	130
 116  0039 00            	dc.b	page(f_NonHandledInterrupt)
 117  003a 0000          	dc.w	f_NonHandledInterrupt
 118  003c 82            	dc.b	130
 120  003d 00            	dc.b	page(f_NonHandledInterrupt)
 121  003e 0000          	dc.w	f_NonHandledInterrupt
 122  0040 82            	dc.b	130
 124  0041 00            	dc.b	page(f_NonHandledInterrupt)
 125  0042 0000          	dc.w	f_NonHandledInterrupt
 126  0044 82            	dc.b	130
 128  0045 00            	dc.b	page(f_NonHandledInterrupt)
 129  0046 0000          	dc.w	f_NonHandledInterrupt
 130  0048 82            	dc.b	130
 132  0049 00            	dc.b	page(f_NonHandledInterrupt)
 133  004a 0000          	dc.w	f_NonHandledInterrupt
 134  004c 82            	dc.b	130
 136  004d 00            	dc.b	page(f_NonHandledInterrupt)
 137  004e 0000          	dc.w	f_NonHandledInterrupt
 138  0050 82            	dc.b	130
 140  0051 00            	dc.b	page(f_UART1_Recv_IRQHandler)
 141  0052 0000          	dc.w	f_UART1_Recv_IRQHandler
 142  0054 82            	dc.b	130
 144  0055 00            	dc.b	page(f_NonHandledInterrupt)
 145  0056 0000          	dc.w	f_NonHandledInterrupt
 146  0058 82            	dc.b	130
 148  0059 00            	dc.b	page(f_NonHandledInterrupt)
 149  005a 0000          	dc.w	f_NonHandledInterrupt
 150  005c 82            	dc.b	130
 152  005d 00            	dc.b	page(f_NonHandledInterrupt)
 153  005e 0000          	dc.w	f_NonHandledInterrupt
 154  0060 82            	dc.b	130
 156  0061 00            	dc.b	page(f_NonHandledInterrupt)
 157  0062 0000          	dc.w	f_NonHandledInterrupt
 158  0064 82            	dc.b	130
 160  0065 00            	dc.b	page(f_NonHandledInterrupt)
 161  0066 0000          	dc.w	f_NonHandledInterrupt
 162  0068 82            	dc.b	130
 164  0069 00            	dc.b	page(f_NonHandledInterrupt)
 165  006a 0000          	dc.w	f_NonHandledInterrupt
 166  006c 82            	dc.b	130
 168  006d 00            	dc.b	page(f_NonHandledInterrupt)
 169  006e 0000          	dc.w	f_NonHandledInterrupt
 170  0070 82            	dc.b	130
 172  0071 00            	dc.b	page(f_NonHandledInterrupt)
 173  0072 0000          	dc.w	f_NonHandledInterrupt
 174  0074 82            	dc.b	130
 176  0075 00            	dc.b	page(f_NonHandledInterrupt)
 177  0076 0000          	dc.w	f_NonHandledInterrupt
 178  0078 82            	dc.b	130
 180  0079 00            	dc.b	page(f_NonHandledInterrupt)
 181  007a 0000          	dc.w	f_NonHandledInterrupt
 182  007c 82            	dc.b	130
 184  007d 00            	dc.b	page(f_NonHandledInterrupt)
 185  007e 0000          	dc.w	f_NonHandledInterrupt
 236                     	xdef	__vectab
 237                     	xref	f_UART1_Recv_IRQHandler
 238                     	xref	__stext
 239                     	xdef	f_NonHandledInterrupt
 258                     	end
