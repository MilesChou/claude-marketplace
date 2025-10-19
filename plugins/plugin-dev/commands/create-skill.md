---
description: Create Skill
argument-hint: [技能描述]
allowed-tools: Read,Write,Edit,Bash(mkdir:*),AskUserQuestion
---

# 建立新的 Skill

協助你從構思到實作，建立一個符合最佳實踐的 Claude Code Skill。

## 參數說明

接收一個可選的技能描述參數：

```
/plugin-dev:create-skill [技能描述]
```

- 如果有提供描述，直接進入設計流程
- 如果沒有提供，先詢問使用者想要建立什麼 skill

## 執行流程

### 步驟 1：收集需求

#### 1-1. 取得技能描述

如果使用者沒有提供描述，使用 AskUserQuestion 詢問：

**問題**：你想建立什麼樣的 Skill？
- 請描述這個 skill 的主要功能
- 它會在什麼場景下使用？

#### 1-2. 收集基本資訊

詢問以下資訊（使用一次 AskUserQuestion 同時詢問）：

1. **所屬 Plugin**：這個 skill 屬於哪個 plugin？
   - 提供當前可用的 plugins 清單作為選項
   - 允許使用者輸入新的 plugin 名稱

2. **使用場景**：
   - 目前有哪些地方會使用這個 skill？
   - 預期未來會在哪些地方使用？

3. **邏輯複雜度**：
   - 大概需要幾個步驟？（簡單 3-5、中等 5-10、複雜 10+）

### 步驟 2：套用設計原則

**引用 `plugin-dev:skills-development` 的判斷標準**

根據收集到的資訊，評估是否符合 skill 的定位：

#### 檢查清單

```markdown
- [ ] 多處使用？（2+ 個地方）
- [ ] 邏輯複雜？（5+ 個步驟）
- [ ] 可獨立呼叫？（使用者可能單獨執行）
- [ ] 需要獨立維護？（邏輯會經常更新）
```

#### 評估結果

**符合 3+ 項**：✅ 適合建立 Skill，繼續流程

**符合 1-2 項**：❓ 提供建議
```markdown
根據 YAGNI 原則，這個功能可能更適合：
- Command：如果使用者需要直接呼叫
- 直接寫在現有的 Command/Agent 中：如果只在一個地方使用

是否仍要繼續建立 Skill？
```

**符合 0 項**：❌ 不建議建立 Skill
```markdown
這個功能不符合 Skill 的定位，建議：
1. 如果使用者需要直接呼叫 → 建立 Command
2. 如果需要複雜互動 → 建立 Agent
3. 如果邏輯簡單 → 直接寫在現有檔案中

提供替代方案建議。
```

### 步驟 3：設計 Skill 結構

如果確定要建立 skill，開始設計細節：

#### 3-1. 確認命名

**Skill 名稱**（使用 kebab-case）：
- 清楚描述功能
- 遵循 `{功能動詞}-{對象}` 格式
- 範例：`analyze-atomicity`、`generate-commit-message`

**YAML Front Matter 名稱**（使用 PascalCase 或自然語言）：
- 範例：`Analyze Atomicity`、`Generate Commit Message`

**Description**（一句話說明）：
- 簡潔明瞭，50 字以內
- 說明核心功能和使用場景

#### 3-2. 設計輸入輸出

**輸入條件**：
- 需要哪些前置資訊？
- 依賴哪些工具或環境？
- 有什麼前提條件？

**輸出結果**：
- 返回什麼資訊？
- 如何被其他 commands/skills 使用？
- 會產生哪些副作用（如建立檔案、修改狀態）？

#### 3-3. 規劃執行步驟

將工作流程分解成清晰的步驟：

```markdown
## 執行步驟

### 步驟 1：[第一個階段]
- 子步驟 1-1
- 子步驟 1-2

### 步驟 2：[第二個階段]
- 子步驟 2-1
- 子步驟 2-2

### 步驟 N：[最後階段]
- 完成並輸出結果
```

**注意事項**：
- 每個步驟應該有明確的目標
- 步驟之間的依賴關係要清楚
- 包含錯誤處理的說明

#### 3-4. 提供使用範例

設計實際的使用場景和範例：

```markdown
## 使用範例

### 場景 1：[典型使用情況]
[描述場景和範例程式碼]

### 場景 2：[特殊情況]
[描述場景和範例程式碼]
```

### 步驟 4：確認設計

在產生檔案前，向使用者確認完整的設計：

```markdown
## Skill 設計摘要

**Plugin**：{plugin-name}
**Skill 名稱**：{skill-name}
**描述**：{description}

**輸入條件**：
- [列出輸入項目]

**執行步驟**：
1. [步驟 1]
2. [步驟 2]
...

**輸出結果**：
- [列出輸出項目]

**使用場景**：
- [場景 1]
- [場景 2]

確認以上設計無誤？
```

使用 AskUserQuestion 確認，如果使用者提出修改意見，調整設計後再次確認。

### 步驟 5：產生檔案

#### 5-1. 建立目錄結構

```bash
mkdir -p plugins/{plugin-name}/skills/{skill-name}
```

#### 5-2. 產生 SKILL.md

使用 Write tool 建立 `plugins/{plugin-name}/skills/{skill-name}/SKILL.md`：

```yaml
---
name: {Skill Name}
description: {簡短描述}
---

# {Skill 標題}

{詳細說明這個 skill 的功能和目的}

## 核心功能

- {功能點 1}
- {功能點 2}
- {功能點 3}

## 輸入條件

- {前置條件 1}
- {前置條件 2}

## 執行步驟

### 步驟 1：{步驟名稱}

{詳細說明}

### 步驟 2：{步驟名稱}

{詳細說明}

## 輸出結果

- {輸出項目 1}
- {輸出項目 2}

## 使用範例

### 場景 1：{場景名稱}

{範例說明}

## 注意事項

- {注意事項 1}
- {注意事項 2}
```

**重要**：
- 檔案結尾要留一個空行
- YAML Front Matter 格式要正確
- Markdown 格式要規範

#### 5-3. 確認檔案已建立

使用 Read tool 讀取剛建立的 SKILL.md，確認內容正確。

### 步驟 6：更新文件

#### 6-1. 更新 README.md

讀取 `plugins/{plugin-name}/README.md`，在 Skills 清單中加入新的 skill：

```markdown
### `{plugin-name}:{skill-name}`

{description}

**功能特點：**

- {特點 1}
- {特點 2}

**適用場景：**

- {場景 1}
- {場景 2}

**使用方式：**

{簡要的使用說明}
```

#### 6-2. 更新 CHANGELOG.md

讀取 `plugins/{plugin-name}/CHANGELOG.md`，在 `[Unreleased]` 區段的 `### Added` 下加入：

```markdown
- 新增 `{plugin-name}:{skill-name}` Skill
  - {功能說明 1}
  - {功能說明 2}
  - {功能說明 3}
```

如果 `[Unreleased]` 區段不存在，創建它。
如果 `### Added` 區段不存在，創建它。

### 步驟 7：總結並提供後續建議

完成後向使用者報告：

```markdown
✅ Skill 建立完成！

**檔案位置**：
- SKILL.md: plugins/{plugin-name}/skills/{skill-name}/SKILL.md
- README.md: 已更新
- CHANGELOG.md: 已更新

**後續步驟建議**：

1. 測試 Skill
   - 在實際場景中使用這個 skill
   - 確認執行步驟是否清晰
   - 驗證輸入輸出是否符合預期

2. 更新引用
   - 在需要使用這個 skill 的 commands/agents 中加入引用
   - 移除重複的邏輯程式碼

3. 版本管理
   - 如果這是重要更新，考慮更新 plugin 版本號
   - 在 CHANGELOG.md 中補充更詳細的說明

4. 文件完善
   - 根據實際使用情況補充更多範例
   - 加入常見問題和注意事項
```

## 設計原則提醒

在整個流程中，持續提醒並應用以下原則：

### YAGNI（You Aren't Gonna Need It）
- 不要為「可能的」未來需求過度設計
- 保持簡單，專注於當前的實際需求

### DRY（Don't Repeat Yourself）
- 確保這個 skill 真的能避免重複
- 如果只有一個使用場景，考慮延後創建

### 單一職責原則
- 一個 skill 只做一件事
- 職責要清晰明確

### 清晰介面
- 輸入輸出要明確
- 文件要完整清楚

## 特殊情況處理

### 情況 1：Plugin 不存在

如果使用者指定的 plugin 不存在，詢問：

```markdown
Plugin `{plugin-name}` 不存在。

你想要：
1. 建立新的 plugin `{plugin-name}`？
2. 選擇其他現有的 plugin？
```

如果選擇建立新 plugin，提示：
```markdown
建立新 plugin 需要：
- .claude-plugin/plugin.json
- README.md
- CHANGELOG.md

建議先使用其他工具建立 plugin，再回來建立 skill。
或者我可以協助你建立基本的 plugin 結構？
```

### 情況 2：Skill 已存在

如果 skill 已經存在，詢問：

```markdown
Skill `{plugin-name}:{skill-name}` 已存在。

你想要：
1. 覆蓋現有的 skill（會備份舊版本）
2. 使用不同的名稱
3. 取消操作
```

### 情況 3：使用者提出的功能不適合 Skill

根據評估結果，提供替代建議：

**建議建立 Command：**
```markdown
這個功能更適合建立 Command，因為：
- [列出理由]

Command 的優點：
- 使用者可以直接呼叫（/plugin-name:command-name）
- 輕量快速
- 適合工具型功能

要改為建立 Command 嗎？
```

**建議建立 Agent：**
```markdown
這個功能更適合建立 Agent，因為：
- [列出理由]

Agent 的優點：
- 可以深入分析和思考
- 支援複雜的多輪互動
- 適合需要專業判斷的場景

要改為建立 Agent 嗎？
```

## 錯誤處理

### 檔案操作錯誤

如果建立檔案失敗：
```markdown
❌ 建立檔案時發生錯誤：{錯誤訊息}

可能的原因：
- 權限不足
- 路徑不存在
- 檔案名稱不合法

請檢查並重試。
```

### 格式錯誤

如果 YAML Front Matter 格式錯誤：
```markdown
⚠️ 檢測到格式問題：

- YAML Front Matter 缺少 `---` 分隔線
- name 或 description 欄位缺失

已自動修正格式。
```

## 品質檢查清單

在完成前確認：

- [ ] SKILL.md 的 YAML Front Matter 格式正確
- [ ] 檔案結尾有空行
- [ ] Markdown 格式規範（標題、列表、程式碼區塊）
- [ ] 輸入輸出說明清楚
- [ ] 執行步驟完整且有邏輯順序
- [ ] 至少有一個使用範例
- [ ] README.md 已更新
- [ ] CHANGELOG.md 已更新
- [ ] 檔案路徑和命名符合規範

## 參考資源

- 設計原則：參考 `plugin-dev:skills-development` skill
- 檔案結構：參考專案 CLAUDE.md 中的目錄結構說明
- 版本管理：參考 CLAUDE.md 中的版本管理規範
