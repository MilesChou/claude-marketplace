# Claude Code Skills 官方定義與參考

本文件整理 Claude Code Skills 的官方定義、特性和最佳實踐，並說明與本 marketplace 專案的對應關係。

## 官方定義

### 什麼是 Skills？

根據 Anthropic 官方文件，**Skills** 是：

> **模組化的能力擴展**，透過組織化的資料夾結構來擴展 Claude 的功能。每個 skill 是一個包含指令、腳本和資源的獨立單元。

Skills 在 2025 年 10 月正式發布，適用於：
- Claude.ai（Pro、Max、Team、Enterprise 方案）
- Claude Code（Beta）
- Claude API（使用 code execution tool）

## 核心特性

### 1. 模組化設計

每個 skill 是一個獨立的資料夾，包含：
- **指令檔案**（如 SKILL.md）：定義工作流程和行為
- **腳本**（可選）：可執行的程式碼
- **範本**（可選）：可重複使用的檔案範本
- **資源**（可選）：其他輔助檔案

**優勢**：
- 邏輯集中管理
- 易於測試和維護
- 可以獨立版本控制

### 2. 跨平台通用

Skills 使用統一的格式，**設計一次，到處使用**：

```
同一個 skill 可以在以下環境中使用：
┌─────────────────────────────────────┐
│ Claude.ai (網頁版)                   │
│ Claude Code (開發工具)               │
│ Claude API (程式整合)                │
└─────────────────────────────────────┘
         ▲
         │
    同一套 skill 定義
```

**本專案的實作**：
- Plugins 遵循官方格式
- 可以輕鬆在不同環境間移植
- 統一的 YAML Front Matter 格式

### 3. 動態載入

Claude 會在相關時**自動發現和載入** skills：
- 根據任務需求自動選擇合適的 skill
- 使用者不需要手動指定
- 也支援明確呼叫特定 skill

**載入方式**：
- **自動**：Claude 偵測到相關任務時自動載入
- **手動**：使用 `/skill-name` 明確呼叫
- **引用**：在 commands、agents 中引用其他 skills

### 4. 統一的安裝方式

**Claude Code 中的安裝**：

```bash
# 方式 1：透過 plugin 安裝（推薦）
# 從 marketplace 安裝，自動載入

# 方式 2：手動安裝
# 將 skill 資料夾複製到 ~/.claude/skills/
```

**本專案的做法**：
- Skills 包含在 plugins 中
- 使用者安裝 plugin 時自動獲得相關 skills
- 遵循官方的資料夾結構

## 官方最佳實踐

### 1. Planning First Approach

**官方建議**：
> 要求 Claude 在編碼前先制定計畫，並明確告知在確認計畫前不要開始編碼。

**應用到 Skills 設計**：
- Skills 應該包含明確的執行步驟
- 複雜的 skills 應該先規劃再執行
- 使用 TodoWrite 追蹤任務進度

### 2. Extended Thinking Mode

**官方建議**：
> 使用「think」、「think hard」、「think harder」、「ultrathink」觸發更深入的思考。

**應用到 Skills 設計**：
- 複雜決策的 skills 應該引導 Claude 深入思考
- 在 skill 中可以加入「仔細思考」的提示

### 3. Custom Commands Integration

**官方建議**：
> 將重複的工作流程儲存為 Markdown 檔案在 `.claude/commands` 資料夾。

**本專案的整合**：
- Commands 可以引用 Skills
- Skills 提供可重複使用的邏輯
- Commands 提供使用者友善的入口點

### 4. Skills as Reusable Workflows

**官方強調**：
> Skills 是可重複使用的工作流程，應該在多處使用相同邏輯時才抽取。

**本專案的實踐**：
- 遵循 YAGNI 原則（詳見 `SKILL.md`）
- 使用判斷標準決定是否獨立成 skill
- 提供決策樹輔助判斷

## 與本專案的對應

### 目錄結構對應

**官方標準結構**：
```
{skill-name}/
├── SKILL.md          # 或其他 .md 檔案
├── scripts/          # 可選
└── resources/        # 可選
```

**本專案的結構**：
```
plugins/{plugin-name}/skills/{skill-name}/
├── SKILL.md          # 必須
├── scripts/          # 可選
├── templates/        # 可選（擴充）
└── resources/        # 可選
```

**差異說明**：
- 本專案將 skills 組織在 plugins 下
- 新增 `templates/` 資料夾用於存放範本
- 其他遵循官方標準

### YAML Front Matter 對應

**官方格式**：
```yaml
---
name: Skill Name
description: Brief description
---
```

**本專案格式**（完全相同）：
```yaml
---
name: Skill-Name              # PascalCase 或 kebab-case
description: 簡短描述         # 一句話說明核心功能
---
```

### 命名規範對應

**官方建議**：
- 使用描述性名稱
- 反映 skill 的功能

**本專案規範**：
- 資料夾名稱：`kebab-case`（如 `skills-development`）
- YAML name 欄位：`PascalCase` 或 `kebab-case`（如 `Skills-Development`）
- 描述性、動詞開頭（如 `analyze-atomicity`）

詳細命名規範請參閱 [`implementation.md`](implementation.md)。

## 官方資源連結

### 文件

- **Claude Code Skills 文件**：https://docs.claude.com/en/docs/claude-code/skills
- **Skills 公告**：https://www.anthropic.com/news/skills
- **Agent Skills 工程部落格**：https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- **Claude Code 最佳實踐**：https://www.anthropic.com/engineering/claude-code-best-practices

### 官方 Skills Repository

- **GitHub**：https://github.com/anthropics/skills
- 官方維護的 skills 範例
- 可以參考學習和貢獻

### 支援文件

- **什麼是 Skills？**：https://support.claude.com/en/articles/12512176-what-are-skills
- **在 Claude 中使用 Skills**：https://support.claude.com/en/articles/12512180-using-skills-in-claude

## 與其他文件的關聯

本專案的 Skills Development 文件系列：

1. **[SKILL.md](SKILL.md)**：主文件，包含核心判斷標準和設計原則
2. **[official-reference.md](official-reference.md)**（本文件）：官方定義和參考
3. **[examples.md](examples.md)**：實際案例分析
4. **[implementation.md](implementation.md)**：實施指南和命名規範
5. **[best-practices.md](best-practices.md)**：最佳實踐和常見錯誤

建議閱讀順序：
1. 先閱讀 `SKILL.md` 了解核心概念
2. 參考本文件了解官方定義
3. 查看 `examples.md` 學習實際案例
4. 使用 `implementation.md` 進行實作
5. 遵循 `best-practices.md` 避免常見錯誤

## 總結

Claude Code Skills 是 Anthropic 官方提供的強大功能，讓開發者能夠：
- **擴展 Claude 的能力**：透過模組化的方式
- **重複使用工作流程**：在多個地方使用相同邏輯
- **跨平台通用**：一次設計，到處使用
- **動態載入**：自動發現和載入相關 skills

本 marketplace 專案遵循官方規範，並加入了適合團隊協作的最佳實踐，幫助開發者更有效地設計和管理 skills。

---

**最後更新**：2025-10-19
**官方 Skills 版本**：2025 年 10 月發布版本
