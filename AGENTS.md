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

## 部署触发规则（重要变化）

**自 2026-08-12 起，main 分支 push 不再自动部署**。部署只在以下情况触发：

1. 打 tag（格式 `v*`，如 `v1.0`、`v1.1`）：`git tag v1.0 && git push origin v1.0`
2. 手动触发：`gh workflow run pages-deploy.yml --repo ccjlovewsy/ccjlovewsy.github.io --ref main`
3. Actions 页面点 "Run workflow"

### 三种发布场景

**场景 1：私人文章（只提交，不部署，别人看不到）**
```bash
# 文章放 _posts/，加 front matter
git add -A && git commit -m "私人草稿: <标题>"
git push origin main
# main 分支 push 不触发部署，线上站点不变
# 自己用 serve.sh 本地预览
```

**场景 2：公开发布新文章（部署到线上）**
```bash
# 1. 先提交到 main
git add -A && git commit -m "发布: <标题>"
git push origin main
# 2. 打 tag 触发部署
git tag v1.1   # 版本号递增
git push origin v1.1
# 3. 监控部署
gh run list --repo ccjlovewsy/ccjlovewsy.github.io --limit 1
```

**场景 3：把多篇文章一起部署**
```bash
# 多次 main 提交都先存着不部署，等积累够了打一次 tag
git push origin main
# ...继续写...
git push origin main
# 准备发布了
git tag v1.2 && git push origin v1.2
```

### Tag 版本号约定

- `v1.0`、`v1.1`、`v1.2` ... 递增即可
- 查看已有 tag：`git tag -l`
- 删除打错的 tag：`git tag -d v1.0 && git push origin :refs/tags/v1.0`
