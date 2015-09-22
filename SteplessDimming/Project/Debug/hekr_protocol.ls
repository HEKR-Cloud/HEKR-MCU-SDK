   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
   4                     	bsct
   5  0000               L7_frame_no:
   6  0000 00            	dc.b	0
   7  0001               _ModuleStatus:
   8  0001 0002          	dc.w	L5_module_status
  51                     ; 104 void HekrInit(void (*fun)(unsigned char))
  51                     ; 105 {	
  53                     	switch	.text
  54  0000               _HekrInit:
  58                     ; 106 	hekr_send_btye = fun;
  60  0000 bf00          	ldw	L11_hekr_send_btye,x
  61                     ; 107 }
  64  0002 81            	ret
 104                     ; 109 unsigned char HekrRecvDataHandle(unsigned char* data)
 104                     ; 110 {
 105                     	switch	.text
 106  0003               _HekrRecvDataHandle:
 108  0003 89            	pushw	x
 109       00000000      OFST:	set	0
 112                     ; 112 	if(SumCheckIsErr(data))
 114  0004 cd00e1        	call	L71_SumCheckIsErr
 116  0007 4d            	tnz	a
 117  0008 2709          	jreq	L501
 118                     ; 114 		ErrResponse(ErrorSumCheck);
 120  000a a602          	ld	a,#2
 121  000c cd0131        	call	L12_ErrResponse
 123                     ; 115 		return RecvDataSumCheckErr;
 125  000f a601          	ld	a,#1
 127  0011 201a          	jra	L01
 128  0013               L501:
 129                     ; 118 	switch(data[2])
 131  0013 1e01          	ldw	x,(OFST+1,sp)
 132  0015 e602          	ld	a,(2,x)
 134                     ; 133 	default:ErrResponse(ErrorNoCMD);break;
 135  0017 4a            	dec	a
 136  0018 2711          	jreq	L55
 137  001a 4a            	dec	a
 138  001b 2712          	jreq	L75
 139  001d a0fc          	sub	a,#252
 140  001f 271b          	jreq	L16
 141  0021 4a            	dec	a
 142  0022 272d          	jreq	L36
 143  0024               L56:
 146  0024 a6ff          	ld	a,#255
 147  0026 cd0131        	call	L12_ErrResponse
 151  0029 202a          	jra	L111
 152  002b               L55:
 153                     ; 120 	case DeviceUploadType://MCU上传信息反馈 不需要处理 
 153                     ; 121 	                        return MCU_UploadACK;
 155  002b a603          	ld	a,#3
 157  002d               L01:
 159  002d 85            	popw	x
 160  002e 81            	ret
 161  002f               L75:
 162                     ; 122 	case ModuleDownloadType://WIFI下传信息
 162                     ; 123 	                        HekrSendFrame(data);
 164  002f 1e01          	ldw	x,(OFST+1,sp)
 165  0031 ad79          	call	L51_HekrSendFrame
 167                     ; 124 	                        HekrValidDataCopy(data);
 169  0033 1e01          	ldw	x,(OFST+1,sp)
 170  0035 cd0152        	call	L52_HekrValidDataCopy
 172                     ; 125 	                        return ValidDataUpdate;
 174  0038 a604          	ld	a,#4
 176  003a 20f1          	jra	L01
 177  003c               L16:
 178                     ; 126 	case ModuleOperationType://Hekr模块状态
 178                     ; 127 													if(data[1] != ModuleResponseFrameLength)
 180  003c 1e01          	ldw	x,(OFST+1,sp)
 181  003e e601          	ld	a,(1,x)
 182  0040 a10b          	cp	a,#11
 183  0042 2704          	jreq	L311
 184                     ; 128 														return MCU_ControlModuleACK;
 186  0044 a607          	ld	a,#7
 188  0046 20e5          	jra	L01
 189  0048               L311:
 190                     ; 129 	                        HekrModuleStateCopy(data);
 192  0048 1e01          	ldw	x,(OFST+1,sp)
 193  004a cd017b        	call	L72_HekrModuleStateCopy
 195                     ; 130 	                        return HekrModuleStateUpdate;
 197  004d a606          	ld	a,#6
 199  004f 20dc          	jra	L01
 200  0051               L36:
 201                     ; 131 	case ErrorFrameType://上一帧发送错误	
 201                     ; 132 	                        return LastFrameSendErr;
 203  0051 a602          	ld	a,#2
 205  0053 20d8          	jra	L01
 206  0055               L111:
 207                     ; 135 	return RecvDataUseless;
 209  0055 a605          	ld	a,#5
 211  0057 20d4          	jra	L01
 259                     ; 138 void HekrValidDataUpload(unsigned char len)
 259                     ; 139 {
 260                     	switch	.text
 261  0059               _HekrValidDataUpload:
 263  0059 88            	push	a
 264  005a 88            	push	a
 265       00000001      OFST:	set	1
 268                     ; 141 	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
 270  005b 3548000c      	mov	L3_hekr_send_buffer,#72
 271                     ; 142 	hekr_send_buffer[1] = len + 5;;
 273  005f ab05          	add	a,#5
 274  0061 b70d          	ld	L3_hekr_send_buffer+1,a
 275                     ; 143 	hekr_send_buffer[2] = DeviceUploadType;
 278  0063 3501000e      	mov	L3_hekr_send_buffer+2,#1
 279                     ; 144 	hekr_send_buffer[3] = frame_no++;
 281  0067 b600          	ld	a,L7_frame_no
 282  0069 3c00          	inc	L7_frame_no
 283  006b b70f          	ld	L3_hekr_send_buffer+3,a
 284                     ; 145 	for(i = 0; i < len ; i++)
 286  006d 0f01          	clr	(OFST+0,sp)
 288  006f 200a          	jra	L341
 289  0071               L731:
 290                     ; 146 		hekr_send_buffer[i+4] = valid_data[i];
 292  0071 7b01          	ld	a,(OFST+0,sp)
 293  0073 5f            	clrw	x
 294  0074 97            	ld	xl,a
 295  0075 e631          	ld	a,(_valid_data,x)
 296  0077 e710          	ld	(L3_hekr_send_buffer+4,x),a
 297                     ; 145 	for(i = 0; i < len ; i++)
 299  0079 0c01          	inc	(OFST+0,sp)
 300  007b               L341:
 303  007b 7b01          	ld	a,(OFST+0,sp)
 304  007d 1102          	cp	a,(OFST+1,sp)
 305  007f 25f0          	jrult	L731
 306                     ; 147 	HekrSendFrame(hekr_send_buffer);
 308  0081 ae000c        	ldw	x,#L3_hekr_send_buffer
 309  0084 ad26          	call	L51_HekrSendFrame
 311                     ; 148 }
 314  0086 85            	popw	x
 315  0087 81            	ret
 352                     ; 150 void HekrModuleControl(unsigned char data)
 352                     ; 151 {
 353                     	switch	.text
 354  0088               _HekrModuleControl:
 356  0088 88            	push	a
 357       00000000      OFST:	set	0
 360                     ; 152 	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
 362  0089 3548000c      	mov	L3_hekr_send_buffer,#72
 363                     ; 153 	hekr_send_buffer[1] = ModuleQueryFrameLength;
 365  008d 3507000d      	mov	L3_hekr_send_buffer+1,#7
 366                     ; 154 	hekr_send_buffer[2] = ModuleOperationType;
 368  0091 35fe000e      	mov	L3_hekr_send_buffer+2,#254
 369                     ; 155 	hekr_send_buffer[3] = frame_no++;
 371  0095 b600          	ld	a,L7_frame_no
 372  0097 3c00          	inc	L7_frame_no
 373  0099 b70f          	ld	L3_hekr_send_buffer+3,a
 374                     ; 156 	hekr_send_buffer[4] = data;
 376  009b 7b01          	ld	a,(OFST+1,sp)
 377  009d b710          	ld	L3_hekr_send_buffer+4,a
 378                     ; 157 	hekr_send_buffer[5] = 0x00;
 380  009f 3f11          	clr	L3_hekr_send_buffer+5
 381                     ; 158 	HekrSendFrame(hekr_send_buffer);
 383  00a1 ae000c        	ldw	x,#L3_hekr_send_buffer
 384  00a4 ad06          	call	L51_HekrSendFrame
 386                     ; 159 }
 389  00a6 84            	pop	a
 390  00a7 81            	ret
 425                     ; 163 static void HekrSendByte(unsigned char ch)
 425                     ; 164 {
 426                     	switch	.text
 427  00a8               L31_HekrSendByte:
 431                     ; 165 	hekr_send_btye(ch);
 433  00a8 92cd00        	call	[L11_hekr_send_btye.w]
 435                     ; 166 }
 438  00ab 81            	ret
 493                     ; 169 static void HekrSendFrame(unsigned char *data)
 493                     ; 170 {
 494                     	switch	.text
 495  00ac               L51_HekrSendFrame:
 497  00ac 89            	pushw	x
 498  00ad 89            	pushw	x
 499       00000002      OFST:	set	2
 502                     ; 171 	unsigned char len = data[1];
 504  00ae e601          	ld	a,(1,x)
 505  00b0 6b01          	ld	(OFST-1,sp),a
 506                     ; 172 	unsigned char i = 0;
 508  00b2 7b02          	ld	a,(OFST+0,sp)
 509  00b4 97            	ld	xl,a
 510                     ; 173 	data[len-1] = SumCalculate(data);
 512  00b5 7b01          	ld	a,(OFST-1,sp)
 513  00b7 5f            	clrw	x
 514  00b8 97            	ld	xl,a
 515  00b9 5a            	decw	x
 516  00ba 72fb03        	addw	x,(OFST+1,sp)
 517  00bd 89            	pushw	x
 518  00be 1e05          	ldw	x,(OFST+3,sp)
 519  00c0 ad44          	call	L32_SumCalculate
 521  00c2 85            	popw	x
 522  00c3 f7            	ld	(x),a
 523                     ; 174 	for(i = 0 ; i < len ; i++)
 525  00c4 0f02          	clr	(OFST+0,sp)
 527  00c6 2010          	jra	L532
 528  00c8               L132:
 529                     ; 176 		HekrSendByte(data[i]);
 531  00c8 7b03          	ld	a,(OFST+1,sp)
 532  00ca 97            	ld	xl,a
 533  00cb 7b04          	ld	a,(OFST+2,sp)
 534  00cd 1b02          	add	a,(OFST+0,sp)
 535  00cf 2401          	jrnc	L22
 536  00d1 5c            	incw	x
 537  00d2               L22:
 538  00d2 02            	rlwa	x,a
 539  00d3 f6            	ld	a,(x)
 540  00d4 add2          	call	L31_HekrSendByte
 542                     ; 174 	for(i = 0 ; i < len ; i++)
 544  00d6 0c02          	inc	(OFST+0,sp)
 545  00d8               L532:
 548  00d8 7b02          	ld	a,(OFST+0,sp)
 549  00da 1101          	cp	a,(OFST-1,sp)
 550  00dc 25ea          	jrult	L132
 551                     ; 178 }
 554  00de 5b04          	addw	sp,#4
 555  00e0 81            	ret
 609                     ; 180 static unsigned char SumCheckIsErr(unsigned char* data)
 609                     ; 181 {
 610                     	switch	.text
 611  00e1               L71_SumCheckIsErr:
 613  00e1 89            	pushw	x
 614  00e2 89            	pushw	x
 615       00000002      OFST:	set	2
 618                     ; 182 	unsigned char temp = SumCalculate(data);
 620  00e3 ad21          	call	L32_SumCalculate
 622  00e5 6b01          	ld	(OFST-1,sp),a
 623                     ; 183 	unsigned char len = data[1] - 1;
 625  00e7 1e03          	ldw	x,(OFST+1,sp)
 626  00e9 e601          	ld	a,(1,x)
 627  00eb 4a            	dec	a
 628  00ec 6b02          	ld	(OFST+0,sp),a
 629                     ; 184 	if(temp == data[len])
 631  00ee 7b03          	ld	a,(OFST+1,sp)
 632  00f0 97            	ld	xl,a
 633  00f1 7b04          	ld	a,(OFST+2,sp)
 634  00f3 1b02          	add	a,(OFST+0,sp)
 635  00f5 2401          	jrnc	L62
 636  00f7 5c            	incw	x
 637  00f8               L62:
 638  00f8 02            	rlwa	x,a
 639  00f9 f6            	ld	a,(x)
 640  00fa 1101          	cp	a,(OFST-1,sp)
 641  00fc 2603          	jrne	L762
 642                     ; 185 		return 0;
 644  00fe 4f            	clr	a
 646  00ff 2002          	jra	L03
 647  0101               L762:
 648                     ; 186 	return 1;
 650  0101 a601          	ld	a,#1
 652  0103               L03:
 654  0103 5b04          	addw	sp,#4
 655  0105 81            	ret
 717                     ; 189 static unsigned char SumCalculate(unsigned char* data)
 717                     ; 190 {
 718                     	switch	.text
 719  0106               L32_SumCalculate:
 721  0106 89            	pushw	x
 722  0107 5203          	subw	sp,#3
 723       00000003      OFST:	set	3
 726                     ; 193 	unsigned char len = data[1] - 1;
 728  0109 e601          	ld	a,(1,x)
 729  010b 4a            	dec	a
 730  010c 6b01          	ld	(OFST-2,sp),a
 731                     ; 194 	temp = 0;
 733  010e 0f02          	clr	(OFST-1,sp)
 734                     ; 195 	for(i = 0;i < len; i++)
 736  0110 0f03          	clr	(OFST+0,sp)
 738  0112 2012          	jra	L723
 739  0114               L323:
 740                     ; 197 			temp += data[i];
 742  0114 7b04          	ld	a,(OFST+1,sp)
 743  0116 97            	ld	xl,a
 744  0117 7b05          	ld	a,(OFST+2,sp)
 745  0119 1b03          	add	a,(OFST+0,sp)
 746  011b 2401          	jrnc	L43
 747  011d 5c            	incw	x
 748  011e               L43:
 749  011e 02            	rlwa	x,a
 750  011f 7b02          	ld	a,(OFST-1,sp)
 751  0121 fb            	add	a,(x)
 752  0122 6b02          	ld	(OFST-1,sp),a
 753                     ; 195 	for(i = 0;i < len; i++)
 755  0124 0c03          	inc	(OFST+0,sp)
 756  0126               L723:
 759  0126 7b03          	ld	a,(OFST+0,sp)
 760  0128 1101          	cp	a,(OFST-2,sp)
 761  012a 25e8          	jrult	L323
 762                     ; 199 	return temp;
 764  012c 7b02          	ld	a,(OFST-1,sp)
 767  012e 5b05          	addw	sp,#5
 768  0130 81            	ret
 805                     ; 202 static void ErrResponse(unsigned char data)
 805                     ; 203 {
 806                     	switch	.text
 807  0131               L12_ErrResponse:
 809  0131 88            	push	a
 810       00000000      OFST:	set	0
 813                     ; 204 	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
 815  0132 3548000c      	mov	L3_hekr_send_buffer,#72
 816                     ; 205 	hekr_send_buffer[1] = ErrorFrameLength;
 818  0136 3507000d      	mov	L3_hekr_send_buffer+1,#7
 819                     ; 206 	hekr_send_buffer[2] = ErrorFrameType;
 821  013a 35ff000e      	mov	L3_hekr_send_buffer+2,#255
 822                     ; 207 	hekr_send_buffer[3] = frame_no++;
 824  013e b600          	ld	a,L7_frame_no
 825  0140 3c00          	inc	L7_frame_no
 826  0142 b70f          	ld	L3_hekr_send_buffer+3,a
 827                     ; 208 	hekr_send_buffer[4] = data;
 829  0144 7b01          	ld	a,(OFST+1,sp)
 830  0146 b710          	ld	L3_hekr_send_buffer+4,a
 831                     ; 209 	hekr_send_buffer[5] = 0x00;
 833  0148 3f11          	clr	L3_hekr_send_buffer+5
 834                     ; 210 	HekrSendFrame(hekr_send_buffer);
 836  014a ae000c        	ldw	x,#L3_hekr_send_buffer
 837  014d cd00ac        	call	L51_HekrSendFrame
 839                     ; 211 }
 842  0150 84            	pop	a
 843  0151 81            	ret
 897                     ; 213 static void HekrValidDataCopy(unsigned char* data)
 897                     ; 214 {
 898                     	switch	.text
 899  0152               L52_HekrValidDataCopy:
 901  0152 89            	pushw	x
 902  0153 89            	pushw	x
 903       00000002      OFST:	set	2
 906                     ; 216 	len = data[1]- HEKR_DATA_LEN;
 908  0154 e601          	ld	a,(1,x)
 909  0156 a005          	sub	a,#5
 910  0158 6b01          	ld	(OFST-1,sp),a
 911                     ; 217 	for(i = 0 ;i < len ; i++)
 913  015a 0f02          	clr	(OFST+0,sp)
 915  015c 2014          	jra	L304
 916  015e               L773:
 917                     ; 218 		valid_data[i] = data[i+4];
 919  015e 7b02          	ld	a,(OFST+0,sp)
 920  0160 5f            	clrw	x
 921  0161 97            	ld	xl,a
 922  0162 7b02          	ld	a,(OFST+0,sp)
 923  0164 905f          	clrw	y
 924  0166 9097          	ld	yl,a
 925  0168 72f903        	addw	y,(OFST+1,sp)
 926  016b 90e604        	ld	a,(4,y)
 927  016e e731          	ld	(_valid_data,x),a
 928                     ; 217 	for(i = 0 ;i < len ; i++)
 930  0170 0c02          	inc	(OFST+0,sp)
 931  0172               L304:
 934  0172 7b02          	ld	a,(OFST+0,sp)
 935  0174 1101          	cp	a,(OFST-1,sp)
 936  0176 25e6          	jrult	L773
 937                     ; 219 }
 940  0178 5b04          	addw	sp,#4
 941  017a 81            	ret
 996                     ; 221 static void HekrModuleStateCopy(unsigned char* data)
 996                     ; 222 {
 997                     	switch	.text
 998  017b               L72_HekrModuleStateCopy:
1000  017b 89            	pushw	x
1001  017c 89            	pushw	x
1002       00000002      OFST:	set	2
1005                     ; 224 	len = data[1]- HEKR_DATA_LEN;
1007  017d e601          	ld	a,(1,x)
1008  017f a005          	sub	a,#5
1009  0181 6b01          	ld	(OFST-1,sp),a
1010                     ; 225 	for(i = 0 ;i < len ; i++)
1012  0183 0f02          	clr	(OFST+0,sp)
1014  0185 2014          	jra	L144
1015  0187               L534:
1016                     ; 226 		module_status[i] = data[i+4];
1018  0187 7b02          	ld	a,(OFST+0,sp)
1019  0189 5f            	clrw	x
1020  018a 97            	ld	xl,a
1021  018b 7b02          	ld	a,(OFST+0,sp)
1022  018d 905f          	clrw	y
1023  018f 9097          	ld	yl,a
1024  0191 72f903        	addw	y,(OFST+1,sp)
1025  0194 90e604        	ld	a,(4,y)
1026  0197 e702          	ld	(L5_module_status,x),a
1027                     ; 225 	for(i = 0 ;i < len ; i++)
1029  0199 0c02          	inc	(OFST+0,sp)
1030  019b               L144:
1033  019b 7b02          	ld	a,(OFST+0,sp)
1034  019d 1101          	cp	a,(OFST-1,sp)
1035  019f 25e6          	jrult	L534
1036                     ; 227 }
1039  01a1 5b04          	addw	sp,#4
1040  01a3 81            	ret
1166                     	switch	.ubsct
1167  0000               L11_hekr_send_btye:
1168  0000 0000          	ds.b	2
1169  0002               L5_module_status:
1170  0002 000000000000  	ds.b	10
1171  000c               L3_hekr_send_buffer:
1172  000c 000000000000  	ds.b	37
1173                     	xdef	_HekrValidDataUpload
1174                     	xdef	_HekrModuleControl
1175                     	xdef	_HekrRecvDataHandle
1176                     	xdef	_HekrInit
1177                     	xdef	_ModuleStatus
1178  0031               _valid_data:
1179  0031 000000000000  	ds.b	32
1180                     	xdef	_valid_data
1200                     	end
