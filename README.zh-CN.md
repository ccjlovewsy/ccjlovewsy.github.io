[English](README.md) | 简体中文

# ccjlovewsy's Blog

个人技术博客，基于 Jekyll 与 [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) 主题构建，托管在 GitHub Pages 上。

**在线访问**：<https://ccjlovewsy.github.io/>

## 写什么

- Kotlin/Native runtime 源码精读（日志、GC、内存管理）
- 把静态笔记做成可交互的"代码电影"式可视化页面

## 已发布文章

| 日期 | 文章 |
| --- | --- |
| 2026-08-21 | [Logging 源码精读 · 交互式可视化](https://ccjlovewsy.github.io/posts/logging-source-reading-interactive/) |
| 2026-08-12 | [编译一个 Kotlin/Native 程序，幕后发生了什么？](https://ccjlovewsy.github.io/posts/kotlin-native-compile-pipeline/) |
| 2026-08-12 | [你好，博客](https://ccjlovewsy.github.io/posts/hello-blog/) |

## 仓库结构

```shell
.
├── _posts/               # 文章，命名 YYYY-MM-DD-<slug>.md
├── _tabs/                # 导航页（about / archives / categories / tags）
├── assets/interactive/   # 自包含的交互式 HTML 页面
├── _config.yml           # 站点配置
├── BLOG-GUIDE.md         # 运维手册（构建、部署、排错）
└── AGENTS.md             # 给 AI 编码代理（opencode）的操作指引
```

## 本地开发

需要 Ruby 3.4（系统 Ruby 2.6 与 Ruby 4.x 均不兼容 Chirpy）：

```shell
bundle install
bundle exec jekyll serve
# → http://127.0.0.1:4000
```

或直接用封装脚本：`./serve.sh`

## 发布流程

文章是 `_posts/` 下的 Markdown 文件。**push 到 `main` 本身不会触发部署**；部署由 GitHub Actions 工作流 `pages-deploy.yml` 手动触发：

```shell
gh workflow run pages-deploy.yml --repo ccjlovewsy/ccjlovewsy.github.io --ref main
```

> 该工作流也声明了 `v*` tag 触发，但 tag 触发的部署目前会被 `github-pages` 环境保护规则拒绝——请使用上面的手动触发方式。草稿放 `_drafts/`（永不构建）；`_posts/` 里的内容会在下一次部署时上线。

触发后用 `gh run list` 监控到 success，再验证文章上线。完整流程见 [BLOG-GUIDE.md](BLOG-GUIDE.md)。

## 许可

基于 [MIT][mit] 许可发布。

[mit]: https://github.com/ccjlovewsy/ccjlovewsy.github.io/blob/main/LICENSE
