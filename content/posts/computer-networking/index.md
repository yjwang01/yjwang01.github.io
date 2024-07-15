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

![UDP报文段结构](https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407141801936.png)

> **长度(16bit)**: 以字节为单位
> 
> **校验和(16bit)**：虽然很多链路层协议都提供了差错检测，但是只有**端到端**实现的差错检测才能保证（端到端原则）；无法实现差错恢复


### 可靠数据传输原理

- 自动重传请求ARQ(Automatic Repeat reQuest)



### 面向连接的传输 TCP

- 在不可靠的IP端到端网络层上实现可靠数据传输协议(reliable data transfer protocol)
- 


## 网络层

## 数据链路层

## 物理层

