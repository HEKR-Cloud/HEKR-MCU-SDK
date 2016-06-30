   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  15                     	bsct
  16  0000               L7_frame_no:
  17  0000 00            	dc.b	0
  18  0001               _ModuleStatus:
  19  0001 0002          	dc.w	L5_module_status
  62                     ; 121 void HekrInit(void (*fun)(unsigned char))
  62                     ; 122 {	
  64                     	switch	.text
  65  0000               _HekrInit:
  69                     ; 123 	hekr_send_btye = fun;
  71  0000 bf00          	ldw	L11_hekr_send_btye,x
  72                     ; 124 }
  75  0002 81            	ret
 115                     ; 126 unsigned char HekrRecvDataHandle(unsigned char* data)
 115                     ; 127 {
 116                     	switch	.text
 117  0003               _HekrRecvDataHandle:
 119  0003 89            	pushw	x
 120       00000000      OFST:	set	0
 123                     ; 129 	if(SumCheckIsErr(data))
 125  0004 cd037b        	call	L71_SumCheckIsErr
 127  0007 4d            	tnz	a
 128  0008 2709          	jreq	L501
 129                     ; 131 		ErrResponse(ErrorSumCheck);
 131  000a a602          	ld	a,#2
 132  000c cd03cb        	call	L12_ErrResponse
 134                     ; 132 		return RecvDataSumCheckErr;
 136  000f a601          	ld	a,#1
 138  0011 201a          	jra	L01
 139  0013               L501:
 140                     ; 135 	switch(data[2])
 142  0013 1e01          	ldw	x,(OFST+1,sp)
 143  0015 e602          	ld	a,(2,x)
 145                     ; 150 	default:ErrResponse(ErrorNoCMD);break;
 146  0017 4a            	dec	a
 147  0018 2711          	jreq	L55
 148  001a 4a            	dec	a
 149  001b 2712          	jreq	L75
 150  001d a0fc          	sub	a,#252
 151  001f 271c          	jreq	L16
 152  0021 4a            	dec	a
 153  0022 272e          	jreq	L36
 154  0024               L56:
 157  0024 a6ff          	ld	a,#255
 158  0026 cd03cb        	call	L12_ErrResponse
 162  0029 202b          	jra	L111
 163  002b               L55:
 164                     ; 137 	case DeviceUploadType://MCU上传信息反馈 不需要处理 
 164                     ; 138 	                        return MCU_UploadACK;
 166  002b a603          	ld	a,#3
 168  002d               L01:
 170  002d 85            	popw	x
 171  002e 81            	ret
 172  002f               L75:
 173                     ; 139 	case ModuleDownloadType://WIFI下传信息
 173                     ; 140 	                        HekrSendFrame(data);
 175  002f 1e01          	ldw	x,(OFST+1,sp)
 176  0031 cd0349        	call	L51_HekrSendFrame
 178                     ; 141 	                        HekrValidDataCopy(data);
 180  0034 1e01          	ldw	x,(OFST+1,sp)
 181  0036 cd03ec        	call	L52_HekrValidDataCopy
 183                     ; 142 	                        return ValidDataUpdate;
 185  0039 a604          	ld	a,#4
 187  003b 20f0          	jra	L01
 188  003d               L16:
 189                     ; 143 	case ModuleOperationType://Hekr模块状态
 189                     ; 144 													if(data[1] != ModuleResponseFrameLength)
 191  003d 1e01          	ldw	x,(OFST+1,sp)
 192  003f e601          	ld	a,(1,x)
 193  0041 a10b          	cp	a,#11
 194  0043 2704          	jreq	L311
 195                     ; 145 														return MCU_ControlModuleACK;
 197  0045 a607          	ld	a,#7
 199  0047 20e4          	jra	L01
 200  0049               L311:
 201                     ; 146 	                        HekrModuleStateCopy(data);
 203  0049 1e01          	ldw	x,(OFST+1,sp)
 204  004b cd0415        	call	L72_HekrModuleStateCopy
 206                     ; 147 	                        return HekrModuleStateUpdate;
 208  004e a606          	ld	a,#6
 210  0050 20db          	jra	L01
 211  0052               L36:
 212                     ; 148 	case ErrorFrameType://上一帧发送错误	
 212                     ; 149 	                        return LastFrameSendErr;
 214  0052 a602          	ld	a,#2
 216  0054 20d7          	jra	L01
 217  0056               L111:
 218                     ; 152 	return RecvDataUseless;
 220  0056 a605          	ld	a,#5
 222  0058 20d3          	jra	L01
 270                     ; 155 void HekrValidDataUpload(unsigned char len)
 270                     ; 156 {
 271                     	switch	.text
 272  005a               _HekrValidDataUpload:
 274  005a 88            	push	a
 275  005b 88            	push	a
 276       00000001      OFST:	set	1
 279                     ; 158 	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
 281  005c 3548000c      	mov	L3_hekr_send_buffer,#72
 282                     ; 159 	hekr_send_buffer[1] = len + 5;;
 284  0060 ab05          	add	a,#5
 285  0062 b70d          	ld	L3_hekr_send_buffer+1,a
 286                     ; 160 	hekr_send_buffer[2] = DeviceUploadType;
 289  0064 3501000e      	mov	L3_hekr_send_buffer+2,#1
 290                     ; 161 	hekr_send_buffer[3] = frame_no++;
 292  0068 b600          	ld	a,L7_frame_no
 293  006a 3c00          	inc	L7_frame_no
 294  006c b70f          	ld	L3_hekr_send_buffer+3,a
 295                     ; 162 	for(i = 0; i < len ; i++)
 297  006e 0f01          	clr	(OFST+0,sp)
 299  0070 200a          	jra	L341
 300  0072               L731:
 301                     ; 163 		hekr_send_buffer[i+4] = valid_data[i];
 303  0072 7b01          	ld	a,(OFST+0,sp)
 304  0074 5f            	clrw	x
 305  0075 97            	ld	xl,a
 306  0076 e675          	ld	a,(_valid_data,x)
 307  0078 e710          	ld	(L3_hekr_send_buffer+4,x),a
 308                     ; 162 	for(i = 0; i < len ; i++)
 310  007a 0c01          	inc	(OFST+0,sp)
 311  007c               L341:
 314  007c 7b01          	ld	a,(OFST+0,sp)
 315  007e 1102          	cp	a,(OFST+1,sp)
 316  0080 25f0          	jrult	L731
 317                     ; 164 	HekrSendFrame(hekr_send_buffer);
 319  0082 ae000c        	ldw	x,#L3_hekr_send_buffer
 320  0085 cd0349        	call	L51_HekrSendFrame
 322                     ; 165 }
 325  0088 85            	popw	x
 326  0089 81            	ret
 329                     .const:	section	.text
 330  0000               L741_Frame_Data:
 331  0000 48            	dc.b	72
 332  0001 07            	dc.b	7
 333  0002 fe            	dc.b	254
 334  0003 00            	dc.b	0
 335  0004 01            	dc.b	1
 336  0005 00            	dc.b	0
 337  0006 00            	dc.b	0
 391                     ; 168 void Module_State_Function(void)
 391                     ; 169 {
 392                     	switch	.text
 393  008a               _Module_State_Function:
 395  008a 5209          	subw	sp,#9
 396       00000009      OFST:	set	9
 399                     ; 170 	unsigned char CheckSum=0;
 401  008c 0f01          	clr	(OFST-8,sp)
 402                     ; 172 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 404  008e 96            	ldw	x,sp
 405  008f 1c0002        	addw	x,#OFST-7
 406  0092 90ae0000      	ldw	y,#L741_Frame_Data
 407  0096 a607          	ld	a,#7
 408  0098 cd0000        	call	c_xymvx
 410                     ; 174 	Frame_Data[3] = frame_no++;
 412  009b b600          	ld	a,L7_frame_no
 413  009d 3c00          	inc	L7_frame_no
 414  009f 6b05          	ld	(OFST-4,sp),a
 415                     ; 175 	Frame_Data[4] = Module_Statue;
 417  00a1 a601          	ld	a,#1
 418  00a3 6b06          	ld	(OFST-3,sp),a
 419                     ; 177 	for(i=0;i<6;i++)
 421  00a5 0f09          	clr	(OFST+0,sp)
 422  00a7               L771:
 423                     ; 178 			 CheckSum=CheckSum + Frame_Data[i];
 425  00a7 96            	ldw	x,sp
 426  00a8 1c0002        	addw	x,#OFST-7
 427  00ab 9f            	ld	a,xl
 428  00ac 5e            	swapw	x
 429  00ad 1b09          	add	a,(OFST+0,sp)
 430  00af 2401          	jrnc	L61
 431  00b1 5c            	incw	x
 432  00b2               L61:
 433  00b2 02            	rlwa	x,a
 434  00b3 7b01          	ld	a,(OFST-8,sp)
 435  00b5 fb            	add	a,(x)
 436  00b6 6b01          	ld	(OFST-8,sp),a
 437                     ; 177 	for(i=0;i<6;i++)
 439  00b8 0c09          	inc	(OFST+0,sp)
 442  00ba 7b09          	ld	a,(OFST+0,sp)
 443  00bc a106          	cp	a,#6
 444  00be 25e7          	jrult	L771
 445                     ; 180 	Frame_Data[6] = CheckSum;	
 447  00c0 7b01          	ld	a,(OFST-8,sp)
 448  00c2 6b08          	ld	(OFST-1,sp),a
 449                     ; 182 	HekrSendFrame(Frame_Data);
 451  00c4 96            	ldw	x,sp
 452  00c5 1c0002        	addw	x,#OFST-7
 453  00c8 cd0349        	call	L51_HekrSendFrame
 455                     ; 183 }
 458  00cb 5b09          	addw	sp,#9
 459  00cd 81            	ret
 462                     	switch	.const
 463  0007               L502_Frame_Data:
 464  0007 48            	dc.b	72
 465  0008 07            	dc.b	7
 466  0009 fe            	dc.b	254
 467  000a 00            	dc.b	0
 468  000b 01            	dc.b	1
 469  000c 00            	dc.b	0
 470  000d 00            	dc.b	0
 524                     ; 186 void Module_Soft_Reboot_Function(void)
 524                     ; 187 {
 525                     	switch	.text
 526  00ce               _Module_Soft_Reboot_Function:
 528  00ce 5209          	subw	sp,#9
 529       00000009      OFST:	set	9
 532                     ; 188 	unsigned char CheckSum=0;
 534  00d0 0f01          	clr	(OFST-8,sp)
 535                     ; 190 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 537  00d2 96            	ldw	x,sp
 538  00d3 1c0002        	addw	x,#OFST-7
 539  00d6 90ae0007      	ldw	y,#L502_Frame_Data
 540  00da a607          	ld	a,#7
 541  00dc cd0000        	call	c_xymvx
 543                     ; 192 	Frame_Data[3] = frame_no++;
 545  00df b600          	ld	a,L7_frame_no
 546  00e1 3c00          	inc	L7_frame_no
 547  00e3 6b05          	ld	(OFST-4,sp),a
 548                     ; 193 	Frame_Data[4] = Module_Soft_Reboot;
 550  00e5 a602          	ld	a,#2
 551  00e7 6b06          	ld	(OFST-3,sp),a
 552                     ; 195 	for(i=0;i<6;i++)
 554  00e9 0f09          	clr	(OFST+0,sp)
 555  00eb               L532:
 556                     ; 196 			 CheckSum=CheckSum + Frame_Data[i];
 558  00eb 96            	ldw	x,sp
 559  00ec 1c0002        	addw	x,#OFST-7
 560  00ef 9f            	ld	a,xl
 561  00f0 5e            	swapw	x
 562  00f1 1b09          	add	a,(OFST+0,sp)
 563  00f3 2401          	jrnc	L22
 564  00f5 5c            	incw	x
 565  00f6               L22:
 566  00f6 02            	rlwa	x,a
 567  00f7 7b01          	ld	a,(OFST-8,sp)
 568  00f9 fb            	add	a,(x)
 569  00fa 6b01          	ld	(OFST-8,sp),a
 570                     ; 195 	for(i=0;i<6;i++)
 572  00fc 0c09          	inc	(OFST+0,sp)
 575  00fe 7b09          	ld	a,(OFST+0,sp)
 576  0100 a106          	cp	a,#6
 577  0102 25e7          	jrult	L532
 578                     ; 198 	Frame_Data[6] = CheckSum;	
 580  0104 7b01          	ld	a,(OFST-8,sp)
 581  0106 6b08          	ld	(OFST-1,sp),a
 582                     ; 200 	HekrSendFrame(Frame_Data);
 584  0108 96            	ldw	x,sp
 585  0109 1c0002        	addw	x,#OFST-7
 586  010c cd0349        	call	L51_HekrSendFrame
 588                     ; 201 }
 591  010f 5b09          	addw	sp,#9
 592  0111 81            	ret
 595                     	switch	.const
 596  000e               L342_Frame_Data:
 597  000e 48            	dc.b	72
 598  000f 07            	dc.b	7
 599  0010 fe            	dc.b	254
 600  0011 00            	dc.b	0
 601  0012 01            	dc.b	1
 602  0013 00            	dc.b	0
 603  0014 00            	dc.b	0
 657                     ; 204 void Module_Factory_Reset_Function()
 657                     ; 205 {
 658                     	switch	.text
 659  0112               _Module_Factory_Reset_Function:
 661  0112 5209          	subw	sp,#9
 662       00000009      OFST:	set	9
 665                     ; 206 	unsigned char CheckSum=0;
 667  0114 0f01          	clr	(OFST-8,sp)
 668                     ; 208 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 670  0116 96            	ldw	x,sp
 671  0117 1c0002        	addw	x,#OFST-7
 672  011a 90ae000e      	ldw	y,#L342_Frame_Data
 673  011e a607          	ld	a,#7
 674  0120 cd0000        	call	c_xymvx
 676                     ; 210 	Frame_Data[3] = frame_no++;
 678  0123 b600          	ld	a,L7_frame_no
 679  0125 3c00          	inc	L7_frame_no
 680  0127 6b05          	ld	(OFST-4,sp),a
 681                     ; 211 	Frame_Data[4] = Module_Factory_Reset;
 683  0129 a603          	ld	a,#3
 684  012b 6b06          	ld	(OFST-3,sp),a
 685                     ; 213 	for(i=0;i<6;i++)
 687  012d 0f09          	clr	(OFST+0,sp)
 688  012f               L372:
 689                     ; 214 			 CheckSum=CheckSum + Frame_Data[i];
 691  012f 96            	ldw	x,sp
 692  0130 1c0002        	addw	x,#OFST-7
 693  0133 9f            	ld	a,xl
 694  0134 5e            	swapw	x
 695  0135 1b09          	add	a,(OFST+0,sp)
 696  0137 2401          	jrnc	L62
 697  0139 5c            	incw	x
 698  013a               L62:
 699  013a 02            	rlwa	x,a
 700  013b 7b01          	ld	a,(OFST-8,sp)
 701  013d fb            	add	a,(x)
 702  013e 6b01          	ld	(OFST-8,sp),a
 703                     ; 213 	for(i=0;i<6;i++)
 705  0140 0c09          	inc	(OFST+0,sp)
 708  0142 7b09          	ld	a,(OFST+0,sp)
 709  0144 a106          	cp	a,#6
 710  0146 25e7          	jrult	L372
 711                     ; 216 	Frame_Data[6] = CheckSum;	
 713  0148 7b01          	ld	a,(OFST-8,sp)
 714  014a 6b08          	ld	(OFST-1,sp),a
 715                     ; 218 	HekrSendFrame(Frame_Data);
 717  014c 96            	ldw	x,sp
 718  014d 1c0002        	addw	x,#OFST-7
 719  0150 cd0349        	call	L51_HekrSendFrame
 721                     ; 219 }
 724  0153 5b09          	addw	sp,#9
 725  0155 81            	ret
 728                     	switch	.const
 729  0015               L103_Frame_Data:
 730  0015 48            	dc.b	72
 731  0016 07            	dc.b	7
 732  0017 fe            	dc.b	254
 733  0018 00            	dc.b	0
 734  0019 01            	dc.b	1
 735  001a 00            	dc.b	0
 736  001b 00            	dc.b	0
 790                     ; 222 void Hekr_Config_Function()
 790                     ; 223 {
 791                     	switch	.text
 792  0156               _Hekr_Config_Function:
 794  0156 5209          	subw	sp,#9
 795       00000009      OFST:	set	9
 798                     ; 224 	unsigned char CheckSum=0;
 800  0158 0f01          	clr	(OFST-8,sp)
 801                     ; 226 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 803  015a 96            	ldw	x,sp
 804  015b 1c0002        	addw	x,#OFST-7
 805  015e 90ae0015      	ldw	y,#L103_Frame_Data
 806  0162 a607          	ld	a,#7
 807  0164 cd0000        	call	c_xymvx
 809                     ; 228 	Frame_Data[3] = frame_no++;
 811  0167 b600          	ld	a,L7_frame_no
 812  0169 3c00          	inc	L7_frame_no
 813  016b 6b05          	ld	(OFST-4,sp),a
 814                     ; 229 	Frame_Data[4] = Hekr_Config;
 816  016d a604          	ld	a,#4
 817  016f 6b06          	ld	(OFST-3,sp),a
 818                     ; 231 	for(i=0;i<6;i++)
 820  0171 0f09          	clr	(OFST+0,sp)
 821  0173               L133:
 822                     ; 232 			 CheckSum=CheckSum + Frame_Data[i];
 824  0173 96            	ldw	x,sp
 825  0174 1c0002        	addw	x,#OFST-7
 826  0177 9f            	ld	a,xl
 827  0178 5e            	swapw	x
 828  0179 1b09          	add	a,(OFST+0,sp)
 829  017b 2401          	jrnc	L23
 830  017d 5c            	incw	x
 831  017e               L23:
 832  017e 02            	rlwa	x,a
 833  017f 7b01          	ld	a,(OFST-8,sp)
 834  0181 fb            	add	a,(x)
 835  0182 6b01          	ld	(OFST-8,sp),a
 836                     ; 231 	for(i=0;i<6;i++)
 838  0184 0c09          	inc	(OFST+0,sp)
 841  0186 7b09          	ld	a,(OFST+0,sp)
 842  0188 a106          	cp	a,#6
 843  018a 25e7          	jrult	L133
 844                     ; 234 	Frame_Data[6] = CheckSum;	
 846  018c 7b01          	ld	a,(OFST-8,sp)
 847  018e 6b08          	ld	(OFST-1,sp),a
 848                     ; 236 	HekrSendFrame(Frame_Data);
 850  0190 96            	ldw	x,sp
 851  0191 1c0002        	addw	x,#OFST-7
 852  0194 cd0349        	call	L51_HekrSendFrame
 854                     ; 237 }
 857  0197 5b09          	addw	sp,#9
 858  0199 81            	ret
 861                     	switch	.const
 862  001c               L733_Frame_Data:
 863  001c 48            	dc.b	72
 864  001d 07            	dc.b	7
 865  001e fe            	dc.b	254
 866  001f 00            	dc.b	0
 867  0020 01            	dc.b	1
 868  0021 00            	dc.b	0
 869  0022 00            	dc.b	0
 923                     ; 240 void Module_Set_Sleep_Function()
 923                     ; 241 {
 924                     	switch	.text
 925  019a               _Module_Set_Sleep_Function:
 927  019a 5209          	subw	sp,#9
 928       00000009      OFST:	set	9
 931                     ; 242 	unsigned char CheckSum=0;
 933  019c 0f01          	clr	(OFST-8,sp)
 934                     ; 244 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 936  019e 96            	ldw	x,sp
 937  019f 1c0002        	addw	x,#OFST-7
 938  01a2 90ae001c      	ldw	y,#L733_Frame_Data
 939  01a6 a607          	ld	a,#7
 940  01a8 cd0000        	call	c_xymvx
 942                     ; 246 	Frame_Data[3] = frame_no++;
 944  01ab b600          	ld	a,L7_frame_no
 945  01ad 3c00          	inc	L7_frame_no
 946  01af 6b05          	ld	(OFST-4,sp),a
 947                     ; 247 	Frame_Data[4] = Module_Set_Sleep;
 949  01b1 a605          	ld	a,#5
 950  01b3 6b06          	ld	(OFST-3,sp),a
 951                     ; 249 	for(i=0;i<6;i++)
 953  01b5 0f09          	clr	(OFST+0,sp)
 954  01b7               L763:
 955                     ; 250 			 CheckSum=CheckSum + Frame_Data[i];
 957  01b7 96            	ldw	x,sp
 958  01b8 1c0002        	addw	x,#OFST-7
 959  01bb 9f            	ld	a,xl
 960  01bc 5e            	swapw	x
 961  01bd 1b09          	add	a,(OFST+0,sp)
 962  01bf 2401          	jrnc	L63
 963  01c1 5c            	incw	x
 964  01c2               L63:
 965  01c2 02            	rlwa	x,a
 966  01c3 7b01          	ld	a,(OFST-8,sp)
 967  01c5 fb            	add	a,(x)
 968  01c6 6b01          	ld	(OFST-8,sp),a
 969                     ; 249 	for(i=0;i<6;i++)
 971  01c8 0c09          	inc	(OFST+0,sp)
 974  01ca 7b09          	ld	a,(OFST+0,sp)
 975  01cc a106          	cp	a,#6
 976  01ce 25e7          	jrult	L763
 977                     ; 252 	Frame_Data[6] = CheckSum;	
 979  01d0 7b01          	ld	a,(OFST-8,sp)
 980  01d2 6b08          	ld	(OFST-1,sp),a
 981                     ; 254 	HekrSendFrame(Frame_Data);
 983  01d4 96            	ldw	x,sp
 984  01d5 1c0002        	addw	x,#OFST-7
 985  01d8 cd0349        	call	L51_HekrSendFrame
 987                     ; 255 }
 990  01db 5b09          	addw	sp,#9
 991  01dd 81            	ret
 994                     	switch	.const
 995  0023               L573_Frame_Data:
 996  0023 48            	dc.b	72
 997  0024 07            	dc.b	7
 998  0025 fe            	dc.b	254
 999  0026 00            	dc.b	0
1000  0027 01            	dc.b	1
1001  0028 00            	dc.b	0
1002  0029 00            	dc.b	0
1056                     ; 258 void Module_Weakup_Function()
1056                     ; 259 {
1057                     	switch	.text
1058  01de               _Module_Weakup_Function:
1060  01de 5209          	subw	sp,#9
1061       00000009      OFST:	set	9
1064                     ; 260 	unsigned char CheckSum=0;
1066  01e0 0f01          	clr	(OFST-8,sp)
1067                     ; 262 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1069  01e2 96            	ldw	x,sp
1070  01e3 1c0002        	addw	x,#OFST-7
1071  01e6 90ae0023      	ldw	y,#L573_Frame_Data
1072  01ea a607          	ld	a,#7
1073  01ec cd0000        	call	c_xymvx
1075                     ; 264 	Frame_Data[3] = frame_no++;
1077  01ef b600          	ld	a,L7_frame_no
1078  01f1 3c00          	inc	L7_frame_no
1079  01f3 6b05          	ld	(OFST-4,sp),a
1080                     ; 265 	Frame_Data[4] = Module_Weakup;
1082  01f5 a606          	ld	a,#6
1083  01f7 6b06          	ld	(OFST-3,sp),a
1084                     ; 267 	for(i=0;i<6;i++)
1086  01f9 0f09          	clr	(OFST+0,sp)
1087  01fb               L524:
1088                     ; 268 			 CheckSum=CheckSum + Frame_Data[i];
1090  01fb 96            	ldw	x,sp
1091  01fc 1c0002        	addw	x,#OFST-7
1092  01ff 9f            	ld	a,xl
1093  0200 5e            	swapw	x
1094  0201 1b09          	add	a,(OFST+0,sp)
1095  0203 2401          	jrnc	L24
1096  0205 5c            	incw	x
1097  0206               L24:
1098  0206 02            	rlwa	x,a
1099  0207 7b01          	ld	a,(OFST-8,sp)
1100  0209 fb            	add	a,(x)
1101  020a 6b01          	ld	(OFST-8,sp),a
1102                     ; 267 	for(i=0;i<6;i++)
1104  020c 0c09          	inc	(OFST+0,sp)
1107  020e 7b09          	ld	a,(OFST+0,sp)
1108  0210 a106          	cp	a,#6
1109  0212 25e7          	jrult	L524
1110                     ; 270 	Frame_Data[6] = CheckSum;	
1112  0214 7b01          	ld	a,(OFST-8,sp)
1113  0216 6b08          	ld	(OFST-1,sp),a
1114                     ; 272 	HekrSendFrame(Frame_Data);
1116  0218 96            	ldw	x,sp
1117  0219 1c0002        	addw	x,#OFST-7
1118  021c cd0349        	call	L51_HekrSendFrame
1120                     ; 273 }
1123  021f 5b09          	addw	sp,#9
1124  0221 81            	ret
1127                     	switch	.const
1128  002a               L334_Frame_Data:
1129  002a 48            	dc.b	72
1130  002b 07            	dc.b	7
1131  002c fe            	dc.b	254
1132  002d 00            	dc.b	0
1133  002e 01            	dc.b	1
1134  002f 00            	dc.b	0
1135  0030 00            	dc.b	0
1189                     ; 276 void Module_Factory_Test_Function()
1189                     ; 277 {
1190                     	switch	.text
1191  0222               _Module_Factory_Test_Function:
1193  0222 5209          	subw	sp,#9
1194       00000009      OFST:	set	9
1197                     ; 278 	unsigned char CheckSum=0;
1199  0224 0f01          	clr	(OFST-8,sp)
1200                     ; 280 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1202  0226 96            	ldw	x,sp
1203  0227 1c0002        	addw	x,#OFST-7
1204  022a 90ae002a      	ldw	y,#L334_Frame_Data
1205  022e a607          	ld	a,#7
1206  0230 cd0000        	call	c_xymvx
1208                     ; 282 	Frame_Data[3] = frame_no++;
1210  0233 b600          	ld	a,L7_frame_no
1211  0235 3c00          	inc	L7_frame_no
1212  0237 6b05          	ld	(OFST-4,sp),a
1213                     ; 283 	Frame_Data[4] = Module_Factory_Test;
1215  0239 a620          	ld	a,#32
1216  023b 6b06          	ld	(OFST-3,sp),a
1217                     ; 285 	for(i=0;i<6;i++)
1219  023d 0f09          	clr	(OFST+0,sp)
1220  023f               L364:
1221                     ; 286 			 CheckSum=CheckSum + Frame_Data[i];
1223  023f 96            	ldw	x,sp
1224  0240 1c0002        	addw	x,#OFST-7
1225  0243 9f            	ld	a,xl
1226  0244 5e            	swapw	x
1227  0245 1b09          	add	a,(OFST+0,sp)
1228  0247 2401          	jrnc	L64
1229  0249 5c            	incw	x
1230  024a               L64:
1231  024a 02            	rlwa	x,a
1232  024b 7b01          	ld	a,(OFST-8,sp)
1233  024d fb            	add	a,(x)
1234  024e 6b01          	ld	(OFST-8,sp),a
1235                     ; 285 	for(i=0;i<6;i++)
1237  0250 0c09          	inc	(OFST+0,sp)
1240  0252 7b09          	ld	a,(OFST+0,sp)
1241  0254 a106          	cp	a,#6
1242  0256 25e7          	jrult	L364
1243                     ; 288 	Frame_Data[6] = CheckSum;	
1245  0258 7b01          	ld	a,(OFST-8,sp)
1246  025a 6b08          	ld	(OFST-1,sp),a
1247                     ; 290 	HekrSendFrame(Frame_Data);
1249  025c 96            	ldw	x,sp
1250  025d 1c0002        	addw	x,#OFST-7
1251  0260 cd0349        	call	L51_HekrSendFrame
1253                     ; 291 }
1256  0263 5b09          	addw	sp,#9
1257  0265 81            	ret
1260                     	switch	.const
1261  0031               L174_Frame_Data:
1262  0031 48            	dc.b	72
1263  0032 07            	dc.b	7
1264  0033 fe            	dc.b	254
1265  0034 00            	dc.b	0
1266  0035 01            	dc.b	1
1267  0036 00            	dc.b	0
1268  0037 00            	dc.b	0
1322                     ; 294 void Module_Firmware_Versions_Function()
1322                     ; 295 {
1323                     	switch	.text
1324  0266               _Module_Firmware_Versions_Function:
1326  0266 5209          	subw	sp,#9
1327       00000009      OFST:	set	9
1330                     ; 296 	unsigned char CheckSum=0;
1332  0268 0f01          	clr	(OFST-8,sp)
1333                     ; 298 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1335  026a 96            	ldw	x,sp
1336  026b 1c0002        	addw	x,#OFST-7
1337  026e 90ae0031      	ldw	y,#L174_Frame_Data
1338  0272 a607          	ld	a,#7
1339  0274 cd0000        	call	c_xymvx
1341                     ; 300 	Frame_Data[3] = frame_no++;
1343  0277 b600          	ld	a,L7_frame_no
1344  0279 3c00          	inc	L7_frame_no
1345  027b 6b05          	ld	(OFST-4,sp),a
1346                     ; 301 	Frame_Data[4] = Module_Firmware_Versions;
1348  027d a610          	ld	a,#16
1349  027f 6b06          	ld	(OFST-3,sp),a
1350                     ; 303 	for(i=0;i<6;i++)
1352  0281 0f09          	clr	(OFST+0,sp)
1353  0283               L125:
1354                     ; 304 			 CheckSum=CheckSum + Frame_Data[i];
1356  0283 96            	ldw	x,sp
1357  0284 1c0002        	addw	x,#OFST-7
1358  0287 9f            	ld	a,xl
1359  0288 5e            	swapw	x
1360  0289 1b09          	add	a,(OFST+0,sp)
1361  028b 2401          	jrnc	L25
1362  028d 5c            	incw	x
1363  028e               L25:
1364  028e 02            	rlwa	x,a
1365  028f 7b01          	ld	a,(OFST-8,sp)
1366  0291 fb            	add	a,(x)
1367  0292 6b01          	ld	(OFST-8,sp),a
1368                     ; 303 	for(i=0;i<6;i++)
1370  0294 0c09          	inc	(OFST+0,sp)
1373  0296 7b09          	ld	a,(OFST+0,sp)
1374  0298 a106          	cp	a,#6
1375  029a 25e7          	jrult	L125
1376                     ; 306 	Frame_Data[6] = CheckSum;	
1378  029c 7b01          	ld	a,(OFST-8,sp)
1379  029e 6b08          	ld	(OFST-1,sp),a
1380                     ; 308 	HekrSendFrame(Frame_Data);
1382  02a0 96            	ldw	x,sp
1383  02a1 1c0002        	addw	x,#OFST-7
1384  02a4 cd0349        	call	L51_HekrSendFrame
1386                     ; 309 }
1389  02a7 5b09          	addw	sp,#9
1390  02a9 81            	ret
1393                     	switch	.const
1394  0038               L725_Frame_Data:
1395  0038 48            	dc.b	72
1396  0039 07            	dc.b	7
1397  003a fe            	dc.b	254
1398  003b 00            	dc.b	0
1399  003c 01            	dc.b	1
1400  003d 00            	dc.b	0
1401  003e 00            	dc.b	0
1455                     ; 312 void Module_ProdKey_Get_Function()
1455                     ; 313 {
1456                     	switch	.text
1457  02aa               _Module_ProdKey_Get_Function:
1459  02aa 5209          	subw	sp,#9
1460       00000009      OFST:	set	9
1463                     ; 314 	unsigned char CheckSum=0;
1465  02ac 0f01          	clr	(OFST-8,sp)
1466                     ; 316 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1468  02ae 96            	ldw	x,sp
1469  02af 1c0002        	addw	x,#OFST-7
1470  02b2 90ae0038      	ldw	y,#L725_Frame_Data
1471  02b6 a607          	ld	a,#7
1472  02b8 cd0000        	call	c_xymvx
1474                     ; 318 	Frame_Data[3] = frame_no++;
1476  02bb b600          	ld	a,L7_frame_no
1477  02bd 3c00          	inc	L7_frame_no
1478  02bf 6b05          	ld	(OFST-4,sp),a
1479                     ; 319 	Frame_Data[4] = Module_ProdKey_Get;
1481  02c1 a611          	ld	a,#17
1482  02c3 6b06          	ld	(OFST-3,sp),a
1483                     ; 321 	for(i=0;i<6;i++)
1485  02c5 0f09          	clr	(OFST+0,sp)
1486  02c7               L755:
1487                     ; 322 			 CheckSum=CheckSum + Frame_Data[i];
1489  02c7 96            	ldw	x,sp
1490  02c8 1c0002        	addw	x,#OFST-7
1491  02cb 9f            	ld	a,xl
1492  02cc 5e            	swapw	x
1493  02cd 1b09          	add	a,(OFST+0,sp)
1494  02cf 2401          	jrnc	L65
1495  02d1 5c            	incw	x
1496  02d2               L65:
1497  02d2 02            	rlwa	x,a
1498  02d3 7b01          	ld	a,(OFST-8,sp)
1499  02d5 fb            	add	a,(x)
1500  02d6 6b01          	ld	(OFST-8,sp),a
1501                     ; 321 	for(i=0;i<6;i++)
1503  02d8 0c09          	inc	(OFST+0,sp)
1506  02da 7b09          	ld	a,(OFST+0,sp)
1507  02dc a106          	cp	a,#6
1508  02de 25e7          	jrult	L755
1509                     ; 324 	Frame_Data[6] = CheckSum;	
1511  02e0 7b01          	ld	a,(OFST-8,sp)
1512  02e2 6b08          	ld	(OFST-1,sp),a
1513                     ; 326 	HekrSendFrame(Frame_Data);
1515  02e4 96            	ldw	x,sp
1516  02e5 1c0002        	addw	x,#OFST-7
1517  02e8 ad5f          	call	L51_HekrSendFrame
1519                     ; 327 }
1522  02ea 5b09          	addw	sp,#9
1523  02ec 81            	ret
1579                     ; 330 void Set_ProdKey(unsigned char *ProdKey_16Byte_Set)
1579                     ; 331 {
1580                     	switch	.text
1581  02ed               _Set_ProdKey:
1583  02ed 89            	pushw	x
1584  02ee 89            	pushw	x
1585       00000002      OFST:	set	2
1588                     ; 332 	unsigned char CheckSum=0;
1590  02ef 0f01          	clr	(OFST-1,sp)
1591                     ; 334   hekr_send_buffer[0] = HEKR_FRAME_HEADER;
1593  02f1 3548000c      	mov	L3_hekr_send_buffer,#72
1594                     ; 335 	hekr_send_buffer[1] = ProdKeyLenth;
1596  02f5 3516000d      	mov	L3_hekr_send_buffer+1,#22
1597                     ; 336 	hekr_send_buffer[2] = ModuleOperationType;
1599  02f9 35fe000e      	mov	L3_hekr_send_buffer+2,#254
1600                     ; 337 	hekr_send_buffer[3] = frame_no++;
1602  02fd b600          	ld	a,L7_frame_no
1603  02ff 3c00          	inc	L7_frame_no
1604  0301 b70f          	ld	L3_hekr_send_buffer+3,a
1605                     ; 338 	hekr_send_buffer[4] = Module_Set_ProdKey;
1607  0303 35210010      	mov	L3_hekr_send_buffer+4,#33
1608                     ; 340 	for(i=0;i<16;i++)						                            
1610  0307 0f02          	clr	(OFST+0,sp)
1611  0309               L316:
1612                     ; 341 			 hekr_send_buffer[i+5]=*(ProdKey_16Byte_Set+i);
1614  0309 7b02          	ld	a,(OFST+0,sp)
1615  030b 5f            	clrw	x
1616  030c 97            	ld	xl,a
1617  030d 89            	pushw	x
1618  030e 7b05          	ld	a,(OFST+3,sp)
1619  0310 97            	ld	xl,a
1620  0311 7b06          	ld	a,(OFST+4,sp)
1621  0313 1b04          	add	a,(OFST+2,sp)
1622  0315 2401          	jrnc	L26
1623  0317 5c            	incw	x
1624  0318               L26:
1625  0318 02            	rlwa	x,a
1626  0319 f6            	ld	a,(x)
1627  031a 85            	popw	x
1628  031b e711          	ld	(L3_hekr_send_buffer+5,x),a
1629                     ; 340 	for(i=0;i<16;i++)						                            
1631  031d 0c02          	inc	(OFST+0,sp)
1634  031f 7b02          	ld	a,(OFST+0,sp)
1635  0321 a110          	cp	a,#16
1636  0323 25e4          	jrult	L316
1637                     ; 343 	for(i=0;i<21;i++)
1639  0325 0f02          	clr	(OFST+0,sp)
1640  0327               L126:
1641                     ; 344 			 CheckSum=CheckSum + hekr_send_buffer[i];
1643  0327 7b02          	ld	a,(OFST+0,sp)
1644  0329 5f            	clrw	x
1645  032a 97            	ld	xl,a
1646  032b 7b01          	ld	a,(OFST-1,sp)
1647  032d eb0c          	add	a,(L3_hekr_send_buffer,x)
1648  032f 6b01          	ld	(OFST-1,sp),a
1649                     ; 343 	for(i=0;i<21;i++)
1651  0331 0c02          	inc	(OFST+0,sp)
1654  0333 7b02          	ld	a,(OFST+0,sp)
1655  0335 a115          	cp	a,#21
1656  0337 25ee          	jrult	L126
1657                     ; 346 	hekr_send_buffer[21] = CheckSum;	
1659  0339 7b01          	ld	a,(OFST-1,sp)
1660  033b b721          	ld	L3_hekr_send_buffer+21,a
1661                     ; 348 	HekrSendFrame(hekr_send_buffer);
1663  033d ae000c        	ldw	x,#L3_hekr_send_buffer
1664  0340 ad07          	call	L51_HekrSendFrame
1666                     ; 349 }
1669  0342 5b04          	addw	sp,#4
1670  0344 81            	ret
1705                     ; 353 static void HekrSendByte(unsigned char ch)
1705                     ; 354 {
1706                     	switch	.text
1707  0345               L31_HekrSendByte:
1711                     ; 355 	hekr_send_btye(ch);
1713  0345 92cd00        	call	[L11_hekr_send_btye.w]
1715                     ; 356 }
1718  0348 81            	ret
1773                     ; 359 static void HekrSendFrame(unsigned char *data)
1773                     ; 360 {
1774                     	switch	.text
1775  0349               L51_HekrSendFrame:
1777  0349 89            	pushw	x
1778  034a 89            	pushw	x
1779       00000002      OFST:	set	2
1782                     ; 361 	unsigned char len = data[1];
1784  034b e601          	ld	a,(1,x)
1785  034d 6b01          	ld	(OFST-1,sp),a
1786                     ; 362 	unsigned char i = 0;
1788                     ; 363 	data[len-1] = SumCalculate(data);
1790  034f 7b01          	ld	a,(OFST-1,sp)
1791  0351 5f            	clrw	x
1792  0352 97            	ld	xl,a
1793  0353 5a            	decw	x
1794  0354 72fb03        	addw	x,(OFST+1,sp)
1795  0357 89            	pushw	x
1796  0358 1e05          	ldw	x,(OFST+3,sp)
1797  035a ad44          	call	L32_SumCalculate
1799  035c 85            	popw	x
1800  035d f7            	ld	(x),a
1801                     ; 364 	for(i = 0 ; i < len ; i++)
1803  035e 0f02          	clr	(OFST+0,sp)
1805  0360 2010          	jra	L776
1806  0362               L376:
1807                     ; 366 		HekrSendByte(data[i]);
1809  0362 7b03          	ld	a,(OFST+1,sp)
1810  0364 97            	ld	xl,a
1811  0365 7b04          	ld	a,(OFST+2,sp)
1812  0367 1b02          	add	a,(OFST+0,sp)
1813  0369 2401          	jrnc	L07
1814  036b 5c            	incw	x
1815  036c               L07:
1816  036c 02            	rlwa	x,a
1817  036d f6            	ld	a,(x)
1818  036e add5          	call	L31_HekrSendByte
1820                     ; 364 	for(i = 0 ; i < len ; i++)
1822  0370 0c02          	inc	(OFST+0,sp)
1823  0372               L776:
1826  0372 7b02          	ld	a,(OFST+0,sp)
1827  0374 1101          	cp	a,(OFST-1,sp)
1828  0376 25ea          	jrult	L376
1829                     ; 368 }
1832  0378 5b04          	addw	sp,#4
1833  037a 81            	ret
1887                     ; 370 static unsigned char SumCheckIsErr(unsigned char* data)
1887                     ; 371 {
1888                     	switch	.text
1889  037b               L71_SumCheckIsErr:
1891  037b 89            	pushw	x
1892  037c 89            	pushw	x
1893       00000002      OFST:	set	2
1896                     ; 372 	unsigned char temp = SumCalculate(data);
1898  037d ad21          	call	L32_SumCalculate
1900  037f 6b01          	ld	(OFST-1,sp),a
1901                     ; 373 	unsigned char len = data[1] - 1;
1903  0381 1e03          	ldw	x,(OFST+1,sp)
1904  0383 e601          	ld	a,(1,x)
1905  0385 4a            	dec	a
1906  0386 6b02          	ld	(OFST+0,sp),a
1907                     ; 374 	if(temp == data[len])
1909  0388 7b03          	ld	a,(OFST+1,sp)
1910  038a 97            	ld	xl,a
1911  038b 7b04          	ld	a,(OFST+2,sp)
1912  038d 1b02          	add	a,(OFST+0,sp)
1913  038f 2401          	jrnc	L47
1914  0391 5c            	incw	x
1915  0392               L47:
1916  0392 02            	rlwa	x,a
1917  0393 f6            	ld	a,(x)
1918  0394 1101          	cp	a,(OFST-1,sp)
1919  0396 2603          	jrne	L137
1920                     ; 375 		return 0;
1922  0398 4f            	clr	a
1924  0399 2002          	jra	L67
1925  039b               L137:
1926                     ; 376 	return 1;
1928  039b a601          	ld	a,#1
1930  039d               L67:
1932  039d 5b04          	addw	sp,#4
1933  039f 81            	ret
1995                     ; 379 static unsigned char SumCalculate(unsigned char* data)
1995                     ; 380 {
1996                     	switch	.text
1997  03a0               L32_SumCalculate:
1999  03a0 89            	pushw	x
2000  03a1 5203          	subw	sp,#3
2001       00000003      OFST:	set	3
2004                     ; 383 	unsigned char len = data[1] - 1;
2006  03a3 e601          	ld	a,(1,x)
2007  03a5 4a            	dec	a
2008  03a6 6b01          	ld	(OFST-2,sp),a
2009                     ; 384 	temp = 0;
2011  03a8 0f02          	clr	(OFST-1,sp)
2012                     ; 385 	for(i = 0;i < len; i++)
2014  03aa 0f03          	clr	(OFST+0,sp)
2016  03ac 2012          	jra	L177
2017  03ae               L567:
2018                     ; 387 			temp += data[i];
2020  03ae 7b04          	ld	a,(OFST+1,sp)
2021  03b0 97            	ld	xl,a
2022  03b1 7b05          	ld	a,(OFST+2,sp)
2023  03b3 1b03          	add	a,(OFST+0,sp)
2024  03b5 2401          	jrnc	L201
2025  03b7 5c            	incw	x
2026  03b8               L201:
2027  03b8 02            	rlwa	x,a
2028  03b9 7b02          	ld	a,(OFST-1,sp)
2029  03bb fb            	add	a,(x)
2030  03bc 6b02          	ld	(OFST-1,sp),a
2031                     ; 385 	for(i = 0;i < len; i++)
2033  03be 0c03          	inc	(OFST+0,sp)
2034  03c0               L177:
2037  03c0 7b03          	ld	a,(OFST+0,sp)
2038  03c2 1101          	cp	a,(OFST-2,sp)
2039  03c4 25e8          	jrult	L567
2040                     ; 389 	return temp;
2042  03c6 7b02          	ld	a,(OFST-1,sp)
2045  03c8 5b05          	addw	sp,#5
2046  03ca 81            	ret
2083                     ; 392 static void ErrResponse(unsigned char data)
2083                     ; 393 {
2084                     	switch	.text
2085  03cb               L12_ErrResponse:
2087  03cb 88            	push	a
2088       00000000      OFST:	set	0
2091                     ; 394 	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
2093  03cc 3548000c      	mov	L3_hekr_send_buffer,#72
2094                     ; 395 	hekr_send_buffer[1] = ErrorFrameLength;
2096  03d0 3507000d      	mov	L3_hekr_send_buffer+1,#7
2097                     ; 396 	hekr_send_buffer[2] = ErrorFrameType;
2099  03d4 35ff000e      	mov	L3_hekr_send_buffer+2,#255
2100                     ; 397 	hekr_send_buffer[3] = frame_no++;
2102  03d8 b600          	ld	a,L7_frame_no
2103  03da 3c00          	inc	L7_frame_no
2104  03dc b70f          	ld	L3_hekr_send_buffer+3,a
2105                     ; 398 	hekr_send_buffer[4] = data;
2107  03de 7b01          	ld	a,(OFST+1,sp)
2108  03e0 b710          	ld	L3_hekr_send_buffer+4,a
2109                     ; 399 	hekr_send_buffer[5] = 0x00;
2111  03e2 3f11          	clr	L3_hekr_send_buffer+5
2112                     ; 400 	HekrSendFrame(hekr_send_buffer);
2114  03e4 ae000c        	ldw	x,#L3_hekr_send_buffer
2115  03e7 cd0349        	call	L51_HekrSendFrame
2117                     ; 401 }
2120  03ea 84            	pop	a
2121  03eb 81            	ret
2175                     ; 403 static void HekrValidDataCopy(unsigned char* data)
2175                     ; 404 {
2176                     	switch	.text
2177  03ec               L52_HekrValidDataCopy:
2179  03ec 89            	pushw	x
2180  03ed 89            	pushw	x
2181       00000002      OFST:	set	2
2184                     ; 406 	len = data[1]- HEKR_DATA_LEN;
2186  03ee e601          	ld	a,(1,x)
2187  03f0 a005          	sub	a,#5
2188  03f2 6b01          	ld	(OFST-1,sp),a
2189                     ; 407 	for(i = 0 ;i < len ; i++)
2191  03f4 0f02          	clr	(OFST+0,sp)
2193  03f6 2014          	jra	L5401
2194  03f8               L1401:
2195                     ; 408 		valid_data[i] = data[i+4];
2197  03f8 7b02          	ld	a,(OFST+0,sp)
2198  03fa 5f            	clrw	x
2199  03fb 97            	ld	xl,a
2200  03fc 7b02          	ld	a,(OFST+0,sp)
2201  03fe 905f          	clrw	y
2202  0400 9097          	ld	yl,a
2203  0402 72f903        	addw	y,(OFST+1,sp)
2204  0405 90e604        	ld	a,(4,y)
2205  0408 e775          	ld	(_valid_data,x),a
2206                     ; 407 	for(i = 0 ;i < len ; i++)
2208  040a 0c02          	inc	(OFST+0,sp)
2209  040c               L5401:
2212  040c 7b02          	ld	a,(OFST+0,sp)
2213  040e 1101          	cp	a,(OFST-1,sp)
2214  0410 25e6          	jrult	L1401
2215                     ; 409 }
2218  0412 5b04          	addw	sp,#4
2219  0414 81            	ret
2274                     ; 411 static void HekrModuleStateCopy(unsigned char* data)
2274                     ; 412 {
2275                     	switch	.text
2276  0415               L72_HekrModuleStateCopy:
2278  0415 89            	pushw	x
2279  0416 89            	pushw	x
2280       00000002      OFST:	set	2
2283                     ; 414 	len = data[1]- HEKR_DATA_LEN;
2285  0417 e601          	ld	a,(1,x)
2286  0419 a005          	sub	a,#5
2287  041b 6b01          	ld	(OFST-1,sp),a
2288                     ; 415 	for(i = 0 ;i < len ; i++)
2290  041d 0f02          	clr	(OFST+0,sp)
2292  041f 2014          	jra	L3011
2293  0421               L7701:
2294                     ; 416 		module_status[i] = data[i+4];
2296  0421 7b02          	ld	a,(OFST+0,sp)
2297  0423 5f            	clrw	x
2298  0424 97            	ld	xl,a
2299  0425 7b02          	ld	a,(OFST+0,sp)
2300  0427 905f          	clrw	y
2301  0429 9097          	ld	yl,a
2302  042b 72f903        	addw	y,(OFST+1,sp)
2303  042e 90e604        	ld	a,(4,y)
2304  0431 e702          	ld	(L5_module_status,x),a
2305                     ; 415 	for(i = 0 ;i < len ; i++)
2307  0433 0c02          	inc	(OFST+0,sp)
2308  0435               L3011:
2311  0435 7b02          	ld	a,(OFST+0,sp)
2312  0437 1101          	cp	a,(OFST-1,sp)
2313  0439 25e6          	jrult	L7701
2314                     ; 417 }
2317  043b 5b04          	addw	sp,#4
2318  043d 81            	ret
2444                     	switch	.ubsct
2445  0000               L11_hekr_send_btye:
2446  0000 0000          	ds.b	2
2447  0002               L5_module_status:
2448  0002 000000000000  	ds.b	10
2449  000c               L3_hekr_send_buffer:
2450  000c 000000000000  	ds.b	105
2451                     	xdef	_Set_ProdKey
2452                     	xdef	_Module_ProdKey_Get_Function
2453                     	xdef	_Module_Firmware_Versions_Function
2454                     	xdef	_Module_Factory_Test_Function
2455                     	xdef	_Module_Weakup_Function
2456                     	xdef	_Module_Set_Sleep_Function
2457                     	xdef	_Hekr_Config_Function
2458                     	xdef	_Module_Factory_Reset_Function
2459                     	xdef	_Module_Soft_Reboot_Function
2460                     	xdef	_Module_State_Function
2461                     	xdef	_HekrValidDataUpload
2462                     	xdef	_HekrRecvDataHandle
2463                     	xdef	_HekrInit
2464                     	xdef	_ModuleStatus
2465  0075               _valid_data:
2466  0075 000000000000  	ds.b	100
2467                     	xdef	_valid_data
2468                     	xref.b	c_x
2488                     	xref	c_xymvx
2489                     	end
