   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4221                     	bsct
4222  0000               _RecvFlag:
4223  0000 00            	dc.b	0
4224  0001               _RecvCount:
4225  0001 00            	dc.b	0
4226  0002               _UserValidLen:
4227  0002 09            	dc.b	9
4281                     ; 28 main()
4281                     ; 29 {
4283                     	switch	.text
4284  0000               _main:
4288                     ; 31 	System_init();
4290  0000 ad14          	call	_System_init
4292                     ; 34 	HekrModuleControl(ModuleQuery);
4294  0002 a601          	ld	a,#1
4295  0004 cd0000        	call	_HekrModuleControl
4297  0007               L1372:
4298                     ; 39     DataHandle();
4300  0007 ad29          	call	_DataHandle
4302                     ; 43     if(ModuleStatus->Mode == HekrConfig_Mode)
4304  0009 be00          	ldw	x,_ModuleStatus
4305  000b e601          	ld	a,(1,x)
4306  000d a102          	cp	a,#2
4307  000f 26f6          	jrne	L1372
4308                     ; 45 			MCU_ConfigMode();
4310  0011 cd0000        	call	_MCU_ConfigMode
4312  0014 20f1          	jra	L1372
4345                     ; 51 void System_init(void)
4345                     ; 52 {
4346                     	switch	.text
4347  0016               _System_init:
4351                     ; 54 	System_Clock_init();
4353  0016 cd0000        	call	_System_Clock_init
4355                     ; 56 	UART1_Init();
4357  0019 cd0000        	call	_UART1_Init
4359                     ; 58 	HekrInit(UART1_SendChar);
4361  001c ae0000        	ldw	x,#_UART1_SendChar
4362  001f cd0000        	call	_HekrInit
4364                     ; 60 	delay_init(16);
4366  0022 a610          	ld	a,#16
4367  0024 cd0000        	call	_delay_init
4369                     ; 62 	Bright_ModeInit();
4371  0027 cd0000        	call	_Bright_ModeInit
4373                     ; 65 	TIM2_Init();
4375  002a cd0000        	call	_TIM2_Init
4377                     ; 67 	TIM1_Init();
4379  002d cd0000        	call	_TIM1_Init
4381                     ; 68 	_asm("rim");
4384  0030 9a            rim
4386                     ; 69 }
4389  0031 81            	ret
4435                     ; 71 void DataHandle(void)
4435                     ; 72 {
4436                     	switch	.text
4437  0032               _DataHandle:
4439  0032 88            	push	a
4440       00000001      OFST:	set	1
4443                     ; 74   if(RecvFlag)
4445  0033 3d00          	tnz	_RecvFlag
4446  0035 275b          	jreq	L7772
4447                     ; 76     temp = HekrRecvDataHandle(RecvBuffer);
4449  0037 ae0000        	ldw	x,#_RecvBuffer
4450  003a cd0000        	call	_HekrRecvDataHandle
4452  003d 6b01          	ld	(OFST+0,sp),a
4453                     ; 78     if(ModuleStatus->Mode != HekrConfig_Mode)
4455  003f be00          	ldw	x,_ModuleStatus
4456  0041 e601          	ld	a,(1,x)
4457  0043 a102          	cp	a,#2
4458  0045 2749          	jreq	L1003
4459                     ; 81       if(ValidDataUpdate == temp)
4461  0047 7b01          	ld	a,(OFST+0,sp)
4462  0049 a104          	cp	a,#4
4463  004b 2643          	jrne	L1003
4464                     ; 83 				switch(valid_data[0])
4466  004d b600          	ld	a,_valid_data
4468                     ; 106         default:break;
4469  004f 4d            	tnz	a
4470  0050 270d          	jreq	L7472
4471  0052 a002          	sub	a,#2
4472  0054 2719          	jreq	L1572
4473  0056 4a            	dec	a
4474  0057 271d          	jreq	L3572
4475  0059 a003          	sub	a,#3
4476  005b 2727          	jreq	L5572
4477  005d 2031          	jra	L1003
4478  005f               L7472:
4479                     ; 86         case LED_Query:
4479                     ; 87               //保存当前数据
4479                     ; 88               valid_data[1] = led_open_flag;
4481  005f 450001        	mov	_valid_data+1,_led_open_flag
4482                     ; 89               valid_data[3] = bright_set;
4484  0062 450003        	mov	_valid_data+3,_bright_set
4485                     ; 90               valid_data[4] = colour_set;
4487  0065 450004        	mov	_valid_data+4,_colour_set
4488                     ; 92               HekrValidDataUpload(UserValidLen);break;
4490  0068 b602          	ld	a,_UserValidLen
4491  006a cd0000        	call	_HekrValidDataUpload
4495  006d 2021          	jra	L1003
4496  006f               L1572:
4497                     ; 94         case LED_PowerONOFF:
4497                     ; 95               LED_StateControl(valid_data[1]);break;
4499  006f b601          	ld	a,_valid_data+1
4500  0071 cd0000        	call	_LED_StateControl
4504  0074 201a          	jra	L1003
4505  0076               L3572:
4506                     ; 97         case LED_Bright_Control:
4506                     ; 98               bright_set = valid_data[3];
4508  0076 450300        	mov	_bright_set,_valid_data+3
4509                     ; 99               if(led_open_flag == 1)UpdateBright();
4511  0079 b600          	ld	a,_led_open_flag
4512  007b a101          	cp	a,#1
4513  007d 2611          	jrne	L1003
4516  007f cd0000        	call	_UpdateBright
4518  0082 200c          	jra	L1003
4519  0084               L5572:
4520                     ; 102         case LED_Colour_Temperature:
4520                     ; 103               colour_set = valid_data[4];
4522  0084 450400        	mov	_colour_set,_valid_data+4
4523                     ; 104               if(led_open_flag == 1)UpdateBright();
4525  0087 b600          	ld	a,_led_open_flag
4526  0089 a101          	cp	a,#1
4527  008b 2603          	jrne	L1003
4530  008d cd0000        	call	_UpdateBright
4532  0090               L7572:
4533                     ; 106         default:break;
4535  0090               L7003:
4536  0090               L1003:
4537                     ; 110     RecvFlag = 0;			
4539  0090 3f00          	clr	_RecvFlag
4540  0092               L7772:
4541                     ; 112 }
4544  0092 84            	pop	a
4545  0093 81            	ret
4548                     	bsct
4549  0003               L5103_timing_delay:
4550  0003 00            	dc.b	0
4586                     ; 115 @far @interrupt void TIM1_IRQHandler(void)
4586                     ; 116 {
4588                     	switch	.text
4589  0094               f_TIM1_IRQHandler:
4592  0094 3b0002        	push	c_x+2
4593  0097 be00          	ldw	x,c_x
4594  0099 89            	pushw	x
4595  009a 3b0002        	push	c_y+2
4596  009d be00          	ldw	x,c_y
4597  009f 89            	pushw	x
4600                     ; 119   if(clod_bright_update || warm_bright_update)
4602  00a0 3d00          	tnz	_clod_bright_update
4603  00a2 2604          	jrne	L7303
4605  00a4 3d00          	tnz	_warm_bright_update
4606  00a6 270d          	jreq	L5303
4607  00a8               L7303:
4608                     ; 121     timing_delay++;
4610  00a8 3c03          	inc	L5103_timing_delay
4611                     ; 122     if(20 == timing_delay) 
4613  00aa b603          	ld	a,L5103_timing_delay
4614  00ac a114          	cp	a,#20
4615  00ae 2605          	jrne	L5303
4616                     ; 124       CurBrighControl();
4618  00b0 cd0000        	call	_CurBrighControl
4620                     ; 125       timing_delay = 0;
4622  00b3 3f03          	clr	L5103_timing_delay
4623  00b5               L5303:
4624                     ; 128   TIM1_SR1 &= (~0x01);   
4626  00b5 72115255      	bres	_TIM1_SR1,#0
4627                     ; 129 }
4630  00b9 85            	popw	x
4631  00ba bf00          	ldw	c_y,x
4632  00bc 320002        	pop	c_y+2
4633  00bf 85            	popw	x
4634  00c0 bf00          	ldw	c_x,x
4635  00c2 320002        	pop	c_x+2
4636  00c5 80            	iret
4638                     	bsct
4639  0004               L3403_TempFlag:
4640  0004 00            	dc.b	0
4686                     ; 131 @far @interrupt void UART1_Recv_IRQHandler(void)
4686                     ; 132 {
4687                     	switch	.text
4688  00c6               f_UART1_Recv_IRQHandler:
4691       00000001      OFST:	set	1
4692  00c6 88            	push	a
4695                     ; 135   ch = UART1_DR;   
4697  00c7 c65231        	ld	a,_UART1_DR
4698  00ca 6b01          	ld	(OFST+0,sp),a
4699                     ; 136 	if(ch == HEKR_FRAME_HEADER)
4701  00cc 7b01          	ld	a,(OFST+0,sp)
4702  00ce a148          	cp	a,#72
4703  00d0 2606          	jrne	L7603
4704                     ; 138 		TempFlag = 1;
4706  00d2 35010004      	mov	L3403_TempFlag,#1
4707                     ; 139 		RecvCount = 0;
4709  00d6 3f01          	clr	_RecvCount
4710  00d8               L7603:
4711                     ; 141 	if(TempFlag)
4713  00d8 3d04          	tnz	L3403_TempFlag
4714  00da 2720          	jreq	L1703
4715                     ; 143 		RecvBuffer[RecvCount++] = ch;
4717  00dc b601          	ld	a,_RecvCount
4718  00de 97            	ld	xl,a
4719  00df 3c01          	inc	_RecvCount
4720  00e1 9f            	ld	a,xl
4721  00e2 5f            	clrw	x
4722  00e3 97            	ld	xl,a
4723  00e4 7b01          	ld	a,(OFST+0,sp)
4724  00e6 e700          	ld	(_RecvBuffer,x),a
4725                     ; 144 		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
4727  00e8 b601          	ld	a,_RecvCount
4728  00ea a105          	cp	a,#5
4729  00ec 250e          	jrult	L1703
4731  00ee b601          	ld	a,_RecvCount
4732  00f0 b101          	cp	a,_RecvBuffer+1
4733  00f2 2508          	jrult	L1703
4734                     ; 146 			RecvFlag = 1;
4736  00f4 35010000      	mov	_RecvFlag,#1
4737                     ; 147 			TempFlag = 0;
4739  00f8 3f04          	clr	L3403_TempFlag
4740                     ; 148 			RecvCount = 0;
4742  00fa 3f01          	clr	_RecvCount
4743  00fc               L1703:
4744                     ; 151 }
4747  00fc 84            	pop	a
4748  00fd 80            	iret
4799                     	xdef	f_UART1_Recv_IRQHandler
4800                     	xdef	f_TIM1_IRQHandler
4801                     	xdef	_main
4802                     	xdef	_DataHandle
4803                     	xdef	_System_init
4804                     	xdef	_UserValidLen
4805                     	switch	.ubsct
4806  0000               _RecvBuffer:
4807  0000 000000000000  	ds.b	20
4808                     	xdef	_RecvBuffer
4809                     	xdef	_RecvCount
4810                     	xdef	_RecvFlag
4811                     	xref	_Bright_ModeInit
4812                     	xref	_MCU_ConfigMode
4813                     	xref	_CurBrighControl
4814                     	xref	_UpdateBright
4815                     	xref	_LED_StateControl
4816                     	xref.b	_led_open_flag
4817                     	xref.b	_colour_set
4818                     	xref.b	_bright_set
4819                     	xref.b	_warm_bright_update
4820                     	xref.b	_clod_bright_update
4821                     	xref	_TIM1_Init
4822                     	xref	_TIM2_Init
4823                     	xref	_HekrValidDataUpload
4824                     	xref	_HekrModuleControl
4825                     	xref	_HekrRecvDataHandle
4826                     	xref	_HekrInit
4827                     	xref.b	_ModuleStatus
4828                     	xref.b	_valid_data
4829                     	xref	_UART1_SendChar
4830                     	xref	_UART1_Init
4831                     	xref	_delay_init
4832                     	xref	_System_Clock_init
4833                     	xref.b	c_x
4834                     	xref.b	c_y
4854                     	end
