#include "stm8s103f.h"
#include "stm8_eeprom.h"

static void EEPROM_UnLock(void)
{
  _asm("sim");
  do
	{
    FLASH_DUKR = 0xae; 
    FLASH_DUKR = 0x56; 
  } 
	while((FLASH_IAPSR & 0x08) == 0);
}


static void EEPROM_Lock(void)
{
  FLASH_IAPSR &= ~(1 << 3);
  _asm("rim");
}

u8 ReadEEPROM(u8 dat)
{
  u8 temp;
  u8 *p;
  p = (unsigned char *)0x4000;
	p+=dat;
	
	EEPROM_UnLock();
	temp = *p;
	EEPROM_Lock();
}

u8 WriteEEPROM(u8 dat,u8 ch)
{
	u8 *p;
	p = (unsigned char *)0x4000;
	p+=dat;
	
	EEPROM_UnLock();
	*p = ch;
	while((FLASH_IAPSR & 0x04) == 0);
	EEPROM_Lock();
}
