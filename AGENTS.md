# AGENTS.md — 给 opencode 的操作指引

本仓库是 GitHub Pages 博客（Jekyll + Chirpy 主题）。完整运维手册见 **[BLOG-GUIDE.md](./BLOG-GUIDE.md)**，操作前必读。

## 关键约束（务必遵守）

1. **Ruby 版本**：必须用 `ruby@3.4`（Chirpy 不兼容系统 Ruby 2.6 和 Ruby 4.x）。所有 `ruby`/`gem`/`bundle`/`jekyll` 命令前加：
   ```bash
   export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
   ```
2. **gh CLI**：`export PATH="/opt/homebrew/bin:$PATH"` 后才能用 `gh`。
3. **网络**：GitHub HTTPS 和 SSH 22 被墙，已配 `~/.ssh/config` 走 `ssh.github.com:443`。不要改用 HTTPS remote。
4. **文章发布流程**：本地 `jekyll build` 验证 → `git push` → `gh run list --limit 1` 监控到 `success` 才算完成。

## 发布文章的标准流程

用户给一个 `.md` 文件路径让你「部署/发布」时：

1. **读源文件**，但 **不要修改原文件**。
2. 在 `_posts/` 创建合规版本：
   - 文件名 `YYYY-MM-DD-英文-slug.md`（用今天的日期，slug 用英文/连字符）
   - 加 front matter：`title` / `date`（含时区 `+0800`）/ `categories` / `tags`
   - 删正文开头的 H1（Chirpy 用 front matter 的 title 自动渲染）
   - 修明显的 markdown 结构问题（未闭合的引用块、缩进错误等）
3. 本地构建验证：`bundle exec jekyll build`（加上面 PATH）无报错。
4. `git add -A && git commit -m "发布: <标题>" && git push origin main`
5. 监控部署：`gh run list --repo ccjlovewsy/ccjlovewsy.github.io --limit 1` 直到 `success`。
6. 验证上线：`curl -sS https://ccjlovewsy.github.io/posts/<slug>/` 应 HTTP 200 且含文章标题。
7. 给用户最终报告：访问地址 + 处理记录（做了哪些适配）。

## 常用命令

```bash
# 本地预览
~/ccjlovewsy.github.io/serve.sh   # → http://127.0.0.1:4000

# 看部署状态
gh run list --repo ccjlovewsy/ccjlovewsy.github.io --limit 3

# 手动触发部署
gh workflow run pages-deploy.yml --repo ccjlovewsy/ccjlovewsy.github.io --ref main

# 看 Pages 配置
gh api repos/ccjlovewsy/ccjlovewsy.github.io/pages
```

## 仓库信息

- 仓库：`ccjlovewsy/ccjlovewsy.github.io`（PUBLIC，必须保持公开）
- 默认分支：`main`
- Pages source：GitHub Actions
- 站点：https://ccjlovewsy.github.io/
- 详细排错、环境重装步骤见 **BLOG-GUIDE.md**
