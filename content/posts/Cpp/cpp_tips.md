---
title: "C/C++ Tips"
description: 在编写 C/C++程序时遇到的一些问题和注意事项的记录
date: 2024-09-03T11:30:47+08:00
slug: 'cpp_tips'
tags: ['Cpp','Learning']
categories: ['学习记录']
image:
math: false
license: false
hidden: true
comments: true
draft: false
---

# 宏定义

宏定义可分为不带参数的宏定义和带参数的宏定义。

## 不带参数的宏定义

```c
// #define 宏名(标识符) 字符串
#define PI  3.1415926
```

对于不带参数的宏定义，编译器会在预处理阶段将"宏名"简单替换成对应的字符串，
不不像函数一样进行值的传递。

## 带参数的宏定义

```c
#define S(r)   r * r
S(a);        // -> r * r -> a * a
S(a + b);    // -> r * r -> a + b * a + b   出错

#define S(r)    (r) * (r) // 将正确替换成 (a+b) * (a+b)
```

在宏定义展开的过程中，需要考虑替换后的优先级等问题

## 宏定义展开顺序

1. 首先用实参代替形参，将实参代入宏文本中
2. 如果实参也是宏，则展开实参
3. 最后继续处理宏替换后的宏文本，如果仍包含宏，则继续展开

注意：如果在第二步，实参代入宏文本后，实参之前或之后遇到 `#` 或 `##`，实参不再展开

## `#`、`##`、`#@`等使用

- `#`：将字符串化操作符
- `##`：将参数转换成一个实际的参数
- `#@`: 将单字符参数转换成字符

```c
#define STR(x)  #x
STR(abc)    // -> "abc"

#define NOP(n)  NOP##n()
NOP(10)     // -> NOP10()

#define CHR(x)  #@x
CHR(a)      // -> 'a'
```

### `##`使用的例子

对于 `##` 的嵌套情况，此处有一个例子如下：

在使用STC8H单片机的过程中，在其头文件中有定义：
```c
sbit P307 = P3^7;    // 表示 P3.7 引脚
```
当我们将需要将该引脚拉高时，采用`P37 = 1;`即可将该引脚的电平置高。

假设我们正在编写一个LED驱动程序，一个引脚只连接一个LED，
我们需要配置GPIO的模式，并且需要设置LED引脚的电平高低。

在GPIO模式配置时，STC的库函数定义了初始化配置GPIO的程序应如下编写：
```c
/* STC8G_H_GPIO.h/c */
GPIO_InitTypeDef    GPIO_InitStructure;     //结构定义
GPIO_InitStructure.Pin  = GPIO_Pin_7;       //指定要初始化的IO, GPIO_Pin_0 ~ GPIO_Pin_7
GPIO_InitStructure.Mode = GPIO_OUT_PP;      //指定IO的输入或输出方式，推挽输出
GPIO_Inilize(GPIO_P3, &GPIO_InitStructure); //初始化
```
此处需要两个信息，即 GPIO 的 `Port` 和 `Pin`；

在控制LED引脚电平高低的时候，`P37 = 1;` 或 `P37 = 0;`，
同样需要 GPIO 的 `Port` 和 `Pin` 两个信息；

因此我们对该 LED 驱动的用户程序中，只需要定义两个宏，即 `LEDx_Port` 和 `LEDx_Pin`；
```c
#define LEDx_Port   3
#define LEDx_Pin    7
```
为了在更换LED引脚的时候更方便修改，那么在初始化程序中，
我们就希望将其中的`GPIO_InitStructure.Pin`的配置`GPIO_Pin_7`
和`Port`的配置`GPIO_P3`使用宏定义进行表示，例如:
- `PIN(LEDx_Pin)` 可以展开为 `GPIO_Pin_7`
- `PORT(LEDx_Port)` 可以展开为 `GPIO_P3`

可能自然地想到了如下所示的宏定义：
```c
#define PIN(x)      GPIO_Pin_ ## x
#define PORT(x)     GPIO_P ## x
```
但是该宏定义是不对的，因为 `##` 会阻止宏定义的进一步展开，
而上述宏定义中，`PIN(LEDx_Pin)` 就将被展开成 `GPIO_Pin_LEDx_Pin`，
其中的`LEDx_Pin`就不会被再次展开成 `7`；
如果使用如下方式定义：
```c
#define CONTACT(a, b)   a ## b
#define PIN(x)      CONTACT(GPIO_Pin_, x)
#define PORT(x)     CONTACT(GPIO_P, x)
```
则`PIN(LEDx_Pin)`就将被展开成`CONTACT(GPIO_Pin_, LEDx_Pin)`，
即`CONTACT(GPIO_Pin_, 7)`，再被展开成 `GPIO_Pin_7`，
此时就实现了我们的目标，通过只修改宏定义中的引脚号，
来实现GPIO初始化配置程序中`Pin`和`Port`两个信息的修改，
而不必修改源函数中的代码。

更进一步，当我们需要控制LED的亮灭时，需要设置引脚的高低电平，
我们期望定义一个宏定义来设置LED的亮灭：
```c
#define LED_ON(port, pin)   // 希望展开后为 P37 = 1，将LED引脚拉高
#define LED_OFF(port, pin)  // 希望展开后为 P37 = 0，将LED引脚拉低
```

可能最直接的想法就是如下定义，将 `P` 和 `[prot]` 和 `[pin]`合并就好了嘛，
根据前面的经验，
我们知道了不能使用`#define LED_ON(port,pin) (P##port##pin = 1)`，
这样`LED_ON(LEDx_Port, LEDx_Pin)`会被展开成`(PLEDx_PortLEDx_Pin = 1)`；
那么我们使用`CONTACT(x,y)`这个宏，只要将`P`和`[port]`先合并然后再和`[pin]`合并：
```c
#define LED_ON(port, pin)   CONTACT(CONTACT(P, port), pin) = 1
```
很可惜，该宏定义只能得到`CONTACT(P, 3)7`，展开过程如下：
1. `LED_ON(LEDx_Port, LEDx_Pin)`，将实参代替形参，有
2. `CONTACT(CONTACT(P, LEDx_Port), LEDx_Pin) = 1`，实参`LEDx_Port`，`LEDx_Pin`为宏，将展开，有
3. `CONTACT(CONTACT(P, 3), 7) = 1`，实参代替形参，有
4. `CONTACT(P, 3) ## 7 = 1`，遇到 `##`，不再对实参`CONTACT(P, 3)`进行展开，得到
5. `CONTACT(P, 3)7 = 1`

还记得我们前面将`PIN(x)`展开为`GPIO_Pin_7`的时候吗？

一开始我们尝试使用`#define PIN(x)      GPIO_Pin_ ## x`，但是失败了；
当我们加了一层对`##`的嵌套，即那一层嵌套的存在，
将`LEDx_Pin`首先展开成了`7`，然后再进入到`CONTACT(a, b)`中的`##`操作；
那我们这里是否也可以加一层嵌套，将`CONTACT(P, 3)`先转换为`P3`呢？
如下所示：
```c
#define CONTACT(a, b)   a ## b
#define CONTACT_EXPAND(a, b)   CONTACT(a, b)
#define LED_ON(port, pin)    CONTACT_EXPAND(CONTACT(P, port), pin) = 1
```
宏的展开步骤如下：
1. `LED_ON(LEDx_Port, LEDx_Pin)`，将实参代替形参，有
2. `CONTACT_EXPAND(CONTACT(P, LEDx_Port), LEDx_Pin) = 1`，实参为宏，展开有
3. `CONTACT_EXPAND(CONTACT(P, 3), 7) = 1`，实参`CONTACT(P,3)`, `7`替代形参，有
4. `CONTACT(CONTACT(P, 3), 7) = 1`，由于此时传入的`CONTACT(P,3)`为一个实参，将被优先展开，有
5. `CONTACT(P3, 7) = 1`，进一步展开，有
6. `P37 = 1`

可以看到上述过程中，第4步得到的结果和前面的宏定义的有一步是非常像的，
但是因为`CONTACT(P, 3)`是作为实参传入的，因此将被优先展开，
而在前面的宏定义`#define LED_ON(port, pin)   CONTACT(CONTACT(P, port), pin) = 1`中，第一个`CONTACT(a, b)`将优先被展开，遇到了`##`阻止了中间的`CONTACT(P, 3)`的展开。