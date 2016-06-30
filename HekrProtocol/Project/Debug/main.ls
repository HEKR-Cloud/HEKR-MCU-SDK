   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
4232                     	bsct
4233  0000               _RecvFlag:
4234  0000 00            	dc.b	0
4235  0001               _RecvCount:
4236  0001 00            	dc.b	0
4237  0002               _DateHandleFlag:
4238  0002 00            	dc.b	0
4239                     	switch	.data
4240  0000               _ProdKey:
4241  0000 01            	dc.b	1
4242  0001 36            	dc.b	54
4243  0002 a6            	dc.b	166
4244  0003 6c            	dc.b	108
4245  0004 12            	dc.b	18
4246  0005 75            	dc.b	117
4247  0006 4e            	dc.b	78
4248  0007 e8            	dc.b	232
4249  0008 2f            	dc.b	47
4250  0009 ff            	dc.b	255
4251  000a 88            	dc.b	136
4252  000b 04            	dc.b	4
4253  000c b7            	dc.b	183
4254  000d fa            	dc.b	250
4255  000e a5            	dc.b	165
4256  000f 3c            	dc.b	60
4335                     ; 70 main()
4335                     ; 71 {
4337                     	switch	.text
4338  0000               _main:
4340  0000 88            	push	a
4341       00000001      OFST:	set	1
4344                     ; 73 	u8 UserValidLen = 9;
4346  0001 a609          	ld	a,#9
4347  0003 6b01          	ld	(OFST+0,sp),a
4348                     ; 74 	System_init();
4350  0005 ad53          	call	_System_init
4352                     ; 76 	HekrValidDataUpload(UserValidLen);	   //上传有效数据
4354  0007 7b01          	ld	a,(OFST+0,sp)
4355  0009 cd0000        	call	_HekrValidDataUpload
4357                     ; 78 	Module_State_Function();               //模块状态查询
4359  000c cd0000        	call	_Module_State_Function
4361  000f               L3472:
4362                     ; 93 		if(RecvFlag && !DateHandleFlag)
4364  000f 3d00          	tnz	_RecvFlag
4365  0011 270a          	jreq	L7472
4367  0013 3d02          	tnz	_DateHandleFlag
4368  0015 2606          	jrne	L7472
4369                     ; 95 			DateHandleFlag = 1;
4371  0017 35010002      	mov	_DateHandleFlag,#1
4372                     ; 96 			RecvFlag = 0;
4374  001b 3f00          	clr	_RecvFlag
4375  001d               L7472:
4376                     ; 98 		if(DateHandleFlag)
4378  001d 3d02          	tnz	_DateHandleFlag
4379  001f 27ee          	jreq	L3472
4380                     ; 100 			temp = HekrRecvDataHandle(RecvBuffer);
4382  0021 ae0000        	ldw	x,#_RecvBuffer
4383  0024 cd0000        	call	_HekrRecvDataHandle
4385  0027 6b01          	ld	(OFST+0,sp),a
4386                     ; 101 			if(ValidDataUpdate == temp)
4388  0029 7b01          	ld	a,(OFST+0,sp)
4389  002b a104          	cp	a,#4
4390  002d 2605          	jrne	L3572
4391                     ; 105 				UART1_SendChar(valid_data[0]);
4393  002f b600          	ld	a,_valid_data
4394  0031 cd0000        	call	_UART1_SendChar
4396  0034               L3572:
4397                     ; 108 			if(HekrModuleStateUpdate == temp)
4399  0034 7b01          	ld	a,(OFST+0,sp)
4400  0036 a106          	cp	a,#6
4401  0038 261c          	jrne	L5572
4402                     ; 112 				UART1_SendChar(ModuleStatus->Mode);           //打印模块工作模式指示字节
4404  003a be00          	ldw	x,_ModuleStatus
4405  003c e601          	ld	a,(1,x)
4406  003e cd0000        	call	_UART1_SendChar
4408                     ; 113 				UART1_SendChar(ModuleStatus->WIFI_Status);    //打印模块WIFI状态指示字节
4410  0041 be00          	ldw	x,_ModuleStatus
4411  0043 e602          	ld	a,(2,x)
4412  0045 cd0000        	call	_UART1_SendChar
4414                     ; 114 				UART1_SendChar(ModuleStatus->CloudStatus);    //打印模块云连接状态指示字节
4416  0048 be00          	ldw	x,_ModuleStatus
4417  004a e603          	ld	a,(3,x)
4418  004c cd0000        	call	_UART1_SendChar
4420                     ; 115 				UART1_SendChar(ModuleStatus->SignalStrength); //打印模块状态查询应答帧保留字节
4422  004f be00          	ldw	x,_ModuleStatus
4423  0051 e604          	ld	a,(4,x)
4424  0053 cd0000        	call	_UART1_SendChar
4426  0056               L5572:
4427                     ; 119 			DateHandleFlag = 0;			
4429  0056 3f02          	clr	_DateHandleFlag
4430  0058 20b5          	jra	L3472
4460                     ; 125 void System_init(void)
4460                     ; 126 {
4461                     	switch	.text
4462  005a               _System_init:
4466                     ; 127 	System_Clock_init();
4468  005a cd0000        	call	_System_Clock_init
4470                     ; 128 	UART1_Init();
4472  005d cd0000        	call	_UART1_Init
4474                     ; 129 	delay_init(16);
4476  0060 a610          	ld	a,#16
4477  0062 cd0000        	call	_delay_init
4479                     ; 130 	HekrInit(UART1_SendChar);
4481  0065 ae0000        	ldw	x,#_UART1_SendChar
4482  0068 cd0000        	call	_HekrInit
4484                     ; 131 	_asm("rim");
4487  006b 9a            rim
4489                     ; 132 }
4492  006c 81            	ret
4495                     	bsct
4496  0003               L7672_TempFlag:
4497  0003 00            	dc.b	0
4543                     ; 134 @far @interrupt void UART1_Recv_IRQHandler(void)
4543                     ; 135 {
4545                     	switch	.text
4546  006d               f_UART1_Recv_IRQHandler:
4548       00000001      OFST:	set	1
4549  006d 88            	push	a
4552                     ; 138   ch = UART1_DR;   
4554  006e c65231        	ld	a,_UART1_DR
4555  0071 6b01          	ld	(OFST+0,sp),a
4556                     ; 139 	if(ch == HEKR_FRAME_HEADER)
4558  0073 7b01          	ld	a,(OFST+0,sp)
4559  0075 a148          	cp	a,#72
4560  0077 2606          	jrne	L3103
4561                     ; 141 		TempFlag = 1;
4563  0079 35010003      	mov	L7672_TempFlag,#1
4564                     ; 142 		RecvCount = 0;
4566  007d 3f01          	clr	_RecvCount
4567  007f               L3103:
4568                     ; 144 	if(TempFlag)
4570  007f 3d03          	tnz	L7672_TempFlag
4571  0081 2720          	jreq	L5103
4572                     ; 146 		RecvBuffer[RecvCount++] = ch;
4574  0083 b601          	ld	a,_RecvCount
4575  0085 97            	ld	xl,a
4576  0086 3c01          	inc	_RecvCount
4577  0088 9f            	ld	a,xl
4578  0089 5f            	clrw	x
4579  008a 97            	ld	xl,a
4580  008b 7b01          	ld	a,(OFST+0,sp)
4581  008d e700          	ld	(_RecvBuffer,x),a
4582                     ; 147 		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
4584  008f b601          	ld	a,_RecvCount
4585  0091 a105          	cp	a,#5
4586  0093 250e          	jrult	L5103
4588  0095 b601          	ld	a,_RecvCount
4589  0097 b101          	cp	a,_RecvBuffer+1
4590  0099 2508          	jrult	L5103
4591                     ; 149 			RecvFlag = 1;
4593  009b 35010000      	mov	_RecvFlag,#1
4594                     ; 150 			TempFlag = 0;
4596  009f 3f03          	clr	L7672_TempFlag
4597                     ; 151 			RecvCount = 0;
4599  00a1 3f01          	clr	_RecvCount
4600  00a3               L5103:
4601                     ; 154 }
4604  00a3 84            	pop	a
4605  00a4 80            	iret
4666                     	xdef	f_UART1_Recv_IRQHandler
4667                     	xdef	_main
4668                     	xdef	_System_init
4669                     	xdef	_ProdKey
4670                     	xdef	_DateHandleFlag
4671                     	switch	.ubsct
4672  0000               _RecvBuffer:
4673  0000 000000000000  	ds.b	20
4674                     	xdef	_RecvBuffer
4675                     	xdef	_RecvCount
4676                     	xdef	_RecvFlag
4677                     	xref	_Module_State_Function
4678                     	xref	_HekrValidDataUpload
4679                     	xref	_HekrRecvDataHandle
4680                     	xref	_HekrInit
4681                     	xref.b	_ModuleStatus
4682                     	xref.b	_valid_data
4683                     	xref	_UART1_SendChar
4684                     	xref	_UART1_Init
4685                     	xref	_delay_init
4686                     	xref	_System_Clock_init
4706                     	end
