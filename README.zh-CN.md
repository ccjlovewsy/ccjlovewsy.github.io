[English](README.md) | 简体中文

# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem]&nbsp;
[![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

一个极简、开箱即用的博客模板，基于 [**Chirpy**][chirpy] Jekyll 主题。所有关键文件均已预配置，几分钟即可上线。

## 为什么需要这个 Starter

通过 [RubyGems.org][gem] 安装 Chirpy 时，Jekyll 只能读取 gem 内的部分主题文件（`_data`、`_layouts`、`_includes`、`_sass`、`assets`）和有限的 `_config.yml` 选项，因此用户无法享受 Chirpy 完整的开箱即用体验。

要解锁全部功能，你的 Jekyll 站点中必须存在以下文件：

```shell
.
├── _config.yml
├── _plugins
├── _tabs
└── index.html
```

本 Starter 打包了最新 **Chirpy** 版本中的这些文件，并附带一套 [CD][CD] 工作流，让你立即开始写作。

## 使用

参考[主题文档](https://github.com/cotes2020/jekyll-theme-chirpy/wiki)。

## 参与贡献

本仓库会随主题仓库的新版本自动更新。如遇问题或想参与改进，请访问[主题仓库][chirpy]反馈。

## 许可

基于 [MIT][mit] 许可发布。

[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[CD]: https://en.wikipedia.org/wiki/Continuous_deployment
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE