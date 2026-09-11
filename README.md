English | [简体中文](README.zh-CN.md)

# ccjlovewsy's Blog

A personal tech blog built with Jekyll and the [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) theme, hosted on GitHub Pages.

**Live site**: <https://ccjlovewsy.github.io/>

## What I Write About

- Source-code deep dives into the Kotlin/Native runtime (logging, GC, memory management)
- Interactive visualization pages that turn static notes into explorable "code movies"

## Posts

| Date | Post |
| --- | --- |
| 2026-08-21 | [Logging 源码精读 · 交互式可视化](https://ccjlovewsy.github.io/posts/logging-source-reading-interactive/) |
| 2026-08-12 | [编译一个 Kotlin/Native 程序，幕后发生了什么？](https://ccjlovewsy.github.io/posts/kotlin-native-compile-pipeline/) |
| 2026-08-12 | [你好，博客](https://ccjlovewsy.github.io/posts/hello-blog/) |

## Repository Layout

```shell
.
├── _posts/               # Posts, named YYYY-MM-DD-<slug>.md
├── _tabs/                # Navigation pages (about / archives / categories / tags)
├── assets/interactive/   # Self-contained interactive HTML pages
├── _config.yml           # Site configuration
├── BLOG-GUIDE.md         # Ops manual (build, deploy, troubleshooting)
└── AGENTS.md             # Instructions for AI coding agents (opencode)
```

## Local Development

Requires Ruby 3.4 (system Ruby 2.6 / Ruby 4.x won't work with Chirpy):

```shell
bundle install
bundle exec jekyll serve
# → http://127.0.0.1:4000
```

Or use the wrapper script: `./serve.sh`

## Publishing

Posts are Markdown files in `_posts/`. Pushing to `main` does **not** deploy by itself; the GitHub Actions workflow `pages-deploy.yml` deploys when manually triggered:

```shell
gh workflow run pages-deploy.yml --repo ccjlovewsy/ccjlovewsy.github.io --ref main
```

> The workflow also declares a `v*` tag trigger, but tag runs are currently rejected by the `github-pages` environment protection rules — use the manual trigger above. Drafts go in `_drafts/` (never built); anything in `_posts/` goes live on the next deploy.

Then watch it finish with `gh run list` and verify the post is live. Full details in [BLOG-GUIDE.md](BLOG-GUIDE.md).

## License

This work is published under [MIT][mit] License.

[mit]: https://github.com/ccjlovewsy/ccjlovewsy.github.io/blob/main/LICENSE
