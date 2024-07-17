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

若`base`序号分组超时，将回退N步，重新发送`base`后的**所有**分组，即将`nextseqnum`重置为`base`

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

#### TCP 连接特性
- 全双工服务
- 点对点


#### TCP报文段结构

- 序号：以字节为单位，每次TCP连接建立将选择一个初始的序号
- 确认号：以字节为单位，**累计确认**
- 接收窗口：用于流量控制，以字节为单位
- 首部长度(Header Length)：以字为单位的TCP首部长度
- RST、SYN、FIN：用于连接建立和拆除
- ACK：指示确认号的值有效

<div align=center>
  <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407160008486.png" title="TCP报文段结构"/>
</div>

#### 超时时间设置

在网络中，由于网络负载的不同，分组的往返时间RTT将会不断变化。

在TCP中对往返延时进行采样测量 $SampleRTT$，
TCP维护一个 $SampleRTT$的指数加权移动平均值

$$
EstimatedRTT = (1-\alpha)\cdot EstimatedRTT + \alpha\cdot SampleRTT
$$

$DevRTT$用于估算 $SampleRTT$偏离 $EstimatedRTT$的程度，
反应了 $SampleRTT$的波动大小

$$
DevRTT = (1-\beta)\cdot DevRTT + \beta \cdot |SampleRTT-EstimatedRTT|
$$

设置的重传时间为

$$
TimeoutInterval = EstimatedRTT + 4 \cdot DevRTT
$$

#### 可靠数据传输

TCP在可靠数据传输技术的基础上，将定时器简化成1个，
使用累计确认、超时重传、冗余确认等技术。

- 超时时间间隔加倍

在超时触发的重传条件下，超时时间将不由估计值推算，而是直接翻倍，
有助于缓解网络拥塞的情况

- 快速重传

若接收方接收到了失序的报文段，则将立即发送冗余`ACK`，
因此发送方可能会连续收到好多个具有相同确认号的`ACK`。
若收到3个冗余`ACK`，则 执行快速重传，不等待超时定时器中断。

#### 流量控制

TCP报文段中捎带有接收窗口的大小，为接收缓存中空余的空间大小。
发送方维护未确认的数据量，保证未确认的数据量小于接收窗口大小

当接收窗口大小为0时，且接收方没有任何需要回复的动作了。
发送方将继续发送一个只有1Byte数据的报文段，来解决发送方被阻塞的问题。

#### TCP连接管理

- 建立连接(三次握手)

[客户端请求连接]，[服务器端回复 + 服务器端同意连接]，[客户端回复]

其中服务器端的回复和同一连接使用同一个TCP报文段实现。

<div align = center>
  <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407171140175.png"/>
</div>

1. Client 给 Server 发送TCP的`SYN`报文段，其中`SYN = 1`，
   并随机选择一个初始序列号`seq = client-isn`，表示**请求建立连接**。
2. Server 给 Client 回复`SYNACK`报文段，其中`SYN = 1 `，
   填入确认号`ack = client-isn + 1`，
   并选择一个初始序列号`seq = server-isn`，
   表示**允许连接**。
3. Client 在收到`SYNACK`报文段后，连接已经建立，`SYN = 0`,
   填入确认号`ack = server-isn + 1`，
   序列号为`seq = client-isn + 1`，
   同时，可由该确认字段直接捎带数据发送。

> **随机选择序列号**，可尽量避免网络中历史残留数据报文段的对此次连接后的影响。
>
> 假设有一个历史的数据报文段，在网络中逗留了很久；
> 客户端和服务器端建立了新的TCP连接，并且使用相同的端口号；
> 此时历史数据报文段到达，会被认为是有效的，干扰此次连接的可靠传输。

- 断开连接 （四次挥手）

<div>
  <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407171149664.png"/>
</div>

> 存在更多不正常的情况需要分析

### 拥塞控制原理

- **拥塞**：网络中需要传输的数据量超过了网络的处理能力

#### 拥塞的表现和代价

- 分组丢失
- 时延变大
- 分组重传导致网络负载更大（正反馈）

#### 拥塞控制方法

- 网络辅助信息的拥塞控制

路由器向发送方提供关于网络中拥塞状态的显式反馈信息，
采用标志位来显示网络中拥塞情况

> e.g. : ATM-ABR 拥塞控制，控制信元中添加显示网络拥塞状况以及最低可支持速率字段

对于大规模复杂网络，网络核心节点的负载更大。

- 端到端拥塞控制

端系统通过观察网络中的行为来推测网络的拥塞情况。

### TCP的拥塞控制

- 拥塞检测

TCP的报文段超时未确认，或收到来自接收方的3个冗余ACK，认为出现了丢包；
可能是由于**拥塞**引起的（大概率），也可能是由于报文段出错被丢弃（概率小）

- 拥塞窗口`cwnd`

与接收端反馈的接收窗口`rwnd`一同，同时实现流量控制和拥塞控制。
未确认的报文段的数量必须小于`min{cwnd, rwnd}`

#### TCP 拥塞控制策略(AIMD)

乘性减，加性增策略（`AIMD`）

- 慢启动（SS）

1. 在连接开始时，`cwnd`以一个`MSS`开始进行传输，
每一个RTT的时候对`cwnd`加倍，进行指数增长，直到发生丢失事件
2. 当发生超时事件后，将`cwnd`设置为1，并重新进入慢启动阶段，
并将上一次的`cwnd`的一半设置为慢启动的阈值`ssthresh`。
3. 当`cwnd`达到慢启动阈值`ssthresh`后，将进入拥塞避免阶段。
4. 当收到3个冗余`ACK`时，`ssthresh = cwnd/2`，`cwnd=ssthresh+3`，
将进入快速恢复阶段。

- 拥塞避免（CA）

1. 每一个RTT将`cwnd`增加一个`MSS`
2. 当发生超时事件后，`ssthresh = cwnd/2`, `cwnd = 1`，并重新进入慢启动阶段
4. 当收到3个冗余`ACK`时，`ssthresh = cwnd/2`，`cwnd=ssthresh+3`，
将进入快速恢复阶段。

- 快速恢复（Fast Recovery，推荐）

1. 每收到一个冗余`ACK`，将`cwnd`增加一个`MSS`
2. 收到新的`ACK`，`cwnd = ssthresh`，进入拥塞避免阶段


- 平均吞吐量

忽略慢启动阶段，$W$ 为发生丢失事件时的窗口尺寸

$$
Rate = (\frac{W}{2} + W)/RTT = 0.75\frac{W}{RTT}\quad (\text{Byte/s})
$$

#### TCP的公平性

- 若TCP连接之间具有相同的RTT和MSS，TCP连接之间会收敛到均分带宽
- RTT小的TCP连接将会抢占更多的带宽
- 对于主机来说，拥有更多并行TCP连接的主机可以获得更大的带宽
- UDP会侵占TCP的带宽

## 网络层 

## 数据链路层

## 物理层

