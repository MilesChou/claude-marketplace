---
description: Commit and Push
allowed-tools: Bash(git add:*),Bash(git branch:*),Bash(git diff:*),Bash(git log:*),Bash(git reset:*),Bash(git push:*),Bash(git status:*),Bash(git symbolic-ref:*)
model: claude-haiku-4-5
---

協助產生符合專案規範的提交訊息，並推送到遠端儲存庫。

## 工作目錄資訊

將所有檔案重新設定成追蹤清單：

```
!`git add -N .`
```

檔案變更與暫存狀態的清單：

```
!`git status --short`
```

檔案變更的詳細內容：

```
!`git diff`
```

最近五筆提交訊息：

```
!`git log --oneline -5`
```

分支資訊：

- **遠端主要分支**： !`git symbolic-ref refs/remotes/origin/HEAD`
- **當前分支**： !`git branch --show-current`

所有分支清單：

```
# 本地分支
!`git branch`

# 遠端分支
!`git branch -r`
```

## 流程

### 步驟 1：分析工作目錄資訊

分析「工作目錄資訊」中收集到的變更狀態，使用一次 AskUserQuestion 工具同時確認：
1. 要提交的檔案範圍（是否符合提交原子性）
2. 目標推送分支

#### 1-1. 檔案變更狀態

分析工作目錄的變更，判斷是否符合提交原子性：

**符合原子性**：所有變更都屬於同一個邏輯修改
- 不使用 AskUserQuestion 詢問檔案範圍
- 只詢問目標推送分支
- 直接提交所有變更

**違反原子性**：包含多個不相關的修改
- 依 Conventional Commits 類型分類檔案：
    - `feat:` 新功能
    - `fix:` 修復問題
    - `docs:` 文件更新
    - `style:` 程式碼格式調整
    - `refactor:` 重構
    - `test:` 測試
    - `chore:` 建置或輔助工具

- 輸出分類後的預計 commit message 和前三個重要檔案：
  ```
  1. feat: [commit message]
     - [檔案路徑]
     - [檔案路徑]
     - [檔案路徑]
  2. docs: [commit message]
     - [檔案路徑]
  ```

- 在 AskUserQuestion 中提供複選選項，讓使用者選擇要提交哪些分類

#### 1-2. 分支狀態

在 AskUserQuestion 中提供分支選項：
- **當前分支** - 在目前的分支上提交並推送
- **其他可能的分支** - 根據修改內容推測相關的分支名稱

若使用者手動輸入的分支名稱不存在，則建立新分支。

**注意：除非必要，否則不要提供「切換到新的分支」的選項**

#### 1-3. AskUserQuestion 範例

同時詢問檔案範圍和目標分支，例如：

**問題 1**：要提交哪些變更？
- 選項：`[feat: 新增登入功能]` / `[docs: 更新 README]`

**問題 2**：要推送到哪個分支？
- 選項：`[當前分支: main]` / `[branch1]` / `[branch2]`

**IMPORTANT**：在使用 AskUserQuestion 工具時，若使用者沒有回答或回答空白選項，則必須重新確認

### 步驟 2：產生提交訊息

根據記憶中的提交訊息格式偏好產生提交訊息，若無特別指示則使用 **Conventional Commits** 規範：

#### 基本格式

```
<type>(<scope>): <subject>

<body>
```

- `type`: 提交類型（feat, fix, docs, style, refactor, test, chore）
- `scope`: 影響範圍（選填）
- `subject`: 簡短描述（50 字以內）
- `body`: 詳細說明（選填，使用 bullet points）

範例

```
feat(auth): 新增登入驗證功能

- 實作 email 驗證邏輯
- 加入驗證碼過期檢查
- 更新相關單元測試
```

### 步驟 3：執行提交與推送

#### 3-1. 加入檔案

先重置暫存區：

```bash
git reset .
```

然後根據步驟 1 使用者選擇的檔案範圍，使用 `git add` 加入檔案。

#### 3-2. 提交

使用步驟 2 產生的提交訊息執行 commit：

```bash
git commit -m <提交訊息>
```

#### 3-3. 推送

推送到使用者選擇的分支：

```bash
git push -u origin <分支名稱>
```

## 注意事項

### 提交原則
- 每個提交應保持原子性，只包含相關的變更
- 提交訊息應清楚描述變更內容和原因

### 錯誤處理
- 執行指令偶爾會出現 `.git/index.lock` 鎖定的錯誤，當指令提示詞正常啟動後，可以忽略這個錯誤
- 遇到其他任何錯誤時立即停止，回報錯誤訊息給使用者
