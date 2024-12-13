---
title: "Holocubic的说明书"
description: 
date: 2024-12-13T22:33:04+08:00
slug: 'holocubic_intro'
tags: ['Holocubic']
categories: ['']
# image: 'img/default_image.jpg'
math: false
license: false
hidden: false
comments: true
hasCJKLanguage: true
draft: false
---

# Holocubic 介绍

![image-20241213225646202](https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202412132256351.png)

[Holocubic ](https://www.bilibili.com/video/BV1VA411p7MD/?spm_id_from=333.1387.upload.video_card.click&vd_source=aa40e7ad8ca9111af678a8e83c635927)最初是由 B站 up 主[稚晖君](https://space.bilibili.com/20259914)开发的一款集成了网络功能的伪全息透明显示桌面站，使用了一个分光棱镜来设计出伪全息显示的效果，因为搭载了 WiFi 和蓝牙能力可以实现很多网络应用。

视频经发布后，就引起了很多网友的复刻，当初我也进行了复刻；后续在众多网友为爱发电下，修复了初版设计的一些问题，并且 Holocubic 的功能越来越丰富。

## 硬件介绍

Holocubic 由主板和屏幕板两个PCB组成，配有外壳和分光棱镜，支持插入TF卡实现更多的功能。

本版本的 Holocubic 的主板未添加供电模块，由屏幕版上的 DC-DC 电路进行供电，因此无法单独测试使用主板。

# Holocubic 使用手册

该 Holocubic 使用的是改进后的硬件版本，固件由 [ClimbSnail](https://github.com/ClimbSnail/HoloCubic_AIO) 及其他更多开发人员共同开发，并由我进行了一定的修改，删除部分不必要的功能以及某些功能。

下面将介绍基于 Holocubic_AIO 固件框架的使用方式。

## 开机注意事项

由于 Holocubic 使用的是 MPU6050 陀螺仪加速度计，通电前3秒需要保持小电视**自然放置**（不要手拿），等待传感器初始化，初始化完毕后指示灯的**亮度显著增加**，之后就可以正常操作了。插不插TF卡都不影响正常开机。

## 交互方式

Holocubic 使用陀螺仪加速度计进行动作的输入，主要包括**上（前进）、下（后退）、左、右**四个指令，对应**后仰、前倾、左摇、右晃**四个动作：

1. 左右摇晃`0.5s`即可切换选择各类 APP，以及在 APP 中操作
2. 后仰`1s`钟即可进入当前页的 APP 应用，同样向前倾斜`1s`即退出该 APP。

## APP介绍

### 网页配置服务（Web Server）

通过网络连接配置Holocubic，例如想要连接的WiFi信息、天气APP参数、相册参数、播放器参数等等。

1. 运行 APP 条件：无。
2. 启用后，会显示`Web Sever Start`。小电视开启AP模式，建立在`AP_IP`上（屏幕的服务界面有标注），AP模式的热点名为`HoloCubic_AIO`，无密码。
3. **初次使用时**需要使用电脑连接 Holocubic 建立的名称为`HoloCubic_AIO`的热点，无密码。
4. 在浏览器地址栏输入`Local_IP`（http://192.168.4.2，也支持域名直接访问 http://holocubic ），即可进入管理设置后台。
5. 在配置好 WiFi 信息，且 Holocubic 成功连接 WiFi 后，可使用连接同一个 WiFi 的电脑访问该`IP`地址再次进行设置。

注：<font color=red>由于芯片的限制，Holocubic仅支持2.4G的WiFi，不支持5G及混合频段的WiFi，可用手机开一个热点使用</font>

### 文件管理器（File Manager）

通过无线网络管理内存卡上的文件。

1. 运行 APP 条件：必须是已经正常配置 WiFi，必须插 TF卡。为避免WiFi连接时，功率不够导致重启，请确保USB口供电充足。
2. 进入`Holocubic`文件管理器后会自动连接已配置的 WiFi，并显示出`IP`地址。
3. 

### 相册（Picture）

1. 运行APP条件：必须插内存卡，内存卡的根目录下必须存在`image/`目录（也可以使用`Web Server服务`APP 通过浏览器上传照片），`image/`目录下必须要有图片文件（`jpg`或者`bin`）。
2. 将需要播放的图片转化成一定格式（`.jpg`或`.bin`），再保存在`image/`目录中，图片文件名必须为英文字符或数字（但不能以数字开头）。
3. 进入 APP 后，左右摇晃进行图片切换。
4. `Web Server`的网页端可以进行附加功能的设置。

注：<font color=red> 由于 Holocubic 使用的是1：1尺寸的屏幕，建议将需要显示的图片进行转换。关于图片转换，见本文后续说明</font>

### 视频播放（Media）

1. 运行APP条件：必须插内存卡，内存卡的根目录下必须存在`movie/`目录。
2. 将所需要播放的视频（最好长宽比是1:1），使用本固件配套的使用转化工具转化为目标文件（`mjpeg`或者`rgb`格式），存放在`movie/`目录下，视频文件名必须为英文字符或数字（但不能以数字开头）。
3. 进入 APP 后，左右摇晃进行视频切换。
4. 默认功率下，无任何动作90s后进入低功耗模式，120s后进入二级低功耗模式，具体表现为播放画面帧数下降。
5. `Web Server`的网页端可以进行附加功能的设置。

### 屏幕分享、电脑投屏（Screen share）

1. 运行APP条件：无需内存卡，但需要利用`Web Server` APP 设置 WiFi 密码（确保能连上路由器）。为避免 `WiFi`连接时，功率不够导致重启，请确保USB口供电充足。
2. 需要搭配上位机使用，使用的是[大大怪](https://gitee.com/superddg123/esp32-TFT/tree/master)的上位机，如果画面卡顿可以降低画质来提升帧数。
3. `Web Server`的网页端可以进行附加功能的设置。

### 天气、时钟（Weather）

在原本的 Holocubic_AIO 框架中，有两款天气时钟的APP，此处仅保留了一款。

1. 运行APP条件：必须是已经联网状态。
2. 由`PuYuuu`模仿了`misaka`的时钟界面，使用高德天气API。
3. 使用天气时钟，需要在`Web Server`网页服务中修改`城市名（精准的城市代码）`、`API的个人Key`。（城市代码的参考编码表 https://lbs.amap.com/api/webservice/download ，key的获取方法 https://lbs.amap.com/api/webservice/create-project-and-key ）

注：<font color=red>即使断网后，时钟也依旧运行。（开机最好连接wifi，这样会自动同步时钟。使用中会间歇尝试同步时钟）</font>

### 特效动画（Idea）

1. 运行 APP 条件：无。内置的几种特效动画。

### 2048

1. 运行 APP 条件：无。基本屏幕能亮就行。

2. `2048`游戏由群友`AndyXFuture`编写并同意，由`ClimbSnail`合入AIO固件。
3. 操作注意：游戏中 **向上** 和 **向下** 操作由于与原 **前进** 和 **后退** 为同一个动作，系统根据已操作时长来区分动作，游戏中 **向上** 和 **向下** 正常操作即可， **前进** 和 **后退** 需要倾斜1秒中方可触发。

### BiliBili

1. 运行APP条件：内存卡中必须要有名为`bilibili`的文件夹。必须是已经正常配置wifi。为避免wifi连接时，功率不够导致重启，请确保USB口供电充足。
2. `UID`查看方法：电脑浏览器上打开B站并登入账号，之后浏览器打开一个空白页粘贴回车这个网址 https://space.bilibili.com/ ，网址尾巴会自动多出一串纯数字码，此即为UID。
3. 第一次使用之前，要先在`WebServer App`的网页上填写`UID`码。
4. 需要在内存卡中名为`bilibili`的文件夹里添加一张名为`avatar.bin`自己B站头像的图片，分辨率为`100*100`的`bin`文件（可以使用AIO上位机转换）。

### 纪念日（Anniversary）

1. 运行APP条件：联网状态
2. 第一次使用之前，要先在`Web Server` APP 的网页上填写纪念日名称和日期，目前可以设置两个纪念日。
3. 纪念日支持的字有`生日还有毕业养小恐龙种土豆老婆女朋友爸妈爷奶弟妹兄姐结婚纪念`，如果纪念日名称包含的字不在这个范围内，请自行生成字体文件并替换`src\app\anniversary\msyhbd_24.c`文件。日期格式如`2022.5.8`，如果年份设置为0，则被认为是每年重复的纪念日（如生日）。

注：<font color=red> 字体文件的替换需要修改源代码并重新进行编译 </font>

### 心跳（Heartbeat）

1. 运行APP条件：联网状态（需要开启性能模式），**一个开放1883端口的mqtt服务器**，**两个HoloCubic**。
2. 第一次使用之前，要先在`Web Server `APP 的网页上填写配置。role可以选择0和1，分别代表互动的两个HoloCubic。client_id为设备的唯一标识，这里请将这两个Holocubic设置成同一个QQ号。mqtt_server填写自己的mqtt服务器地址,port填写端口号。用户名以及密码根据具体的服务器配置而定。
3. 设置完心跳APP之后，开机自动联网，并开启mqtt客户端。收到另一个HoloCubic的消息之后自动进入APP。正常方式进入APP则自动向另一个HoloCubic发送消息。

注：<font color=red> 俺手上也没有两个Holocubic，呜呜</font>

### PC资源监控(PC Resource)

1. 运行条件: 必须是已经正常配置wifi。PC端与HoloCubic处于同一网段，在`WebServer` APP中配置PC的服务IP地址（具体看教程）。
2. 下载[AIDA64](https://www.aida64.com/downloads)，PC安装AIDA64后的导入配置文件`aida64_setting.rslcd`（在`AIO_Firmware_PIO\src\app\pc_resource`目录下或者群文件中）

注：<font color=red>具体操作步骤较长，见群文档。有些内容在群文档中，我应该会尽可能收集信息打包，但可能有遗漏的资源，可通过下方的评论给我发送信息。</font>

### 多功能动画(LH&LXW)

1. 运行APP条件：带有该固件功能的Holocubic

【功能说明】

- 功能1： 代码雨；进入此功能后——左/右倾 可切换代码雨大小、前倾退出此功能。

- 功能2：赛博相册；进入此功能后——左倾停止自动切换、右倾恢复自动切换、后倾在静态和动态间切换、前倾退出此功能。

进入此功能前，得确保你的内存卡中有以下文件：

```
1. ./LH&LXW/cyber/imgx.cyber 存放需要显示的图片文件(x为0~99)
2. ./LH&LXW/cyber/cyber_num.txt 存放需要显示的图片文件数(00~99) 例如7个图片，写07
   注意：./LH&LXW/cyber/imgx.cyber 中的图片数必须等于./LH&LXW/cyber/cyber_num.txt 中用户输入的图片文件数
```

.cyber格式的图片文件由以下python代码生成：

```python
import cv2
img_path = './123.jpg'#输入图片路径(图片大小必须48x40)
out_path = './123.cyber'#输出文件路径
img = cv2.imread(img_path)
img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
with open(out_path, 'wb') as f:
    for a in img:
        for b in a:
            f.write(b)
```

- 功能3：QQ超级表情；进入此功能后——左/右倾 选择不同表情、后仰播放当前表情、在播放时前倾会退出播放、在选择表情时前倾会退出此功能。播放表情时自动循环播放33.3秒，然后播放下一个，播放过程中可以左/右倾 手动切换。

  进入此功能前，得确保你的内存卡中有以下文件

  ```
  1. ./LH&LXW/emoji/videos/videox.mjpeg   存放要播放的视频（大小240x240）(x为0~99)
  2. ./LH&LXW/emoji/images/imagex.bin 存放要播放的视频的封面（大小60x60）(x为0~99)
  3. ./LH&LXW/emoji/emoji_num.txt 存放要播放的视频数(00~99) 例如7个视频，写07
  
  注意：./LH&LXW/emoji/videos/ 中的视频数必须等于 ./LH&LXW/emoji/images/ 中的封面数
  同时必须等于 ./LH&LXW/emoji/emoji_num.txt 中用户输入的视频个数。
  ```

- 功能4：眼珠子；进入此功能后——左/右倾 切换眼睛样式、前倾退出此功能。

- 功能5：动态心；进入此功能后——晃动小电视，组成♥的粒子也会晃动，停止晃动后，粒子又会聚集成♥的样子、、前倾退出此功能。

APP演示视频：[【LVGL菜单#透明小电视#LVGL开发】 ](https://www.bilibili.com/video/BV1wK421173C/?share_source=copy_web&vd_source=68337adbea96c8cef50403a4b2809df6)



# 参考

1. https://github.com/peng-zhihui/HoloCubic
2. https://github.com/ClimbSnail/HoloCubic_AIO

注：<font color=red>本文仅作为本礼物的快速说明，更细节的相关文档包括源代码可进入 `ClimbSnail` 的github仓库中获取。</font>

3. 此处添加一个收集到的资源合集的获取链接 【】

