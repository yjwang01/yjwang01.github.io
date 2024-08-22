---
title: "C++"
description: C++ 学习记录
date: 2024-08-21T15:33:36+08:00
slug: 'cpp'
tags: ['Cpp','Learning']
categories: ['学习记录']
image: 'img/default_image.jpg'
math: false
license: false
# hidden: false
comments: true
draft: false
---

# C++基础
## 对象

**对象**(object)：一块能存储数据比具有某种类型的内存空间。

## 变量
### 作用域

变量的作用域以`{}`分隔。

嵌套作用域下，内层作用域可访问外层作用域的变量，以内层作用域名字优先；

全局作用域没有名字，当作用域操作符`::`左侧为空时，表示使用全局变量；

```cpp
#include <iostream>
int a = 42;
int main(void)
{
    int a = 40;
    std::cout << a << std::endl;    // a = 40;
    std::cout << ::a << std::endl;    // a = 42;
}
```
### 引用

引用相当于给对象起了另外一个名字，必须被**初始化**绑定到一个对象。

引用不是对象。

### 指针

指针是对象，指向其他对象的地址。

不能定义指向引用的指针，因为引用不是对象，但是可以定义指向指针的引用。

```cpp
int i = 42;
int *p;
int *&r = p;    // 指向指针int *p的引用 r
```

空指针：`nullptr`

`void*` 指针：可以指向任意类型对象，可以存放任意类型指针。
用于指针比较，作为函数的输入输出，不能直接操作 `void*` 指针所指的对象。

> 初始化所有指针。

## const限定符

const对象在创建后将不可被改变，必须进行初始化。

默认状态下，const对象仅在文件内有效，编译器会在编译过程中将变量都替换成对应的值，
有点类似于宏定义的预处理了。

### const 引用

非const的引用不能指向一个const对象
```cpp
const int ci = 42;
const int &r1 = ci; // 正确，初始化常量引用时可以使用任意表达式作为初值，const int &r1 = 42;
int &r2 = ci;       // 错误！因为编译的时候相当于 int &r2 = 42; 该引用并没有指向一个对象
```

允许为一个常量引用绑定非常量的对象
```cpp
int i = 42;
const int &r = i;
r = 30; // invalid!
i = 30;
std::cout << r << ", " << i << std::endl;   // 30, 30
```

### const 指针

```cpp
// p1是一个const的int *指针，必须被初始化，顶层const表示本身是一个常量
int *const p1;  
// p2是一个指针，自以为指向const int，但是被指向的变量可以是非const int，底层const，表示指向的对象为一个常量
const int *p2;
```

### constexpr

**常量表达式**： 值不会改变，并且在编译过程中就能得到计算结果的表达式。







