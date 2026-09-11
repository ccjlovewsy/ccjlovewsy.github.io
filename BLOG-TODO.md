# 博客进化 TODO

> 对标成熟 GitHub Pages 博客的完整实践清单。按优先级分组，做完一项勾一项。
> 主题：Jekyll + Chirpy。Chirpy 已内置的能力见「已具备」节，不要重复造轮子。

## 已具备（Chirpy 内置，无需折腾）

- [x] 全文搜索、暗色模式切换、文章 TOC、代码高亮
- [x] RSS / Atom feed（`/feed.xml`）、sitemap（jekyll-sitemap）
- [x] SEO meta（jekyll-seo-tag）、OG 卡片基础信息
- [x] 分类 / 标签归档页（jekyll-archives）
- [x] PWA 离线缓存
- [x] 评论系统挂载点（giscus 已启用，2026-09-11 修复为 General 类别全站生效）
- [x] 嵌套分类树（Kotlin/Native » 源码精读）
- [x] 部署流水线（GitHub Actions + htmlproofer 链接检查）

## P0 — 影响基本体验

- [ ] **About 页写真实介绍**（`_tabs/about.md` 现在还是模板占位文字）：我是谁、写什么方向、联系方式
- [ ] **侧边栏头像**：加一张图放 `assets/img/avatar.png`，`_config.yml` 的 `avatar:` 指过去
- [ ] **验证 giscus 在全部文章生效**：部署后逐篇打开文章页滚动到底部确认评论框出现；访客（未登录/非维护者）可点赞

## P1 — 提升内容发现与分享

- [ ] **社交分享卡片图（og:image）**：给文章 front matter 加 `image:`，没有图的用站点级 `social_preview_image:` 兜底——分享到微信群/Twitter 时有预览图
- [ ] **RSS 全文输出**：Chirpy 的 feed 默认输出内容（确认 `_config.yml` 无需改动，验证 `curl /feed.xml` 里正文完整）
- [ ] **系列文章索引页**：Kotlin/Native 源码精读系列（Logging → madvise → Alloc → GC）做成一篇「系列导航」文章，放在系列开头，互相链接
- [ ] **发布 madvise 源码精读**：文档已在本地 `02-madvise-三类用途精读.md`，套用 logging 文章的发布流程

## P2 — 数据与运维

- [ ] **访问统计**：启用 `_config.yml` 的 `analytics`，推荐 goatcounter（免费、轻量、无 Cookie）或 umami 自托管
- [ ] **邮箱补全**：`social.email`（会显示在侧边栏和 feed 里，注意隐私可填专用邮箱）
- [ ] **定时链接体检**：加一个每月跑 `htmlproofer` 的 scheduled workflow，死链开 issue
- [ ] **README 加 CI 徽章**：`![deploy](https://github.com/ccjlovewsy/ccjlovewsy.github.io/actions/workflows/pages-deploy.yml/badge.svg)`

## P3 — 锦上添花

- [ ] **自定义 404 页**（`404.html`，Chirpy 有 `layout: 404` 可直接用）
- [ ] **favicon 换掉默认的**：Chirpy 默认用主题图标，自定义 `assets/img/favicons/` 一套
- [ ] **自定义域名**（可选）：买域名 → DNS CNAME → Pages 设置 → `_config.yml` 的 `url` 同步改
- [ ] **博客互链 / 友链页**：`_tabs/` 加 links 页
- [ ] **文章字数与阅读时长**（Chirpy 内置 read time，确认 front matter 无需额外配置即显示）
- [ ] **GitHub Sponsors / 打赏入口**（如需要）：侧边栏加 links

## 运维备忘（已完成的关键节点）

- 2026-08-12：博客初始化（Chirpy starter），部署规则改为「main push 不自动部署」
- 2026-08-21：发布 Logging 交互页面；发现 tag 部署被环境保护规则拒绝 → 改手动触发；发现草稿泄漏 → 建立 `_drafts/` 流程
- 2026-09-11：README 完善（中英双语 + 博客地址）；giscus 启用并修复类别（Announcements → General）
