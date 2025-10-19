# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案概述

這是一個 Claude Code Plugin Marketplace，提供各種 Claude Code 的 Plugins、Agents、Commands 和 Skills，讓使用者可以擴充 Claude Code 的功能。

## 核心概念

### 四層架構

專案採用四層架構來組織功能：

1. **Plugin**：功能集合的最上層容器，一個 plugin 可以包含多個 agents、commands 和 skills
2. **Agent**：專門的 AI 代理，定義在 `agents/` 目錄中，用於處理特定任務
3. **Command**：可直接呼叫的 slash command，定義在 `.md` 檔案中，使用者可透過 `/plugin:command-name` 呼叫
4. **Skill**：可重複使用的工作流程，定義在 `SKILL.md` 檔案中，透過 YAML Front Matter 定義名稱和描述

## 目錄結構

```
plugins/
└── {plugin-name}/              # Plugin 名稱（kebab-case）
    ├── .claude-plugin/         # Plugin 元資料目錄（必須）
    │   └── plugin.json         # Plugin 配置檔（必須，包含版本號）
    ├── README.md               # Plugin 說明文件（必須）
    ├── CHANGELOG.md            # 版本變更記錄（必須）
    ├── agents/                 # Agents 目錄（選用）
    │   └── {agent-name}.md     # Agent 定義檔
    ├── commands/               # Commands 目錄（選用）
    │   └── {name}.md           # Command 定義檔
    └── skills/                 # Skills 目錄（選用）
        └── {skill-name}/       # Skill 名稱（kebab-case）
            └── SKILL.md        # Skill 定義檔（必須）
```

### 必要檔案說明

- **`.claude-plugin/plugin.json`**：定義 Plugin 的基本資訊和版本號
- **`README.md`**：Plugin 的完整說明文件，包含功能介紹、使用方式、範例等
- **`CHANGELOG.md`**：記錄每個版本的變更內容

**重要提醒**：當完成 Plugin 更新時，需要同步更新以下檔案：
- `README.md`：功能說明文件
- `CHANGELOG.md`：版本變更記錄
- `.claude-plugin/plugin.json`：版本號（發布新版本時）

## 版本管理規範

### 版本號格式

遵循 [Semantic Versioning 2.0.0](https://semver.org/)：

```
主版本號.次版本號.修訂號 (MAJOR.MINOR.PATCH)
```

- **MAJOR**：不相容的 API 變更
- **MINOR**：向下相容的功能新增
- **PATCH**：向下相容的問題修正

### 版本號位置

每個 Plugin 都必須在以下位置維護版本號：

1. **plugin.json**：`plugins/{plugin-name}/.claude-plugin/plugin.json`
   ```json
   {
     "name": "plugin-name",
     "description": "Plugin description",
     "version": "1.0.0",
     "author": {
       "name": "Author Name"
     }
   }
   ```

2. **CHANGELOG.md**：`plugins/{plugin-name}/CHANGELOG.md`
   - 記錄每個版本的變更內容

**重要**：發布新版本時，必須同步更新這兩個檔案的版本號

### CHANGELOG 結構

每個 plugin 和專案本身都應維護 CHANGELOG.md 檔案：

```
plugins/
├── {plugin-name}/
│   ├── CHANGELOG.md        # Plugin 的變更記錄
│   └── README.md           # 需包含 CHANGELOG 連結
└── ...
CHANGELOG.md                 # 專案整體的變更記錄
README.md                    # 需包含 CHANGELOG 連結
```

### CHANGELOG.md 格式

遵循 [Keep a Changelog](https://keepachangelog.com/) 規範：

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- 新增的功能

### Changed
- 變更的功能

### Deprecated
- 即將棄用的功能

### Removed
- 移除的功能

### Fixed
- 修正的問題

### Security
- 安全性更新

## [1.0.0] - YYYY-MM-DD

### Added
- 初始版本功能
```

### 變更類型說明

- **Added**：新增的功能
- **Changed**：現有功能的變更
- **Deprecated**：即將在未來版本移除的功能
- **Removed**：已移除的功能
- **Fixed**：錯誤修正
- **Security**：安全性相關的修正

### 更新 CHANGELOG 流程

1. **開發期間**：在 `[Unreleased]` 區段記錄變更
2. **發布版本前**：
   - 將 `[Unreleased]` 內容移至新版本區段
   - 加上版本號和發布日期
   - 同步更新 `.claude-plugin/plugin.json` 中的 version 欄位
   - 更新版本比較連結（如果使用 Git tags）
3. **更新 README**：確保 README.md 包含 CHANGELOG 連結
4. **提交變更**：使用有意義的提交訊息，如 `chore: release version X.Y.Z`
5. **標記版本**（建議）：使用 Git tag 標記發布版本
   ```bash
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin vX.Y.Z
   ```

### README.md 中的 CHANGELOG 連結

#### Plugin README.md 格式

在 Plugin README.md 的末尾加入：

```markdown
## 版本記錄

請參閱 [CHANGELOG.md](./CHANGELOG.md) 查看詳細的版本變更記錄。

## 作者

[作者資訊]
```

#### 專案 README.md 格式

在專案根目錄 README.md 的適當位置加入：

```markdown
## 版本記錄

請參閱 [CHANGELOG.md](./CHANGELOG.md) 查看專案的版本變更記錄。
```

### 自動化建議

- 使用 `/git:commit-push` 或 `/git:commit-push-all` 提交時，根據 Conventional Commits 類型自動更新 CHANGELOG
- 可搭配 CI/CD 工具自動驗證 CHANGELOG 格式
- 建議使用 Git tags 標記每個版本發布

**版本發布檢查清單**：
- [ ] 更新 `CHANGELOG.md` 的 `[Unreleased]` 內容到新版本區段
- [ ] 更新 `.claude-plugin/plugin.json` 的 `version` 欄位
- [ ] 確認 `README.md` 包含 CHANGELOG 連結
- [ ] 提交變更並加上適當的提交訊息
- [ ] 建立 Git tag 標記版本（建議）
