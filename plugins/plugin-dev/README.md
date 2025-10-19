# Plugin Development Tools

協助開發和測試 Claude Code Plugin 的工具集，提供快速修正和優化 plugin 的功能。

## Commands 清單

### `/plugin-dev:create-skill [技能描述]`

從構思到實作，協助你建立一個符合最佳實踐的 Claude Code Skill。

**功能特點：**

- 收集需求並套用 skills-development 的判斷標準
- 自動評估是否適合建立為 Skill（或建議使用 Command/Agent）
- 互動式設計流程，確認名稱、輸入輸出、執行步驟
- 自動產生符合規範的 SKILL.md 檔案
- 自動更新 README.md 和 CHANGELOG.md
- 提供完整的品質檢查和後續建議

**使用方式：**

```bash
# 直接提供技能描述
/plugin-dev:create-skill 分析 Git 提交的原子性

# 或先呼叫，再輸入描述
/plugin-dev:create-skill
```

**執行流程：**

1. 收集需求（功能描述、所屬 plugin、使用場景）
2. 套用設計原則評估（YAGNI、DRY、單一職責）
3. 設計 Skill 結構（命名、輸入輸出、執行步驟）
4. 確認設計並產生檔案
5. 更新相關文件（README.md、CHANGELOG.md）
6. 提供測試和後續建議

## Skills 清單

### `plugin-dev:skills-development`

協助設計和開發 Claude Code Skills 的指南，提供清晰的判斷標準、設計原則和實際案例分析。

**功能特點：**

- 提供 Skill 設計的核心概念和判斷標準
- 說明何時需要／不需要獨立成 Skill
- 包含 YAGNI、DRY、單一職責等設計原則
- 提供實際案例分析（Git 原子性判斷、Commit 訊息產生等）
- 包含決策樹（mermaid 流程圖）快速判斷
- 列出常見錯誤與最佳實踐

**適用場景：**

- 評估某個功能是否應該獨立成 Skill
- 學習 Skill 設計的思考邏輯
- 避免過度工程化或重複程式碼
- 制定 Skill 重構計畫

**使用方式：**

當你需要判斷某個功能是否應該獨立成 Skill 時，可以參考這個 skill 的指南：
1. 使用檢查清單評估條件
2. 套用設計原則（YAGNI、DRY）
3. 參考實際案例分析
4. 使用決策樹快速判斷

### `plugin-dev:quick-fix`

在測試 plugin 過程中快速修正的技能，當發現問題或需要改善時，立即調整對應的 md 檔案。

**功能特點：**

- 快速識別當前測試的 plugin 和相關檔案
- 根據使用者回饋定位需要修改的 md 檔案
- 立即進行修正並驗證
- 提供修改前後的對比說明
- 支援修改 agent 的 .md、command 的 .md 或 SKILL.md

**適用場景：**

- 測試 Agent 時發現提示詞需要調整
- 測試 Command 時發現說明不清楚
- 測試 Skill 時發現工作流程需要優化
- 需要快速迭代改善 plugin 的品質

**使用方式：**

當你在測試 plugin 時，直接提出需要改善的觀點，skill 會自動：
1. 識別正在測試的 plugin 和檔案
2. 讀取當前的檔案內容
3. 根據你的意見進行修改
4. 說明修改內容並確認

**範例：**

```
[正在測試 git:resolving-conflict skill]

User: 我發現步驟 3 的說明不夠清楚，應該要先執行 git status。
Assistant: [定位到 git plugin 的 resolving-conflict skill]
         好的，我來更新步驟 3 的說明，加入 git status 指令。
         [使用 Edit 工具修改 SKILL.md]
```

## 安裝方式

將此 Plugin 加入你的 Claude Code 配置：

```json
{
  "plugins": {
    "plugin-dev": {
      "source": "marketplace:plugin-dev@mileschou-marketplace"
    }
  }
}
```

## 版本記錄

請參閱 [CHANGELOG.md](./CHANGELOG.md) 查看詳細的版本變更記錄。
