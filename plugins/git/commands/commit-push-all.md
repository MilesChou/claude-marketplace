---
description: Commit and Push All
allowed-tools: Bash(git add:*),Bash(git branch:*),Bash(git diff:*),Bash(git log:*),Bash(git push:*),Bash(git status:*),Bash(git symbolic-ref:*)
model: claude-haiku-4-5
---

無條件將所有變更提交並推送到遠端儲存庫，不考慮提交原子性。

## 工作目錄資訊

將所有檔案加入暫存區：

```
# 執行 git add .
!`git add .`
```

檔案變更與暫存狀態的清單：

```
!`git status --short`
```

檔案變更的詳細內容：

```
!`git diff --cached`
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

### 步驟 1：確認目標分支

分析「工作目錄資訊」中收集到的變更狀態，總結所有變更內容。

使用 AskUserQuestion 工具詢問目標推送分支：

**問題**：要推送到哪個分支？
- 選項：`[當前分支: main]` / `[branch1]` / `[branch2]`

分支選項建議：
- **當前分支** - 在目前的分支上提交並推送
- **其他可能的分支** - 根據修改內容推測相關的分支名稱

若使用者手動輸入的分支名稱不存在，則建立新分支。

**注意事項**：
- 除非必要，否則不要提供「切換到新的分支」的選項
- **IMPORTANT**：若使用者沒有回答或回答空白選項，則必須重新確認

### 步驟 2：產生提交訊息

根據記憶中的提交訊息格式偏好產生提交訊息，若無特別指示則使用以下格式：

#### 基本格式

```
<簡短描述所有變更>

- <type>: <變更描述>
- <type>: <變更描述>
- <type>: <變更描述>
```

- **標題**：簡單描述這次提交的整體內容（不使用 Conventional Commits 前綴）
- **內容**：使用 Conventional Commits 類型標示各項變更

#### Conventional Commits 類型

- `feat`: 新功能
- `fix`: 修復問題
- `docs`: 文件更新
- `style`: 程式碼格式調整
- `refactor`: 重構
- `test`: 測試
- `chore`: 建置或輔助工具

#### 範例

**範例 1：混合類型變更**
```
更新認證系統與文件

- feat: 新增 OAuth 登入功能
- fix: 修正驗證碼過期問題
- docs: 更新 API 文件
- test: 補充單元測試
```

**範例 2：單一類型多項變更**
```
完善登入驗證功能

- feat: 實作 email 驗證邏輯
- feat: 加入驗證碼過期檢查
- test: 更新相關單元測試
```

**範例 3：簡單變更**
```
修正登入頁面錯誤訊息顯示

- fix: 修正驗證失敗時的錯誤訊息
```

### 步驟 3：執行提交與推送

#### 3-1. 提交

所有檔案已在「工作目錄資訊」階段加入暫存區，使用步驟 2 產生的提交訊息執行 commit：

```bash
git commit -m <提交訊息>
```

#### 3-2. 推送

推送到使用者選擇的分支：

```bash
git push -u origin <分支名稱>
```

## 注意事項

### 提交特性
- **全部提交**：此指令會無條件提交工作目錄中的所有變更
- **不考慮原子性**：即使包含多種類型的修改，也會合併成單一提交
- 提交訊息應盡可能清楚描述所有變更內容

### 錯誤處理
- 遇到任何錯誤時立即停止，回報錯誤訊息給使用者
