# Changelog - Plugin Dev Plugin

All notable changes to this plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- 新增 `/plugin-dev:create-skill` Command
  - 從構思到實作的完整 Skill 建立流程
  - 自動套用 skills-development 的判斷標準評估
  - 互動式設計流程（命名、輸入輸出、執行步驟）
  - 自動產生符合規範的 SKILL.md 檔案
  - 自動更新 README.md 和 CHANGELOG.md
  - 提供品質檢查清單和後續建議
  - 支援特殊情況處理（plugin 不存在、skill 已存在等）
  - 當不適合建立 Skill 時，提供 Command/Agent 的替代建議
- 新增 `plugin-dev:skills-development` Skill
  - 提供 Skill 設計的核心概念和判斷標準
  - 說明何時需要／不需要獨立成 Skill
  - 包含 YAGNI、DRY、單一職責等設計原則
  - 提供實際案例分析（Git 原子性判斷、Commit 訊息產生、檔案變更分類）
  - 包含 mermaid 決策樹流程圖，幫助快速判斷
  - 列出常見錯誤與最佳實踐
  - 提供完整的執行步驟和實施計畫

## [0.1.0] - 2025-10-19

### Added

- 初始版本發布
- 新增 `plugin-dev:quick-fix` Skill
  - 在測試 plugin 過程中快速修正功能
  - 快速識別當前測試的 plugin 和相關檔案
  - 根據使用者回饋定位需要修改的 md 檔案
  - 立即進行修正並驗證
  - 提供修改前後的對比說明
  - 支援修改 Agent、Command 或 Skill 的定義檔
- 提供完整的使用場景和範例說明
- 協助快速迭代改善 plugin 品質
