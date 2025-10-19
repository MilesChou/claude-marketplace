# Skills 設計最佳實踐

本文件整理 skills 設計和開發中的最佳實踐和常見錯誤，幫助你避免陷阱，寫出高品質的 skills。

## 常見錯誤

### 1. 過早抽象（Premature Abstraction）

#### 錯誤示範

```markdown
場景：正在開發第一個使用某個邏輯的 command

開發者：「這個檔案分析邏輯未來可能會在其他地方用到，
        我先把它抽成一個 skill 好了。」

結果：
- 創建了一個只有一個使用者的 skill
- 增加了不必要的複雜度
- 後來發現其他地方根本不需要這個邏輯
```

#### 為什麼會發生

- **過度優化**：想要提前做好「未來的準備」
- **誤解 DRY 原則**：認為「可能重複」就要抽象
- **缺乏判斷標準**：沒有明確的判斷流程

#### 正確做法

```markdown
✅ 第一次使用：直接寫在 command 中，保持簡單

✅ 第二次使用：這時候才考慮是否要抽取成 skill
   - 檢查兩個使用場景的相似度
   - 評估未來的擴展可能性
   - 如果高度相似且可能繼續擴展，才抽取

✅ 第三次使用：必須抽取成 skill
   - 此時已經有明確的重複使用模式
   - DRY 原則明確適用
```

#### 記住

> **YAGNI（You Aren't Gonna Need It）**：不要為「可能的」未來需求設計，等需求真正出現再重構。

---

### 2. 過度細分（Over-Fragmentation）

#### 錯誤示範

```markdown
場景：將 3 行簡單的邏輯抽成一個 skill

# skills/format-string/SKILL.md
---
name: Format-String
description: 格式化字串，移除首尾空白
---

## 執行步驟
1. 使用 trim() 移除首尾空白
2. 轉換為小寫
3. 返回結果

結果：
- 檔案過多，難以維護
- 增加理解成本
- 這種簡單邏輯應該直接內嵌在 command 中
```

#### 為什麼會發生

- **誤解模組化**：認為「什麼都要獨立」
- **忽略複雜度**：簡單邏輯也獨立成 skill
- **缺乏成本意識**：沒有考慮維護成本

#### 正確做法

```markdown
❌ 不獨立：3 行以下的簡單邏輯
   - 直接寫在 command 中
   - 保持程式碼的連貫性

✅ 考慮獨立：5+ 行且有重複使用的可能
   - 邏輯稍微複雜
   - 有明確的第二個使用場景

✅ 必須獨立：10+ 行或有複雜分支邏輯
   - 即使只有一個使用場景
   - 也值得為了可讀性獨立出來
```

#### 判斷原則

**詢問自己**：
- 這個邏輯獨立出來後，是否更容易理解？
- 維護兩個地方（skill 定義 + command 引用）是否比直接寫在 command 中更簡單？
- 未來真的會在其他地方使用嗎？

如果答案都是「否」，那就不要獨立。

---

### 3. 職責不清（Unclear Responsibility）

#### 錯誤示範

```markdown
# skills/commit-helper/SKILL.md
---
name: Commit-Helper
description: 協助提交相關的各種操作
---

## 核心功能
- 分析檔案變更
- 判斷原子性
- 產生提交訊息
- 執行 git add
- 執行 git commit
- 推送到遠端

問題：
- 一個 skill 包含太多不相關的功能
- 難以重複使用（因為太「大包」了）
- 難以維護（修改一個功能可能影響其他功能）
```

#### 為什麼會發生

- **缺乏單一職責意識**：想把相關的東西都放在一起
- **過度整合**：認為「都是提交相關的，放一起比較方便」
- **沒有考慮重複使用性**：只想到自己目前的需求

#### 正確做法

```markdown
✅ 拆分成多個職責清晰的 skills：

1. `analyze-changes` skill
   - 只負責分析檔案變更
   - 輸入：檔案列表
   - 輸出：變更分類結果

2. `generate-commit-message` skill
   - 只負責產生提交訊息
   - 輸入：變更分類結果
   - 輸出：格式化的提交訊息

3. `validate-atomicity` skill
   - 只負責判斷原子性
   - 輸入：變更分類結果
   - 輸出：原子性判斷結果

然後在 command 中組合這些 skills：
commands/commit-push.md 可以選擇性地使用需要的 skills
```

#### 單一職責原則

> 每個 skill 應該只有**一個明確的職責**，只因為**一個理由**而需要修改。

---

### 4. 缺乏文件（Lack of Documentation）

#### 錯誤示範

```markdown
---
name: Process-Data
description: 處理資料
---

# 處理資料

執行資料處理。

問題：
- 沒有說明輸入是什麼
- 沒有說明輸出是什麼
- 沒有執行步驟
- 其他人（或未來的自己）不知道如何使用
```

#### 為什麼會發生

- **趕時間**：想快速完成功能
- **覺得簡單**：「程式碼就是最好的文件」
- **缺乏同理心**：沒有考慮其他人使用的情況

#### 正確做法

```markdown
---
name: Process-Data
description: 處理和轉換輸入資料，將 JSON 格式轉換為標準化的物件結構
---

# 處理資料

將輸入的 JSON 資料轉換為標準化的物件結構，並進行驗證和清理。

## 核心功能
- 解析 JSON 資料
- 驗證資料格式
- 清理無效欄位
- 標準化欄位名稱
- 返回處理後的物件

## 輸入條件
- JSON 格式的資料字串或檔案路徑
- 必須包含 `id` 和 `name` 欄位
- 可選：`metadata` 欄位

## 執行步驟
1. 讀取輸入資料（字串或檔案）
2. 解析 JSON
3. 驗證必要欄位
4. 清理和標準化
5. 返回處理後的物件

## 輸出結果
- 標準化的物件，包含：
  - `id`: string
  - `name`: string
  - `metadata`: object（可選）

## 使用範例
\`\`\`
輸入：{"id": "123", "Name": "Test", "extra": "data"}
輸出：{"id": "123", "name": "Test"}  （欄位名稱標準化，移除 extra）
\`\`\`
```

#### 文件最低要求

- ✅ 清楚的 description（50-100 字）
- ✅ 核心功能列表
- ✅ 詳細的執行步驟
- ✅ 使用範例（如果邏輯不是顯而易見）

---

## 最佳實踐

### 1. 等待第二次使用（Rule of Three）

#### 原則

```markdown
第 1 次使用 → 直接寫在 command/agent 中
第 2 次使用 → 認真考慮是否要抽取成 skill
第 3 次使用 → 必須抽取成 skill（如果還沒抽的話）
```

#### 為什麼這樣做

**避免過早抽象**：
- 第 1 次：還不知道是否真的需要重複使用
- 第 2 次：開始看到重複模式，可以評估
- 第 3 次：明確的重複，DRY 原則適用

**實際重構時機更明確**：
- 有真實的使用案例可以參考
- 知道不同使用場景的差異
- 可以設計更通用的介面

#### 範例

```markdown
場景：檔案變更分析邏輯

第 1 次：在 git:commit-push 中直接實作
決策：保持簡單，觀察是否有其他需求

第 2 次：git:commit-review 也需要類似邏輯
決策：評估兩個使用場景的相似度
      - 如果 80% 以上相似 → 考慮抽取
      - 如果差異很大 → 各自保持獨立

第 3 次：git:pre-commit-check 也需要
決策：明確的重複模式，必須抽取成 analyze-changes skill
```

---

### 2. 明確的命名（Clear Naming）

#### 好的命名特徵

✅ **描述性**：一看就知道 skill 做什麼

```markdown
✅ analyze-atomicity      # 清楚：分析原子性
✅ generate-commit-message # 清楚：產生提交訊息
✅ resolve-conflict       # 清楚：解決衝突
✅ validate-config        # 清楚：驗證配置
```

✅ **動詞開頭**：強調 skill 的動作

```markdown
✅ analyze-*    # 分析
✅ generate-*   # 產生
✅ validate-*   # 驗證
✅ resolve-*    # 解決
✅ transform-*  # 轉換
```

✅ **簡潔但不失清晰**：

```markdown
✅ parse-json              # 簡潔清楚
❌ parse-json-data-format  # 太冗長
❌ parse                   # 太簡短，不知道解析什麼
```

#### 壞的命名範例

❌ **太抽象**：

```markdown
❌ helper       # 幫什麼忙？
❌ utils        # 什麼工具？
❌ processor    # 處理什麼？
❌ manager      # 管理什麼？
```

❌ **太具體**：

```markdown
❌ analyze-git-commit-atomicity-for-conventional-commits
   # 太長，應該簡化為 analyze-atomicity

❌ validate-json-config-file-format-version-2
   # 太長，應該簡化為 validate-config
```

❌ **不清楚的縮寫**：

```markdown
❌ val-cfg      # 應該寫完整：validate-config
❌ gen-msg      # 應該寫完整：generate-message
❌ proc-data    # 應該寫完整：process-data
```

#### 命名檢查清單

詢問自己：
- [ ] 其他人看到名稱，是否能猜到 70% 的功能？
- [ ] 名稱是否使用了動詞開頭？
- [ ] 名稱是否簡潔（2-4 個單字）？
- [ ] 名稱是否避免了不清楚的縮寫？
- [ ] 名稱是否符合專案的命名規範（kebab-case）？

---

### 3. 完整的文件（Complete Documentation）

#### 必須包含的元素

1. **YAML Front Matter**
   ```yaml
   ---
   name: Skill-Name
   description: 清楚的一句話說明（50-100 字）
   ---
   ```

2. **核心功能**
   ```markdown
   ## 核心功能
   - 列出 3-5 個主要功能
   - 使用簡潔的條列式
   ```

3. **執行步驟**
   ```markdown
   ## 執行步驟

   ### 1. 準備階段
   詳細說明...

   ### 2. 執行階段
   詳細說明...

   ### 3. 完成階段
   詳細說明...
   ```

4. **使用範例**
   ```markdown
   ## 工作流程範例

   提供實際的使用案例，包含：
   - 使用者的輸入
   - Skill 的執行過程
   - 預期的輸出
   ```

#### 建議包含的元素

1. **輸入條件**（如果有特定要求）
   ```markdown
   ## 輸入條件
   - 需要的工具或環境
   - 前置條件
   - 必要的參數
   ```

2. **輸出結果**（如果有明確產出）
   ```markdown
   ## 輸出結果
   - 返回什麼資訊
   - 如何被其他 commands/skills 使用
   ```

3. **注意事項**
   ```markdown
   ## 注意事項

   ### 安全檢查
   - 需要注意的安全問題

   ### 常見錯誤
   - 避免什麼
   - 推薦什麼
   ```

4. **整合其他工具**（如果相關）
   ```markdown
   ## 整合其他工具
   - 可以配合使用的 commands
   - 相關的 skills
   - 建議的工作流程
   ```

#### 文件品質檢查

- [ ] 其他人閱讀文件後，能否獨立使用這個 skill？
- [ ] 文件是否說明了「為什麼」而不只是「怎麼做」？
- [ ] 是否提供了實際的使用範例？
- [ ] 是否說明了邊界情況和錯誤處理？

---

### 4. 測試和驗證（Testing and Validation）

#### 基本測試

在發布 skill 前，至少要測試：

1. **獨立執行**
   ```markdown
   測試：skill 可以被單獨呼叫並正常運作
   方法：創建一個簡單的 command 來測試這個 skill
   ```

2. **整合測試**
   ```markdown
   測試：所有引用這個 skill 的 commands/agents 都能正常運作
   方法：逐一測試每個引用者
   ```

3. **邊界情況**
   ```markdown
   測試：極端輸入、錯誤輸入的處理
   方法：故意提供不正常的輸入，確認錯誤處理
   ```

#### 驗證清單

- [ ] 在至少 2 個使用場景中測試過
- [ ] 測試過正常輸入
- [ ] 測試過異常輸入
- [ ] 確認錯誤訊息清楚易懂
- [ ] 確認文件與實際行為一致

#### 回歸測試

當修改 skill 時：
- [ ] 測試所有引用這個 skill 的地方
- [ ] 確認向後相容性
- [ ] 更新 CHANGELOG 記錄變更
- [ ] 如果有 breaking changes，考慮增加 MAJOR 版本號

---

## 特殊處理

### 1. YAML Front Matter 修改

修改 YAML Front Matter 時要特別小心：

```yaml
---
name: Skill-Name           # 修改這個會影響引用
description: 描述          # 修改這個是安全的
---
```

#### 修改 name 的影響

如果修改 `name` 欄位：
- 所有引用這個 skill 的地方都需要更新
- 考慮使用「搜尋並替換」確保不遺漏
- 在 CHANGELOG 中明確記錄這個變更

#### 正確的修改流程

1. 搜尋所有引用舊名稱的地方
2. 逐一更新引用
3. 更新 skill 的 `name` 欄位
4. 測試所有引用者
5. 更新 CHANGELOG

---

### 2. 大幅度重構

當 skill 需要大幅度重構時：

#### 評估影響範圍

1. **列出所有引用者**
   - Commands
   - Agents
   - 其他 Skills

2. **評估變更影響**
   - 是否會破壞現有功能？
   - 是否需要更新介面？
   - 是否需要遷移指南？

#### 重構策略

**選項 1：原地重構**（適用於小影響）

```markdown
1. 備份當前版本
2. 修改 skill
3. 測試所有引用者
4. 更新 CHANGELOG
```

**選項 2：創建新版本**（適用於大變更）

```markdown
1. 創建新的 skill（如 skill-v2）
2. 保留舊版本一段時間
3. 逐步遷移引用者
4. 在 CHANGELOG 中標記舊版本為 deprecated
5. 一段時間後移除舊版本
```

#### 溝通變更

- 在 CHANGELOG 中詳細說明變更
- 如果是 breaking change，增加 MAJOR 版本號
- 提供遷移指南（如果需要）

---

### 3. 同時修改多個檔案

當修改涉及多個檔案時：

#### 使用 TodoWrite 規劃

```markdown
✅ 使用 TodoWrite 追蹤任務：

Todos:
1. 修改 skill: analyze-changes
2. 更新 command: git:commit-push
3. 更新 command: git:commit-review
4. 更新 README.md
5. 更新 CHANGELOG.md
6. 測試所有變更
```

#### 修改順序

建議的修改順序：

1. **核心檔案**（skills、agents）
2. **引用檔案**（commands）
3. **文件檔案**（README、CHANGELOG）
4. **測試**
5. **提交**

#### 整體確認

修改完成後：
- [ ] 所有檔案的變更是一致的
- [ ] 文件反映了實際行為
- [ ] 測試通過
- [ ] CHANGELOG 記錄完整

---

## 避免這些反模式（Anti-Patterns）

### ❌ 「未來可能用到」症候群

```markdown
錯誤思維：
「這個功能現在只有一個地方用到，但未來可能會有其他地方需要，
 所以我先抽成 skill 好了。」

正確做法：
等到真的有第二個使用場景時再抽取。
```

### ❌ 「什麼都要獨立」症候群

```markdown
錯誤做法：
把每個小功能都抽成獨立的 skill，
結果檔案數量爆炸，反而更難維護。

正確做法：
只有真正需要重複使用或邏輯複雜時才獨立。
```

### ❌ 「複製貼上」症候群

```markdown
錯誤做法：
發現兩個地方有相同的邏輯，
直接複製貼上程式碼。

正確做法：
第二次使用時就應該考慮抽取成 skill。
```

### ❌ 「文件晚點再寫」症候群

```markdown
錯誤想法：
「先把功能寫完，文件晚點有時間再補。」

結果：
文件永遠不會補，因為過一段時間就忘記細節了。

正確做法：
邊寫程式碼邊寫文件，趁記憶猶新時記錄下來。
```

---

## 成功的 Skills 設計模式

### 模式 1：轉換器（Transformer）

**特徵**：
- 輸入一種格式
- 輸出另一種格式
- 職責清晰

**範例**：
```markdown
skills/generate-commit-message/
- 輸入：git diff 結果
- 處理：分析變更、套用格式
- 輸出：Conventional Commits 格式的訊息
```

### 模式 2：驗證器（Validator）

**特徵**：
- 檢查輸入是否符合規範
- 返回驗證結果
- 提供清楚的錯誤訊息

**範例**：
```markdown
skills/validate-atomicity/
- 輸入：變更列表
- 處理：檢查是否符合原子性
- 輸出：通過/不通過 + 原因
```

### 模式 3：工作流程（Workflow）

**特徵**：
- 完整的多步驟流程
- 包含決策點
- 可能與使用者互動

**範例**：
```markdown
skills/resolving-conflict/
- 偵測狀態
- 列出衝突
- 詢問使用者
- 解決衝突
- 完成流程
```

---

## 與其他文件的關聯

- **[SKILL.md](SKILL.md)**：核心判斷標準和設計原則
- **[official-reference.md](official-reference.md)**：官方定義和規範
- **[examples.md](examples.md)**：實際案例中的錯誤和正確做法
- **[implementation.md](implementation.md)**：如何正確實作這些最佳實踐

---

## 總結

### 核心原則

1. **YAGNI**：不要過度設計，等需求明確時再抽取
2. **DRY**：出現重複時才抽取，而不是提前
3. **單一職責**：一個 skill 只做一件事
4. **清晰文件**：完整的說明和範例

### 記住

- ✅ 等待第二次使用再抽取
- ✅ 使用清楚的命名
- ✅ 撰寫完整的文件
- ✅ 充分測試和驗證
- ❌ 不要過早抽象
- ❌ 不要過度細分
- ❌ 不要職責不清
- ❌ 不要缺乏文件

**保持簡單永遠是最好的設計。**

---

**最後更新**：2025-10-19
