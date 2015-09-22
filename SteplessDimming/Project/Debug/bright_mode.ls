   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4286                     ; 18 void Bright_ModeInit(void)
4286                     ; 19 {
4288                     	switch	.text
4289  0000               _Bright_ModeInit:
4291  0000 88            	push	a
4292       00000001      OFST:	set	1
4295                     ; 20   u8 count = 0;
4297  0001 0f01          	clr	(OFST+0,sp)
4298                     ; 22   count = ReadEEPROM(COUNT_BYTE);
4300  0003 4f            	clr	a
4301  0004 cd0000        	call	_ReadEEPROM
4303  0007 6b01          	ld	(OFST+0,sp),a
4304                     ; 23   if(count < 4)
4306  0009 7b01          	ld	a,(OFST+0,sp)
4307  000b a104          	cp	a,#4
4308  000d 240a          	jruge	L1572
4309                     ; 25     count++;
4311  000f 0c01          	inc	(OFST+0,sp)
4312                     ; 26     WriteEEPROM(COUNT_BYTE,count);
4314  0011 7b01          	ld	a,(OFST+0,sp)
4315  0013 97            	ld	xl,a
4316  0014 4f            	clr	a
4317  0015 95            	ld	xh,a
4318  0016 cd0000        	call	_WriteEEPROM
4320  0019               L1572:
4321                     ; 28   delay_ms(500);delay_ms(500);
4323  0019 ae01f4        	ldw	x,#500
4324  001c cd0000        	call	_delay_ms
4328  001f ae01f4        	ldw	x,#500
4329  0022 cd0000        	call	_delay_ms
4331                     ; 29   delay_ms(500);delay_ms(500);
4333  0025 ae01f4        	ldw	x,#500
4334  0028 cd0000        	call	_delay_ms
4338  002b ae01f4        	ldw	x,#500
4339  002e cd0000        	call	_delay_ms
4341                     ; 30   delay_ms(500);delay_ms(500);
4343  0031 ae01f4        	ldw	x,#500
4344  0034 cd0000        	call	_delay_ms
4348  0037 ae01f4        	ldw	x,#500
4349  003a cd0000        	call	_delay_ms
4351                     ; 31   delay_ms(500);delay_ms(500);
4353  003d ae01f4        	ldw	x,#500
4354  0040 cd0000        	call	_delay_ms
4358  0043 ae01f4        	ldw	x,#500
4359  0046 cd0000        	call	_delay_ms
4361                     ; 32   delay_ms(500);delay_ms(500);
4363  0049 ae01f4        	ldw	x,#500
4364  004c cd0000        	call	_delay_ms
4368  004f ae01f4        	ldw	x,#500
4369  0052 cd0000        	call	_delay_ms
4371                     ; 34   WriteEEPROM(COUNT_BYTE,0x00);
4373  0055 5f            	clrw	x
4374  0056 4f            	clr	a
4375  0057 95            	ld	xh,a
4376  0058 cd0000        	call	_WriteEEPROM
4378                     ; 36 	switch(count)
4380  005b 7b01          	ld	a,(OFST+0,sp)
4382                     ; 55   default:
4382                     ; 56           break;
4383  005d 4a            	dec	a
4384  005e 270b          	jreq	L3172
4385  0060 4a            	dec	a
4386  0061 2718          	jreq	L5172
4387  0063 4a            	dec	a
4388  0064 2725          	jreq	L7172
4389  0066 4a            	dec	a
4390  0067 2732          	jreq	L1272
4391  0069 2069          	jra	L5572
4392  006b               L3172:
4393                     ; 38   case 1: bright_set = ReadEEPROM(BrightMode1);
4395  006b a601          	ld	a,#1
4396  006d cd0000        	call	_ReadEEPROM
4398  0070 b700          	ld	_bright_set,a
4399                     ; 39           colour_set = ReadEEPROM(ColourMode1);
4401  0072 a602          	ld	a,#2
4402  0074 cd0000        	call	_ReadEEPROM
4404  0077 b700          	ld	_colour_set,a
4405                     ; 40           break;
4407  0079 2059          	jra	L5572
4408  007b               L5172:
4409                     ; 41   case 2: bright_set = ReadEEPROM(BrightMode2);
4411  007b a603          	ld	a,#3
4412  007d cd0000        	call	_ReadEEPROM
4414  0080 b700          	ld	_bright_set,a
4415                     ; 42           colour_set = ReadEEPROM(ColourMode2);
4417  0082 a604          	ld	a,#4
4418  0084 cd0000        	call	_ReadEEPROM
4420  0087 b700          	ld	_colour_set,a
4421                     ; 43           break;
4423  0089 2049          	jra	L5572
4424  008b               L7172:
4425                     ; 44   case 3: bright_set = ReadEEPROM(BrightMode3);
4427  008b a605          	ld	a,#5
4428  008d cd0000        	call	_ReadEEPROM
4430  0090 b700          	ld	_bright_set,a
4431                     ; 45           colour_set = ReadEEPROM(ColourMode3);
4433  0092 a606          	ld	a,#6
4434  0094 cd0000        	call	_ReadEEPROM
4436  0097 b700          	ld	_colour_set,a
4437                     ; 46           break;
4439  0099 2039          	jra	L5572
4440  009b               L1272:
4441                     ; 50   case 4: HekrModuleControl(HekrConfig);
4443  009b a604          	ld	a,#4
4444  009d cd0000        	call	_HekrModuleControl
4446                     ; 51           WriteEEPROM(BrightMode1,0x32);WriteEEPROM(ColourMode1,0x80);
4448  00a0 ae0032        	ldw	x,#50
4449  00a3 a601          	ld	a,#1
4450  00a5 95            	ld	xh,a
4451  00a6 cd0000        	call	_WriteEEPROM
4455  00a9 ae0080        	ldw	x,#128
4456  00ac a602          	ld	a,#2
4457  00ae 95            	ld	xh,a
4458  00af cd0000        	call	_WriteEEPROM
4460                     ; 52           WriteEEPROM(BrightMode2,0x32);WriteEEPROM(ColourMode2,0x00);
4462  00b2 ae0032        	ldw	x,#50
4463  00b5 a603          	ld	a,#3
4464  00b7 95            	ld	xh,a
4465  00b8 cd0000        	call	_WriteEEPROM
4469  00bb 5f            	clrw	x
4470  00bc a604          	ld	a,#4
4471  00be 95            	ld	xh,a
4472  00bf cd0000        	call	_WriteEEPROM
4474                     ; 53           WriteEEPROM(BrightMode3,0x32);WriteEEPROM(ColourMode3,0xFF);
4476  00c2 ae0032        	ldw	x,#50
4477  00c5 a605          	ld	a,#5
4478  00c7 95            	ld	xh,a
4479  00c8 cd0000        	call	_WriteEEPROM
4483  00cb ae00ff        	ldw	x,#255
4484  00ce a606          	ld	a,#6
4485  00d0 95            	ld	xh,a
4486  00d1 cd0000        	call	_WriteEEPROM
4488                     ; 54           break;
4490  00d4               L3272:
4491                     ; 55   default:
4491                     ; 56           break;
4493  00d4               L5572:
4494                     ; 58   UpdateBright();
4496  00d4 cd0000        	call	_UpdateBright
4498                     ; 59 }
4501  00d7 84            	pop	a
4502  00d8 81            	ret
4515                     	xref	_HekrModuleControl
4516                     	xref	_UpdateBright
4517                     	xref.b	_colour_set
4518                     	xref.b	_bright_set
4519                     	xref	_delay_ms
4520                     	xref	_WriteEEPROM
4521                     	xref	_ReadEEPROM
4522                     	xdef	_Bright_ModeInit
4541                     	end
