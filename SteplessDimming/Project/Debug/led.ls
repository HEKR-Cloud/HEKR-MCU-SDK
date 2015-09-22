   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
4221                     	bsct
4222  0000               _clod_bright_update:
4223  0000 00            	dc.b	0
4224  0001               _warm_bright_update:
4225  0001 00            	dc.b	0
4226  0002               _cur_clod_bright:
4227  0002 0000          	dc.w	0
4228  0004               _cur_warm_bright:
4229  0004 0000          	dc.w	0
4230  0006               _goal_clod_bright:
4231  0006 0000          	dc.w	0
4232  0008               _goal_warm_bright:
4233  0008 0000          	dc.w	0
4234  000a               _bright_set:
4235  000a 00            	dc.b	0
4236  000b               _colour_set:
4237  000b 00            	dc.b	0
4238  000c               _led_open_flag:
4239  000c 01            	dc.b	1
4301                     ; 31 void LED_WarmWhiteBrightSet(u16 dat)
4301                     ; 32 {
4303                     	switch	.text
4304  0000               _LED_WarmWhiteBrightSet:
4306  0000 89            	pushw	x
4307       00000000      OFST:	set	0
4310                     ; 34   TIM2_CH2_Duty(dat >> 8,dat);
4312  0001 9f            	ld	a,xl
4313  0002 97            	ld	xl,a
4314  0003 7b01          	ld	a,(OFST+1,sp)
4315  0005 95            	ld	xh,a
4316  0006 cd0000        	call	_TIM2_CH2_Duty
4318                     ; 35 }
4321  0009 85            	popw	x
4322  000a 81            	ret
4358                     ; 38 void LED_ClodWhiteBrightSet(u16 dat)
4358                     ; 39 {
4359                     	switch	.text
4360  000b               _LED_ClodWhiteBrightSet:
4362  000b 89            	pushw	x
4363       00000000      OFST:	set	0
4366                     ; 41   TIM2_CH3_Duty(dat >> 8,dat);
4368  000c 9f            	ld	a,xl
4369  000d 97            	ld	xl,a
4370  000e 7b01          	ld	a,(OFST+1,sp)
4371  0010 95            	ld	xh,a
4372  0011 cd0000        	call	_TIM2_CH3_Duty
4374                     ; 42 }
4377  0014 85            	popw	x
4378  0015 81            	ret
4415                     ; 45 void LED_StateControl(u8 dat)
4415                     ; 46 {
4416                     	switch	.text
4417  0016               _LED_StateControl:
4421                     ; 47   if(1 == dat)
4423  0016 a101          	cp	a,#1
4424  0018 2608          	jrne	L1003
4425                     ; 49     LED_Open();
4427  001a ad1c          	call	L5172_LED_Open
4429                     ; 50     led_open_flag = 1;
4431  001c 3501000c      	mov	_led_open_flag,#1
4433  0020 2006          	jra	L3003
4434  0022               L1003:
4435                     ; 54     LED_Close();
4437  0022 ad05          	call	L3172_LED_Close
4439                     ; 55     led_open_flag = 2;
4441  0024 3502000c      	mov	_led_open_flag,#2
4442  0028               L3003:
4443                     ; 57 }
4446  0028 81            	ret
4473                     ; 62 static void LED_Close(void)
4473                     ; 63 {
4474                     	switch	.text
4475  0029               L3172_LED_Close:
4479                     ; 64   goal_clod_bright = 0x0000;
4481  0029 5f            	clrw	x
4482  002a bf06          	ldw	_goal_clod_bright,x
4483                     ; 65   goal_warm_bright = 0x0000;
4485  002c 5f            	clrw	x
4486  002d bf08          	ldw	_goal_warm_bright,x
4487                     ; 66   clod_bright_update = 1;
4489  002f 35010000      	mov	_clod_bright_update,#1
4490                     ; 67   warm_bright_update = 1;
4492  0033 35010001      	mov	_warm_bright_update,#1
4493                     ; 68 }
4496  0037 81            	ret
4520                     ; 74 static void LED_Open(void)
4520                     ; 75 {
4521                     	switch	.text
4522  0038               L5172_LED_Open:
4526                     ; 76   UpdateBright();
4528  0038 cd00cf        	call	_UpdateBright
4530                     ; 77 }
4533  003b 81            	ret
4580                     ; 81 static void UpdateColourTemp(void)            
4580                     ; 82 {
4581                     	switch	.text
4582  003c               L5203_UpdateColourTemp:
4584  003c 5203          	subw	sp,#3
4585       00000003      OFST:	set	3
4588                     ; 83     u16 temp = bright_set;
4590  003e b60a          	ld	a,_bright_set
4591  0040 5f            	clrw	x
4592  0041 97            	ld	xl,a
4593  0042 1f02          	ldw	(OFST-1,sp),x
4594                     ; 86     if(colour_set >0x80)
4596  0044 b60b          	ld	a,_colour_set
4597  0046 a181          	cp	a,#129
4598  0048 2540          	jrult	L1503
4599                     ; 88         colour_temp =  0xFF - colour_set;
4601  004a a6ff          	ld	a,#255
4602  004c b00b          	sub	a,_colour_set
4603  004e 6b01          	ld	(OFST-2,sp),a
4604                     ; 89         if(temp < 0x80)
4606  0050 1e02          	ldw	x,(OFST-1,sp)
4607  0052 a30080        	cpw	x,#128
4608  0055 2415          	jruge	L3503
4609                     ; 90             temp = temp * colour_temp / 0x80;
4611  0057 1e02          	ldw	x,(OFST-1,sp)
4612  0059 7b01          	ld	a,(OFST-2,sp)
4613  005b 905f          	clrw	y
4614  005d 9097          	ld	yl,a
4615  005f cd0000        	call	c_imul
4617  0062 a607          	ld	a,#7
4618  0064               L02:
4619  0064 54            	srlw	x
4620  0065 4a            	dec	a
4621  0066 26fc          	jrne	L02
4622  0068 1f02          	ldw	(OFST-1,sp),x
4624  006a 2013          	jra	L5503
4625  006c               L3503:
4626                     ; 92             temp = temp / 0x80 * colour_temp ;
4628  006c 1e02          	ldw	x,(OFST-1,sp)
4629  006e a607          	ld	a,#7
4630  0070               L22:
4631  0070 54            	srlw	x
4632  0071 4a            	dec	a
4633  0072 26fc          	jrne	L22
4634  0074 7b01          	ld	a,(OFST-2,sp)
4635  0076 905f          	clrw	y
4636  0078 9097          	ld	yl,a
4637  007a cd0000        	call	c_imul
4639  007d 1f02          	ldw	(OFST-1,sp),x
4640  007f               L5503:
4641                     ; 93         goal_clod_bright = (temp) * (temp);
4643  007f 1e02          	ldw	x,(OFST-1,sp)
4644  0081 1602          	ldw	y,(OFST-1,sp)
4645  0083 cd0000        	call	c_imul
4647  0086 bf06          	ldw	_goal_clod_bright,x
4649  0088 2042          	jra	L7503
4650  008a               L1503:
4651                     ; 95     else if (colour_set < 0x80)
4653  008a b60b          	ld	a,_colour_set
4654  008c a180          	cp	a,#128
4655  008e 243c          	jruge	L7503
4656                     ; 97         colour_temp =  colour_set;
4658  0090 b60b          	ld	a,_colour_set
4659  0092 6b01          	ld	(OFST-2,sp),a
4660                     ; 98         if(temp < 0x80)
4662  0094 1e02          	ldw	x,(OFST-1,sp)
4663  0096 a30080        	cpw	x,#128
4664  0099 2415          	jruge	L3603
4665                     ; 99             temp = temp * colour_temp / 0x80;
4667  009b 1e02          	ldw	x,(OFST-1,sp)
4668  009d 7b01          	ld	a,(OFST-2,sp)
4669  009f 905f          	clrw	y
4670  00a1 9097          	ld	yl,a
4671  00a3 cd0000        	call	c_imul
4673  00a6 a607          	ld	a,#7
4674  00a8               L42:
4675  00a8 54            	srlw	x
4676  00a9 4a            	dec	a
4677  00aa 26fc          	jrne	L42
4678  00ac 1f02          	ldw	(OFST-1,sp),x
4680  00ae 2013          	jra	L5603
4681  00b0               L3603:
4682                     ; 101             temp = temp / 0x80 * colour_temp;
4684  00b0 1e02          	ldw	x,(OFST-1,sp)
4685  00b2 a607          	ld	a,#7
4686  00b4               L62:
4687  00b4 54            	srlw	x
4688  00b5 4a            	dec	a
4689  00b6 26fc          	jrne	L62
4690  00b8 7b01          	ld	a,(OFST-2,sp)
4691  00ba 905f          	clrw	y
4692  00bc 9097          	ld	yl,a
4693  00be cd0000        	call	c_imul
4695  00c1 1f02          	ldw	(OFST-1,sp),x
4696  00c3               L5603:
4697                     ; 102         goal_warm_bright = (temp) * (temp);
4699  00c3 1e02          	ldw	x,(OFST-1,sp)
4700  00c5 1602          	ldw	y,(OFST-1,sp)
4701  00c7 cd0000        	call	c_imul
4703  00ca bf08          	ldw	_goal_warm_bright,x
4705  00cc               L7503:
4706                     ; 107 }
4709  00cc 5b03          	addw	sp,#3
4710  00ce 81            	ret
4739                     ; 110 void UpdateBright(void)             
4739                     ; 111 {
4740                     	switch	.text
4741  00cf               _UpdateBright:
4745                     ; 112     if(!bright_set)
4747  00cf 3d0a          	tnz	_bright_set
4748  00d1 2601          	jrne	L1013
4749                     ; 113         return ;
4752  00d3 81            	ret
4753  00d4               L1013:
4754                     ; 115     goal_clod_bright = goal_warm_bright = bright_set * bright_set;
4756  00d4 b60a          	ld	a,_bright_set
4757  00d6 97            	ld	xl,a
4758  00d7 b60a          	ld	a,_bright_set
4759  00d9 42            	mul	x,a
4760  00da bf08          	ldw	_goal_warm_bright,x
4761  00dc be08          	ldw	x,_goal_warm_bright
4762  00de bf06          	ldw	_goal_clod_bright,x
4763                     ; 116     UpdateColourTemp();
4765  00e0 cd003c        	call	L5203_UpdateColourTemp
4767                     ; 118     clod_bright_update = 1;
4769  00e3 35010000      	mov	_clod_bright_update,#1
4770                     ; 119     warm_bright_update = 1;
4772  00e7 35010001      	mov	_warm_bright_update,#1
4773                     ; 120 }
4776  00eb 81            	ret
4818                     ; 122 void CurBrighControl(void)
4818                     ; 123 {
4819                     	switch	.text
4820  00ec               _CurBrighControl:
4822  00ec 89            	pushw	x
4823       00000002      OFST:	set	2
4826                     ; 125   if(clod_bright_update)
4828  00ed 3d00          	tnz	_clod_bright_update
4829  00ef 2739          	jreq	L1213
4830                     ; 127     temp = cur_clod_bright * cur_clod_bright;
4832  00f1 be02          	ldw	x,_cur_clod_bright
4833  00f3 90be02        	ldw	y,_cur_clod_bright
4834  00f6 cd0000        	call	c_imul
4836  00f9 1f01          	ldw	(OFST-1,sp),x
4837                     ; 128     if (temp == goal_clod_bright)
4839  00fb 1e01          	ldw	x,(OFST-1,sp)
4840  00fd b306          	cpw	x,_goal_clod_bright
4841  00ff 2604          	jrne	L3213
4842                     ; 129       clod_bright_update = 0;
4844  0101 3f00          	clr	_clod_bright_update
4846  0103 2016          	jra	L5213
4847  0105               L3213:
4848                     ; 130     else if(temp > goal_clod_bright)
4850  0105 1e01          	ldw	x,(OFST-1,sp)
4851  0107 b306          	cpw	x,_goal_clod_bright
4852  0109 2309          	jrule	L7213
4853                     ; 131       cur_clod_bright--;
4855  010b be02          	ldw	x,_cur_clod_bright
4856  010d 1d0001        	subw	x,#1
4857  0110 bf02          	ldw	_cur_clod_bright,x
4859  0112 2007          	jra	L5213
4860  0114               L7213:
4861                     ; 133       cur_clod_bright++;
4863  0114 be02          	ldw	x,_cur_clod_bright
4864  0116 1c0001        	addw	x,#1
4865  0119 bf02          	ldw	_cur_clod_bright,x
4866  011b               L5213:
4867                     ; 134     temp = cur_clod_bright * cur_clod_bright;
4869  011b be02          	ldw	x,_cur_clod_bright
4870  011d 90be02        	ldw	y,_cur_clod_bright
4871  0120 cd0000        	call	c_imul
4873  0123 1f01          	ldw	(OFST-1,sp),x
4874                     ; 135     LED_ClodWhiteBrightSet(temp);
4876  0125 1e01          	ldw	x,(OFST-1,sp)
4877  0127 cd000b        	call	_LED_ClodWhiteBrightSet
4879  012a               L1213:
4880                     ; 137   if(warm_bright_update)
4882  012a 3d01          	tnz	_warm_bright_update
4883  012c 2739          	jreq	L3313
4884                     ; 139     temp = cur_warm_bright * cur_warm_bright;
4886  012e be04          	ldw	x,_cur_warm_bright
4887  0130 90be04        	ldw	y,_cur_warm_bright
4888  0133 cd0000        	call	c_imul
4890  0136 1f01          	ldw	(OFST-1,sp),x
4891                     ; 140     if (temp == goal_warm_bright)
4893  0138 1e01          	ldw	x,(OFST-1,sp)
4894  013a b308          	cpw	x,_goal_warm_bright
4895  013c 2604          	jrne	L5313
4896                     ; 141       warm_bright_update = 0;
4898  013e 3f01          	clr	_warm_bright_update
4900  0140 2016          	jra	L7313
4901  0142               L5313:
4902                     ; 142     else if(temp > goal_warm_bright)
4904  0142 1e01          	ldw	x,(OFST-1,sp)
4905  0144 b308          	cpw	x,_goal_warm_bright
4906  0146 2309          	jrule	L1413
4907                     ; 143       cur_warm_bright--;
4909  0148 be04          	ldw	x,_cur_warm_bright
4910  014a 1d0001        	subw	x,#1
4911  014d bf04          	ldw	_cur_warm_bright,x
4913  014f 2007          	jra	L7313
4914  0151               L1413:
4915                     ; 145       cur_warm_bright++;
4917  0151 be04          	ldw	x,_cur_warm_bright
4918  0153 1c0001        	addw	x,#1
4919  0156 bf04          	ldw	_cur_warm_bright,x
4920  0158               L7313:
4921                     ; 146     temp = cur_warm_bright * cur_warm_bright;
4923  0158 be04          	ldw	x,_cur_warm_bright
4924  015a 90be04        	ldw	y,_cur_warm_bright
4925  015d cd0000        	call	c_imul
4927  0160 1f01          	ldw	(OFST-1,sp),x
4928                     ; 147     LED_WarmWhiteBrightSet(temp);
4930  0162 1e01          	ldw	x,(OFST-1,sp)
4931  0164 cd0000        	call	_LED_WarmWhiteBrightSet
4933  0167               L3313:
4934                     ; 149 } 
4937  0167 85            	popw	x
4938  0168 81            	ret
4941                     	bsct
4942  000d               L5413_flag:
4943  000d 0000          	dc.w	0
4981                     ; 151 void MCU_ConfigMode(void)
4981                     ; 152 {
4982                     	switch	.text
4983  0169               _MCU_ConfigMode:
4987                     ; 154   if(!clod_bright_update && !warm_bright_update)
4989  0169 3d00          	tnz	_clod_bright_update
4990  016b 2631          	jrne	L5613
4992  016d 3d01          	tnz	_warm_bright_update
4993  016f 262d          	jrne	L5613
4994                     ; 156     delay_ms(300);
4996  0171 ae012c        	ldw	x,#300
4997  0174 cd0000        	call	_delay_ms
4999                     ; 157     if(flag++%2)
5001  0177 be0d          	ldw	x,L5413_flag
5002  0179 1c0001        	addw	x,#1
5003  017c bf0d          	ldw	L5413_flag,x
5004  017e 1d0001        	subw	x,#1
5005  0181 a602          	ld	a,#2
5006  0183 cd0000        	call	c_smodx
5008  0186 a30000        	cpw	x,#0
5009  0189 270a          	jreq	L7613
5010                     ; 159       bright_set = 0x49;
5012  018b 3549000a      	mov	_bright_set,#73
5013                     ; 160       colour_set = 0xFF;
5015  018f 35ff000b      	mov	_colour_set,#255
5017  0193 2006          	jra	L1713
5018  0195               L7613:
5019                     ; 164       bright_set = 0x49;
5021  0195 3549000a      	mov	_bright_set,#73
5022                     ; 165       colour_set = 0x00;
5024  0199 3f0b          	clr	_colour_set
5025  019b               L1713:
5026                     ; 167     UpdateBright();
5028  019b cd00cf        	call	_UpdateBright
5030  019e               L5613:
5031                     ; 169 }
5034  019e 81            	ret
5130                     	xdef	_LED_ClodWhiteBrightSet
5131                     	xdef	_LED_WarmWhiteBrightSet
5132                     	xref	_TIM2_CH3_Duty
5133                     	xref	_TIM2_CH2_Duty
5134                     	xref	_delay_ms
5135                     	xdef	_MCU_ConfigMode
5136                     	xdef	_CurBrighControl
5137                     	xdef	_UpdateBright
5138                     	xdef	_LED_StateControl
5139                     	xdef	_led_open_flag
5140                     	xdef	_colour_set
5141                     	xdef	_bright_set
5142                     	xdef	_goal_warm_bright
5143                     	xdef	_goal_clod_bright
5144                     	xdef	_cur_warm_bright
5145                     	xdef	_cur_clod_bright
5146                     	xdef	_warm_bright_update
5147                     	xdef	_clod_bright_update
5166                     	xref	c_smodx
5167                     	xref	c_imul
5168                     	end
