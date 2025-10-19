# Changelog - Git Plugin

All notable changes to this plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.0.0] - 2025-10-19

### Added

- 初始版本發布
- 新增 `/git:commit-push` 指令
  - 自動分析工作目錄變更狀態
  - 判斷變更是否符合提交原子性
  - 支援分類選擇要提交的檔案
  - 產生符合 Conventional Commits 規範的提交訊息
  - 支援選擇目標推送分支
- 新增 `/git:commit-push-all` 指令
  - 快速提交所有變更
  - 產生綜合所有變更的提交訊息
  - 支援選擇目標推送分支
- 新增 `git:resolving-conflict` Skill
  - 系統化的 Git 衝突解決流程
  - 提供逐步解決衝突的指引
  - 支援 rebase 和 merge 場景
- 提供完整的使用建議和情境說明文件
