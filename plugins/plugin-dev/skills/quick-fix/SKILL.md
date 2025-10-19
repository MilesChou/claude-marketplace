---
name: quick-fix
description: 當使用 test 開頭的 command、skill、agent 時，在執行過程中使用者提出改善建議，立即調整 .claude 目錄中對應的 md 檔案
---

# Plugin 快速修正

當使用 test 開頭的 command、skill、agent 進行測試時，若使用者提出改善建議，立即定位並調整 `.claude` 目錄中對應的 md 檔案。

## 核心功能

- 快速識別當前測試的 plugin 和相關檔案
- 根據使用者回饋定位需要修改的 md 檔案
- 立即進行修正並驗證
- 提供修改前後的對比說明

## 執行步驟

### 1. 確認測試中的 Plugin

當使用者在測試過程中提出改善觀點時：

1. **識別目標 Plugin**
   - 從對話脈絡中確認正在測試的 plugin 名稱
   - 如果不明確，使用 AskUserQuestion 詢問：
     - 正在測試哪個 plugin？
     - 是測試 agent、command 還是 skill？
     - 具體是哪個檔案？

2. **定位目標檔案**
   - Agent: `plugins/{plugin-name}/agents/{agent-name}.md`
   - Command: `plugins/{plugin-name}/commands/{command-name}.md`
   - Skill: `plugins/{plugin-name}/skills/{skill-name}/SKILL.md`

### 2. 讀取並分析當前內容

1. **使用 Read tool 讀取目標檔案**
   ```
   Read: plugins/{plugin-name}/{type}/{name}/檔案.md
   ```

2. **分析使用者的改善觀點**
   - 理解使用者反映的問題點
   - 確認需要修改的具體區塊
   - 思考最佳的修改方式

3. **確認修改範圍**
   - 如果使用者的意見很明確，直接進行修改
   - 如果需要澄清，使用 AskUserQuestion 確認：
     - 具體要修改哪個章節？
     - 要新增內容還是修改現有內容？
     - 修改的幅度如何？

### 3. 執行修改

1. **使用 Edit tool 進行修改**
   - 精確定位需要修改的區塊
   - 使用 old_string 和 new_string 進行替換
   - 保持檔案格式的一致性（YAML Front Matter、Markdown 格式）

2. **注意事項**
   - 保持 YAML Front Matter 的完整性
   - 維持原有的文件結構
   - 確保修改後的內容符合 Markdown 格式
   - 檔案結尾保留一個空行

3. **多處修改**
   - 如果需要修改多處，一次性處理
   - 保持修改的邏輯一致性

### 4. 驗證與確認

1. **重新讀取檔案**
   - 使用 Read tool 確認修改結果
   - 檢查是否有格式錯誤

2. **向使用者說明修改內容**
   - 清楚說明修改了哪些部分
   - 解釋修改的理由和預期效果
   - 提供修改前後的對比（如果必要）

3. **詢問是否需要繼續測試**
   - 確認使用者是否滿意修改
   - 是否需要再次測試功能
   - 是否還有其他需要調整的地方

## 使用場景

### 適用情境

1. **測試 Agent 時**
   - Agent 的提示詞不夠明確
   - Agent 的執行步驟需要調整
   - Agent 的範例需要更新

2. **測試 Command 時**
   - Command 的說明不清楚
   - Command 的參數說明需要補充
   - Command 的執行邏輯需要修正

3. **測試 Skill 時**
   - Skill 的工作流程需要優化
   - Skill 的注意事項需要補充
   - Skill 的範例需要修正

### 典型工作流程

```
[使用者正在測試某個 skill]

User: 我發現這個 skill 的步驟 3 說明不夠清楚，
      應該要先執行 git status 再決定要用哪個策略。

Agent: 我會立即修正這個 skill 的 SKILL.md 檔案。

[使用 Read tool 讀取當前的 SKILL.md]
[使用 Edit tool 修改步驟 3 的內容]

Agent: 已修改 plugins/git/skills/resolving-conflict/SKILL.md:42
       - 在步驟 3 開頭新增「先執行 git status 確認狀態」的說明
       - 補充不同狀態下的處理策略

       修改內容：
       原本：「對於每個衝突的檔案...」
       修改後：「先執行 git status 確認衝突狀態，再對於每個衝突的檔案...」

       你要繼續測試看看嗎？

User: 好的，再測試一次。

[繼續測試流程...]
```

## 特殊處理

### YAML Front Matter 修改

如果需要修改 YAML Front Matter（name 或 description）：

```yaml
---
name: 原始名稱
description: 原始描述
---
```

修改時要特別注意：
- 保持 `---` 分隔線的完整性
- name 使用 PascalCase 或 kebab-case
- description 簡潔明瞭，說明核心功能

### 大幅度重構

如果使用者的改善意見需要大幅度重構：

1. **使用 AskUserQuestion 確認範圍**
   - 列出需要調整的主要區塊
   - 確認是否需要重新組織結構
   - 是否影響其他相關檔案

2. **分步驟進行**
   - 先調整結構性的內容
   - 再補充細節說明
   - 最後更新範例

3. **保持溝通**
   - 每個大區塊修改後向使用者確認
   - 確保修改方向符合使用者期望

### 同時修改多個檔案

如果改善意見涉及多個檔案（例如 SKILL.md 和 README.md）：

1. **使用 TodoWrite 規劃任務**
   - 列出所有需要修改的檔案
   - 標示修改的優先順序

2. **按順序執行**
   - 先修改核心檔案（agent 的 .md、command 的 .md、SKILL.md 等）
   - 再更新文件檔案（README.md）

3. **整體確認**
   - 所有修改完成後，整體說明變更
   - 確保檔案間的一致性

## 注意事項

### 修改原則

- **快速響應**：立即處理使用者的改善意見，不要拖延
- **精確定位**：準確找到需要修改的區塊，避免影響其他內容
- **保持格式**：維持原有的檔案格式和結構
- **清楚溝通**：說明修改的內容和理由

### 常見錯誤

**避免：**
- 在不確定的情況下猜測使用者的意圖
- 修改過度，超出使用者的要求
- 破壞檔案的原有結構
- 修改後沒有向使用者確認

**推薦：**
- 不確定時使用 AskUserQuestion 確認
- 只修改使用者明確提出的部分
- 保持檔案結構的完整性
- 修改後清楚說明變更內容

### 品質檢查

修改完成後檢查：
- [ ] YAML Front Matter 格式正確
- [ ] Markdown 格式正確
- [ ] 檔案結尾有空行
- [ ] 內容邏輯清晰
- [ ] 符合使用者的改善意見

## 整合其他工具

- 如果修改涉及 README.md，確保與 plugin 的實際功能一致
