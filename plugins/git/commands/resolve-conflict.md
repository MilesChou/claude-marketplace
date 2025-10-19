---
description: 解決 Git 衝突
allowed-tools: Bash(git status:*),Bash(git diff:*),Bash(git log:*),Skill(git:resolving-conflict)
model: claude-sonnet-4-5
---

協助解決當前的 Git Rebase 或 Merge 衝突。

## 工作流程

### 1. 檢查衝突狀態

先檢查當前是否處於衝突狀態：

```
!`git status`
```

### 2. 判斷處理方式

根據 git status 的結果：

**有衝突：**
- 如果偵測到衝突（rebase in progress 或 You have unmerged paths），使用 Skill tool 調用 `git:resolving-conflict`
- 該 skill 會系統化地引導解決所有衝突

**無衝突：**
- 提示使用者目前沒有衝突需要解決
- 說明此指令適用於 `git rebase` 或 `git merge` 過程中遇到衝突的情況

## 使用場景

此指令適用於以下情況：

- 執行 `git rebase` 時遇到衝突
- 執行 `git merge` 時遇到衝突
- 需要系統化地處理多個衝突檔案
- 不確定如何正確解決衝突時

## 注意事項

- 解決衝突前會先展示完整的衝突內容
- 使用 AskUserQuestion 提供所有可能的解決方案
- 解決後建議執行測試確保功能正常
