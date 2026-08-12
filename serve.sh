#!/usr/bin/env bash
# 启动本地 Jekyll 预览服务
# 用法: ./serve.sh  然后访问 http://127.0.0.1:4000
export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
cd "$(dirname "$0")"
exec bundle exec jekyll serve
