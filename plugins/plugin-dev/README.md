# Plugin Development Tools

協助開發和測試 Claude Code Plugin 的工具集，提供快速修正和優化 plugin 的功能。

## Skills 清單

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