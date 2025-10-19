# Skills 實施指南

本文件提供詳細的 skill 實施指南，包含檔案結構、格式規範、命名規範和實施步驟。

## Skill 檔案結構

### 基本結構

每個 skill 都是一個獨立的資料夾，裡面的結構如下：

```
/
├── SKILL.md          # 必須：Skill 定義檔
├── scripts/          # 可選：可執行腳本
│   ├── setup.sh
│   └── helper.py
├── templates/        # 可選：範本檔案
│   ├── config.yaml
│   └── example.md
└── resources/        # 可選：其他資源
    ├── diagrams/
    └── references/
```

### 目錄命名規範

**官方標準 vs 本專案擴充**

根據 [Claude Code Skills 官方規範](https://docs.claude.com/en/docs/claude-code/skills)，以下是目錄命名的規範：

| 目錄名稱         | 性質    | 說明                        | 建議                      |
|--------------|-------|---------------------------|-------------------------|
| `SKILL.md`   | 官方必須  | Skill 定義檔，也可以是其他 `.md` 檔案 | 強烈建議使用 `SKILL.md` 保持一致性 |
| `scripts/`   | 官方建議  | 存放可執行腳本的標準目錄              | **建議使用**官方名稱以保持跨平台相容性   |
| `resources/` | 官方建議  | 存放輔助資源的標準目錄               | **建議使用**官方名稱以保持跨平台相容性   |
| `templates/` | 本專案擴充 | 本專案新增的範本檔案目錄              | 可選使用，不影響官方相容性           |

**自訂目錄名稱**

雖然官方沒有強制規定目錄名稱，但為了保持一致性和跨平台相容性：

- ✅ **建議**：使用官方推薦的 `scripts/` 和 `resources/` 名稱
- ✅ **可以**：新增本專案的 `templates/` 或其他自訂目錄
- ⚠️ **不建議**：修改官方推薦的目錄名稱（如將 `scripts/` 改為 `bin/`）
- ❌ **避免**：使用可能與官方未來擴充衝突的名稱

**重要提醒**：

- 使用官方名稱可確保 skill 在不同平台（Claude.ai、Claude Code、Claude API）間正常運作
- 自訂目錄只能在支援的平台上使用，可能影響可移植性

### 必須的檔案

#### SKILL.md

**用途**：定義 skill 的核心工作流程和行為

**必須包含**：

- YAML Front Matter（name, description）
- 核心功能說明
- 執行步驟

**範例**：

```markdown
---
name: example-skill
description: 簡短描述這個 skill 的核心功能
---

# Skill 標題

## 核心功能

- 功能 1
- 功能 2

## 執行步驟

1. 步驟 1
2. 步驟 2
3. 步驟 3
```

### 可選的資源類型

#### 腳本檔案 (scripts/)

**用途**：存放可執行的腳本

**適用情境**：

- Skill 需要執行系統命令
- 包含可重複使用的腳本邏輯
- 需要與外部工具整合

**範例**：

```
scripts/
├── analyze.py      # Python 分析腳本
├── format.sh       # Bash 格式化腳本
└── validate.js     # JavaScript 驗證腳本
```

**注意事項**：

- 腳本應該有可執行權限（`chmod +x`）
- 在 SKILL.md 中說明如何使用這些腳本
- 腳本應該有清晰的錯誤處理

#### 範本檔案 (templates/)

**用途**：存放範本檔案

**適用情境**：

- Skill 需要產生標準格式的檔案
- 提供可自訂的配置範本
- 包含文件範本

**範例**：

```
templates/
├── README.template.md     # README 範本
├── config.template.yaml   # 配置檔範本
└── test.template.js       # 測試檔案範本
```

**注意事項**：

- 範本中使用清晰的佔位符（如 `{{PLACEHOLDER}}`）
- 在 SKILL.md 中說明如何使用範本
- 提供範本的填寫說明

#### 輔助資源檔案 (resources/)

**用途**：存放其他輔助資源

**適用情境**：

- 需要參考的圖表或文件
- 靜態資料檔案
- 額外的說明文件

**範例**：

```
resources/
├── diagrams/
│   └── workflow.mermaid    # Mermaid 流程圖
├── references/
│   └── api-spec.json       # API 規格
└── data/
    └── examples.json       # 範例資料
```

---

## SKILL.md 格式規範

### YAML Front Matter

位於檔案開頭，使用 `---` 包圍：

```yaml
---
name: Skill-Name              # 必須：skill 的名稱
description: 簡短描述         # 必須：一句話說明核心功能
---
```

#### name 欄位

**必須欄位**

**格式**：

- 使用 kebab-case（如 `skills-development`）
- 與資料夾名稱完全一致

**範例**：

```
# ✅ 正確
name: resolving-conflict
name: skills-development
name: quick-fix

# ❌ 錯誤
name: Resolving-Conflict     # 首字母大寫
name: resolvingConflict      # camelCase
name: resolving_conflict     # snake_case
name: RESOLVING-CONFLICT     # SCREAMING-KEBAB-CASE
```

#### description 欄位

**必須欄位**

**用途與重要性**

description 是 **AI 發現和選擇 skill 的關鍵**：

1. **啟動時預載入**：Claude 在啟動時會預載入所有 skills 的 name 和 description 到 system prompt
2. **動態發現**：工作時 Claude 會掃描 descriptions 來找到相關的 skills
3. **漸進式揭露**：只有在需要時才載入完整的 SKILL.md 內容
4. **Token 效率**：每個 skill 只佔用幾十個 tokens，保持 Claude 快速運作

**內容要求**

description 必須包含兩個關鍵資訊：

1. ✅ **What（做什麼）**：這個 skill 的核心功能
2. ✅ **When（何時使用）**：Claude 應該在什麼情況下使用它

**格式規範**

- **官方限制**：最大 1024 字元
- **建議長度**：50-150 字（一到兩句話）
- **語言**：繁體中文（本專案規範）
- **語態**：使用主動語態，直接說明功能

**範例**

```yaml
# ✅ 優秀範例（包含 What 和 When）
description: 協助解決 Git Rebase 或 Merge 過程中的衝突，提供系統化的衝突解決流程。
# What: 解決 Git 衝突
# When: Git Rebase 或 Merge 過程中

description: 協助設計和開發 Claude Code Skills，提供 skill 設計的思考邏輯和最佳實踐
# What: 協助設計和開發 Skills
# When: 設計 Skills 時需要思考邏輯和最佳實踐

# ⚠️ 需要改進
description: 解決衝突
# 問題：太簡短，缺少 When（何時使用）

description: 這個 skill 是用來幫助使用者解決 Git 衝突的工具
# 問題：不要用「這個 skill」開頭，語句冗長

description: 處理資料
# 問題：太模糊，沒有說明做什麼資料處理、何時使用

# ❌ 錯誤範例
description: Helps resolve git conflicts
# 問題：應使用繁體中文（本專案規範）

description: 解決 Git 衝突的工具，可以幫助使用者在遇到衝突時進行處理，包含自動分析、手動編輯、衝突標記移除等多種功能，並且支援 rebase 和 merge 兩種模式
# 問題：太冗長，應該簡潔明瞭
```

**撰寫技巧**

1. **直接說明功能**
   - ✅ 協助解決 Git Rebase 或 Merge 過程中的衝突
   - ❌ 這是一個用來解決 Git 衝突的 skill

2. **包含使用時機**
   - ✅ 在 Git Rebase 或 Merge 過程中遇到衝突時
   - ❌ 解決衝突（沒說明什麼時候）

3. **保持簡潔但完整**
   - ✅ 一到兩句話，涵蓋 What 和 When
   - ❌ 過度詳細的功能列表（這些應該放在 SKILL.md 內容中）

4. **使用具體的情境**
   - ✅ Git Rebase 或 Merge 過程中
   - ❌ 當你需要處理版本控制問題時

### 內容結構

**建議的章節順序**：

```markdown
---
name: skill-name
description: 簡短描述
---

# Skill 標題

簡短的介紹（1-2 段）

## 核心功能

- 列出主要功能

## 輸入條件（可選）

- 列出前置條件
- 需要的資訊或工具

## 執行步驟

1. 步驟 1
2. 步驟 2
3. 步驟 3

## 輸出結果（可選）

- 說明產出內容
- 如何被其他 commands/skills 使用

## 使用場景

- 適用情境
- 工作流程範例

## 注意事項

- 安全檢查
- 常見錯誤

## 整合其他工具（可選）

- 相關的 commands、skills、agents
```

### 章節說明

#### 核心功能（必須）

列出 skill 的主要功能，使用條列式：

```markdown
## 核心功能

- 偵測當前的衝突狀態（rebase 或 merge）
- 列出所有衝突的檔案
- 逐個檢視並解決衝突
- 完成 rebase 或 merge 流程
```

#### 執行步驟（必須）

詳細說明工作流程，使用編號列表：

```markdown
## 執行步驟

### 1. 準備階段

檢查前置條件：

- 確認工具已安裝
- 驗證環境設定

### 2. 執行階段

1. **第一步**
    - 詳細說明
    - 可能的指令

2. **第二步**
    - 詳細說明
    - 注意事項

### 3. 完成階段

清理和驗證：

- 檢查結果
- 產生報告
```

#### 使用場景（建議）

提供實際的使用範例：

```markdown
## 使用場景

### 適用情境

- 情境 1
- 情境 2

### 工作流程範例

\`\`\`
[使用者的操作]

User: 描述使用者的請求

Agent: Claude 的回應和操作

[執行 skill 的過程]

User: 使用者的後續互動

Agent: 完成的回應
\`\`\`
```

---

## 命名規範

### 資料夾命名

**格式**：kebab-case（全小寫，單字用 `-` 分隔）

**規則**：

- ✅ 使用小寫字母和數字
- ✅ 使用 `-` 分隔單字
- ❌ 不使用 `_`（底線）
- ❌ 不使用大寫字母
- ❌ 不使用特殊字元

**範例**：

| ✅ 正確                      | ❌ 錯誤                      | 原因            |
|---------------------------|---------------------------|---------------|
| `resolving-conflict`      | `ResolvingConflict`       | 不使用大寫         |
| `skills-development`      | `skills_development`      | 使用 `-` 而非 `_` |
| `quick-fix`               | `quickFix`                | 不使用 camelCase |
| `generate-commit-message` | `generate.commit.message` | 不使用 `.`       |
| `api-v2-client`           | `api_v2_client`           | 使用 `-` 而非 `_` |

### YAML name 欄位命名

**格式**：kebab-case（全小寫，與資料夾名稱完全一致）

**規則**：

- ✅ 使用 kebab-case 與資料夾名稱完全一致
- ❌ 不使用首字母大寫
- ❌ 不使用 camelCase
- ❌ 不使用 snake_case
- ❌ 不使用 PascalCase

**範例**：

| 資料夾名稱                | ✅ 正確的 name           | ❌ 錯誤的 name                                                  |
|----------------------|----------------------|-------------------------------------------------------------|
| `resolving-conflict` | `resolving-conflict` | `Resolving-Conflict`<br>`resolvingConflict`<br>`resolving_conflict` |
| `skills-development` | `skills-development` | `Skills-Development`<br>`skillsDevelopment`<br>`SKILLS-DEVELOPMENT` |
| `quick-fix`          | `quick-fix`          | `Quick-Fix`<br>`quickFix`<br>`QuickFix`                         |

**推薦做法**：

```yaml
# 推薦：與資料夾名稱完全一致
資料夾：skills-development/
name: skills-development
```

### 描述性命名

Skill 名稱應該清楚描述功能：

**✅ 好的命名**：

| 名稱                        | 說明           |
|---------------------------|--------------|
| `analyze-atomicity`       | 明確說明「分析原子性」  |
| `generate-commit-message` | 明確說明「產生提交訊息」 |
| `resolving-conflict`      | 明確說明「解決衝突」   |
| `validate-config`         | 明確說明「驗證配置」   |

**❌ 壞的命名**：

| 名稱          | 問題         |
|-------------|------------|
| `helper`    | 太抽象，不知道幫什麼 |
| `utils`     | 太通用，應該明確功能 |
| `processor` | 不知道處理什麼    |
| `manager`   | 不知道管理什麼    |
| `do-stuff`  | 完全不清楚功能    |

### 命名最佳實踐

#### 1. 使用動詞開頭

描述 skill 的動作：

```
✅ analyze-atomicity     （分析原子性）
✅ generate-message      （產生訊息）
✅ validate-input        （驗證輸入）
✅ resolve-conflict      （解決衝突）

❌ atomicity-analyzer    （應該用動詞開頭）
❌ message-generator     （應該用動詞開頭）
```

#### 2. 保持簡潔但清楚

```
✅ validate-config       （簡潔清楚）
✅ parse-json           （簡潔清楚）

❌ validate-all-configuration-files  （太長）
❌ val-cfg              （縮寫不清楚）
```

#### 3. 避免重複

```
✅ git/skills/resolve-conflict/      （git 已在 plugin 名稱中）
❌ git/skills/git-resolve-conflict/  （重複 git）

✅ jira/skills/analyze-ticket/
❌ jira/skills/jira-analyze-ticket/
```

---

## 實施計畫

當你決定要創建一個新的 skill 時，按照以下步驟進行：

### 步驟 1：創建檔案結構

```bash
# 進入 plugin 目錄
cd plugins/{plugin-name}

# 創建 skill 資料夾
mkdir -p skills/{skill-name}

# 創建核心定義檔
touch skills/{skill-name}/SKILL.md

# 如果需要，創建可選的資源資料夾
mkdir -p skills/{skill-name}/scripts
mkdir -p skills/{skill-name}/templates
mkdir -p skills/{skill-name}/resources
```

### 步驟 2：設計 SKILL.md

**2.1 撰寫 YAML Front Matter**

```yaml
---
name: your-skill-name
description: 一句話說明這個 skill 的核心功能（50-100 字）
---
```

**2.2 撰寫核心內容**

按照以下順序組織內容：

1. **主標題和簡介**
   ```markdown
   # Skill 標題

   簡短介紹這個 skill 的用途和價值（1-2 段）
   ```

2. **核心功能**
   ```markdown
   ## 核心功能

   - 功能 1
   - 功能 2
   - 功能 3
   ```

3. **執行步驟**
   ```markdown
   ## 執行步驟

   ### 1. 步驟標題

   詳細說明...

   ### 2. 步驟標題

   詳細說明...
   ```

4. **其他章節**（視需要加入）
    - 輸入條件
    - 輸出結果
    - 使用場景
    - 注意事項
    - 整合其他工具

**2.3 撰寫範例**

提供實際的使用範例，幫助使用者理解：

```markdown
## 工作流程範例

\`\`\`
User: [使用者的請求]

Agent: [Claude 的回應]
[執行 skill 的步驟]

User: [使用者的後續互動]

Agent: [完成的回應]
\`\`\`
```

### 步驟 3：重構現有程式碼（如果適用）

如果是從現有的 command/agent 中抽取 skill：

**3.1 識別要抽取的邏輯**

找出重複使用或可以獨立的部分

**3.2 更新原始檔案**

移除重複的邏輯，改為引用新的 skill：

```markdown
## 執行步驟

1. 準備工作
2. **使用 `{plugin-name}:{skill-name}` skill** 執行主要邏輯
3. 後續處理
```

**3.3 測試功能**

確保重構後功能正常：

- 測試所有引用這個 skill 的 commands
- 確認 skill 可以獨立執行
- 檢查錯誤處理

### 步驟 4：更新文件

**4.1 更新 Plugin README.md**

在 plugin 的 README 中加入新的 skill：

```markdown
## Skills

### {skill-name}

簡短說明這個 skill 的功能。

**位置**：`skills/{skill-name}/SKILL.md`

**主要功能**：

- 功能 1
- 功能 2

**使用方式**：
在 commands 或 agents 中引用這個 skill
```

**4.2 更新 CHANGELOG.md**

記錄到 plugin 的 CHANGELOG：

```markdown
## [Unreleased]

### Added

- 新增 `{skill-name}` skill：{簡短說明}
```

**4.3 更新版本號**（如果需要發布）

在 `.claude-plugin/plugin.json` 中更新版本號：

```json
{
  "name": "plugin-name",
  "version": "1.1.0",
  ...
}
```

---

## 品質檢查清單

創建或修改 skill 後，使用這個檢查清單確保品質：

### 檔案結構

- [ ] `SKILL.md` 檔案存在且位於正確位置
- [ ] 資料夾名稱使用 kebab-case
- [ ] 檔案結尾有空行
- [ ] 可選的資料夾（scripts, templates, resources）有適當的組織

### YAML Front Matter

- [ ] 包含 `name` 欄位
- [ ] 包含 `description` 欄位
- [ ] `name` 使用 PascalCase 或 kebab-case
- [ ] `description` 清楚簡潔（50-100 字）
- [ ] 使用繁體中文
- [ ] YAML 格式正確（使用 `---` 包圍）

### 內容品質

- [ ] 包含「核心功能」章節
- [ ] 包含「執行步驟」章節
- [ ] 執行步驟清晰且可操作
- [ ] 提供使用範例或場景
- [ ] 包含注意事項（如果適用）
- [ ] Markdown 格式正確
- [ ] 沒有錯字和語法錯誤

### 命名規範

- [ ] 資料夾名稱使用 kebab-case
- [ ] YAML name 與資料夾名稱一致（推薦）
- [ ] 名稱具有描述性，清楚說明功能
- [ ] 使用動詞開頭（建議）
- [ ] 避免重複 plugin 名稱

### 功能驗證

- [ ] Skill 可以獨立執行
- [ ] 所有引用這個 skill 的 commands/agents 都能正常運作
- [ ] 測試過主要使用場景
- [ ] 錯誤處理完善

### 文件更新

- [ ] 更新 Plugin README.md
- [ ] 更新 CHANGELOG.md
- [ ] 更新版本號（如果需要發布）
- [ ] 所有文件間的連結正確

### 整合檢查

- [ ] 與其他 skills 的介面清楚
- [ ] 與 commands 的整合正確
- [ ] 與 agents 的整合正確
- [ ] 沒有與其他 skills 重複的功能

---

## 常見問題

### Q1：應該創建多少個可選資料夾？

**A**：只創建你實際需要的資料夾。

- 如果沒有腳本，不要創建空的 `scripts/` 資料夾
- 如果沒有範本，不要創建空的 `templates/` 資料夾
- 保持結構簡單，遵循 YAGNI 原則

### Q2：YAML name 必須使用 kebab-case 嗎？

**A**：**是的，統一使用全小寫的 kebab-case** 與資料夾名稱完全一致。

範例：

```
資料夾：skills-development/
YAML：  name: skills-development  （全小寫的 kebab-case）
```

這樣可以保持命名的一致性，便於維護和識別。

### Q3：description 應該寫多長？要包含什麼內容？

**A**：**建議 50-150 字**，一到兩句話，必須包含 **What（做什麼）** 和 **When（何時使用）**。

**原因**：
- description 是 AI 發現 skill 的關鍵，會被預載入到 system prompt
- Claude 透過掃描 descriptions 來決定使用哪個 skill
- 官方限制最大 1024 字元

**範例**：
- ✅ 優秀：「協助解決 Git Rebase 或 Merge 過程中的衝突，提供系統化的衝突解決流程。」
  - What: 解決 Git 衝突
  - When: Git Rebase 或 Merge 過程中
- ❌ 太簡短：「解決衝突」（缺少 When 和具體情境）
- ❌ 太冗長：列出所有功能細節（應該放在 SKILL.md 內容中）

### Q4：可以在 skill 中引用其他 skills 嗎？

**A**：可以，但要注意避免循環依賴。

```markdown
## 執行步驟

1. 使用 `analyze-changes` skill 分析變更
2. 根據分析結果決定策略
3. 執行對應的操作
```

### Q5：如何處理 skill 的版本控制？

**A**：Skills 的版本跟隨 plugin 的版本。

- 修改 skill 時更新 plugin 的 CHANGELOG
- 如果是重大變更，考慮增加 plugin 的 MAJOR 版本號
- 在 CHANGELOG 中明確記錄 skill 的變更

---

## 與其他文件的關聯

- **[SKILL.md](SKILL.md)**：核心判斷標準，決定是否需要創建 skill
- **[official-reference.md](official-reference.md)**：官方格式規範的詳細說明
- **[examples.md](examples.md)**：實際案例，看其他 skills 如何實作
- **[best-practices.md](best-practices.md)**：避免實施中的常見錯誤

---

**最後更新**：2025-10-19
