---
title: "Python_learning"
description: 记录python基础语法等学习（杂记）
date: 2024-10-28T11:01:44+08:00
slug: 'python'
tags: ['Python','Learning']
categories: ['学习记录']
image: 'img/default_image.jpg'
math: false
license: false
# hidden: true
comments: true
draft: true
---


# Pytorch

## 常用神经网络模块

- 线性层：

torch.nn.Linear：用于全连接层。

- 卷积层：

torch.nn.Conv1d：一维卷积层（常用于时间序列）。

torch.nn.Conv2d：二维卷积层（常用于图像处理）。

torch.nn.Conv3d：三维卷积层（常用于视频处理）。

- 激活函数：

torch.nn.ReLU：ReLU 激活函数。

torch.nn.LeakyReLU：Leaky ReLU 激活函数。

torch.nn.Sigmoid：Sigmoid 激活函数。

torch.nn.Tanh：双曲正切激活函数。

- 池化层：

torch.nn.MaxPool2d：二维最大池化层。

torch.nn.AvgPool2d：二维平均池化层。

- 循环神经网络（RNN）：

torch.nn.RNN：基本 RNN 模块。

torch.nn.LSTM：长短期记忆网络。

torch.nn.GRU：门控循环单元。

- 批归一化：

torch.nn.BatchNorm1d：一维批归一化层。

torch.nn.BatchNorm2d：二维批归一化层。

- 丢弃层：

torch.nn.Dropout：随机丢弃层，用于防止过拟合。

- 嵌入层：

torch.nn.Embedding：用于将离散的整数映射到稠密的向量空间，常用于自然语言处理。

- 残差块和跳跃连接：

torch.nn.Sequential：用于构建顺序的网络模块。

- 自定义残差块：常用于构建 ResNet 等深度网络。