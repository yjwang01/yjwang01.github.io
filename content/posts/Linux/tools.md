---
title: "Linux Tools"
description: Linux 下一些工具的使用学习
date: 2024-08-21T14:14:10+08:00
slug: 'linux-tools'
tags: ['Linux','Learning']
categories: ['学习记录', 'Linux']
image: 'img/default_image.jpg'
math: false
license: false
hidden: false
comments: true
draft: false
---

# Tmux

## 基本概念

- **窗口**(window)：打开一个Terminal，是一个终端窗口；
- **会话**(session)：打开一个窗口，即建立起一个用户与计算机的会话，对应于计算机的一个进程；
- **窗格**(pane)：Tmux可将一个窗口分成多个窗格；

## 快捷键列表

|   快捷键      |   功能说明        |
|   :---:       |       :---        |
|   Ctrl+b d    | 将窗口与会话分离  |


## REF
[Tmux使用教程](https://www.ruanyifeng.com/blog/2019/10/tmux.html)

# Vim

## 基本说明

Vim拥有四种模式：命令模式、输入模式、末行命令模式和可视模式(Visual)。

<div align=center>
<img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408220922161.png" style="zoom:40%"/>
</div>

Vim启动后，默认的模式为命令模式，此时所有的字符输入被识别为命令；

输入命令`i`将切换到输入模式；

输入命令`v`、`V`、`Ctrl+v`将切换到可视模式；

输入命令`:`将切换到末行命令模式；

所有模式下输入`ESC`切换到命令模式；

## 命令列表

### 命令模式下
|   命令    |   作用    |
| :---:     | :------   |
|   `i`     | 切换到输入模式，在光标当前位置输入文本    |
|   `I`     | 在所在行的内容非空格的行首开始输入    |
|   `a`     | 进入到输入模式，在光标下一位置输入文本    |
|   `A`     | 在光标所在行的最后一个字符输入        |
|   `o`     | 在当前行下插入新行，并进入到输入模式      |
|   `O`     | 在当前行上插入新行，并进入到输入模式      |
|   `r`     | 进入取代当前字符的模式，只取代一个字符    |
|   `R`     | 进入取代字符的模式，相当于输入模式下的`INSERT`，按下`ESC`结束 |
|   `dd`    | 剪切当前行    |
|   `ndd`   | 剪切`n`行     |
|   `yy`    | 复制当前行    |
|   `nyy`   | 复制`n`行     |
|   `p`     | 粘贴剪切板内容到光标下方  |
|   `P`     | 粘贴剪切板内容到光标上方  |
|   `u`     | 撤销上一次操作            |
|`Ctrl + r` | 重做上一次撤销的操作      |
|   `:`     | 切换到末行命令模式        |
|   `j`     | 方向键下，`nj`数字加`j`，向下`n`行，光标位于同一列 |
|   `k`     | 方向键上              |
|   `h`     | 方向键左，不支持跨行  |
|   `l`     | 方向键右，不支持跨行  |
|`Ctrl + f` | Forward，向下一页     |
|`Ctrl + b` | Backward，向上一页     |
|`Ctrl + d` | Down，向下半页    |
|`Ctrl + u` | Up，向上半页    |
|   `0`     | 移动到该行第一个字符，`HOME`    |
|   `$`     | 移动到该行最后一个字符，`END`   |
|   `G`     | 移动到最后一行        |
|   `nG`    | 移动到文件第`n`行     |
|   `gg`    | 移动到文件第一行      |
| `n<Enter>`| 光标向下移动`n`行，光标位于行首 | 
|`Ctrl + g` | 显示文档的基本信息    |
|   `w`     | 向后移动一个单词      |
| `/word`   | 向下搜索字符串`word`  |
| `?word`   | 向上搜索字符串`word`  |
|   `n`     | 重复上一次搜索动作    |
|   `N`     | 反向进行上一次的搜索动作  |

### 输入模式下

|   按键    | 作用  |
| :---:     | :------   |
|   `ESC`   | 退出输入模式，切换到命令模式  |

### 末行命令模式下

|   命令    |   作用    |
| :---:     | :------   |
|   `:q`    | 退出编辑器    |
|   `:w`    | 保存文件      |
|   `:wq`   | 保存文件并退出编辑器  |
|   `:q!`   | 强制退出，不保存文件  |
|`:w [filename]`| 另存为文件 |
|`:r [filename]`| 读取另一个文件的数据，添加到光标后面 |
|`:! command` | 暂时离开vim模式，切换到terminal输入的结果 |

## REF

1. [菜鸟教程 Linux vi/vim](https://www.runoob.com/linux/linux-vim.html)