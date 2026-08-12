---
title: 编译一个 Kotlin/Native 程序，幕后发生了什么？
date: 2026-08-12 16:28:00 +0800
categories: [Kotlin/Native]
tags: [konanc, llvm, kexe, runtime, 编译器]
---

> 入门第一篇。不讲虚的,直接拿一条真实的编译命令拆到底,看看 `konanc` 按下回车后,你的 `.kt` 是怎么变成能直接运行的 `.kexe` 的。

---

## 0. 一条命令,一台"编译器"

很多教程教你写 Kotlin 程序,却很少拆开看"编译器"到底是什么。先看这张最小地图:

```
你的 .kt 文件
     │
     ▼
 konanc  ──────────►  kotlin-native-compiler-embeddable.jar(编译器本体)
     │                        │
     │                        │  Kotlin 前端:语法分析、类型检查、IR 生成
     │                        │  LLVM 后端:Kotlin IR ──► LLVM IR
     │                        ▼
     │              (中间的 .bc / .o 临时文件,用完即弃)
     │                        │
     └────────────────────────┤ 链接器:你的代码 + Native runtime(一堆 .bc)
                              ▼
                         app.kexe  ← 静态链接的可执行文件,零依赖,直接跑
```

`konanc` 就是一个 bash 脚本,最后一行是:

```bash
"${DIR}"/run_konan konanc "$@"
```

也就是说,`konanc` 只是一个壳,真正干活的是 `run_konan` 去启动的那个 JVM 里的编译器。

## 1. 编译器本体:一个 jar

仓库里的位置:

```
kotlin-native/dist/konan/lib/kotlin-native-compiler-embeddable.jar
```

对,Kotlin/Native 的编译器本体是个 **jar**——编译器本身跑在 JVM 上,它做两件事:

1. **前端**:把你的 Kotlin 源码解析成 Kotlin IR(中间表示),做类型检查。
2. **后端**:把 Kotlin IR 翻译成 **LLVM IR**,再交给 LLVM 生成机器码。

这一步产出的中间文件(bitcode,后缀 `.bc`)通常在临时目录,编译完就没了。所以平时你看不到它——但理解"Kotlin 代码先变成 LLVM IR"这一点,是后面所有 GC、StackMap 文章的地基。

## 2. Native runtime:那一堆 .bc 文件

Kotlin/Native 不像 JVM 那样有个运行时环境,它的"运行时"是**直接链接进你程序里的一段代码**——内存管理(GC)、协程调度、异常、反射支持,全在这里。

在 dist 里,它们以 bitcode 形式躺在:

```
kotlin-native/dist/konan/targets/macos_arm64/native/
├── common_gc.bc           ← 通用 GC 骨架
├── concurrent_ms_gc.bc    ← 并发标记清扫 GC
├── breakpad.bc            ← 崩溃转储
├── ...(几十个)
```

这些 `.bc` 是由 `llvm-link` 拼起来的:

> ```
> llvm-link CRTAllocator.bc + CRTRuntime.bc + KNRootVisitor.bc  →  crt.bc
> ```
>
> 三个模块的符号表拼起来和 dist 里的 `crt.bc` 完全一致(各 298 个符号,只有 `llvm-link` 自动重编号带来的名字差异)。这个认知非常值钱——意味着**修 runtime 的某个文件,不需要重编整个编译器,只需要重编那一个模块再 link 回去**。

## 3. 链接:你的代码 + runtime → kexe

前端翻译出的 LLVM IR 和 runtime 的 `.bc` 最后会一起被链接成机器码,生成 `.kexe`。

关键特性:**静态链接**。所有 runtime 代码、GC、标准库全部打进一个文件,没有任何动态依赖。

这也解释了为什么我们复现 bug 时,可以把编译好的 `min_repro_fail.kexe` 拷到任何一台 mac 上直接跑——它不需要 `~/.konan`,不需要重建环境,`./min_repro_fail.kexe` 就能稳定复现 SIGSEGV(exit 139)。

## 4. 为什么理解这条链路有用?

举一个我们踩过的真实例子:

- 调查一个 GC bug(topic-1-1,`VisitGlobalRoots` 被改成 no-op 导致全局对象被误回收),第一反应往往是"要重编编译器,完了,大工程"。
- 但理解了上面的链路后结论完全不同:**改的是 runtime 的 C++ 代码,跟编译器 jar 无关**。
- 于是做法变成:重编 `KNRootVisitor.cpp` → 得到 `KNRootVisitor_new.bc` → `llvm-link` 三个模块 → 替换 dist 里的 `crt.bc` → 重新 `konanc`。全流程 ~30 秒,不需要碰 gradle、不需要重编编译器。

一句话:**知道"编译"发生了什么,你才知道"改一行代码"到底要花多少成本。**

## 5. 小结与下一步

- `konanc` 是壳,编译器本体是 jar(JVM 程序)。
- 你的代码和 Native runtime(一堆 `.bc`)一起被静态链接成零依赖的 `.kexe`。
- runtime 是插件式的:GC、分配器都是编译时选项。
- **修 runtime 不用重编编译器**——重编对应 `.bc` 再 link 回去即可。
