# 直接在主幹提交

小型修改、快速整合到主幹的工作模式。

## 適用場景

- 小型團隊（< 10 人）
- 簡單的修改或 bug 修復
- 有完善的自動化測試保護
- 不需要 Code Review 的變更

## 核心特點

直接在 main 分支開發，無需建立功能分支。推薦使用 `/git:commit-push` 指令自動產生提交訊息並推送。

## 執行步驟

### 1. 確保在主幹上

```bash
git checkout main
```

如果當前不在主幹上，先切換到主幹分支。

### 2. 拉取最新變更

```bash
git pull --rebase origin main
```

**重要：使用 rebase 而非 merge**
- 保持線性的提交歷史
- 避免不必要的合併提交
- 符合 TBD 的最佳實踐

### 3. 進行開發

編輯檔案，實作功能或修復問題。保持變更範圍小且專注。

### 4. 執行測試（可選）

執行本地測試確保變更不會破壞現有功能。測試失敗則修正後再繼續。

### 5. 提交並推送

**使用 `/git:commit-push` 指令**

這個指令會自動：
- 分析工作目錄變更
- 判斷提交原子性
- 產生符合 Conventional Commits 規範的提交訊息
- 提交變更
- 推送到指定分支（通常是 main）

**執行方式：**
```
/git:commit-push
```

**指令會處理：**
1. 檢查變更內容
2. 讓你確認要提交的檔案範圍
3. 產生提交訊息
4. 執行 commit 和 push

**手動方式（如果不使用指令）：**

如果因為某些原因無法使用 `/git:commit-push` 指令，可以手動執行：

```bash
# 1. 檢查變更
git status
git diff

# 2. 加入變更
git add .

# 3. 建立提交（使用 Conventional Commits 格式）
git commit -m "類型(範圍): 簡短描述"

# 4. 推送到遠端
git push origin main
```

**提交原則：**
- 每個提交都應該是原子性的
- 提交訊息要清楚描述變更內容
- 避免一次提交過多變更

**如果推送失敗：**
```bash
# 有其他人已推送到主幹
git pull --rebase origin main
# 解決衝突（如有，使用 resolving-conflict skill）
git push origin main
```

### 6. 監控 CI/CD

推送後：
- 檢查 CI/CD pipeline 是否通過
- 監控自動化測試結果
- 如有失敗，立即修正


## 常見問題

**Q: 推送時有衝突怎麼辦？**
A: 執行 `git pull --rebase origin main`，解決衝突後 `git rebase --continue`，再推送。

**Q: 提交後發現問題？**
A: 還沒推送用 `git commit --amend`，已推送則建立新的修正提交。

**Q: 多人同時提交會有問題嗎？**
A: 不會，使用 rebase 保持線性歷史，頻繁整合減少衝突。

**Q: 什麼變更適合直接提交？**
A: Bug 修復、小型功能、文件更新、格式調整。大型功能、破壞性變更應使用短期分支。

## 最佳實踐

**DO：** 頻繁提交（每 1-2 小時）、小批次變更（< 200 行）、清晰提交訊息、頻繁同步主幹。

**DON'T：** 累積大量變更、跳過測試、強制推送、提交未完成功能（應使用 feature flags）。


## 相關工具

- `/git:commit-push` - 自動產生提交訊息並推送（強烈推薦）
- `resolving-conflict` skill - 解決推送衝突
