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
4242  0001 02            	dc.b	2
4243  0002 03            	dc.b	3
4244  0003 04            	dc.b	4
4245  0004 05            	dc.b	5
4246  0005 06            	dc.b	6
4247  0006 07            	dc.b	7
4248  0007 08            	dc.b	8
4249  0008 09            	dc.b	9
4250  0009 0a            	dc.b	10
4251  000a 0b            	dc.b	11
4252  000b 0c            	dc.b	12
4253  000c 0d            	dc.b	13
4254  000d 0e            	dc.b	14
4255  000e 0f            	dc.b	15
4256  000f 10            	dc.b	16
4335                     ; 59 main()
4335                     ; 60 {
4337                     	switch	.text
4338  0000               _main:
4340  0000 88            	push	a
4341       00000001      OFST:	set	1
4344                     ; 62 	u8 UserValidLen = 9;
4346  0001 a609          	ld	a,#9
4347  0003 6b01          	ld	(OFST+0,sp),a
4348                     ; 63 	System_init();
4350  0005 ad3f          	call	_System_init
4352                     ; 77 	HekrValidDataUpload(UserValidLen);
4354  0007 7b01          	ld	a,(OFST+0,sp)
4355  0009 cd0000        	call	_HekrValidDataUpload
4357                     ; 79 	HekrModuleControl(ModuleQuery);
4359  000c a601          	ld	a,#1
4360  000e cd0000        	call	_HekrModuleControl
4362  0011               L3472:
4363                     ; 83 		if(RecvFlag && !DateHandleFlag)
4365  0011 3d00          	tnz	_RecvFlag
4366  0013 270a          	jreq	L7472
4368  0015 3d02          	tnz	_DateHandleFlag
4369  0017 2606          	jrne	L7472
4370                     ; 85 			DateHandleFlag = 1;
4372  0019 35010002      	mov	_DateHandleFlag,#1
4373                     ; 86 			RecvFlag = 0;
4375  001d 3f00          	clr	_RecvFlag
4376  001f               L7472:
4377                     ; 88 		if(DateHandleFlag)
4379  001f 3d02          	tnz	_DateHandleFlag
4380  0021 27ee          	jreq	L3472
4381                     ; 90 			temp = HekrRecvDataHandle(RecvBuffer);
4383  0023 ae0000        	ldw	x,#_RecvBuffer
4384  0026 cd0000        	call	_HekrRecvDataHandle
4386  0029 6b01          	ld	(OFST+0,sp),a
4387                     ; 91 			if(ValidDataUpdate == temp)
4389  002b 7b01          	ld	a,(OFST+0,sp)
4390  002d a104          	cp	a,#4
4391  002f 2605          	jrne	L3572
4392                     ; 95 				UART1_SendChar(valid_data[0]);
4394  0031 b600          	ld	a,_valid_data
4395  0033 cd0000        	call	_UART1_SendChar
4397  0036               L3572:
4398                     ; 97 			if(HekrModuleStateUpdate == temp)
4400  0036 7b01          	ld	a,(OFST+0,sp)
4401  0038 a106          	cp	a,#6
4402  003a 2606          	jrne	L5572
4403                     ; 101 				UART1_SendChar(ModuleStatus->CMD);
4405  003c 92c600        	ld	a,[_ModuleStatus.w]
4406  003f cd0000        	call	_UART1_SendChar
4408  0042               L5572:
4409                     ; 103 			DateHandleFlag = 0;			
4411  0042 3f02          	clr	_DateHandleFlag
4412  0044 20cb          	jra	L3472
4442                     ; 109 void System_init(void)
4442                     ; 110 {
4443                     	switch	.text
4444  0046               _System_init:
4448                     ; 111 	System_Clock_init();
4450  0046 cd0000        	call	_System_Clock_init
4452                     ; 112 	UART1_Init();
4454  0049 cd0000        	call	_UART1_Init
4456                     ; 113 	delay_init(16);
4458  004c a610          	ld	a,#16
4459  004e cd0000        	call	_delay_init
4461                     ; 114 	HekrInit(UART1_SendChar);
4463  0051 ae0000        	ldw	x,#_UART1_SendChar
4464  0054 cd0000        	call	_HekrInit
4466                     ; 115 	_asm("rim");
4469  0057 9a            rim
4471                     ; 116 }
4474  0058 81            	ret
4477                     	bsct
4478  0003               L7672_TempFlag:
4479  0003 00            	dc.b	0
4525                     ; 118 @far @interrupt void UART1_Recv_IRQHandler(void)
4525                     ; 119 {
4527                     	switch	.text
4528  0059               f_UART1_Recv_IRQHandler:
4530       00000001      OFST:	set	1
4531  0059 88            	push	a
4534                     ; 122   ch = UART1_DR;   
4536  005a c65231        	ld	a,_UART1_DR
4537  005d 6b01          	ld	(OFST+0,sp),a
4538                     ; 123 	if(ch == HEKR_FRAME_HEADER)
4540  005f 7b01          	ld	a,(OFST+0,sp)
4541  0061 a148          	cp	a,#72
4542  0063 2606          	jrne	L3103
4543                     ; 125 		TempFlag = 1;
4545  0065 35010003      	mov	L7672_TempFlag,#1
4546                     ; 126 		RecvCount = 0;
4548  0069 3f01          	clr	_RecvCount
4549  006b               L3103:
4550                     ; 128 	if(TempFlag)
4552  006b 3d03          	tnz	L7672_TempFlag
4553  006d 2720          	jreq	L5103
4554                     ; 130 		RecvBuffer[RecvCount++] = ch;
4556  006f b601          	ld	a,_RecvCount
4557  0071 97            	ld	xl,a
4558  0072 3c01          	inc	_RecvCount
4559  0074 9f            	ld	a,xl
4560  0075 5f            	clrw	x
4561  0076 97            	ld	xl,a
4562  0077 7b01          	ld	a,(OFST+0,sp)
4563  0079 e700          	ld	(_RecvBuffer,x),a
4564                     ; 131 		if(RecvCount > 4 && RecvCount >= RecvBuffer[1])
4566  007b b601          	ld	a,_RecvCount
4567  007d a105          	cp	a,#5
4568  007f 250e          	jrult	L5103
4570  0081 b601          	ld	a,_RecvCount
4571  0083 b101          	cp	a,_RecvBuffer+1
4572  0085 2508          	jrult	L5103
4573                     ; 133 			RecvFlag = 1;
4575  0087 35010000      	mov	_RecvFlag,#1
4576                     ; 134 			TempFlag = 0;
4578  008b 3f03          	clr	L7672_TempFlag
4579                     ; 135 			RecvCount = 0;
4581  008d 3f01          	clr	_RecvCount
4582  008f               L5103:
4583                     ; 138 }
4586  008f 84            	pop	a
4587  0090 80            	iret
4648                     	xdef	f_UART1_Recv_IRQHandler
4649                     	xdef	_main
4650                     	xdef	_System_init
4651                     	xdef	_ProdKey
4652                     	xdef	_DateHandleFlag
4653                     	switch	.ubsct
4654  0000               _RecvBuffer:
4655  0000 000000000000  	ds.b	20
4656                     	xdef	_RecvBuffer
4657                     	xdef	_RecvCount
4658                     	xdef	_RecvFlag
4659                     	xref	_HekrValidDataUpload
4660                     	xref	_HekrModuleControl
4661                     	xref	_HekrRecvDataHandle
4662                     	xref	_HekrInit
4663                     	xref.b	_ModuleStatus
4664                     	xref.b	_valid_data
4665                     	xref	_UART1_SendChar
4666                     	xref	_UART1_Init
4667                     	xref	_delay_init
4668                     	xref	_System_Clock_init
4688                     	end
