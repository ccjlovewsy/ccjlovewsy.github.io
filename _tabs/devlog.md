---
title: 博客开发过程
icon: fas fa-code-branch
order: 6
---

本页记录博客的开发与运维过程，全程按「实现 → 微测 → 审查 → 收尾」的质检节奏推进，过程账本原文附于文末。

## 2026-09-11 评论系统上线（giscus）

- 开启仓库 Discussions，抓取 `repo_id` / `category_id`（Announcements 分类，仅维护者可开帖）
- `_config.yml` 填入 giscus 四项配置，本地构建验证组件注入
- 权限边界实测：GitHub App 安装只能网页授权（PAT/MCP 无法代办），其余全部 API 完成
- 上线验证：文章页 HTTP 200、widget iframe 挂载、渲染高度 372px（错误态只有约 60px 横幅）、widget 与页面 postMessage 双向通信正常

## 2026-09-11 「待办」页签上线

- 新增 `_tabs/todo.md` 进侧边栏，替代仓库根目录的 TODO.md
- 公开页对本地绝对路径做了脱敏

## 2026-09-11 PWA 离线缓存缺陷修复

- **现象**：部署后首次访问能看到新页签，刷新后侧边栏又消失
- **定位**：Chirpy 的 Service Worker（`sw.min.js`）cache-first 策略 + 时间戳版本缓存（`chirpy-<ts>`），部署后老访客的刷新命中旧缓存，需要「后台拉新 → 激活 → 再刷新」一轮才恢复
- **修复**：关闭 `pwa.cache.enabled`；新增 `custom-head.html` 主动 unregister 遗留 SW 并清理 `chirpy-*` 缓存，保证已安装缓存的访客自动痊愈

## 开发方法：质检式流水线

以 agent-grill-loop v2 升级为例（五任务 + 终审，全部通过）：

| 任务 | 内容 | 微测 |
|---|---|---|
| Task 1 | 备份 + triage 分级 + checkpoint 落盘 | PASS 4/4 |
| Task 2 | OPEN flag 结构化（owner + why） | PASS |
| Task 3 | Heavy 双 B 独立盘 | PASS 5/5 |
| Task 4 | 实测要点/反模式/边界增补 | PASS 3/3 |
| Task 5 | 终验（结构/词数/全链路） | PASS |
| Final | 全文审查 → 1 处必修 → 修复核验 | Ready |

### 过程账本原文（progress.md）

```
Task 1: complete (review clean; micro-test PASS 4/4)
Task 2: complete (review clean; micro-test PASS)
Task 3: complete (review clean; micro-test PASS 5/5 含退化条款)
Task 4: complete (review clean; retrieval micro-test 3/3 PASS)
Task 5: complete (结构 7 节; 词数 whole 407/body 287 ≤ 预算; GREEN 全链路 PASS)
Final review: Needs fixes → 1 fix wave (M7 + M6) → 已修复并核验 → Ready
I1 dismissed (按 plan wc -w 口径达标); M1/M4/M2/M5/M9 dismissed
STATUS: ALL DONE — agent-grill-loop v2 就绪
```
