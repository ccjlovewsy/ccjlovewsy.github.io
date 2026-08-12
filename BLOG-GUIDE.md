# ccjlovewsy.github.io 博客运维手册

> 本文档记录从环境配置到日常管理的完整流程。环境已一次性配好，日常只需关注「日常使用」章节。

## 环境清单

| 组件 | 版本 | 路径 |
|------|------|------|
| Ruby | 3.4.10 | `/opt/homebrew/opt/ruby@3.4/bin/ruby` |
| Gem | 4.0.15 | `/opt/homebrew/opt/ruby@3.4/bin/gem` |
| Bundler | 4.0.18 | `/opt/homebrew/opt/ruby@3.4/bin/bundle` |
| gh CLI | 2.96.0 | `/opt/homebrew/bin/gh` |
| git | 2.49.0 | `/usr/bin/git`（被 `/Users/issuser/.git-ai/bin/git` 优先） |
| Jekyll 主题 | Chirpy 7.6.0 | 通过 gem `jekyll-theme-chirpy` |

**仓库目录**：`~/ccjlovewsy.github.io`
**站点地址**：https://ccjlovewsy.github.io/

> ⚠️ 注意：Chirpy 7.6.0 要求 Ruby `~> 3.1`，**不能用系统自带 Ruby 2.6 或 Ruby 4.x**。必须用 `ruby@3.4`。所有 Ruby/bundle 命令前都要加：
> ```bash
> export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
> ```

## 关键网络配置（GitHub 直连被墙的解决方案）

本地网络环境下：
- HTTPS 443 到 github.com **被墙**
- SSH 22 端口 **被墙**
- `ssh.github.com:443` **可达**（走 HTTPS 端口的 SSH 通道）

已在 `~/.ssh/config` 配好，让所有 `git@github.com:...` 操作自动走 443 通道：

```sshconfig
Host github.com
  HostName ssh.github.com
  Port 443
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 15
  ServerAliveCountMax 4
  IPQoS none
```

- SSH key：`~/.ssh/id_ed25519`（已绑定 GitHub 账号 ccjlovewsy）
- 远程地址：`git@github.com:ccjlovewsy/ccjlovewsy.github.io.git`（SSH 协议，不用 HTTPS）
- 验证连通：`ssh -T git@github.com` 应返回 `Hi ccjlovewsy!`

## gh CLI 登录

已用 device-code 流程登录账号 `ccjlovewsy`，token 存于 macOS keyring。

- 检查状态：`gh auth status`
- 重新登录（如失效）：`gh auth login`，选 GitHub.com → SSH → Login with a web browser → 输入一次性码
- 退出：`gh auth logout`

token scopes：`gist, read:org, repo`。

## 仓库与 Pages 配置

- 仓库：`ccjlovewsy/ccjlovewsy.github.io`（**必须 PUBLIC**，免费账号的 `<username>.github.io` 私有仓库无法启用 Pages）
- 默认分支：`main`
- Pages source：**GitHub Actions**（不是 Deploy from a branch）。配置在 仓库 Settings → Pages → Build and deployment → Source
- 部署工作流：`.github/workflows/pages-deploy.yml`（Chirpy 自带）
- HTTPS 强制：已开启

```bash
# 查 Pages 配置
gh api repos/ccjlovewsy/ccjlovewsy.github.io/pages

# 查仓库可见性（必须是 PUBLIC）
gh repo view ccjlovewsy/ccjlovewsy.github.io --json visibility,isPrivate

# 改回 public（若误设为私有导致 Pages 失效）
gh repo edit ccjlovewsy/ccjlovewsy.github.io --visibility public --accept-visibility-change-consequences

# 重新启用 Pages（若被禁用）
gh api repos/ccjlovewsy/ccjlovewsy.github.io/pages -X POST -f build_type=workflow
```

## 目录结构

```
~/ccjlovewsy.github.io/
├── _config.yml           # 站点配置（标题、URL、社交链接等）
├── _posts/               # ← 文章放这里，文件名 YYYY-MM-DD-标题-slug.md
├── _drafts/              # 草稿（本地预览用，不发布）
├── _tabs/                # 关于页、归档页等页面
├── _data/                # 主题数据
├── _plugins/             # 主题插件
├── assets/               # 静态资源（图片等）
├── .github/workflows/
│   └── pages-deploy.yml  # 自动部署工作流
├── serve.sh              # 本地预览脚本（已配好 Ruby PATH）
├── Gemfile               # Ruby 依赖
├── Gemfile.lock
└── index.html
```

## 日常使用

### 本地预览

```bash
~/ccjlovewsy.github.io/serve.sh
# 访问 http://127.0.0.1:4000
# 按 Ctrl+C 停止
```

`serve.sh` 内容（已自动注入 Ruby 3.4 的 PATH）：
```bash
#!/usr/bin/env bash
export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
cd "$(dirname "$0")"
exec bundle exec jekyll serve
```

### 写文章

1. 在 `_posts/` 新建文件，命名格式 **必须**：`YYYY-MM-DD-英文-slug.md`
   - 例：`2026-08-12-kotlin-native-compile-pipeline.md`
   - 日期是发布日期，slug 用英文/连字符（生成 URL `https://ccjlovewsy.github.io/posts/<slug>/`）

2. 文件头 **必须** front matter：
   ```markdown
   ---
   title: 文章标题
   date: 2026-08-12 16:28:00 +0800
   categories: [分类1]
   tags: [标签1, 标签2]
   ---

   正文从这里开始...
   ```

3. 正文 **不要** 再写 H1（`# 标题`），Chirpy 用 front matter 的 `title` 自动渲染 H1，写两遍会重复。

4. 草稿放 `_drafts/`，本地预览加参数：`bundle exec jekyll serve --drafts`

### 发布流程（标准三步）

```bash
cd ~/ccjlovewsy.github.io

# 1. 本地构建验证（可选但推荐，避免构建失败导致 Actions 红叉）
export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
bundle exec jekyll build    # 无报错即可

# 2. 提交推送
git add -A
git commit -m "发布: 文章标题"
git push origin main        # push 后自动触发 GitHub Actions 部署

# 3. 监控部署（约 1~2 分钟）
export PATH="/opt/homebrew/bin:$PATH"
gh run watch                # 看实时日志
# 或只看状态：
gh run list --limit 1
```

部署 `success` 后，等几秒访问 https://ccjlovewsy.github.io/

### 常用 gh 命令

```bash
# 看最近 5 次构建
gh run list --repo ccjlovewsy/ccjlovewsy.github.io --limit 5

# 手动触发一次部署（不改代码也能重跑）
gh workflow run pages-deploy.yml --repo ccjlovewsy/ccjlovewsy.github.io --ref main

# 看某次构建详情
gh run view <run-id> --repo ccjlovewsy/ccjlovewsy.github.io

# 看构建日志（排错用）
gh run view <run-id> --repo ccjlovewsy/ccjlovewsy.github.io --log

# 看最近提交
gh api repos/ccjlovewsy/ccjlovewsy.github.io/commits --jq '.[0:5][] | "\(.commit.author.date | split("T")[0])  \(.commit.message | split("\n")[0])"'

# 看仓库访问量
gh api repos/ccjlovewsy/ccjlovewsy.github.io/traffic/views
```

## 排错速查

| 现象 | 原因 | 解决 |
|------|------|------|
| `git push` 卡住超时 | 网络墙 | 确认 `~/.ssh/config` 走 `ssh.github.com:443`，`ssh -T git@github.com` 验证 |
| Pages 设置页看不到 Source 选项 | 仓库是 Private | `gh repo edit ... --visibility public ...` |
| Actions 失败，提示 Ruby 版本 | 用了系统 Ruby 2.6 | 所有命令前加 `export PATH="...ruby@3.4/bin..."` |
| Actions 失败，`index-pack failed` | 浅克隆 `--depth=1` 历史 push | 删 `.git` 重新 `git init` 再提交（一次性问题，已修复） |
| 本地 `jekyll serve` 报 command not found | PATH 未配 | 用 `serve.sh`，或手动 `export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"` |
| 推送后站点没更新 | Actions 在跑或失败 | `gh run list --limit 1` 看状态，失败用 `gh run view --log` 看日志 |

## 一次性环境安装命令（仅参考，已执行过）

如果换机器或重装系统，按下面从头执行：

```bash
# 1. 安装 Homebrew（已有则跳过）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 安装 Ruby 3.4（不要用 4.x，Chirpy 不兼容）
brew install ruby@3.4

# 3. 安装 gh CLI
brew install gh

# 4. 配置 PATH（写进 ~/.zshrc 或 ~/.bash_profile）
echo 'export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 5. 安装 bundler
gem install bundler

# 6. 配置 SSH 走 443 通道（绕过墙）
# 写入 ~/.ssh/config，内容见上方「关键网络配置」段

# 7. gh 登录（device-code 流程）
gh auth login
# 选 GitHub.com → SSH → Login with a web browser → 浏览器输入一次性码

# 8. 克隆 Chirpy 模板（首次搭建才需要）
git clone --depth=1 https://github.com/cotes2020/chirpy-starter.git ccjlovewsy.github.io
cd ccjlovewsy.github.io

# 9. 改 origin 为自己的仓库
git remote set-url origin git@github.com:ccjlovewsy/ccjlovewsy.github.io.git

# 10. 改 _config.yml（url、github.username、social 等）

# 11. 安装 Ruby 依赖
bundle install

# 12. 浅克隆处理：重置 git 历史避免 push 时 index-pack 失败
rm -rf .git && git init -b main
git remote add origin git@github.com:ccjlovewsy/ccjlovewsy.github.io.git
git add -A && git commit -m "init blog"

# 13. GitHub 建空仓库 ccjlovewsy.github.io（必须 PUBLIC）
gh repo create ccjlovewsy/ccjlovewsy.github.io --public
# 或网页建：https://github.com/new，名字严格用 ccjlovewsy.github.io，不勾任何初始化

# 14. 推送
git push -u origin main

# 15. 启用 Pages（GitHub Actions 模式）
gh api repos/ccjlovewsy/ccjlovewsy.github.io/pages -X POST -f build_type=workflow

# 16. 等几分钟访问 https://ccjlovewsy.github.io/
```

## 给 opencode 的备忘

- 这个仓库的 AGENTS.md 或本文件就是 opencode 操作此博客的入口文档
- 任何对 `_posts/` 的改动，都要先 `bundle exec jekyll build` 验证再 push
- push 后用 `gh run watch` 或 `gh run list --limit 1` 确认部署 success
- Ruby 命令永远加 `export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"`
- gh 命令加 `export PATH="/opt/homebrew/bin:$PATH"`
- 文章 front matter 必填：title / date / categories / tags
- 用户给的原 .md 可能缺 front matter、文件名不符规范、正文有 H1，需要适配后再放到 `_posts/`，**原文件不要改**
