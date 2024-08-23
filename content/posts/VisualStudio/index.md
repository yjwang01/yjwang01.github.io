---
title: "VisualStudio 使用学习记录"
description: 
date: 2024-08-19T09:04:16+08:00
slug: 'VisualStudio-learning'
tags: ['VisualStudio','Learning']
categories: ['学习记录']
image:
math: false
license: false
# hidden: false
comments: true
draft: false
---

> Microsoft Visual Studio Community 2022 (64 位) - Current 版本 17.10.4
> 
> 以开发 C++ 项目为例

# 创建项目

VS中以解决方案为一个管理单元，每个解决方案中可包含多个项目，这些项目可相互依赖。

在新建项目时，项目会存放在`$(SolutionDir)$(ProjectName)`路径下，
也可选择将`$(SolutionDir)`和`$(ProjectName)`放在同一目录中。

<div align = center>
<img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408190914677.png" style="zoom:100%"/>
</div>

后续在**解决方案资源管理器**中可在当前解决方案中添加项目。

# 项目搜索目录管理

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

# DLL项目开发

## 创建DLL项目

在新建项目的时候，选取**动态链接库(DLL)**项目模板，并创建。

在新建的DLL项目中，
会自动添加文件`dllmain.cpp,pch.h/cpp,framework.h`，
其中：

- `dllmain.cpp`定义了DLL程序的入口点，不需要修改；
- `pch.h/cpp`是预编译标头，用于提高编译性能，编译器会生成`$(ProjectName).pch`；
- `framework.h`应该是包含DLL框架必须的头文件吧；

> <font color=red>**Tips:**</font>
> 
> 在解决方案资源管理器中选中`dllmain.cpp`，右键，属性；
> 在 *C/C++$\rightarrow$预编译头* 中可以看到该文件的属性为
>
> <div align=center>
> <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408190950510.png"/>
> </div>
>
> 即该文件在编译时需要使用预编译头创建的`$(ProjectName).pch`文件；
>
> 而对于`pch.cpp`，其属性为
>
> <div align=center>
> <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408190955213.png"/>
> </div>
> 
> 即该文件被认为是用来创建`$(ProjectName).pch`的，
> 如果在使用过程中，将该文件修改文件路径后重新添加进项目中，则需要将该属性重新设置> 为`/Yc`，
> 否则将提示无法找到`$(ProjectName).pch`文件。

## 编写 DLL 项目

DLL项目中的函数可分为内部函数和导出函数，导出函数可由其他程序调用。

对于需要导出的函数或类需要在函数或类名前添加`__declspec(dllexport)`关键字。

一般来说，将使用宏定义来提高代码可读性，如下所示：

```cpp
#if defined(DLL_EXPORTS)
#if defined(_MSC_VER)
#define DLL_API __declspec(dllexport)
#elif defined(__GNUC__)
#define DLL_API __attribute__((visibility("default")))
#else
#error Unsupported compiler!
#endif
#else /* !defined(DLL_EXPORTS) */
#if defined(_MSC_VER)
#define DLL_API __declspec(dllimport)
#elif defined(__GNUC__)
#define DLL_API
#else
#error Unsupported compiler!
#endif
#endif /* defined(DLL_EXPORTS) */
```

其中`DLL_EXPORTS`为编译时的预处理器定义。

对于DLL程序的编写则和普通C/C++程序一样，
编译后会在输出目录下生成`$(ProjectName).dll`和`$(ProjectName).lib`

## 调用 DLL 项目

新建一个控制台应用(Console Application)，
配置好项目的搜索目录
*C/C++$\rightarrow$常规$\rightarrow$ 附加包含目录*、
*链接器$\rightarrow$常规$\rightarrow$附加库目录*；

在*链接器$\rightarrow$输入$\rightarrow$附加依赖项*中
添加需要调用的DLL文件 `$(DLLProjectName).lib`。

在程序中包含DLL项目的头文件后，可调用DLL导出函数。

## DLL循环依赖问题

假设在解决方案Solution.sln中有两个DLL和一个控制台程序，
分别为`A.DLL`、`B.DLL`、`Test.Console`，
两个DLL可认为是两个模块的仿真，两者需要互相交互，即会互相调用对方的函数，
这在程序架构上就出现了循环依赖的问题。
`Test.Console`作为执行程序来调用两个DLL。

在链接`A.dll`是需要使用`B.dll`，链接`B.dll`的时候需要使用`A.dll`。

可采用分阶段编译来解决循环依赖问题：

1. 在`A.dll`中注释掉对`B.dll`的依赖的代码，这样可直接编译链接得到`A.dll`
2. 编译链接`B.dll`
3. 恢复`A.dll`中的代码，再次编译链接`A.dll`
4. 最后编译`Test.Console`，因为需要依赖`A.dll`和`B.dll`

其中对`A.dll`代码的注释通过预处理器定义来控制，例如

```c
#if defined(REBUILD_DLL)
    // A.dll 中调用 B.dll 的代码
#endif
// A.dll中其他代码
```

在VS中，手动执行上述操作较为麻烦，可采用脚本进行自动化执行：

```batch
@REM build.bat
@REM 设置VS运行的环境变量
call "D:\Path\to\VS\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
@REM 执行对项目配置文件 A.vxproj 的修改脚本，注释A.dll中的代码
powershell -ExecutionPolicy Bypass -File ".\Prebuild.ps1"
@REM 编译程序，会根据 Solution.sln 中项目的顺序编译所有项目，包括 Test
msbuild Solution.sln /p:Configuration=Debug /p:Platform=x64 -t:Build
@REM 执行对项目配置文件 A.vxproj 的修改脚本，取消A.dll中代码的注释
powershell -ExecutionPolicy Bypass -File ".\Rebuild.ps1"
@REM 编译程序
msbuild Solution.sln /p:Configuration=Debug /p:Platform=x64 -t:Build
```

其中 `Prebuild.ps1`和`Rebuild.ps1`如下所示：

```powershell
# 定义文件路径
$vcxprojPath = "./A/A.vcxproj"
# 加载 XML 文件
[xml]$xml = Get-Content $vcxprojPath
# 确定目标条件的字符串形式
$targetCondition = "'`$(Configuration)|`$(Platform)'=='Debug|x64'"
# 查找 PropertyGroup
$propertyGroup = $xml.Project.ItemDefinitionGroup | Where-Object { $_.Condition -eq $targetCondition }
# 根据需要设置连接器和编译器参数
## 这是 Prebuild.ps1 的参数
$propertyGroup.Link.AdditionalDependencies = "%(AdditionalDependencies)"
$propertyGroup.ClCompile.PreprocessorDefinitions = "_DEBUG;DLL_EXPORTS;_WINDOWS;_USRDLL;%(PreprocessorDefinitions)"
## 这是 Rebuild.ps1 的参数
$propertyGroup.Link.AdditionalDependencies = "B.lib;%(AdditionalDependencies)"
$propertyGroup.ClCompile.PreprocessorDefinitions = "_DEBUG;DLL_EXPORTS;REBUILD_DLL;_WINDOWS;_USRDLL;%(PreprocessorDefinitions)"
# 保存修改后的文件
$xml.Save($vcxprojPath)
```

同时，在`Solution.sln`中项目的定义顺序也影响到了`msbuild`执行时项目的编译顺序，可能会引起编译出错。

在这里，根据依赖关系，我们需要先编译`A.dll`，解决方案中的项目顺序应该为
`A.dll`$\rightarrow$`B.dll`$\rightarrow$`Test`。

```c
// A.dll
Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "A", "A\A.vcxproj", "{104776AD-2398-47A5-8B05-E48A778735B5}"
EndProject
// B.dll
Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "B", "B\B.vcxproj", "{CB778243-2033-4522-957E-EF3710F9D089}"
    // 表示项目依赖关系
    ProjectSection(ProjectDependencies) = postProject
        {104776AD-2398-47A5-8B05-E48A778735B5} = {104776AD-2398-47A5-8B05-E48A778735B5}
    EndProjectSection
EndProject
// Test.Console
Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "Test", "Test\Test.vcxproj", "{F11C3DAD-559C-4571-A3E2-4EC8C9C664D0}"
    ProjectSection(ProjectDependencies) = postProject
        {104776AD-2398-47A5-8B05-E48A778735B5} = {104776AD-2398-47A5-8B05-E48A778735B5}
        {CB778243-2033-4522-957E-EF3710F9D089} = {CB778243-2033-4522-957E-EF3710F9D089}
    EndProjectSection
EndProject
```

