   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
  34                     ; 12 @far @interrupt void NonHandledInterrupt (void)
  34                     ; 13 {
  35                     	switch	.text
  36  0000               f_NonHandledInterrupt:
  41                     ; 17 	return;
  44  0000 80            	iret
  46                     .const:	section	.text
  47  0000               __vectab:
  48  0000 82            	dc.b	130
  50  0001 00            	dc.b	page(__stext)
  51  0002 0000          	dc.w	__stext
  52  0004 82            	dc.b	130
  54  0005 00            	dc.b	page(f_NonHandledInterrupt)
  55  0006 0000          	dc.w	f_NonHandledInterrupt
  56  0008 82            	dc.b	130
  58  0009 00            	dc.b	page(f_NonHandledInterrupt)
  59  000a 0000          	dc.w	f_NonHandledInterrupt
  60  000c 82            	dc.b	130
  62  000d 00            	dc.b	page(f_NonHandledInterrupt)
  63  000e 0000          	dc.w	f_NonHandledInterrupt
  64  0010 82            	dc.b	130
  66  0011 00            	dc.b	page(f_NonHandledInterrupt)
  67  0012 0000          	dc.w	f_NonHandledInterrupt
  68  0014 82            	dc.b	130
  70  0015 00            	dc.b	page(f_NonHandledInterrupt)
  71  0016 0000          	dc.w	f_NonHandledInterrupt
  72  0018 82            	dc.b	130
  74  0019 00            	dc.b	page(f_NonHandledInterrupt)
  75  001a 0000          	dc.w	f_NonHandledInterrupt
  76  001c 82            	dc.b	130
  78  001d 00            	dc.b	page(f_NonHandledInterrupt)
  79  001e 0000          	dc.w	f_NonHandledInterrupt
  80  0020 82            	dc.b	130
  82  0021 00            	dc.b	page(f_NonHandledInterrupt)
  83  0022 0000          	dc.w	f_NonHandledInterrupt
  84  0024 82            	dc.b	130
  86  0025 00            	dc.b	page(f_NonHandledInterrupt)
  87  0026 0000          	dc.w	f_NonHandledInterrupt
  88  0028 82            	dc.b	130
  90  0029 00            	dc.b	page(f_NonHandledInterrupt)
  91  002a 0000          	dc.w	f_NonHandledInterrupt
  92  002c 82            	dc.b	130
  94  002d 00            	dc.b	page(f_NonHandledInterrupt)
  95  002e 0000          	dc.w	f_NonHandledInterrupt
  96  0030 82            	dc.b	130
  98  0031 00            	dc.b	page(f_NonHandledInterrupt)
  99  0032 0000          	dc.w	f_NonHandledInterrupt
 100  0034 82            	dc.b	130
 102  0035 00            	dc.b	page(f_TIM1_IRQHandler)
 103  0036 0000          	dc.w	f_TIM1_IRQHandler
 104  0038 82            	dc.b	130
 106  0039 00            	dc.b	page(f_NonHandledInterrupt)
 107  003a 0000          	dc.w	f_NonHandledInterrupt
 108  003c 82            	dc.b	130
 110  003d 00            	dc.b	page(f_NonHandledInterrupt)
 111  003e 0000          	dc.w	f_NonHandledInterrupt
 112  0040 82            	dc.b	130
 114  0041 00            	dc.b	page(f_NonHandledInterrupt)
 115  0042 0000          	dc.w	f_NonHandledInterrupt
 116  0044 82            	dc.b	130
 118  0045 00            	dc.b	page(f_NonHandledInterrupt)
 119  0046 0000          	dc.w	f_NonHandledInterrupt
 120  0048 82            	dc.b	130
 122  0049 00            	dc.b	page(f_NonHandledInterrupt)
 123  004a 0000          	dc.w	f_NonHandledInterrupt
 124  004c 82            	dc.b	130
 126  004d 00            	dc.b	page(f_NonHandledInterrupt)
 127  004e 0000          	dc.w	f_NonHandledInterrupt
 128  0050 82            	dc.b	130
 130  0051 00            	dc.b	page(f_UART1_Recv_IRQHandler)
 131  0052 0000          	dc.w	f_UART1_Recv_IRQHandler
 132  0054 82            	dc.b	130
 134  0055 00            	dc.b	page(f_NonHandledInterrupt)
 135  0056 0000          	dc.w	f_NonHandledInterrupt
 136  0058 82            	dc.b	130
 138  0059 00            	dc.b	page(f_NonHandledInterrupt)
 139  005a 0000          	dc.w	f_NonHandledInterrupt
 140  005c 82            	dc.b	130
 142  005d 00            	dc.b	page(f_NonHandledInterrupt)
 143  005e 0000          	dc.w	f_NonHandledInterrupt
 144  0060 82            	dc.b	130
 146  0061 00            	dc.b	page(f_NonHandledInterrupt)
 147  0062 0000          	dc.w	f_NonHandledInterrupt
 148  0064 82            	dc.b	130
 150  0065 00            	dc.b	page(f_NonHandledInterrupt)
 151  0066 0000          	dc.w	f_NonHandledInterrupt
 152  0068 82            	dc.b	130
 154  0069 00            	dc.b	page(f_NonHandledInterrupt)
 155  006a 0000          	dc.w	f_NonHandledInterrupt
 156  006c 82            	dc.b	130
 158  006d 00            	dc.b	page(f_NonHandledInterrupt)
 159  006e 0000          	dc.w	f_NonHandledInterrupt
 160  0070 82            	dc.b	130
 162  0071 00            	dc.b	page(f_NonHandledInterrupt)
 163  0072 0000          	dc.w	f_NonHandledInterrupt
 164  0074 82            	dc.b	130
 166  0075 00            	dc.b	page(f_NonHandledInterrupt)
 167  0076 0000          	dc.w	f_NonHandledInterrupt
 168  0078 82            	dc.b	130
 170  0079 00            	dc.b	page(f_NonHandledInterrupt)
 171  007a 0000          	dc.w	f_NonHandledInterrupt
 172  007c 82            	dc.b	130
 174  007d 00            	dc.b	page(f_NonHandledInterrupt)
 175  007e 0000          	dc.w	f_NonHandledInterrupt
 226                     	xdef	__vectab
 227                     	xref	f_TIM1_IRQHandler
 228                     	xref	f_UART1_Recv_IRQHandler
 229                     	xref	__stext
 230                     	xdef	f_NonHandledInterrupt
 249                     	end
