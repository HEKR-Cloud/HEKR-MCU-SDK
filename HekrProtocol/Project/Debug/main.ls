   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4221                     	bsct
4222  0000               _RecvFlag:
4223  0000 00            	dc.b	0
4224  0001               _RecvCount:
4225  0001 00            	dc.b	0
4226  0002               _DateHandleFlag:
4227  0002 00            	dc.b	0
4306                     ; 58 main()
4306                     ; 59 {
4308                     	switch	.text
4309  0000               _main:
4311  0000 88            	push	a
4312       00000001      OFST:	set	1
4315                     ; 61 	u8 UserValidLen = 9;
4317  0001 a609          	ld	a,#9
4318  0003 6b01          	ld	(OFST+0,sp),a
4319                     ; 62 	System_init();
4321  0005 ad3f          	call	_System_init
4323                     ; 65 	HekrValidDataUpload(UserValidLen);
4325  0007 7b01          	ld	a,(OFST+0,sp)
4326  0009 cd0000        	call	_HekrValidDataUpload
4328                     ; 67 	HekrModuleControl(ModuleQuery);
4330  000c a601          	ld	a,#1
4331  000e cd0000        	call	_HekrModuleControl
4333  0011               L3472:
4334                     ; 71 		if(RecvFlag && !DateHandleFlag)
4336  0011 3d00          	tnz	_RecvFlag
4337  0013 270a          	jreq	L7472
4339  0015 3d02          	tnz	_DateHandleFlag
4340  0017 2606          	jrne	L7472
4341                     ; 73 			DateHandleFlag = 1;
4343  0019 35010002      	mov	_DateHandleFlag,#1
4344                     ; 74 			RecvFlag = 0;
4346  001d 3f00          	clr	_RecvFlag
4347  001f               L7472:
4348                     ; 76 		if(DateHandleFlag)
4350  001f 3d02          	tnz	_DateHandleFlag
4351  0021 27ee          	jreq	L3472
4352                     ; 78 			temp = HekrRecvDataHandle(RecvBuffer);
4354  0023 ae0000        	ldw	x,#_RecvBuffer
4355  0026 cd0000        	call	_HekrRecvDataHandle
4357  0029 6b01          	ld	(OFST+0,sp),a
4358                     ; 79 			if(ValidDataUpdate == temp)
4360  002b 7b01          	ld	a,(OFST+0,sp)
4361  002d a104          	cp	a,#4
4362  002f 2605          	jrne	L3572
4363                     ; 83 				UART1_SendChar(valid_data[0]);
4365  0031 b600          	ld	a,_valid_data
4366  0033 cd0000        	call	_UART1_SendChar
4368  0036               L3572:
4369                     ; 85 			if(HekrModuleStateUpdate == temp)
4371  0036 7b01          	ld	a,(OFST+0,sp)
4372  0038 a106          	cp	a,#6
4373  003a 2606          	jrne	L5572
4374                     ; 89 				UART1_SendChar(ModuleStatus->CMD);
4376  003c 92c600        	ld	a,[_ModuleStatus.w]
4377  003f cd0000        	call	_UART1_SendChar
4379  0042               L5572:
4380                     ; 91 			DateHandleFlag = 0;			
4382  0042 3f02          	clr	_DateHandleFlag
4383  0044 20cb          	jra	L3472
4413                     ; 97 void System_init(void)
4413                     ; 98 {
4414                     	switch	.text
4415  0046               _System_init:
4419                     ; 99 	System_Clock_init();
4421  0046 cd0000        	call	_System_Clock_init
4423                     ; 100 	UART1_Init();
4425  0049 cd0000        	call	_UART1_Init
4427                     ; 101 	delay_init(16);
4429  004c a610          	ld	a,#16
4430  004e cd0000        	call	_delay_init
4432                     ; 102 	HekrInit(UART1_SendChar);
4434  0051 ae0000        	ldw	x,#_UART1_SendChar
4435  0054 cd0000        	call	_HekrInit
4437                     ; 103 	_asm("rim");
4440  0057 9a            rim
4442                     ; 104 }
4445  0058 81            	ret
4448                     	bsct
4449  0003               L7672_TempFlag:
4450  0003 00            	dc.b	0
4496                     ; 106 @far @interrupt void UART1_Recv_IRQHandler(void)
4496                     ; 107 {
4498                     	switch	.text
4499  0059               f_UART1_Recv_IRQHandler:
4502       00000001      OFST:	set	1
4503  0059 88            	push	a
4506                     ; 110   ch = UART1_DR;   
4508  005a c65231        	ld	a,_UART1_DR
4509  005d 6b01          	ld	(OFST+0,sp),a
4510                     ; 111 	if(ch == HEKR_FRAME_HEADER)
4512  005f 7b01          	ld	a,(OFST+0,sp)
4513  0061 a148          	cp	a,#72
4514  0063 2606          	jrne	L3103
4515                     ; 113 		TempFlag = 1;
4517  0065 35010003      	mov	L7672_TempFlag,#1
4518                     ; 114 		RecvCount = 0;
4520  0069 3f01          	clr	_RecvCount
4521  006b               L3103:
4522                     ; 116 	if(TempFlag)
4524  006b 3d03          	tnz	L7672_TempFlag
4525  006d 2720          	jreq	L5103
4526                     ; 118 		RecvBuffer[RecvCount++] = ch;
4528  006f b601          	ld	a,_RecvCount
4529  0071 97            	ld	xl,a
4530  0072 3c01          	inc	_RecvCount
4531  0074 9f            	ld	a,xl
4532  0075 5f            	clrw	x
4533  0076 97            	ld	xl,a
4534  0077 7b01          	ld	a,(OFST+0,sp)
4535  0079 e700          	ld	(_RecvBuffer,x),a
4536                     ; 119 		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
4538  007b b601          	ld	a,_RecvCount
4539  007d a105          	cp	a,#5
4540  007f 250e          	jrult	L5103
4542  0081 b601          	ld	a,_RecvCount
4543  0083 b101          	cp	a,_RecvBuffer+1
4544  0085 2508          	jrult	L5103
4545                     ; 121 			RecvFlag = 1;
4547  0087 35010000      	mov	_RecvFlag,#1
4548                     ; 122 			TempFlag = 0;
4550  008b 3f03          	clr	L7672_TempFlag
4551                     ; 123 			RecvCount = 0;
4553  008d 3f01          	clr	_RecvCount
4554  008f               L5103:
4555                     ; 126 }
4558  008f 84            	pop	a
4559  0090 80            	iret
4610                     	xdef	f_UART1_Recv_IRQHandler
4611                     	xdef	_main
4612                     	xdef	_System_init
4613                     	xdef	_DateHandleFlag
4614                     	switch	.ubsct
4615  0000               _RecvBuffer:
4616  0000 000000000000  	ds.b	20
4617                     	xdef	_RecvBuffer
4618                     	xdef	_RecvCount
4619                     	xdef	_RecvFlag
4620                     	xref	_HekrValidDataUpload
4621                     	xref	_HekrModuleControl
4622                     	xref	_HekrRecvDataHandle
4623                     	xref	_HekrInit
4624                     	xref.b	_ModuleStatus
4625                     	xref.b	_valid_data
4626                     	xref	_UART1_SendChar
4627                     	xref	_UART1_Init
4628                     	xref	_delay_init
4629                     	xref	_System_Clock_init
4649                     	end
