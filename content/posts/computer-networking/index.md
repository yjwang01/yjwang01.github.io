---
title: "Computer Networking学习记录"
description: '学习计算机网络时的笔记'
date: 2024-07-13T22:39:35+08:00
slug: 'computer-networking'
tags: ['Computer Networking']
categories: ["学习记录"]
# image: 'image path'
math: false
license: false
comments: true
hasCJKLanguage: true
draft: false
---

## 应用层

To be added.

## 传输层

### 概述 

- 网络层实现了**主机**到**主机**之间的逻辑通信
- 传输层提供了主机上**进程**与**进程**之间的逻辑通信
- 传输层分组称为**报文段(segment)**，部分文档将UDP分组称为**数据报(datagram)**

### 多路复用与多路分解

- 将网络层提供的主机间的逻辑通信扩展到进程间的逻辑通信称为运输层的**多路复用与多路分解**
- 每个传输层报文段都有`源端口号`和`目的端口号`

#### 无连接的多路复用与分解(UDP)
- UDP socket对应2元组，`(dest_IP, dest_Port)`
- 当主机收到一个报文后，传输层将根据报文中的`dest_Port`查找对应的socket
- UDP报文段中的`(src_IP, src_Port)`作为返回地址

```Python
# udp server
from socket import *
serverPort = 12000
serverSocket = socket(AF_INET, SOCK_DGRAM)
serverSocket.bind(('', serverPort))

while True:
    message, clientAddress = serverSocket.recvfrom(2048) # 同时获取返回地址
    modifiedMessage = message.decode().upper()
    serverSocket.sendto(modifiedMessage.encode(), clientAddress)
```

```Python
# udp client
from socket import *
serverName = 'xxx.xxx.xxx.xxx' # IP address
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_DGRAM)
message = "test udp"
clientSocket.sendto(message.encode(), (serverName, serverPort))
modifiedMessage, serverAddress = clientSocket.recvfrom(2048)
```

#### 面向连接的多路复用与分解(TCP)

- TCP套接字对应4元组，`(src_IP, src_Port, dest_IP, dest_Port)`
- TCP服务器端程序有一个`欢迎套接字`，等待连接建立请求
- 当收到连接请求后，将新建一个套接字用于传输

```Python
from socket import *
serverPort = 12000
serverSocket = socket(AF_INET, SOCK_STREAM) # 欢迎套接字
serverSocket.bind(('',serverPort))
serverSocket.listen(1)
while True:
    connectionSocket, addr = serverSocket.accept()  # 建立连接后，将生成新的套接字
    sentence = connectionSocket.recv(1024).decode()
    modifiedSentence = sentence.upper()
    connectionSocket.send(modifiedSentence.encode())
    connectionSocket.close()
```

```Python
from socket import *
serverName = 'xxx.xxx.xxx.xxx' # IP address
servePort = 12000
clientSocket = socket(AF_INET, SOCK_STREAM)
clientSocket.connect((serverName, servePort))   # 连接请求
sentence = "test tcp
clientSocket.send(sentence.encode())
modifiedsentence = clientSocket.recv(1024)
clientSocket.close()
```

### 无连接传输 UDP

- 优点
  - 无须建立连接(时延低)
  - 无连接状态(不需要维护连接状态数据)
  - 分组首部开销小

- UDP报文段

<div align = center>
  <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407141801936.png" style="zoom:80%">
</div>

> **长度(16bit)**: 以字节为单位
> 
> **校验和(16bit)**：虽然很多链路层协议都提供了差错检测，但是只有**端到端**实现的差错检测才能保证（端到端原则）；无法实现差错恢复


### 构造可靠数据传输原理

#### 比特差错信道(分组不丢失)

> **问题：**
> 发送方的DATA出错，接收方需要告知发送方

- 自动重传请求ARQ(Automatic Repeat reQuest)
  - 差错控制
  - 接收方反馈
  - 重传

- 停等协议(stop-and-wait protocol)
  - 发送方等待接收方的`ACK`或`NAK`

> **问题：**
> 如果接收方回复的`ACK`或`NAK`也出现了差错？
> 发送方将进行重传，引入冗余分组，接收方需要判断是新的数据还是重传数据

对数据分组进行编号，接收方检查序号，判断是否是重传数据，解决冗余分组判定问题

同时也可对`ACK`进行编号，来实现NAK的效果。
在发送`DATA(n)`时，接收端发送`ACK(n-1)`，可被认为发送了`NAK(n)`。
这为后续连续发送多个分组奠定了基础。

#### 比特差错 & 分组丢失信道

> **问题：**
> 发送端发送`DATA(0)`，等待`ACK(0)`，接收方没收到数据，不回复`ACK`

- 引入**超时重传机制**

若发送方收到不符合序号的`ACK`，将不立即重传，而是等待超时定时器中断再重传，两者效果一致
（实际上对后续**回退N步**协议来说，超时重传机制更为合理，因为接收方收到乱序分组后，会一直重复发送已确认的分组的`ACK`）；
若超时定时器设置过小，导致效率降低，可能每个包都重传了多次

> **问题：**
> 停等协议在带宽时延积很大的时候（信道速率快，时延大），效率低

----

#### 流水线可靠数据传输协议

为解决效率低的问题，可一次发送多个未经确认的分组，这必须增大分组序号的范围，并且需要收发方具有更大的缓存队列

- **回退N步(GBN, Go-Back-N)** [![Link](icons/link.svg)](https://media.pearsoncmg.com/ph/esm/ecs_kurose_compnetwork_8/cw/content/interactiveanimations/go-back-n-protocol/index.html)

又称**滑动窗口协议(sliding-window protocol)**

发送滑动窗口`SW = N`：
最多允许有`N`个未确认的分组，若`SW`中有未发送的分组，可立即发送。

`base`：最早未确认的分组序号，`nextseqnum`：最小未使用的序号，则有`nextseqnum - base <= N`，

当收到`ACK(n)`后，发送窗口将后移到`base = n + 1`

若`base`序号分组超时，将回退N步，重新发送`base`后的分组，即将`nextseqnum`重置为`base`

限制滑动窗口的大小，可实现**流量控制**功能

接收滑动窗口`RW = 1`：
接收方只需要维护一个下一个分组期待的分组编号`expectedseqnum`，

若收到不在接收窗口中的分组，将丢弃该分组，并给出按序收到的分组中最大序号的`ACK(n)`，
表示对前n个分组的**累积确认**，


- **选择重传(SR,Selective Repeat)**[![Link](icons/link.svg)](https://media.pearsoncmg.com/ph/esm/ecs_kurose_compnetwork_8/cw/content/interactiveanimations/selective-repeat-protocol/index.html)

接收滑动窗口`RW > 1`：
收到哪个分组就给哪个分组的确认，**独立确认**，每次收到都需要给单独确认

可失序接收，当前面的分组都收到后，再统一上传给上层。

接收方收到的分组序号只会在`[rcv_base-N, rcv_base + N - 1]`共`2N`的范围内，
即发送方和接收方的窗口完全错开。
e.g.:
<div align=center>
  <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407152139276.png"/>
</div>

当接收方收到了`DATA(1)`，并回复了`ACK(1)`，而发送方未接收到该`ACK(1)`，且超时重传时间很长，
并且后续的`N-1`个`DATA`都正确接收，此时接收窗口与发送窗口完全错开。

### 面向连接的传输 TCP

在不可靠的IP端到端网络层上实现可靠数据传输协议(reliable data transfer protocol) 


## 网络层

## 数据链路层

## 物理层

