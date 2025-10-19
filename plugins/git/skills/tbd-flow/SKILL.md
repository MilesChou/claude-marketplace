---
name: TBD-Flow
description: 當規範有提到使用 Trunk Based Development 時，且要處理版控任務時，使用這個 skill。
---

# Trunk Based Development 工作流程

協助使用者在 Git 上實踐 Trunk Based Development（主幹開發）模式，強調頻繁整合、小批次提交和快速反饋。

## 核心概念

Trunk Based Development 是一種源碼控制分支模型，開發者在單一分支（trunk/main）上協作，使用短期功能分支或直接在主幹上提交。

**核心原則：**
- **單一主幹**：所有開發最終都整合到 main/trunk 分支
- **短期分支**：功能分支存活時間短（通常 < 1 天）
- **頻繁整合**：每天至少整合一次到主幹
- **小批次提交**：每次提交範圍小且可獨立運作
- **Feature Flags**：使用功能開關控制未完成功能的可見性
- **快速反饋**：依賴自動化測試和 CI/CD

## 工作模式

### 模式 1：直接在主幹上提交
適用於小型團隊、簡單修改、有完善自動化測試的情境。

### 模式 2：短期功能分支
適用於需要 Code Review 或較複雜功能，分支存活時間 < 1 天。

## 執行步驟

### 1. 分析當前狀態

首先確認專案的 Git 狀態：

```bash
# 檢查當前分支
git branch --show-current

# 檢查工作目錄狀態
git status

# 檢查與主幹的差異
git log --oneline main..HEAD
```

根據狀態決定工作模式：
- 如果在主幹上：考慮是否直接提交或建立短期分支
- 如果在功能分支上：確認分支存在時間，建議 < 1 天

### 2. 選擇工作流程

**使用 AskUserQuestion 詢問使用者：**

問題：要使用哪種 TBD 工作模式？

選項：
1. **直接在主幹提交** - 適合小型修改，立即整合
2. **建立短期分支** - 需要 Code Review，計劃 < 1 天完成

### 3. 執行對應流程

根據使用者在步驟 2 選擇的工作模式，讀取並執行對應的流程文件：

- **選項 1：直接在主幹提交** → 讀取 `committing-straight.md` 並執行流程
- **選項 2：建立短期分支** → 讀取 `short-lived-branch.md` 並執行流程

**重要：**
- 使用 Read 工具讀取對應的流程文件
- 完整遵循文件中的執行步驟
- 如遇衝突，使用 `resolving-conflict` skill 解決
- 提供清晰的進度回饋給使用者

**流程文件路徑：**
```
plugins/git/skills/tbd-flow/committing-straight.md
plugins/git/skills/tbd-flow/short-lived-branch.md
```

### 4. 發布管理

TBD 使用發布分支（release branches）進行生產部署：

```bash
# 從主幹建立發布分支
git checkout main
git pull origin main
git checkout -b release/v1.2.0

# 只允許 hotfix 提交到發布分支
# 發布完成後，標記版本
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin release/v1.2.0 --tags

# Hotfix 需要同時合併回主幹
git checkout main
git cherry-pick [hotfix-commit-hash]
git push origin main
```

## 最佳實踐

### 分支管理

**DO（推薦做法）：**
- 保持功能分支短期存在（< 1 天）
- 每天至少整合一次到主幹
- 使用描述性的分支名稱：`feature/`, `fix/`, `refactor/`
- PR 合併後立即刪除分支
- 使用 rebase 保持線性的提交歷史

**DON'T（避免做法）：**
- 長期存在的功能分支（> 2 天）
- 一次提交大量變更
- 延遲整合主幹變更
- 保留已合併的分支
- 使用複雜的分支結構（如 Git Flow）

### 提交策略

- 保持原子性：每個提交專注於單一功能
- 每完成一個小功能就提交
- 提交前確保程式碼可編譯

### Feature Flags

使用功能開關隱藏未完成功能，允許提早合併到主幹：
- 降低合併衝突
- 在生產環境中逐步啟用
- 快速回滾問題功能

### 持續整合

- 每天開始工作前：`git pull --rebase origin main`
- 開發過程中每 2-4 小時：`git rebase origin/main`
- 提交前執行測試並推送

## 工作流程範例

### 範例：小功能直接提交
```bash
# 1. 更新主幹
git checkout main && git pull --rebase origin main

# 2. 進行修改後使用
/git:commit-push

# 3. 監控 CI/CD
```

### 範例：短期分支開發
```bash
# 1. 建立短期分支（預計 < 1 天完成）
git checkout -b feature/advanced-search

# 2. 開發循環：編碼 → 提交 → 整合（每 2-4 小時）
git add . && git commit -m "feat: xxx"
git fetch origin main && git rebase origin/main

# 3. 完成後建立 PR，Review 通過立即合併
gh pr create && gh pr merge --squash
git checkout main && git branch -d feature/advanced-search
```

## 注意事項

### 團隊協作

**溝通機制：**
- 提交前先 pull rebase，確保整合最新變更
- 使用清晰的提交訊息（Conventional Commits）
- 在 PR 中詳細說明變更內容
- 快速回應 Code Review 意見

**衝突處理：**
- 頻繁整合可減少衝突
- 遇到衝突使用 `resolving-conflict` skill
- 大型重構需要團隊協調時間窗口

### 技術要求

**必要條件：**
- 完善的自動化測試（單元測試 + 整合測試）
- CI/CD 流程（每次提交都觸發）
- 快速的建置和測試（< 10 分鐘）

**建議條件：**
- Feature flag 系統
- 自動化部署
- 監控和快速回滾機制
- Code review 流程

### 常見問題

**Q: 功能還沒完成可以合併到主幹嗎？**
A: 可以！使用 feature flags 隱藏未完成功能，這樣能持續整合並減少衝突。

**Q: 緊急 hotfix 怎麼處理？**
A: 直接在主幹修復或在 release 分支修復後 cherry-pick 回主幹。

**Q: 自動化測試不完善怎麼辦？**
A: 先建立基礎測試覆蓋，逐步過渡，加強 Code Review，使用 feature flags 降低風險。

**Q: 如何處理大型重構？**
A: 拆分成多個小步驟，使用 Branch by Abstraction 模式，每個步驟可獨立運作並頻繁提交。

## 相關工具

- `commit-push` - 產生提交訊息
- `resolving-conflict` - 解決衝突
- `reviewers:requesting-code-review` - 請求審查

