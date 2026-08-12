---
title: 这是一篇私人草稿，不应上线
date: 2026-08-12 17:00:00 +0800
categories: [测试]
tags: [draft, private]
---

> 验证：此文章已提交到 main 分支，但因为部署规则改为 tag 触发，main push 不应触发部署。
> 如果你在线上 https://ccjlovewsy.github.io/ 看到这篇文章，说明配置失败。

## 验证清单

- [ ] main 分支 push 后 Actions **不触发**部署
- [ ] 线上站点首页 **不显示**这篇文章
- [ ] 本地 `serve.sh` 预览 **能看到**这篇文章

## 私人内容

这段文字只有我自己能通过本地预览看到。打 tag 部署之前，线上不会有这篇文章。

需要公开发布时：
```bash
git tag v1.x
git push origin v1.x
```
