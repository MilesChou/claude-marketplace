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
└── {plugin-name}/          # Plugin 名稱（kebab-case）
    ├── README.md           # Plugin 說明文件
    ├── agents/             # Agents 目錄
    │   └── {agent-name}.md # Agent 定義檔
    ├── commands/           # Commands 目錄
    │   └── {name}.md       # Command 定義檔
    └── skills/             # Skills 目錄
        └── {skill-name}/   # Skill 名稱（kebab-case）
            └── SKILL.md    # Skill 定義檔（必須）
```

當完成 Plugin 更新，需要同步更新 README.md 文件
