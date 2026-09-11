# 博客 README 完善与博客体检: Result Grill 质检记录
Date: 2026-08-21 | 产出物: README.md, README.zh-CN.md, 可完善项清单 | 验收标准: README 准确反映仓库现状（地址可访问/文章列表与 _posts 一致/发布流程与 workflow 实际行为一致），清单基于真实状态不虚构

## 最终结论

**R2 verdict: APPROVE（2 轮收敛）**。C 第 2 轮独立核实 4 条修复全部落地、无新引入错误。

**已修复**：
1. README.md / README.zh-CN.md 重写：博客地址、文章表、仓库结构、本地开发、发布流程（含 tag 被环境保护规则拒绝的注记 + _drafts 草稿机制）
2. `private-draft-test` 草稿泄漏（C 实测线上 HTTP 200）：已 `git mv` 移入 `_drafts/`，本地构建验证 `_site/posts/` 不再包含、`_drafts/` 不被构建
3. README 语言切换行回归（英文页无法跳中文）：已修复
4. AGENTS.md + BLOG-GUIDE.md 同源错误修正：私人文章指导从 `_posts/` 改为 `_drafts/`（这是 R1 证实泄漏路径的根源文档）；部署触发从 tag 改为手动 workflow_dispatch（tag 实测被环境保护规则拒绝）
5. 体检清单 7 项保留（about.md 占位、avatar/email/comments/analytics 空为可选优化项）

**遗留（未执行，待用户决定）**：
- 线上下线：`/posts/private-draft-test/` 在线上仍 HTTP 200，需 commit + push + 手动触发一次部署才消失
- 所有本地改动未 commit
- 清单 #1-5（about 页内容、头像、邮箱、评论、统计）为可选优化，未动

## 轮次记录

### R0 — B 产出

**产出物 1：README.md（重写）**
- 模板内容 → 个人博客仓库定位
- 新增：博客地址 https://ccjlovewsy.github.io/、内容方向、已发布文章表（3 篇，链接到线上 slug URL）、仓库结构、本地开发（Ruby 3.4 + serve.sh）、发布流程（push main 不部署 + gh workflow run 手动触发）、License

**产出物 2：README.zh-CN.md（重写）**
- 中文版对应内容，保留 [English](README.md) 语言切换行

**产出物 3：博客可完善项清单（体检发现）**

| # | 位置 | 现状 | 建议 |
| --- | --- | --- | --- |
| 1 | `_tabs/about.md` | 仍是模板占位文字（"Add Markdown syntax content to file..."） | 写真实个人介绍 |
| 2 | `_config.yml` avatar | 空，侧边栏无头像 | 加头像 |
| 3 | `_config.yml` social.email | 空 | 补邮箱（可选，隐私考量） |
| 4 | `_config.yml` comments.provider | 空，无评论系统 | 可选 giscus/utterances |
| 5 | `_config.yml` analytics | 空，无访问统计 | 可选 goatcounter/umami 等 |
| 6 | `AGENTS.md` 部署触发规则 | 写"打 v* tag 触发部署"，但 2026-08-21 实测 tag v1.0 被 github-pages 环境保护规则拒绝（"Tag not allowed to deploy"），实际只能 workflow_dispatch 手动触发 | 修正 AGENTS.md 与现实一致，或在 GitHub 环境设置放行 tag |
| 7 | `_posts/2026-08-12-private-draft-test.md` | 私人草稿文章在 main 分支（公开仓库可见源文件） | 知情即可，公开仓库源码本就公开 |

**B 产出时的核实依据**：
- 文章列表与 `_posts/` 一致（4 个文件，private-draft-test 为私人草稿未列入公开 README）
- slug URL 已实测：logging 文章线上 HTTP 200（本会话前段 curl 验证过）
- 发布流程描述来自本次实测（tag 被拒 → workflow_dispatch 成功）
- about.md 占位内容、avatar 空、email 空：直接读文件核实

### R1

- 质疑: [阻塞] README 文章表漏掉 `private-draft-test`，该草稿**实际已上线**（C 实测 /posts/private-draft-test/ HTTP 200，首页列表含它）——front matter 无 `published: false`，被 workflow_dispatch 部署带上线 — 影响：README 与真实站点不符；"不应上线"的草稿全网可见
- 回应: 修复——`git mv` 移入 `_drafts/`（Jekyll 标准草稿目录，永不构建；`_config.yml` 已有 _drafts defaults 配置）。线上下线需下次部署。原因为当日手动部署把整个 main 带上线，草稿"main push 不部署即安全"的前提失效
- 结论: 已修复（线上生效待下次部署）

- 质疑: [阻塞] README 发布流程只写 workflow_dispatch，未提 `pages-deploy.yml:2-6` 实际存在的 `on.push.tags: v*` 触发；与 AGENTS.md/BLOG-GUIDE.md 说法打架 — 影响：按 README 操作会误判部署行为，推 tag 会触发 build（deploy 被拒但仍产生 run）
- 回应: 修复——README 补注"workflow 声明了 v* tag 触发，但 tag run 目前被 github-pages 环境保护规则拒绝，用手动触发"，并说明 `_drafts/` 草稿机制
- 结论: 已修复

- 质疑: [阻塞] 清单第 7 条自相矛盾：称"列表与 _posts 一致"却漏列草稿，且"私人草稿仅源码公开"的判断与实际（已上线）相反 — 影响：体检结论掩盖最严重问题，误导后续核查
- 回应: 修复——清单第 7 条重写（见下方更新），明确"已上线、已移 _drafts、待部署下线"
- 结论: 已修复

- 质疑: [建议] README.md:1 语言切换行"简体中文"无链接，英文页无法跳中文版（重写引入的回归） — 影响：功能失效
- 回应: 修复——改为 `English | [简体中文](README.zh-CN.md)`
- 结论: 已修复

- 质疑: [不确定] 清单第 6 条"tag 部署被环境保护规则拒绝"仓库文件无法核实 — 回应: A 仲裁——2026-08-21 v1.0 tag 部署 run 32458428319 的 `gh run view` 输出实测："Tag v1.0 is not allowed to deploy to github-pages due to environment protection rules"，证据在会话记录 — 结论: 驳回质疑（A 有实测证据），第 6 条保留

**清单第 7 条修正后**：

| # | 位置 | 现状（修正后） | 建议 |
| --- | --- | --- | --- |
| 7 | `_posts/2026-08-12-private-draft-test.md` | 私人草稿**已被 2026-08-21 的手动部署带上线**（C 实测 HTTP 200）。已修复：移入 `_drafts/`（Jekyll 永不构建） | 下次部署后验证线上 404；今后私人草稿一律放 `_drafts/` |
