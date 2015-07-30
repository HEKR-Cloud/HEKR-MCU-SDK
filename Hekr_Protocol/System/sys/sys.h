#ifndef _SYS_H
#define _SYS_H

#include "stm8s103f.h"

//+++++++++++++++++++++++++++ Type Declaration ++++++++++++++++++++++++++++++++++//
//!You should modify it for different c compiler.
typedef unsigned  char       bool;
typedef           char       ascii;
typedef unsigned  char       u8;
typedef signed    char       s8;
typedef unsigned  short      u16;
typedef signed    short      s16;
typedef unsigned  long       u32;
typedef signed    long       s32;


void System_Clock_init(void);

_Bool PA0_ODR @PA_ODR:0;
_Bool PA1_ODR @PA_ODR:1; //位定义 类似C51
_Bool PA2_ODR @PA_ODR:2;
_Bool PA3_ODR @PA_ODR:3;
_Bool PA4_ODR @PA_ODR:4;
_Bool PA5_ODR @PA_ODR:5;
_Bool PA6_ODR @PA_ODR:6;
_Bool PA7_ODR @PA_ODR:7;

_Bool PB0_ODR @PB_ODR:0;
_Bool PB1_ODR @PB_ODR:1; //位定义 类似C51
_Bool PB2_ODR @PB_ODR:2;
_Bool PB3_ODR @PB_ODR:3;
_Bool PB4_ODR @PB_ODR:4;
_Bool PB5_ODR @PB_ODR:5;
_Bool PB6_ODR @PB_ODR:6;
_Bool PB7_ODR @PB_ODR:7;

_Bool PC0_ODR @PC_ODR:0;
_Bool PC1_ODR @PC_ODR:1; //位定义 类似C51
_Bool PC2_ODR @PC_ODR:2;
_Bool PC3_ODR @PC_ODR:3;
_Bool PC4_ODR @PC_ODR:4;
_Bool PC5_ODR @PC_ODR:5;
_Bool PC6_ODR @PC_ODR:6;
_Bool PC7_ODR @PC_ODR:7;

_Bool PD0_ODR @PD_ODR:0;
_Bool PD1_ODR @PD_ODR:1; //位定义 类似C51
_Bool PD2_ODR @PD_ODR:2;
_Bool PD3_ODR @PD_ODR:3;
_Bool PD4_ODR @PD_ODR:4;
_Bool PD5_ODR @PD_ODR:5;
_Bool PD6_ODR @PD_ODR:6;
_Bool PD7_ODR @PD_ODR:7;

//////////////////////////////////
_Bool PA0_IDR @PA_IDR:0;
_Bool PA1_IDR @PA_IDR:1; //位定义 类似C51
_Bool PA2_IDR @PA_IDR:2;
_Bool PA3_IDR @PA_IDR:3;
_Bool PA4_IDR @PA_IDR:4;
_Bool PA5_IDR @PA_IDR:5;
_Bool PA6_IDR @PA_IDR:6;
_Bool PA7_IDR @PA_IDR:7;

_Bool PB0_IDR @PB_IDR:0;
_Bool PB1_IDR @PB_IDR:1; //位定义 类似C51
_Bool PB2_IDR @PB_IDR:2;
_Bool PB3_IDR @PB_IDR:3;
_Bool PB4_IDR @PB_IDR:4;
_Bool PB5_IDR @PB_IDR:5;
_Bool PB6_IDR @PB_IDR:6;
_Bool PB7_IDR @PB_IDR:7;

_Bool PC0_IDR @PC_IDR:0;
_Bool PC1_IDR @PC_IDR:1; //位定义 类似C51
_Bool PC2_IDR @PC_IDR:2;
_Bool PC3_IDR @PC_IDR:3;
_Bool PC4_IDR @PC_IDR:4;
_Bool PC5_IDR @PC_IDR:5;
_Bool PC6_IDR @PC_IDR:6;
_Bool PC7_IDR @PC_IDR:7;

_Bool PD0_IDR @PD_IDR:0;
_Bool PD1_IDR @PD_IDR:1; //位定义 类似C51
_Bool PD2_IDR @PD_IDR:2;
_Bool PD3_IDR @PD_IDR:3;
_Bool PD4_IDR @PD_IDR:4;
_Bool PD5_IDR @PD_IDR:5;
_Bool PD6_IDR @PD_IDR:6;
_Bool PD7_IDR @PD_IDR:7;

/******************************************/
/////////IO配置寄存器///////////////////
//PA口配置
_Bool PA1_DDR @PA_DDR:1; //位定义 类似C51
_Bool PA1_CR1 @PA_CR1:1;
_Bool PA1_CR2 @PA_CR2:1;

_Bool PA2_DDR @PA_DDR:2;
_Bool PA2_CR1 @PA_CR1:2;
_Bool PA2_CR2 @PA_CR2:2;

_Bool PA3_DDR @PA_DDR:3;
_Bool PA3_CR1 @PA_CR1:3;
_Bool PA3_CR2 @PA_CR2:3;

_Bool PA4_DDR @PA_DDR:4;
_Bool PA4_CR1 @PA_CR1:4;
_Bool PA4_CR2 @PA_CR2:4;

_Bool PA5_DDR @PA_DDR:5;
_Bool PA5_CR1 @PA_CR1:5;
_Bool PA5_CR2 @PA_CR2:5;

_Bool PA6_DDR @PA_DDR:6;
_Bool PA6_CR1 @PA_CR1:6;
_Bool PA6_CR2 @PA_CR2:6;

_Bool PA7_DDR @PA_DDR:7;
_Bool PA7_CR1 @PA_CR1:7;
_Bool PA7_CR2 @PA_CR2:7;
////////////////////////////////////////
/////////////////////////////////
//PB口配置
_Bool PB1_DDR @PB_DDR:1; //位定义 类似C51
_Bool PB1_CR1 @PB_CR1:1;
_Bool PB1_CR2 @PB_CR2:1;

_Bool PB2_DDR @PB_DDR:2;
_Bool PB2_CR1 @PB_CR1:2;
_Bool PB2_CR2 @PB_CR2:2;

_Bool PB3_DDR @PB_DDR:3;
_Bool PB3_CR1 @PB_CR1:3;
_Bool PB3_CR2 @PB_CR2:3;

_Bool PB4_DDR @PB_DDR:4;
_Bool PB4_CR1 @PB_CR1:4;
_Bool PB4_CR2 @PB_CR2:4;

_Bool PB5_DDR @PB_DDR:5;
_Bool PB5_CR1 @PB_CR1:5;
_Bool PB5_CR2 @PB_CR2:5;

_Bool PB6_DDR @PB_DDR:6;
_Bool PB6_CR1 @PB_CR1:6;
_Bool PB6_CR2 @PB_CR2:6;

_Bool PB7_DDR @PB_DDR:7;
_Bool PB7_CR1 @PB_CR1:7;
_Bool PB7_CR2 @PB_CR2:7;
/////////////////////////////////
//PC口配置
_Bool PC1_DDR @PC_DDR:1; //位定义 类似C51
_Bool PC1_CR1 @PC_CR1:1;
_Bool PC1_CR2 @PC_CR2:1;

_Bool PC2_DDR @PC_DDR:2;
_Bool PC2_CR1 @PC_CR1:2;
_Bool PC2_CR2 @PC_CR2:2;

_Bool PC3_DDR @PC_DDR:3;
_Bool PC3_CR1 @PC_CR1:3;
_Bool PC3_CR2 @PC_CR2:3;

_Bool PC4_DDR @PC_DDR:4;
_Bool PC4_CR1 @PC_CR1:4;
_Bool PC4_CR2 @PC_CR2:4;

_Bool PC5_DDR @PC_DDR:5;
_Bool PC5_CR1 @PC_CR1:5;
_Bool PC5_CR2 @PC_CR2:5;

_Bool PC6_DDR @PC_DDR:6;
_Bool PC6_CR1 @PC_CR1:6;
_Bool PC6_CR2 @PC_CR2:6;

_Bool PC7_DDR @PC_DDR:7;
_Bool PC7_CR1 @PC_CR1:7;
_Bool PC7_CR2 @PC_CR2:7;
/////////////////////////////////
//PD口配置
_Bool PD1_DDR @PD_DDR:1; //位定义 类似D51
_Bool PD1_CR1 @PD_CR1:1;
_Bool PD1_CR2 @PD_CR2:1;

_Bool PD2_DDR @PD_DDR:2;
_Bool PD2_CR1 @PD_CR1:2;
_Bool PD2_CR2 @PD_CR2:2;

_Bool PD3_DDR @PD_DDR:3;
_Bool PD3_CR1 @PD_CR1:3;
_Bool PD3_CR2 @PD_CR2:3;

_Bool PD4_DDR @PD_DDR:4;
_Bool PD4_CR1 @PD_CR1:4;
_Bool PD4_CR2 @PD_CR2:4;

_Bool PD5_DDR @PD_DDR:5;
_Bool PD5_CR1 @PD_CR1:5;
_Bool PD5_CR2 @PD_CR2:5;

_Bool PD6_DDR @PD_DDR:6;
_Bool PD6_CR1 @PD_CR1:6;
_Bool PD6_CR2 @PD_CR2:6;

_Bool PD7_DDR @PD_DDR:7;
_Bool PD7_CR1 @PD_CR1:7;
_Bool PD7_CR2 @PD_CR2:7;


#endif
