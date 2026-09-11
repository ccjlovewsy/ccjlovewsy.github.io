---
title: 我的 GitHub 仓库盘点：这个账号里都收藏和折腾了些什么
date: 2026-09-11 12:00:00 +0800
categories: [随笔]
tags: [github, collection, learning]
---

博客写了几篇，回头看了看自己的 [GitHub 主页](https://github.com/ccjlovewsy)，发现里面躺着的东西其实比想象中多：有本站源码，有正在啃的学习资料，有跟着视频课程敲的项目，也有做技术调研时 fork 下来精读的仓库。与其让它们安静地躺在列表里，不如写一篇文章把它们梳理一遍——哪些是我的原创，哪些是收藏后在学的，为什么值得留。如果你也想了解这个账号的「库存」，这篇就是导览图。

## 仓库总览

| 仓库 | 类型 | 一句话介绍 |
| --- | --- | --- |
| [ccjlovewsy.github.io](https://github.com/ccjlovewsy/ccjlovewsy.github.io) | 原创 | 本博客的源码仓库（Jekyll + Chirpy） |
| [ovCompose-sample](https://github.com/ccjlovewsy/ovCompose-sample) | fork · 在学 | KMP 技术分析组使用的示例工程 |
| [lottie-flutter](https://github.com/ccjlovewsy/lottie-flutter) | fork · 在学 | Flutter 上的 Lottie 动画播放器（纯 Dart 实现） |
| [hackthon-2026-5-10](https://github.com/ccjlovewsy/hackthon-2026-5-10) | fork · 参与 | 一次黑客松活动留下的 JavaScript 代码 |
| [reggie_parent](https://github.com/ccjlovewsy/reggie_parent) | fork · 学习 | 瑞吉外卖项目 2.0，前后端分离的在线订餐系统 |
| [JavaGuide](https://github.com/ccjlovewsy/JavaGuide) | fork · 收藏 | Java 学习 + 面试指南 |
| [CS-Notes](https://github.com/ccjlovewsy/CS-Notes) | fork · 收藏 | 技术面试基础知识：操作系统、计算机网络、系统设计等 |
| [JavaBooks](https://github.com/ccjlovewsy/JavaBooks) | fork · 收藏 | Java 程序员书单整理，附下载地址 |
| [uestc-course](https://github.com/ccjlovewsy/uestc-course) | fork · 收藏 | 电子科技大学课程资料共享平台 |
| [edu-knowlege](https://github.com/ccjlovewsy/edu-knowlege) | fork · 收藏 | 从幼儿园到中小学的教育资料合集 |
| [rpi](https://github.com/ccjlovewsy/rpi) | fork · 收藏 | B 站 UP 主「我是炬峰」视频配套代码 |

> 下文提到的所有 fork 仓库都是收藏或在学的项目，版权归原作者所有；介绍点是「我为什么留着它」，不代表原创。
{: .prompt-info }

除了上面这些，账号里还有少量备用仓库，就不一一展开了。下面挑几个有故事的说。

## ccjlovewsy.github.io：博客本身

这个仓库就是你现在看到的这个网站。用 Jekyll 搭配 Chirpy 主题搭建，托管在 GitHub Pages 上，语言统计显示为 HTML（模板和文章为主体），目前收获了 1 个 Star——来自我自己（笑）。2026 年 9 月还在活跃更新，[「编译一个 Kotlin/Native 程序，幕后发生了什么？」]({% post_url 2026-08-12-kotlin-native-compile-pipeline %})这类文章的源稿都保存在这里。对一个博客仓库来说，「持续有新文章进来」大概就是它最有生命力的状态。

## ovCompose-sample：KMP 技术分析组的功课

这是我为 KMP（Kotlin Multiplatform）技术分析准备的示例工程，2026 年 3 月前后在跟进。为什么关注它？因为我在写[编译管线那篇文章]({% post_url 2026-08-12-kotlin-native-compile-pipeline %})时对 Kotlin 的跨端与编译体系产生了兴趣，而 KMP 正是这条线的自然延伸——同一份业务逻辑编译到多端，背后同样依赖 Kotlin 编译器链路。fork 下来是为了方便对照源码做笔记，等看得更透了，应该会有相应文章产出。

## lottie-flutter：设计稿动效到 Flutter 的桥梁

lottie-flutter 是 Lottie 在 Flutter 上的播放器实现，能把 After Effects 导出的动画直接渲染到 Flutter 界面里，而且是纯 Dart 实现、不依赖平台通道。fork 它是 2026 年 6 月的事，当时在研究 Flutter 动画方案，这个仓库的「纯 Dart 跨平台渲染」思路很值得读：一份动画描述文件，iOS 和 Android 上表现一致，省去了双方各自实现动效的成本。移动端动画这个话题，未来可能单独写一篇。

## hackthon-2026-5-10：黑客松的痕迹

名字已经说明了一切：2026 年 5 月 10 日前后一次黑客松活动留下的 JavaScript 代码。它目前是这个账号里唯一一个收获了 1 个 Star 的 fork——大概说明作品确实有可取之处。黑客松的意义从来不只是代码本身，而是在有限时间里把想法跑通的经历。9 月初还有过一次更新，也算是为那段经历留了个活口。

## reggie_parent：跟着做的实战项目

瑞吉外卖 2.0 是一个前后端分离的在线订餐系统，是我学习后端开发时跟着做的完整项目。它对我的价值在于「完整性」：从下单、支付到管理端，一条业务线跑通，比零散的 demo 更能暴露真实问题。学后端的路上，找一个这样的项目完整啃一遍，比收藏十份教程有用。

## 学习资料三件套：JavaGuide / CS-Notes / JavaBooks

这三个仓库是我收藏的资料类项目，目的很直接：应对学习与面试。

- **[JavaGuide](https://github.com/ccjlovewsy/JavaGuide)**：一份涵盖大部分 Java 程序员所需核心知识的学习 + 面试指南，准备 Java 面试时几乎是标配。
- **[CS-Notes](https://github.com/ccjlovewsy/CS-Notes)**：技术面试必备基础知识合集，覆盖 Leetcode、计算机操作系统、计算机网络、系统设计——JavaGuide 之外的查漏补缺。
- **[JavaBooks](https://github.com/ccjlovewsy/JavaBooks)**：Java 程序员必读书单整理，附下载地址，从 Java、设计模式到数据库、大数据、架构，帮你按图索骥地构建知识体系。

这三个都是社区里口碑很好的资料库，fork 回来就当自己的学习进度锚点：看完一部分，标记一部分。

## 课程与教育资料：uestc-course / edu-knowlege

- **[uestc-course](https://github.com/ccjlovewsy/uestc-course)**：电子科技大学的课程资料共享平台，收藏它一方面是资料本身有用，另一方面也欣赏这种「把课程资料开源共享」的社区做法。
- **[edu-knowlege](https://github.com/ccjlovewsy/edu-knowlege)**：从幼儿园到中小学的教育资料合集，涵盖学而思、万维、猿辅导等多个机构，2026 年 8 月还在持续增加中——家里有娃的话，这个仓库值得常来看看。

## rpi：跟着视频学硬件的一扇窗

[rpi](https://github.com/ccjlovewsy/rpi) 是 B 站 UP 主「我是炬峰」的视频配套代码仓库，2024 年收藏。对跟着视频学习的人来说，把代码仓库 fork 下来边看边跑，是效率最高的方式。

## 写在最后

以上就是我这几年在 GitHub 上沉淀的全部「家当」：一个认真维护的博客仓库，几份在啃的技术源码，一批诚实的收藏。如果你对其中某个仓库有同样的兴趣，欢迎访问我的 [GitHub 主页](https://github.com/ccjlovewsy)交流，也欢迎给本博客点个 Star——那是它收到过的第一个，但希望不会是最后一个。

> 本文中的仓库状态（fork 属性、语言、Star 数）均基于 2026-09-11 的 GitHub API 数据整理。
