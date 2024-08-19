---
title: "VisualStudio 使用学习记录"
description: 
date: 2024-08-19T09:04:16+08:00
slug: 'VisualStudio-learning'
tags: ['VisualStudio','Learning']
categories: ["学习记录"]
# image: 'image path'
math: false
license: false
# hidden: false
comments: true
draft: true
---

> Microsoft Visual Studio Community 2022 (64 位) - Current 版本 17.10.4
> 
> 以开发 C++ 项目为例

## 创建项目

VS中以解决方案为一个管理单元，每个解决方案中可包含多个项目，这些项目可相互依赖。

在新建项目时，项目会存放在`$(SolutionDir)$(ProjectName)`路径下，
也可选择将`$(SolutionDir)`和`$(ProjectName)`放在同一目录中。

<div align = center>
<img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408190914677.png" style="zoom:60%"/>
</div>

后续在**解决方案资源管理器**中可在当前解决方案中添加项目。

## 项目库目录管理

在**解决方案资源管理器**中选中项目后右键，打开属性项。

在项目属性页中，可配置项目的输出目录、中间目录等常规属性。

对于C/C++项目来说，

可在
*C/C++$\rightarrow$常规$\rightarrow$ 附加包含目录*
中添加C/C++的头文件搜索路径，

可在
*链接器$\rightarrow$常规$\rightarrow$附加库目录*
中添加库目录搜索路径。

可在
*链接器$\rightarrow$输入$\rightarrow$附加依赖项*
中设置该项目的依赖库

## DLL项目开发

### 创建DLL项目

在新建项目的时候，选取**动态链接库(DLL)**项目模板，并创建。

在新建的DLL项目中，
会自动添加文件`dllmain.cpp,pch.h/cpp,framework.h`，
其中：

- `dllmain.cpp`定义了DLL程序的入口点，不需要修改；
- `pch.h/cpp`是预编译标头，用于提高编译性能，编译器会生成`$(ProjectName).pch`；
- `framework.h`应该是包含DLL框架必须的头文件吧；

<font color=red>**Tips:**</font>

在解决方案资源管理器中选中`dllmain.cpp`，右键，属性；
在 *C/C++$\rightarrow$预编译头* 中可以看到该文件的属性为

<div align=center>
<img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408190950510.png" style="zoom:80%"/>
</div>

即该文件在编译时需要使用预编译头创建的`$(ProjectName).pch`文件；

而对于`pch.cpp`，其属性为

<div align=center>
<img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408190955213.png" style="zoom:80%"/>
</div>

即该文件被认为是用来创建`$(ProjectName).pch`的，如果在使用过程中，将该文件修改文件路径后重新添加进项目中，则需要将该属性重新设置为`/Yc`，
否则将提示无法找到`$(ProjectName).pch`文件。

### 编写 DLL 项目








