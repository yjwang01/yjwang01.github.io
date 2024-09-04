---
title: "C++"
description: C++ 学习记录
date: 2024-08-21T15:33:36+08:00
slug: 'cpp'
tags: ['Cpp','Learning']
categories: ['学习记录']
image:
math: false
license: false
hidden: false
comments: true
draft: false
---

# C++基础
## 对象

**对象**(object)：一块能存储数据比具有某种类型的内存空间。

## 变量

### 初始化

```cpp
int a = 0;
int a = {0}；
int a{0};   // 列表初始化
int a(0);
```
以花括号来初始化的方式称为**列表初始化**，对于内置类型的遍历，如果初始值存在丢失信息的风险，将报错。

```cpp
long double ld = 3.14159;
int a{ld}, b = {ld};    // 报错：因为long double变为int，存在丢失信息的风险
int c(ld), d = ld;      // 正确：按照类型转换方式执行初始化赋值
```

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

```cpp
const int mf = 20;
constexpr int md = 20;
```

## 自动处理类型

```cpp
typedef double wages;   // wages = double
typedef wages base, *p; // base = double, p = (double *)
using SI = Sales_item;  // SI = Sales_item
```

- `auto`

自动推断类型，对于`const`等修饰符的自动推断不一定正确
```cpp
int i = 0, &r = i;
auto a = r; // a 的类型不是 int&, 而是int，因为r只是int i的指示，不是一个对象
```

- `decltype`

选择并返回操作数的数据类型

```cpp
decltype(f()) sum = x; // sum就是f()的返回类型
```
在使用`decltype`定义一个变量时，引用将不再作为对象的同义词
```cpp
int i = 0, &r = i;
decltype(r) a = i; // a 的类型是 int&
```

## 自定义数据结构

### 结构体

```cpp
struct _StructType
{
    int n = 0;  // 类内初始值，用于初始化变量
    double x = 0.0;
};
// C++中_StructType被认为是类型名，不再需要使用 struct _StructType

// 下述两种typedef方式在 C++ 中被允许
typedef struct _StructType StructType;
typedef _StructType StructType; // 在 C 中不被允许
// 下述三种变量定义方式在 C++ 中都是允许的
struct StructType s0;
_StructType s1; // 在 C 中不被允许
StructType s2;
```

- 更改头文件中的声明后，相应的源文件必须重新编译以获取更新过的声明。

### 类

## 预处理器

- `#define`、`#ifdef` / `#ifndef` + `endif`
- 预处理变量会无视 C++ 中关于作用域的规则

## 命名空间

### using声明

```using``` *namespace::name*

```cpp
using std::cin; // 当使用 cin时，将从命令空间std中获取它
```

- 头文件中不应该包含`using`声明，因为头文件将被包含复制到其他源文件中，造成意外引入名字

# C++ 标准库

## string

```cpp
#include <string>
using std::string;
```

### 定义和初始化string对象

```cpp
string s1;          // s1 为一个空字符串
string s2 = s1;
string s2_(s1);
string s3 = "hi";
string s3_("hi");
string s4(6, 'c');  // s4的内容为 "cccccc"
```

- 直接初始化
  - 不使用 `=` 进行初始化
- 拷贝初始化
  - 使用 `=` 进行初始化

### string 的方法

- `os << s` && `is >> s`

将忽略开头的空白（空格符、换行符、制表符等），从第一个有效字符开始，直到读到下一处空白结束。

对于连续输入，可采用`while`循环来操作。

```cpp
string word;
while(cin >> word)  // 当输入文件结束符之后才返回 false
{
    cout << word << endl;
}
```

> **键盘输入文件结束符**：Windows - `Ctrl+Z`，Linux - `Ctrl+D`.

- `getline(is, s)`

从给定输入中读取，直到遇到换行符（**读取包括换行符本身，但不在字符串中存换行符！**）

- `s.empty()`

返回`string`对象是否为空的`bool`值。

- `s.size()`

返回`string`对象的长度，返回的类型为`string::size_type`，是一个`unsigned`类型的数值。

- 运算操作符
  - `+`：串接字符串
  - `>` | `<` | `<=` | `>=` | `==` | `!=`：比较字符串，返回`bool`

```cpp
string s1;
string s2 = s1 + "a" + "b"; // 正确
string s3 = "a" + "b" + s1; // 错误，字面值不能直接相加
```

### 对字符的判断

在 `cctype` 头文件中定义了一些标准库函数来判定字符的特性。

- `isalnum(c)`: 字母或数字为真
- `isalpha(c)`: 字母
- `iscntrl(c)`: 控制字符
- `isdigit(c)`: 数字
- `isgraph(c)`: 可打印，非空格
- `isprint(c)`: 可打印
- `islower(c)`: 小写字母
- `isupper(c)`: 大写字母
- `ispunct(c)`: 标点符号，非控制、数字、字母、空格
- `isspace(c)`: 空白，空格、横向制表符、纵向制表符、回车符、换行符、进纸符
- `isxdigit(c)`: 十六进制数字
- `tolower(c)`: 转换为小写字母
- `toupper(c)`: 转换为大写字母

### 遍历 & 索引

```cpp
for (auto c : s){}    // 将 s[i] 复制到 c
for (auto &c : s){}   // c 是对 s[i] 的引用
```

## vector

```cpp
#include <vector>
using std::vector;
```

`vector`是一个类模板。

### 定义和初始化vector对象

```cpp
vector<T> v1;
vector<T> v2(v1);
vector<T> v2_ = v1;
vector<T> v3(n, val);
vector<T> v4(n);
vector<T> v5{a, b, c};
vector<T> v5_ = {a, b, c};
vector<T> v6(a,b,c);        // 错误！
```

### vector的方法

- `v.push_back(val)`

把一个值当作`vector`的末尾元素push到vector对象的back

> **vector的高效增长**：当元素的值存在不同时，在定义`vector`对象的时候设置其大小甚至不如`push_back()`效率高

- `v.empty()`
- `v.size()`

返回 `vector<int>::size_type`，而不是 `vector::size_type`

- `>` | `<` | `<=` | `>=` | `==` | `!=`

仅当`vector`中的元素类型定义了比较等运算符时才可进行比较

## 迭代器

所有标准库容器都可以使用迭代器，但只有少数几种支持下标运算符。

```cpp
auto b = v.begin(), e = v.end();
```

`end()`返回的迭代器称为**尾后迭代器**，指向容器尾元素的下一位置，不存在该元素。<br>
当容器为空时,`begin()`和`end()`返回的都是尾后迭代器。

### 迭代器运算符

- `*iter`: 返回迭代器所指元素的引用
- `iter->mem`: 相当于`(*iter).mem`，取该元素的`mem`成员
- `++iter` / `--iter`: 指向下一个/上一个元素
- `==` / `!=`: 不同元素的迭代器则不相等

{{<notice warning>}}
凡是使用了迭代器的循环体，都不要向迭代器所属的容器添加元素。（删除呢？）
{{</notice>}}









# Reference

1. <a href="/posts/cpp/cpp_tips"> C/C++ 注意事项 </a>