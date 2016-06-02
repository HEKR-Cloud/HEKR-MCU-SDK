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
 125  0004 cd039c        	call	L71_SumCheckIsErr
 127  0007 4d            	tnz	a
 128  0008 2709          	jreq	L501
 129                     ; 131 		ErrResponse(ErrorSumCheck);
 131  000a a602          	ld	a,#2
 132  000c cd03ec        	call	L12_ErrResponse
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
 158  0026 cd03ec        	call	L12_ErrResponse
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
 176  0031 cd036a        	call	L51_HekrSendFrame
 178                     ; 141 	                        HekrValidDataCopy(data);
 180  0034 1e01          	ldw	x,(OFST+1,sp)
 181  0036 cd040d        	call	L52_HekrValidDataCopy
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
 204  004b cd0436        	call	L72_HekrModuleStateCopy
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
 320  0085 cd036a        	call	L51_HekrSendFrame
 322                     ; 165 }
 325  0088 85            	popw	x
 326  0089 81            	ret
 363                     ; 167 void HekrModuleControl(unsigned char data)
 363                     ; 168 {
 364                     	switch	.text
 365  008a               _HekrModuleControl:
 367  008a 88            	push	a
 368       00000000      OFST:	set	0
 371                     ; 169 	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
 373  008b 3548000c      	mov	L3_hekr_send_buffer,#72
 374                     ; 170 	hekr_send_buffer[1] = ModuleQueryFrameLength;
 376  008f 3507000d      	mov	L3_hekr_send_buffer+1,#7
 377                     ; 171 	hekr_send_buffer[2] = ModuleOperationType;
 379  0093 35fe000e      	mov	L3_hekr_send_buffer+2,#254
 380                     ; 172 	hekr_send_buffer[3] = frame_no++;
 382  0097 b600          	ld	a,L7_frame_no
 383  0099 3c00          	inc	L7_frame_no
 384  009b b70f          	ld	L3_hekr_send_buffer+3,a
 385                     ; 173 	hekr_send_buffer[4] = data;
 387  009d 7b01          	ld	a,(OFST+1,sp)
 388  009f b710          	ld	L3_hekr_send_buffer+4,a
 389                     ; 174 	hekr_send_buffer[5] = 0x00;
 391  00a1 3f11          	clr	L3_hekr_send_buffer+5
 392                     ; 175 	HekrSendFrame(hekr_send_buffer);
 394  00a3 ae000c        	ldw	x,#L3_hekr_send_buffer
 395  00a6 cd036a        	call	L51_HekrSendFrame
 397                     ; 176 }
 400  00a9 84            	pop	a
 401  00aa 81            	ret
 404                     .const:	section	.text
 405  0000               L561_Frame_Data:
 406  0000 48            	dc.b	72
 407  0001 07            	dc.b	7
 408  0002 fe            	dc.b	254
 409  0003 00            	dc.b	0
 410  0004 01            	dc.b	1
 411  0005 00            	dc.b	0
 412  0006 00            	dc.b	0
 466                     ; 179 void Module_State_Function(void)
 466                     ; 180 {
 467                     	switch	.text
 468  00ab               _Module_State_Function:
 470  00ab 5209          	subw	sp,#9
 471       00000009      OFST:	set	9
 474                     ; 181 	unsigned char CheckSum=0;
 476  00ad 0f01          	clr	(OFST-8,sp)
 477                     ; 183 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 479  00af 96            	ldw	x,sp
 480  00b0 1c0002        	addw	x,#OFST-7
 481  00b3 90ae0000      	ldw	y,#L561_Frame_Data
 482  00b7 a607          	ld	a,#7
 483  00b9 cd0000        	call	c_xymvx
 485                     ; 185 	Frame_Data[3] = frame_no++;
 487  00bc b600          	ld	a,L7_frame_no
 488  00be 3c00          	inc	L7_frame_no
 489  00c0 6b05          	ld	(OFST-4,sp),a
 490                     ; 186 	Frame_Data[4] = Module_Statue;
 492  00c2 a601          	ld	a,#1
 493  00c4 6b06          	ld	(OFST-3,sp),a
 494                     ; 188 	for(i=0;i<6;i++)
 496  00c6 0f09          	clr	(OFST+0,sp)
 497  00c8               L512:
 498                     ; 189 			 CheckSum=CheckSum + Frame_Data[i];
 500  00c8 96            	ldw	x,sp
 501  00c9 1c0002        	addw	x,#OFST-7
 502  00cc 9f            	ld	a,xl
 503  00cd 5e            	swapw	x
 504  00ce 1b09          	add	a,(OFST+0,sp)
 505  00d0 2401          	jrnc	L02
 506  00d2 5c            	incw	x
 507  00d3               L02:
 508  00d3 02            	rlwa	x,a
 509  00d4 7b01          	ld	a,(OFST-8,sp)
 510  00d6 fb            	add	a,(x)
 511  00d7 6b01          	ld	(OFST-8,sp),a
 512                     ; 188 	for(i=0;i<6;i++)
 514  00d9 0c09          	inc	(OFST+0,sp)
 517  00db 7b09          	ld	a,(OFST+0,sp)
 518  00dd a106          	cp	a,#6
 519  00df 25e7          	jrult	L512
 520                     ; 191 	Frame_Data[6] = CheckSum;	
 522  00e1 7b01          	ld	a,(OFST-8,sp)
 523  00e3 6b08          	ld	(OFST-1,sp),a
 524                     ; 193 	HekrSendFrame(Frame_Data);
 526  00e5 96            	ldw	x,sp
 527  00e6 1c0002        	addw	x,#OFST-7
 528  00e9 cd036a        	call	L51_HekrSendFrame
 530                     ; 194 }
 533  00ec 5b09          	addw	sp,#9
 534  00ee 81            	ret
 537                     	switch	.const
 538  0007               L322_Frame_Data:
 539  0007 48            	dc.b	72
 540  0008 07            	dc.b	7
 541  0009 fe            	dc.b	254
 542  000a 00            	dc.b	0
 543  000b 01            	dc.b	1
 544  000c 00            	dc.b	0
 545  000d 00            	dc.b	0
 599                     ; 197 void Module_Soft_Reboot_Function(void)
 599                     ; 198 {
 600                     	switch	.text
 601  00ef               _Module_Soft_Reboot_Function:
 603  00ef 5209          	subw	sp,#9
 604       00000009      OFST:	set	9
 607                     ; 199 	unsigned char CheckSum=0;
 609  00f1 0f01          	clr	(OFST-8,sp)
 610                     ; 201 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 612  00f3 96            	ldw	x,sp
 613  00f4 1c0002        	addw	x,#OFST-7
 614  00f7 90ae0007      	ldw	y,#L322_Frame_Data
 615  00fb a607          	ld	a,#7
 616  00fd cd0000        	call	c_xymvx
 618                     ; 203 	Frame_Data[3] = frame_no++;
 620  0100 b600          	ld	a,L7_frame_no
 621  0102 3c00          	inc	L7_frame_no
 622  0104 6b05          	ld	(OFST-4,sp),a
 623                     ; 204 	Frame_Data[4] = Module_Soft_Reboot;
 625  0106 a602          	ld	a,#2
 626  0108 6b06          	ld	(OFST-3,sp),a
 627                     ; 206 	for(i=0;i<6;i++)
 629  010a 0f09          	clr	(OFST+0,sp)
 630  010c               L352:
 631                     ; 207 			 CheckSum=CheckSum + Frame_Data[i];
 633  010c 96            	ldw	x,sp
 634  010d 1c0002        	addw	x,#OFST-7
 635  0110 9f            	ld	a,xl
 636  0111 5e            	swapw	x
 637  0112 1b09          	add	a,(OFST+0,sp)
 638  0114 2401          	jrnc	L42
 639  0116 5c            	incw	x
 640  0117               L42:
 641  0117 02            	rlwa	x,a
 642  0118 7b01          	ld	a,(OFST-8,sp)
 643  011a fb            	add	a,(x)
 644  011b 6b01          	ld	(OFST-8,sp),a
 645                     ; 206 	for(i=0;i<6;i++)
 647  011d 0c09          	inc	(OFST+0,sp)
 650  011f 7b09          	ld	a,(OFST+0,sp)
 651  0121 a106          	cp	a,#6
 652  0123 25e7          	jrult	L352
 653                     ; 209 	Frame_Data[6] = CheckSum;	
 655  0125 7b01          	ld	a,(OFST-8,sp)
 656  0127 6b08          	ld	(OFST-1,sp),a
 657                     ; 211 	HekrSendFrame(Frame_Data);
 659  0129 96            	ldw	x,sp
 660  012a 1c0002        	addw	x,#OFST-7
 661  012d cd036a        	call	L51_HekrSendFrame
 663                     ; 212 }
 666  0130 5b09          	addw	sp,#9
 667  0132 81            	ret
 670                     	switch	.const
 671  000e               L162_Frame_Data:
 672  000e 48            	dc.b	72
 673  000f 07            	dc.b	7
 674  0010 fe            	dc.b	254
 675  0011 00            	dc.b	0
 676  0012 01            	dc.b	1
 677  0013 00            	dc.b	0
 678  0014 00            	dc.b	0
 732                     ; 215 void Module_Factory_Reset_Function()
 732                     ; 216 {
 733                     	switch	.text
 734  0133               _Module_Factory_Reset_Function:
 736  0133 5209          	subw	sp,#9
 737       00000009      OFST:	set	9
 740                     ; 217 	unsigned char CheckSum=0;
 742  0135 0f01          	clr	(OFST-8,sp)
 743                     ; 219 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 745  0137 96            	ldw	x,sp
 746  0138 1c0002        	addw	x,#OFST-7
 747  013b 90ae000e      	ldw	y,#L162_Frame_Data
 748  013f a607          	ld	a,#7
 749  0141 cd0000        	call	c_xymvx
 751                     ; 221 	Frame_Data[3] = frame_no++;
 753  0144 b600          	ld	a,L7_frame_no
 754  0146 3c00          	inc	L7_frame_no
 755  0148 6b05          	ld	(OFST-4,sp),a
 756                     ; 222 	Frame_Data[4] = Module_Factory_Reset;
 758  014a a603          	ld	a,#3
 759  014c 6b06          	ld	(OFST-3,sp),a
 760                     ; 224 	for(i=0;i<6;i++)
 762  014e 0f09          	clr	(OFST+0,sp)
 763  0150               L113:
 764                     ; 225 			 CheckSum=CheckSum + Frame_Data[i];
 766  0150 96            	ldw	x,sp
 767  0151 1c0002        	addw	x,#OFST-7
 768  0154 9f            	ld	a,xl
 769  0155 5e            	swapw	x
 770  0156 1b09          	add	a,(OFST+0,sp)
 771  0158 2401          	jrnc	L03
 772  015a 5c            	incw	x
 773  015b               L03:
 774  015b 02            	rlwa	x,a
 775  015c 7b01          	ld	a,(OFST-8,sp)
 776  015e fb            	add	a,(x)
 777  015f 6b01          	ld	(OFST-8,sp),a
 778                     ; 224 	for(i=0;i<6;i++)
 780  0161 0c09          	inc	(OFST+0,sp)
 783  0163 7b09          	ld	a,(OFST+0,sp)
 784  0165 a106          	cp	a,#6
 785  0167 25e7          	jrult	L113
 786                     ; 227 	Frame_Data[6] = CheckSum;	
 788  0169 7b01          	ld	a,(OFST-8,sp)
 789  016b 6b08          	ld	(OFST-1,sp),a
 790                     ; 229 	HekrSendFrame(Frame_Data);
 792  016d 96            	ldw	x,sp
 793  016e 1c0002        	addw	x,#OFST-7
 794  0171 cd036a        	call	L51_HekrSendFrame
 796                     ; 230 }
 799  0174 5b09          	addw	sp,#9
 800  0176 81            	ret
 803                     	switch	.const
 804  0015               L713_Frame_Data:
 805  0015 48            	dc.b	72
 806  0016 07            	dc.b	7
 807  0017 fe            	dc.b	254
 808  0018 00            	dc.b	0
 809  0019 01            	dc.b	1
 810  001a 00            	dc.b	0
 811  001b 00            	dc.b	0
 865                     ; 233 void Hekr_Config_Function()
 865                     ; 234 {
 866                     	switch	.text
 867  0177               _Hekr_Config_Function:
 869  0177 5209          	subw	sp,#9
 870       00000009      OFST:	set	9
 873                     ; 235 	unsigned char CheckSum=0;
 875  0179 0f01          	clr	(OFST-8,sp)
 876                     ; 237 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
 878  017b 96            	ldw	x,sp
 879  017c 1c0002        	addw	x,#OFST-7
 880  017f 90ae0015      	ldw	y,#L713_Frame_Data
 881  0183 a607          	ld	a,#7
 882  0185 cd0000        	call	c_xymvx
 884                     ; 239 	Frame_Data[3] = frame_no++;
 886  0188 b600          	ld	a,L7_frame_no
 887  018a 3c00          	inc	L7_frame_no
 888  018c 6b05          	ld	(OFST-4,sp),a
 889                     ; 240 	Frame_Data[4] = Hekr_Config;
 891  018e a604          	ld	a,#4
 892  0190 6b06          	ld	(OFST-3,sp),a
 893                     ; 242 	for(i=0;i<6;i++)
 895  0192 0f09          	clr	(OFST+0,sp)
 896  0194               L743:
 897                     ; 243 			 CheckSum=CheckSum + Frame_Data[i];
 899  0194 96            	ldw	x,sp
 900  0195 1c0002        	addw	x,#OFST-7
 901  0198 9f            	ld	a,xl
 902  0199 5e            	swapw	x
 903  019a 1b09          	add	a,(OFST+0,sp)
 904  019c 2401          	jrnc	L43
 905  019e 5c            	incw	x
 906  019f               L43:
 907  019f 02            	rlwa	x,a
 908  01a0 7b01          	ld	a,(OFST-8,sp)
 909  01a2 fb            	add	a,(x)
 910  01a3 6b01          	ld	(OFST-8,sp),a
 911                     ; 242 	for(i=0;i<6;i++)
 913  01a5 0c09          	inc	(OFST+0,sp)
 916  01a7 7b09          	ld	a,(OFST+0,sp)
 917  01a9 a106          	cp	a,#6
 918  01ab 25e7          	jrult	L743
 919                     ; 245 	Frame_Data[6] = CheckSum;	
 921  01ad 7b01          	ld	a,(OFST-8,sp)
 922  01af 6b08          	ld	(OFST-1,sp),a
 923                     ; 247 	HekrSendFrame(Frame_Data);
 925  01b1 96            	ldw	x,sp
 926  01b2 1c0002        	addw	x,#OFST-7
 927  01b5 cd036a        	call	L51_HekrSendFrame
 929                     ; 248 }
 932  01b8 5b09          	addw	sp,#9
 933  01ba 81            	ret
 936                     	switch	.const
 937  001c               L553_Frame_Data:
 938  001c 48            	dc.b	72
 939  001d 07            	dc.b	7
 940  001e fe            	dc.b	254
 941  001f 00            	dc.b	0
 942  0020 01            	dc.b	1
 943  0021 00            	dc.b	0
 944  0022 00            	dc.b	0
 998                     ; 251 void Module_Set_Sleep_Function()
 998                     ; 252 {
 999                     	switch	.text
1000  01bb               _Module_Set_Sleep_Function:
1002  01bb 5209          	subw	sp,#9
1003       00000009      OFST:	set	9
1006                     ; 253 	unsigned char CheckSum=0;
1008  01bd 0f01          	clr	(OFST-8,sp)
1009                     ; 255 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1011  01bf 96            	ldw	x,sp
1012  01c0 1c0002        	addw	x,#OFST-7
1013  01c3 90ae001c      	ldw	y,#L553_Frame_Data
1014  01c7 a607          	ld	a,#7
1015  01c9 cd0000        	call	c_xymvx
1017                     ; 257 	Frame_Data[3] = frame_no++;
1019  01cc b600          	ld	a,L7_frame_no
1020  01ce 3c00          	inc	L7_frame_no
1021  01d0 6b05          	ld	(OFST-4,sp),a
1022                     ; 258 	Frame_Data[4] = Module_Set_Sleep;
1024  01d2 a605          	ld	a,#5
1025  01d4 6b06          	ld	(OFST-3,sp),a
1026                     ; 260 	for(i=0;i<6;i++)
1028  01d6 0f09          	clr	(OFST+0,sp)
1029  01d8               L504:
1030                     ; 261 			 CheckSum=CheckSum + Frame_Data[i];
1032  01d8 96            	ldw	x,sp
1033  01d9 1c0002        	addw	x,#OFST-7
1034  01dc 9f            	ld	a,xl
1035  01dd 5e            	swapw	x
1036  01de 1b09          	add	a,(OFST+0,sp)
1037  01e0 2401          	jrnc	L04
1038  01e2 5c            	incw	x
1039  01e3               L04:
1040  01e3 02            	rlwa	x,a
1041  01e4 7b01          	ld	a,(OFST-8,sp)
1042  01e6 fb            	add	a,(x)
1043  01e7 6b01          	ld	(OFST-8,sp),a
1044                     ; 260 	for(i=0;i<6;i++)
1046  01e9 0c09          	inc	(OFST+0,sp)
1049  01eb 7b09          	ld	a,(OFST+0,sp)
1050  01ed a106          	cp	a,#6
1051  01ef 25e7          	jrult	L504
1052                     ; 263 	Frame_Data[6] = CheckSum;	
1054  01f1 7b01          	ld	a,(OFST-8,sp)
1055  01f3 6b08          	ld	(OFST-1,sp),a
1056                     ; 265 	HekrSendFrame(Frame_Data);
1058  01f5 96            	ldw	x,sp
1059  01f6 1c0002        	addw	x,#OFST-7
1060  01f9 cd036a        	call	L51_HekrSendFrame
1062                     ; 266 }
1065  01fc 5b09          	addw	sp,#9
1066  01fe 81            	ret
1069                     	switch	.const
1070  0023               L314_Frame_Data:
1071  0023 48            	dc.b	72
1072  0024 07            	dc.b	7
1073  0025 fe            	dc.b	254
1074  0026 00            	dc.b	0
1075  0027 01            	dc.b	1
1076  0028 00            	dc.b	0
1077  0029 00            	dc.b	0
1131                     ; 269 void Module_Weakup_Function()
1131                     ; 270 {
1132                     	switch	.text
1133  01ff               _Module_Weakup_Function:
1135  01ff 5209          	subw	sp,#9
1136       00000009      OFST:	set	9
1139                     ; 271 	unsigned char CheckSum=0;
1141  0201 0f01          	clr	(OFST-8,sp)
1142                     ; 273 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1144  0203 96            	ldw	x,sp
1145  0204 1c0002        	addw	x,#OFST-7
1146  0207 90ae0023      	ldw	y,#L314_Frame_Data
1147  020b a607          	ld	a,#7
1148  020d cd0000        	call	c_xymvx
1150                     ; 275 	Frame_Data[3] = frame_no++;
1152  0210 b600          	ld	a,L7_frame_no
1153  0212 3c00          	inc	L7_frame_no
1154  0214 6b05          	ld	(OFST-4,sp),a
1155                     ; 276 	Frame_Data[4] = Module_Weakup;
1157  0216 a606          	ld	a,#6
1158  0218 6b06          	ld	(OFST-3,sp),a
1159                     ; 278 	for(i=0;i<6;i++)
1161  021a 0f09          	clr	(OFST+0,sp)
1162  021c               L344:
1163                     ; 279 			 CheckSum=CheckSum + Frame_Data[i];
1165  021c 96            	ldw	x,sp
1166  021d 1c0002        	addw	x,#OFST-7
1167  0220 9f            	ld	a,xl
1168  0221 5e            	swapw	x
1169  0222 1b09          	add	a,(OFST+0,sp)
1170  0224 2401          	jrnc	L44
1171  0226 5c            	incw	x
1172  0227               L44:
1173  0227 02            	rlwa	x,a
1174  0228 7b01          	ld	a,(OFST-8,sp)
1175  022a fb            	add	a,(x)
1176  022b 6b01          	ld	(OFST-8,sp),a
1177                     ; 278 	for(i=0;i<6;i++)
1179  022d 0c09          	inc	(OFST+0,sp)
1182  022f 7b09          	ld	a,(OFST+0,sp)
1183  0231 a106          	cp	a,#6
1184  0233 25e7          	jrult	L344
1185                     ; 281 	Frame_Data[6] = CheckSum;	
1187  0235 7b01          	ld	a,(OFST-8,sp)
1188  0237 6b08          	ld	(OFST-1,sp),a
1189                     ; 283 	HekrSendFrame(Frame_Data);
1191  0239 96            	ldw	x,sp
1192  023a 1c0002        	addw	x,#OFST-7
1193  023d cd036a        	call	L51_HekrSendFrame
1195                     ; 284 }
1198  0240 5b09          	addw	sp,#9
1199  0242 81            	ret
1202                     	switch	.const
1203  002a               L154_Frame_Data:
1204  002a 48            	dc.b	72
1205  002b 07            	dc.b	7
1206  002c fe            	dc.b	254
1207  002d 00            	dc.b	0
1208  002e 01            	dc.b	1
1209  002f 00            	dc.b	0
1210  0030 00            	dc.b	0
1264                     ; 287 void Module_Factory_Test_Function()
1264                     ; 288 {
1265                     	switch	.text
1266  0243               _Module_Factory_Test_Function:
1268  0243 5209          	subw	sp,#9
1269       00000009      OFST:	set	9
1272                     ; 289 	unsigned char CheckSum=0;
1274  0245 0f01          	clr	(OFST-8,sp)
1275                     ; 291 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1277  0247 96            	ldw	x,sp
1278  0248 1c0002        	addw	x,#OFST-7
1279  024b 90ae002a      	ldw	y,#L154_Frame_Data
1280  024f a607          	ld	a,#7
1281  0251 cd0000        	call	c_xymvx
1283                     ; 293 	Frame_Data[3] = frame_no++;
1285  0254 b600          	ld	a,L7_frame_no
1286  0256 3c00          	inc	L7_frame_no
1287  0258 6b05          	ld	(OFST-4,sp),a
1288                     ; 294 	Frame_Data[4] = Module_Factory_Test;
1290  025a a620          	ld	a,#32
1291  025c 6b06          	ld	(OFST-3,sp),a
1292                     ; 296 	for(i=0;i<6;i++)
1294  025e 0f09          	clr	(OFST+0,sp)
1295  0260               L105:
1296                     ; 297 			 CheckSum=CheckSum + Frame_Data[i];
1298  0260 96            	ldw	x,sp
1299  0261 1c0002        	addw	x,#OFST-7
1300  0264 9f            	ld	a,xl
1301  0265 5e            	swapw	x
1302  0266 1b09          	add	a,(OFST+0,sp)
1303  0268 2401          	jrnc	L05
1304  026a 5c            	incw	x
1305  026b               L05:
1306  026b 02            	rlwa	x,a
1307  026c 7b01          	ld	a,(OFST-8,sp)
1308  026e fb            	add	a,(x)
1309  026f 6b01          	ld	(OFST-8,sp),a
1310                     ; 296 	for(i=0;i<6;i++)
1312  0271 0c09          	inc	(OFST+0,sp)
1315  0273 7b09          	ld	a,(OFST+0,sp)
1316  0275 a106          	cp	a,#6
1317  0277 25e7          	jrult	L105
1318                     ; 299 	Frame_Data[6] = CheckSum;	
1320  0279 7b01          	ld	a,(OFST-8,sp)
1321  027b 6b08          	ld	(OFST-1,sp),a
1322                     ; 301 	HekrSendFrame(Frame_Data);
1324  027d 96            	ldw	x,sp
1325  027e 1c0002        	addw	x,#OFST-7
1326  0281 cd036a        	call	L51_HekrSendFrame
1328                     ; 302 }
1331  0284 5b09          	addw	sp,#9
1332  0286 81            	ret
1335                     	switch	.const
1336  0031               L705_Frame_Data:
1337  0031 48            	dc.b	72
1338  0032 07            	dc.b	7
1339  0033 fe            	dc.b	254
1340  0034 00            	dc.b	0
1341  0035 01            	dc.b	1
1342  0036 00            	dc.b	0
1343  0037 00            	dc.b	0
1397                     ; 305 void Module_Firmware_Versions_Function()
1397                     ; 306 {
1398                     	switch	.text
1399  0287               _Module_Firmware_Versions_Function:
1401  0287 5209          	subw	sp,#9
1402       00000009      OFST:	set	9
1405                     ; 307 	unsigned char CheckSum=0;
1407  0289 0f01          	clr	(OFST-8,sp)
1408                     ; 309 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1410  028b 96            	ldw	x,sp
1411  028c 1c0002        	addw	x,#OFST-7
1412  028f 90ae0031      	ldw	y,#L705_Frame_Data
1413  0293 a607          	ld	a,#7
1414  0295 cd0000        	call	c_xymvx
1416                     ; 311 	Frame_Data[3] = frame_no++;
1418  0298 b600          	ld	a,L7_frame_no
1419  029a 3c00          	inc	L7_frame_no
1420  029c 6b05          	ld	(OFST-4,sp),a
1421                     ; 312 	Frame_Data[4] = Module_Firmware_Versions;
1423  029e a610          	ld	a,#16
1424  02a0 6b06          	ld	(OFST-3,sp),a
1425                     ; 314 	for(i=0;i<6;i++)
1427  02a2 0f09          	clr	(OFST+0,sp)
1428  02a4               L735:
1429                     ; 315 			 CheckSum=CheckSum + Frame_Data[i];
1431  02a4 96            	ldw	x,sp
1432  02a5 1c0002        	addw	x,#OFST-7
1433  02a8 9f            	ld	a,xl
1434  02a9 5e            	swapw	x
1435  02aa 1b09          	add	a,(OFST+0,sp)
1436  02ac 2401          	jrnc	L45
1437  02ae 5c            	incw	x
1438  02af               L45:
1439  02af 02            	rlwa	x,a
1440  02b0 7b01          	ld	a,(OFST-8,sp)
1441  02b2 fb            	add	a,(x)
1442  02b3 6b01          	ld	(OFST-8,sp),a
1443                     ; 314 	for(i=0;i<6;i++)
1445  02b5 0c09          	inc	(OFST+0,sp)
1448  02b7 7b09          	ld	a,(OFST+0,sp)
1449  02b9 a106          	cp	a,#6
1450  02bb 25e7          	jrult	L735
1451                     ; 317 	Frame_Data[6] = CheckSum;	
1453  02bd 7b01          	ld	a,(OFST-8,sp)
1454  02bf 6b08          	ld	(OFST-1,sp),a
1455                     ; 319 	HekrSendFrame(Frame_Data);
1457  02c1 96            	ldw	x,sp
1458  02c2 1c0002        	addw	x,#OFST-7
1459  02c5 cd036a        	call	L51_HekrSendFrame
1461                     ; 320 }
1464  02c8 5b09          	addw	sp,#9
1465  02ca 81            	ret
1468                     	switch	.const
1469  0038               L545_Frame_Data:
1470  0038 48            	dc.b	72
1471  0039 07            	dc.b	7
1472  003a fe            	dc.b	254
1473  003b 00            	dc.b	0
1474  003c 01            	dc.b	1
1475  003d 00            	dc.b	0
1476  003e 00            	dc.b	0
1530                     ; 323 void Module_ProdKey_Get_Function()
1530                     ; 324 {
1531                     	switch	.text
1532  02cb               _Module_ProdKey_Get_Function:
1534  02cb 5209          	subw	sp,#9
1535       00000009      OFST:	set	9
1538                     ; 325 	unsigned char CheckSum=0;
1540  02cd 0f01          	clr	(OFST-8,sp)
1541                     ; 327 	unsigned char Frame_Data[7]={0x48,0x07,0xFE,0x00,0x01,0x00,0x00};
1543  02cf 96            	ldw	x,sp
1544  02d0 1c0002        	addw	x,#OFST-7
1545  02d3 90ae0038      	ldw	y,#L545_Frame_Data
1546  02d7 a607          	ld	a,#7
1547  02d9 cd0000        	call	c_xymvx
1549                     ; 329 	Frame_Data[3] = frame_no++;
1551  02dc b600          	ld	a,L7_frame_no
1552  02de 3c00          	inc	L7_frame_no
1553  02e0 6b05          	ld	(OFST-4,sp),a
1554                     ; 330 	Frame_Data[4] = Module_ProdKey_Get;
1556  02e2 a611          	ld	a,#17
1557  02e4 6b06          	ld	(OFST-3,sp),a
1558                     ; 332 	for(i=0;i<6;i++)
1560  02e6 0f09          	clr	(OFST+0,sp)
1561  02e8               L575:
1562                     ; 333 			 CheckSum=CheckSum + Frame_Data[i];
1564  02e8 96            	ldw	x,sp
1565  02e9 1c0002        	addw	x,#OFST-7
1566  02ec 9f            	ld	a,xl
1567  02ed 5e            	swapw	x
1568  02ee 1b09          	add	a,(OFST+0,sp)
1569  02f0 2401          	jrnc	L06
1570  02f2 5c            	incw	x
1571  02f3               L06:
1572  02f3 02            	rlwa	x,a
1573  02f4 7b01          	ld	a,(OFST-8,sp)
1574  02f6 fb            	add	a,(x)
1575  02f7 6b01          	ld	(OFST-8,sp),a
1576                     ; 332 	for(i=0;i<6;i++)
1578  02f9 0c09          	inc	(OFST+0,sp)
1581  02fb 7b09          	ld	a,(OFST+0,sp)
1582  02fd a106          	cp	a,#6
1583  02ff 25e7          	jrult	L575
1584                     ; 335 	Frame_Data[6] = CheckSum;	
1586  0301 7b01          	ld	a,(OFST-8,sp)
1587  0303 6b08          	ld	(OFST-1,sp),a
1588                     ; 337 	HekrSendFrame(Frame_Data);
1590  0305 96            	ldw	x,sp
1591  0306 1c0002        	addw	x,#OFST-7
1592  0309 ad5f          	call	L51_HekrSendFrame
1594                     ; 338 }
1597  030b 5b09          	addw	sp,#9
1598  030d 81            	ret
1654                     ; 341 void Set_ProdKey(unsigned char *ProdKey_16Byte_Set)
1654                     ; 342 {
1655                     	switch	.text
1656  030e               _Set_ProdKey:
1658  030e 89            	pushw	x
1659  030f 89            	pushw	x
1660       00000002      OFST:	set	2
1663                     ; 343 	unsigned char CheckSum=0;
1665  0310 0f01          	clr	(OFST-1,sp)
1666                     ; 345   hekr_send_buffer[0] = HEKR_FRAME_HEADER;
1668  0312 3548000c      	mov	L3_hekr_send_buffer,#72
1669                     ; 346 	hekr_send_buffer[1] = ProdKeyLenth;
1671  0316 3516000d      	mov	L3_hekr_send_buffer+1,#22
1672                     ; 347 	hekr_send_buffer[2] = ModuleOperationType;
1674  031a 35fe000e      	mov	L3_hekr_send_buffer+2,#254
1675                     ; 348 	hekr_send_buffer[3] = frame_no++;
1677  031e b600          	ld	a,L7_frame_no
1678  0320 3c00          	inc	L7_frame_no
1679  0322 b70f          	ld	L3_hekr_send_buffer+3,a
1680                     ; 349 	hekr_send_buffer[4] = Module_Set_ProdKey;
1682  0324 35210010      	mov	L3_hekr_send_buffer+4,#33
1683                     ; 351 	for(i=0;i<16;i++)						                            
1685  0328 0f02          	clr	(OFST+0,sp)
1686  032a               L136:
1687                     ; 352 			 hekr_send_buffer[i+5]=*(ProdKey_16Byte_Set+i);
1689  032a 7b02          	ld	a,(OFST+0,sp)
1690  032c 5f            	clrw	x
1691  032d 97            	ld	xl,a
1692  032e 89            	pushw	x
1693  032f 7b05          	ld	a,(OFST+3,sp)
1694  0331 97            	ld	xl,a
1695  0332 7b06          	ld	a,(OFST+4,sp)
1696  0334 1b04          	add	a,(OFST+2,sp)
1697  0336 2401          	jrnc	L46
1698  0338 5c            	incw	x
1699  0339               L46:
1700  0339 02            	rlwa	x,a
1701  033a f6            	ld	a,(x)
1702  033b 85            	popw	x
1703  033c e711          	ld	(L3_hekr_send_buffer+5,x),a
1704                     ; 351 	for(i=0;i<16;i++)						                            
1706  033e 0c02          	inc	(OFST+0,sp)
1709  0340 7b02          	ld	a,(OFST+0,sp)
1710  0342 a110          	cp	a,#16
1711  0344 25e4          	jrult	L136
1712                     ; 354 	for(i=0;i<21;i++)
1714  0346 0f02          	clr	(OFST+0,sp)
1715  0348               L736:
1716                     ; 355 			 CheckSum=CheckSum + hekr_send_buffer[i];
1718  0348 7b02          	ld	a,(OFST+0,sp)
1719  034a 5f            	clrw	x
1720  034b 97            	ld	xl,a
1721  034c 7b01          	ld	a,(OFST-1,sp)
1722  034e eb0c          	add	a,(L3_hekr_send_buffer,x)
1723  0350 6b01          	ld	(OFST-1,sp),a
1724                     ; 354 	for(i=0;i<21;i++)
1726  0352 0c02          	inc	(OFST+0,sp)
1729  0354 7b02          	ld	a,(OFST+0,sp)
1730  0356 a115          	cp	a,#21
1731  0358 25ee          	jrult	L736
1732                     ; 357 	hekr_send_buffer[21] = CheckSum;	
1734  035a 7b01          	ld	a,(OFST-1,sp)
1735  035c b721          	ld	L3_hekr_send_buffer+21,a
1736                     ; 359 	HekrSendFrame(hekr_send_buffer);
1738  035e ae000c        	ldw	x,#L3_hekr_send_buffer
1739  0361 ad07          	call	L51_HekrSendFrame
1741                     ; 360 }
1744  0363 5b04          	addw	sp,#4
1745  0365 81            	ret
1780                     ; 363 static void HekrSendByte(unsigned char ch)
1780                     ; 364 {
1781                     	switch	.text
1782  0366               L31_HekrSendByte:
1786                     ; 365 	hekr_send_btye(ch);
1788  0366 92cd00        	call	[L11_hekr_send_btye.w]
1790                     ; 366 }
1793  0369 81            	ret
1848                     ; 369 static void HekrSendFrame(unsigned char *data)
1848                     ; 370 {
1849                     	switch	.text
1850  036a               L51_HekrSendFrame:
1852  036a 89            	pushw	x
1853  036b 89            	pushw	x
1854       00000002      OFST:	set	2
1857                     ; 371 	unsigned char len = data[1];
1859  036c e601          	ld	a,(1,x)
1860  036e 6b01          	ld	(OFST-1,sp),a
1861                     ; 372 	unsigned char i = 0;
1863                     ; 373 	data[len-1] = SumCalculate(data);
1865  0370 7b01          	ld	a,(OFST-1,sp)
1866  0372 5f            	clrw	x
1867  0373 97            	ld	xl,a
1868  0374 5a            	decw	x
1869  0375 72fb03        	addw	x,(OFST+1,sp)
1870  0378 89            	pushw	x
1871  0379 1e05          	ldw	x,(OFST+3,sp)
1872  037b ad44          	call	L32_SumCalculate
1874  037d 85            	popw	x
1875  037e f7            	ld	(x),a
1876                     ; 374 	for(i = 0 ; i < len ; i++)
1878  037f 0f02          	clr	(OFST+0,sp)
1880  0381 2010          	jra	L517
1881  0383               L117:
1882                     ; 376 		HekrSendByte(data[i]);
1884  0383 7b03          	ld	a,(OFST+1,sp)
1885  0385 97            	ld	xl,a
1886  0386 7b04          	ld	a,(OFST+2,sp)
1887  0388 1b02          	add	a,(OFST+0,sp)
1888  038a 2401          	jrnc	L27
1889  038c 5c            	incw	x
1890  038d               L27:
1891  038d 02            	rlwa	x,a
1892  038e f6            	ld	a,(x)
1893  038f add5          	call	L31_HekrSendByte
1895                     ; 374 	for(i = 0 ; i < len ; i++)
1897  0391 0c02          	inc	(OFST+0,sp)
1898  0393               L517:
1901  0393 7b02          	ld	a,(OFST+0,sp)
1902  0395 1101          	cp	a,(OFST-1,sp)
1903  0397 25ea          	jrult	L117
1904                     ; 378 }
1907  0399 5b04          	addw	sp,#4
1908  039b 81            	ret
1962                     ; 380 static unsigned char SumCheckIsErr(unsigned char* data)
1962                     ; 381 {
1963                     	switch	.text
1964  039c               L71_SumCheckIsErr:
1966  039c 89            	pushw	x
1967  039d 89            	pushw	x
1968       00000002      OFST:	set	2
1971                     ; 382 	unsigned char temp = SumCalculate(data);
1973  039e ad21          	call	L32_SumCalculate
1975  03a0 6b01          	ld	(OFST-1,sp),a
1976                     ; 383 	unsigned char len = data[1] - 1;
1978  03a2 1e03          	ldw	x,(OFST+1,sp)
1979  03a4 e601          	ld	a,(1,x)
1980  03a6 4a            	dec	a
1981  03a7 6b02          	ld	(OFST+0,sp),a
1982                     ; 384 	if(temp == data[len])
1984  03a9 7b03          	ld	a,(OFST+1,sp)
1985  03ab 97            	ld	xl,a
1986  03ac 7b04          	ld	a,(OFST+2,sp)
1987  03ae 1b02          	add	a,(OFST+0,sp)
1988  03b0 2401          	jrnc	L67
1989  03b2 5c            	incw	x
1990  03b3               L67:
1991  03b3 02            	rlwa	x,a
1992  03b4 f6            	ld	a,(x)
1993  03b5 1101          	cp	a,(OFST-1,sp)
1994  03b7 2603          	jrne	L747
1995                     ; 385 		return 0;
1997  03b9 4f            	clr	a
1999  03ba 2002          	jra	L001
2000  03bc               L747:
2001                     ; 386 	return 1;
2003  03bc a601          	ld	a,#1
2005  03be               L001:
2007  03be 5b04          	addw	sp,#4
2008  03c0 81            	ret
2070                     ; 389 static unsigned char SumCalculate(unsigned char* data)
2070                     ; 390 {
2071                     	switch	.text
2072  03c1               L32_SumCalculate:
2074  03c1 89            	pushw	x
2075  03c2 5203          	subw	sp,#3
2076       00000003      OFST:	set	3
2079                     ; 393 	unsigned char len = data[1] - 1;
2081  03c4 e601          	ld	a,(1,x)
2082  03c6 4a            	dec	a
2083  03c7 6b01          	ld	(OFST-2,sp),a
2084                     ; 394 	temp = 0;
2086  03c9 0f02          	clr	(OFST-1,sp)
2087                     ; 395 	for(i = 0;i < len; i++)
2089  03cb 0f03          	clr	(OFST+0,sp)
2091  03cd 2012          	jra	L7001
2092  03cf               L3001:
2093                     ; 397 			temp += data[i];
2095  03cf 7b04          	ld	a,(OFST+1,sp)
2096  03d1 97            	ld	xl,a
2097  03d2 7b05          	ld	a,(OFST+2,sp)
2098  03d4 1b03          	add	a,(OFST+0,sp)
2099  03d6 2401          	jrnc	L401
2100  03d8 5c            	incw	x
2101  03d9               L401:
2102  03d9 02            	rlwa	x,a
2103  03da 7b02          	ld	a,(OFST-1,sp)
2104  03dc fb            	add	a,(x)
2105  03dd 6b02          	ld	(OFST-1,sp),a
2106                     ; 395 	for(i = 0;i < len; i++)
2108  03df 0c03          	inc	(OFST+0,sp)
2109  03e1               L7001:
2112  03e1 7b03          	ld	a,(OFST+0,sp)
2113  03e3 1101          	cp	a,(OFST-2,sp)
2114  03e5 25e8          	jrult	L3001
2115                     ; 399 	return temp;
2117  03e7 7b02          	ld	a,(OFST-1,sp)
2120  03e9 5b05          	addw	sp,#5
2121  03eb 81            	ret
2158                     ; 402 static void ErrResponse(unsigned char data)
2158                     ; 403 {
2159                     	switch	.text
2160  03ec               L12_ErrResponse:
2162  03ec 88            	push	a
2163       00000000      OFST:	set	0
2166                     ; 404 	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
2168  03ed 3548000c      	mov	L3_hekr_send_buffer,#72
2169                     ; 405 	hekr_send_buffer[1] = ErrorFrameLength;
2171  03f1 3507000d      	mov	L3_hekr_send_buffer+1,#7
2172                     ; 406 	hekr_send_buffer[2] = ErrorFrameType;
2174  03f5 35ff000e      	mov	L3_hekr_send_buffer+2,#255
2175                     ; 407 	hekr_send_buffer[3] = frame_no++;
2177  03f9 b600          	ld	a,L7_frame_no
2178  03fb 3c00          	inc	L7_frame_no
2179  03fd b70f          	ld	L3_hekr_send_buffer+3,a
2180                     ; 408 	hekr_send_buffer[4] = data;
2182  03ff 7b01          	ld	a,(OFST+1,sp)
2183  0401 b710          	ld	L3_hekr_send_buffer+4,a
2184                     ; 409 	hekr_send_buffer[5] = 0x00;
2186  0403 3f11          	clr	L3_hekr_send_buffer+5
2187                     ; 410 	HekrSendFrame(hekr_send_buffer);
2189  0405 ae000c        	ldw	x,#L3_hekr_send_buffer
2190  0408 cd036a        	call	L51_HekrSendFrame
2192                     ; 411 }
2195  040b 84            	pop	a
2196  040c 81            	ret
2250                     ; 413 static void HekrValidDataCopy(unsigned char* data)
2250                     ; 414 {
2251                     	switch	.text
2252  040d               L52_HekrValidDataCopy:
2254  040d 89            	pushw	x
2255  040e 89            	pushw	x
2256       00000002      OFST:	set	2
2259                     ; 416 	len = data[1]- HEKR_DATA_LEN;
2261  040f e601          	ld	a,(1,x)
2262  0411 a005          	sub	a,#5
2263  0413 6b01          	ld	(OFST-1,sp),a
2264                     ; 417 	for(i = 0 ;i < len ; i++)
2266  0415 0f02          	clr	(OFST+0,sp)
2268  0417 2014          	jra	L3601
2269  0419               L7501:
2270                     ; 418 		valid_data[i] = data[i+4];
2272  0419 7b02          	ld	a,(OFST+0,sp)
2273  041b 5f            	clrw	x
2274  041c 97            	ld	xl,a
2275  041d 7b02          	ld	a,(OFST+0,sp)
2276  041f 905f          	clrw	y
2277  0421 9097          	ld	yl,a
2278  0423 72f903        	addw	y,(OFST+1,sp)
2279  0426 90e604        	ld	a,(4,y)
2280  0429 e775          	ld	(_valid_data,x),a
2281                     ; 417 	for(i = 0 ;i < len ; i++)
2283  042b 0c02          	inc	(OFST+0,sp)
2284  042d               L3601:
2287  042d 7b02          	ld	a,(OFST+0,sp)
2288  042f 1101          	cp	a,(OFST-1,sp)
2289  0431 25e6          	jrult	L7501
2290                     ; 419 }
2293  0433 5b04          	addw	sp,#4
2294  0435 81            	ret
2349                     ; 421 static void HekrModuleStateCopy(unsigned char* data)
2349                     ; 422 {
2350                     	switch	.text
2351  0436               L72_HekrModuleStateCopy:
2353  0436 89            	pushw	x
2354  0437 89            	pushw	x
2355       00000002      OFST:	set	2
2358                     ; 424 	len = data[1]- HEKR_DATA_LEN;
2360  0438 e601          	ld	a,(1,x)
2361  043a a005          	sub	a,#5
2362  043c 6b01          	ld	(OFST-1,sp),a
2363                     ; 425 	for(i = 0 ;i < len ; i++)
2365  043e 0f02          	clr	(OFST+0,sp)
2367  0440 2014          	jra	L1211
2368  0442               L5111:
2369                     ; 426 		module_status[i] = data[i+4];
2371  0442 7b02          	ld	a,(OFST+0,sp)
2372  0444 5f            	clrw	x
2373  0445 97            	ld	xl,a
2374  0446 7b02          	ld	a,(OFST+0,sp)
2375  0448 905f          	clrw	y
2376  044a 9097          	ld	yl,a
2377  044c 72f903        	addw	y,(OFST+1,sp)
2378  044f 90e604        	ld	a,(4,y)
2379  0452 e702          	ld	(L5_module_status,x),a
2380                     ; 425 	for(i = 0 ;i < len ; i++)
2382  0454 0c02          	inc	(OFST+0,sp)
2383  0456               L1211:
2386  0456 7b02          	ld	a,(OFST+0,sp)
2387  0458 1101          	cp	a,(OFST-1,sp)
2388  045a 25e6          	jrult	L5111
2389                     ; 427 }
2392  045c 5b04          	addw	sp,#4
2393  045e 81            	ret
2519                     	switch	.ubsct
2520  0000               L11_hekr_send_btye:
2521  0000 0000          	ds.b	2
2522  0002               L5_module_status:
2523  0002 000000000000  	ds.b	10
2524  000c               L3_hekr_send_buffer:
2525  000c 000000000000  	ds.b	105
2526                     	xdef	_Set_ProdKey
2527                     	xdef	_Module_ProdKey_Get_Function
2528                     	xdef	_Module_Firmware_Versions_Function
2529                     	xdef	_Module_Factory_Test_Function
2530                     	xdef	_Module_Weakup_Function
2531                     	xdef	_Module_Set_Sleep_Function
2532                     	xdef	_Hekr_Config_Function
2533                     	xdef	_Module_Factory_Reset_Function
2534                     	xdef	_Module_Soft_Reboot_Function
2535                     	xdef	_Module_State_Function
2536                     	xdef	_HekrValidDataUpload
2537                     	xdef	_HekrModuleControl
2538                     	xdef	_HekrRecvDataHandle
2539                     	xdef	_HekrInit
2540                     	xdef	_ModuleStatus
2541  0075               _valid_data:
2542  0075 000000000000  	ds.b	100
2543                     	xdef	_valid_data
2544                     	xref.b	c_x
2564                     	xref	c_xymvx
2565                     	end
