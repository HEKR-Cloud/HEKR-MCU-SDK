   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4271                     ; 4 static void EEPROM_UnLock(void)
4271                     ; 5 {
4273                     	switch	.text
4274  0000               L3172_EEPROM_UnLock:
4278                     ; 6   _asm("sim");
4281  0000 9b            sim
4283  0001               L3372:
4284                     ; 9     FLASH_DUKR = 0xae; 
4286  0001 35ae5064      	mov	_FLASH_DUKR,#174
4287                     ; 10     FLASH_DUKR = 0x56; 
4289  0005 35565064      	mov	_FLASH_DUKR,#86
4290                     ; 12 	while((FLASH_IAPSR & 0x08) == 0);
4292  0009 c6505f        	ld	a,_FLASH_IAPSR
4293  000c a508          	bcp	a,#8
4294  000e 27f1          	jreq	L3372
4295                     ; 13 }
4298  0010 81            	ret
4323                     ; 16 static void EEPROM_Lock(void)
4323                     ; 17 {
4324                     	switch	.text
4325  0011               L1472_EEPROM_Lock:
4329                     ; 18   FLASH_IAPSR &= ~(1 << 3);
4331  0011 7217505f      	bres	_FLASH_IAPSR,#3
4332                     ; 19   _asm("rim");
4335  0015 9a            rim
4337                     ; 20 }
4340  0016 81            	ret
4395                     ; 22 u8 ReadEEPROM(u8 dat)
4395                     ; 23 {
4396                     	switch	.text
4397  0017               _ReadEEPROM:
4399  0017 5203          	subw	sp,#3
4400       00000003      OFST:	set	3
4403                     ; 26   p = (unsigned char *)0x4000;
4405  0019 ae4000        	ldw	x,#16384
4406  001c 1f02          	ldw	(OFST-1,sp),x
4407                     ; 27 	p+=dat;
4409  001e 1b03          	add	a,(OFST+0,sp)
4410  0020 6b03          	ld	(OFST+0,sp),a
4411  0022 2402          	jrnc	L21
4412  0024 0c02          	inc	(OFST-1,sp)
4413  0026               L21:
4414                     ; 29 	EEPROM_UnLock();
4416  0026 add8          	call	L3172_EEPROM_UnLock
4418                     ; 30 	temp = *p;
4420  0028 7b01          	ld	a,(OFST-2,sp)
4421  002a 97            	ld	xl,a
4422  002b 1e02          	ldw	x,(OFST-1,sp)
4423  002d f6            	ld	a,(x)
4424  002e 97            	ld	xl,a
4425                     ; 31 	EEPROM_Lock();
4427  002f ade0          	call	L1472_EEPROM_Lock
4429                     ; 32 }
4432  0031 5b03          	addw	sp,#3
4433  0033 81            	ret
4489                     ; 34 u8 WriteEEPROM(u8 dat,u8 ch)
4489                     ; 35 {
4490                     	switch	.text
4491  0034               _WriteEEPROM:
4493  0034 89            	pushw	x
4494  0035 5204          	subw	sp,#4
4495       00000004      OFST:	set	4
4498                     ; 37 	p = (unsigned char *)0x4000;
4500  0037 ae4000        	ldw	x,#16384
4501  003a 1f03          	ldw	(OFST-1,sp),x
4502                     ; 38 	p+=dat;
4504  003c 7b05          	ld	a,(OFST+1,sp)
4505  003e 5f            	clrw	x
4506  003f 97            	ld	xl,a
4507  0040 1f01          	ldw	(OFST-3,sp),x
4508  0042 1e03          	ldw	x,(OFST-1,sp)
4509  0044 72fb01        	addw	x,(OFST-3,sp)
4510  0047 1f03          	ldw	(OFST-1,sp),x
4511                     ; 40 	EEPROM_UnLock();
4513  0049 adb5          	call	L3172_EEPROM_UnLock
4515                     ; 41 	*p = ch;
4517  004b 7b06          	ld	a,(OFST+2,sp)
4518  004d 1e03          	ldw	x,(OFST-1,sp)
4519  004f f7            	ld	(x),a
4521  0050               L3303:
4522                     ; 42 	while((FLASH_IAPSR & 0x04) == 0);
4524  0050 c6505f        	ld	a,_FLASH_IAPSR
4525  0053 a504          	bcp	a,#4
4526  0055 27f9          	jreq	L3303
4527                     ; 43 	EEPROM_Lock();
4529  0057 adb8          	call	L1472_EEPROM_Lock
4531                     ; 44 }
4534  0059 5b06          	addw	sp,#6
4535  005b 81            	ret
4548                     	xdef	_WriteEEPROM
4549                     	xdef	_ReadEEPROM
4568                     	end
