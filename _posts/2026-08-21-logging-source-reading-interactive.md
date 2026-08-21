---
title: Logging 源码精读 · 交互式可视化
date: 2026-08-21 09:00:00 +0800
categories: [源码精读]
tags: [kotlin-native, logging, 可视化, 交互页面]
---

> 把 Kotlin/Native runtime 里 `Logging.cpp` / `Logging.hpp` 的源码精读，从静态文档升级成一个"代码电影"式的交互页面：一条日志从诞生到输出，拆成 8 个动画场景，可以播放、逐句、调速、跳转。

## 这是什么

对应 Kotlin/Native runtime 的日志框架层精读。核心文件：

| 文件 | 行数 | 路径 |
| --- | --- | --- |
| `Logging.hpp` | 159 | `runtime/src/main/cpp/Logging.hpp` |
| `Logging.cpp` | 136 | `runtime/src/main/cpp/Logging.cpp` |
| `Porting.cpp` | 331 | `runtime/src/main/cpp/Porting.cpp`（tid 来源） |

单条日志的最终形态是 `[LEVEL][tag[,tag...]][tid#N][X.XXXs] message`，这个交互页面把它的组装过程"演"给你看。

## 八个场景的故事线

一条日志从无到有，串成一条完整故事：

1. **一条日志的诞生** —— `FormatLogEntry` 流水线：Level → Tag → Thread → Timestamp → 消息体
2. **多 tag 拼接** —— `FormatTags` 的 subspan 游标推进，首个不带逗号、后续带逗号
3. **Level 判定** —— `enabled()` 的 `<=` 比较，多 tag 任一启用即输出
4. **1024 字节截断** —— 栈上 `std::array<char, 1024>` 溢出无声截断，不留标记
5. **RuntimeLog 惰性求值** —— 先 `enabled()` 检查再求值参数，日志关闭时参数表达式不求值
6. **OnRuntimeInit 启动样本** —— 遍历 12 个 tag 生成 `logging = INFO, rt = DEBUG, ...`
7. **tid 的来源** —— 跨文件调用链到 `syscall(__NR_gettid)`
8. **时间零点** —— `steady_clock` 懒初始化，首条日志必为 `0.000s`

## 交互页面

下面嵌入了交互页面（建议直接全屏体验，三栏布局在宽屏下观感最好）：

<iframe src="/assets/interactive/logging-source-reading.html" width="100%" height="760" style="border:1px solid #30363d;border-radius:8px;" loading="lazy" allowfullscreen></iframe>

无法正常显示？直接 [全屏打开交互页面](/assets/interactive/logging-source-reading.html){:target="_blank" rel="noopener"}。

## 操作说明

- 顶部进度条：点击任意位置直接跳到对应场景
- 底部控制栏：播放 / 暂停、逐句前进后退（停在关键帧而非固定秒数）、速度滑块 0.25x–2x
- 左侧源码区会随场景高亮当前函数行号；右侧讲解区同步滚动字幕

## 几个值得记住的点

- **截断无声**：超长消息到 1023 字节后停下，剩余内容直接丢弃，**不留任何截断标记**。`GCMark` 开 Debug 实测可产生 3.5GB 日志，根因就在这。
- **惰性求值是性能保证**：`RuntimeLog` 宏先做 `enabled()` 判定，关闭日志时参数里的 `obj->toString()` 这类重计算**根本不会执行**。
- **tid 走 syscall**：`konan::currentThreadId()` 在 Linux 上最终落到 `syscall(__NR_gettid)`，因为 glibc 2.30 才有 `gettid()` 封装，太新。
- **时间是相对的**：用 `steady_clock` 在首次 `VLog` 时懒初始化零点，后续都是相对纳秒，所以首条日志恒为 `0.000s`。

## 技术实现

单文件 HTML，零依赖、零构建、零网络：原生 JS + Canvas 2D + `requestAnimationFrame` 时间轴，所有源码文本和动画数据内联。断网双击即开。设计思路见同目录的《交互页面技术方案》。
