---
description: Commit and Push
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git symbolic-ref:*)
model: claude-haiku-4-5
---

# Commit and Push

協助產生符合專案規範的提交訊息，並推送到遠端儲存庫。

## 流程

### 1. 檢查當前分支

```bash
# 檢查遠端的主要分支（HEAD）為何
git symbolic-ref refs/remotes/origin/HEAD

# 查看當前分支，確認是否為遠端的主要分支
git branch --show-current
```

發現在遠端的主要分支上的話，除非有額外提示，不然統一使用 AskUserQuestion 工具跟我確認下面選項

- **推送到主要分支** - 直接提交並推送目前的變更到主要分支
- 請我提供新的分支名稱，並在新的分支上 commit 並推送變更

### 2. 檢查暫存的變更

查看已加入暫存區的檔案：

```bash
# 查看暫存的檔案清單
git status --short

# 查看暫存變更的詳細內容
git diff --cached
```

### 3. 產生提交訊息

#### 提交格式

標題使用簡短描述

    <簡短描述>

內文標記類型：

- `feat:` 新功能
- `fix:` 修復問題
- `docs:` 文件更新
- `style:` 程式碼格式調整
- `refactor:` 重構

#### 範例

```bash
git commit -m "修正登入驗證邏輯

fix: 解決 Email 驗證時的錯誤處理問題
- 修正驗證碼過期檢查邏輯
- 加入錯誤訊息國際化
- 更新相關單元測試
```

### 4. 推送至遠端

```bash
git push -u origin <分支名稱>
```

## 注意事項

- 確保提交訊息清楚描述變更內容
- 每個提交應保持原子性，只包含相關的變更
- 推送前務必依照專案開發規範執行測試，確保不會破壞現有功能
- 遵循專案開發規範
