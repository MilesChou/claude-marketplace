---
name: TBD-Flow
description: 協助在 Git 上實踐 Trunk Based Development 工作流程，支援短期分支開發與頻繁整合。
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

TBD 支援兩種主要工作模式：

### 模式 1：直接在主幹上提交

適用於：
- 小型團隊（< 10 人）
- 簡單的修改
- 有完善的自動化測試

流程：
```bash
# 拉取最新變更
git pull --rebase origin main

# 進行開發並頻繁提交
git add .
git commit -m "feat: 小功能增量"

# 推送到主幹
git push origin main
```

### 模式 2：短期功能分支

適用於：
- 中大型團隊
- 需要 Code Review
- 較複雜的功能

流程：
```bash
# 從主幹建立短期分支
git checkout -b feature/short-lived-branch

# 開發並提交（盡快完成，< 1 天）
git add .
git commit -m "feat: 功能增量"

# 頻繁整合主幹變更
git pull --rebase origin main

# 推送並建立 Pull Request
git push -u origin feature/short-lived-branch

# 通過 review 後立即合併
# 刪除分支
git branch -d feature/short-lived-branch
```

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
3. **整合現有分支** - 已在功能分支上，準備合併回主幹

### 3. 執行對應流程

#### 流程 A：直接在主幹提交

```bash
# 確保在主幹上
git checkout main

# 拉取最新變更（使用 rebase 保持線性歷史）
git pull --rebase origin main

# 進行開發...
# [使用者編輯檔案]

# 提交變更
git add .
git commit -m "類型(範圍): 簡短描述"

# 執行測試（如果有）
npm test  # 或其他測試指令

# 推送到遠端
git push origin main
```

#### 流程 B：建立短期分支

```bash
# 確保主幹是最新的
git checkout main
git pull origin main

# 建立描述性的短期分支
git checkout -b feature/[簡短描述]

# 進行開發...
# [使用者編輯檔案]

# 頻繁提交（小批次）
git add .
git commit -m "類型(範圍): 簡短描述"

# 在開發過程中頻繁整合主幹變更
git fetch origin main
git rebase origin/main

# 如遇衝突，使用 resolving-conflict skill 解決

# 推送分支
git push -u origin feature/[簡短描述]

# 建立 Pull Request（透過 gh cli）
gh pr create --title "標題" --body "描述"

# PR 通過後立即合併
gh pr merge --squash  # 或 --merge, --rebase

# 切回主幹並刪除分支
git checkout main
git pull origin main
git branch -d feature/[簡短描述]
```

#### 流程 C：整合現有分支

```bash
# 確保分支是最新的
git fetch origin

# Rebase 到最新的主幹
git rebase origin/main

# 如遇衝突，使用 resolving-conflict skill 解決

# 強制推送（因為 rebase 改寫歷史）
git push --force-with-lease

# 如果 PR 已存在，通知 reviewer
# 如果還沒 PR，建立一個
gh pr create --title "標題" --body "描述"

# 合併後清理
git checkout main
git pull origin main
git branch -d [分支名稱]
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

**原子性提交：**
```bash
# 好的例子：小範圍、可獨立運作
git commit -m "feat(auth): 新增 email 驗證邏輯"
git commit -m "test(auth): 新增 email 驗證測試"
git commit -m "docs(auth): 更新驗證流程文件"

# 不好的例子：一次提交所有變更
git commit -m "feat: 完成整個登入系統"
```

**提交頻率：**
- 每完成一個小功能就提交
- 提交前確保程式碼可編譯
- 使用 `--amend` 修正最近的提交（推送前）

### Feature Flags

使用功能開關來隱藏未完成的功能：

```typescript
// 範例：使用 feature flag 控制新功能
if (featureFlags.isEnabled('new-auth-flow')) {
  // 新的驗證流程（開發中）
  return newAuthenticationFlow(user)
} else {
  // 舊的驗證流程（穩定）
  return legacyAuthenticationFlow(user)
}
```

**優點：**
- 未完成功能可以合併到主幹
- 降低合併衝突
- 在生產環境中逐步啟用功能
- 快速回滾問題功能

### 持續整合

**整合頻率：**
```bash
# 每天開始工作前
git checkout main
git pull --rebase origin main

# 開發過程中（每 2-4 小時）
git fetch origin main
git rebase origin/main

# 提交前
git pull --rebase origin main
npm test  # 執行測試
git push origin main
```

## 使用場景

### 適用情境

**非常適合：**
- 強調快速交付的團隊
- 有完善 CI/CD 的專案
- 需要頻繁發布的產品
- 重視程式碼整合品質

**適合：**
- 中小型團隊（< 100 人）
- 有自動化測試覆蓋
- 使用微服務架構

**需謹慎評估：**
- 缺乏自動化測試的專案
- 發布週期很長的產品（> 1 個月）
- 高度監管的產業（需要嚴格的變更控制）

### 與 Git Flow 的對比

| 特性 | Trunk Based Development | Git Flow |
|------|------------------------|----------|
| 主要分支 | main | main + develop |
| 功能分支 | 短期（< 1 天） | 長期（數天到數週） |
| 整合頻率 | 每天多次 | 功能完成時 |
| 發布策略 | 發布分支或標籤 | release 分支 |
| 適合團隊 | 中小型，高自動化 | 大型，複雜發布週期 |
| 合併策略 | Rebase 優先 | Merge |

**遷移建議：**
- 從 Git Flow 遷移到 TBD 需要建立完善的自動化測試
- 逐步縮短功能分支的存活時間
- 引入 feature flags 機制
- 加強 CI/CD 流程

## 工作流程範例

### 範例 1：小功能直接提交

```
User: 我要修正一個小 bug，直接在 main 上改可以嗎？

Agent: 可以的，這符合 TBD 的直接提交模式。讓我幫你執行流程：

1. 確保 main 是最新的
   [執行] git checkout main && git pull --rebase origin main

2. 進行修改
   User: [修改檔案]

3. 提交變更
   [執行] git add . && git commit -m "fix(api): 修正使用者查詢的 null pointer 錯誤"

4. 執行測試
   [執行] npm test
   ✓ 所有測試通過

5. 推送到主幹
   [執行] git push origin main
   ✓ 完成！變更已整合到主幹。
```

### 範例 2：功能分支開發

```
User: 我要開發一個新的搜尋功能，預計今天完成。

Agent: 了解，我會建立短期功能分支。這個功能預計今天完成符合 TBD 原則。

1. 建立功能分支
   [執行] git checkout -b feature/advanced-search

2. 你可以開始開發了。記得：
   - 小批次提交（每完成一個子功能就提交）
   - 每 2-4 小時整合一次 main 的變更

User: [開發 2 小時後] 我完成第一部分了。

Agent: 很好！讓我幫你提交並整合主幹變更：

1. 提交當前進度
   [執行] git add . && git commit -m "feat(search): 實作基礎搜尋邏輯"

2. 整合主幹變更
   [執行] git fetch origin main && git rebase origin/main
   ✓ 無衝突，整合成功

3. 推送分支
   [執行] git push -u origin feature/advanced-search

繼續開發吧！記得在完成前再整合一次。

User: [下午] 功能完成了，要合併回 main。

Agent: 太好了！讓我幫你完成整合：

1. 最後一次整合主幹
   [執行] git fetch origin main && git rebase origin/main

2. 推送更新
   [執行] git push --force-with-lease

3. 建立 Pull Request
   [執行] gh pr create --title "feat: 新增進階搜尋功能" --body "..."

4. 等待 CI 和 Code Review
   [檢查] 所有 CI 檢查通過 ✓

User: Review 通過了。

Agent: 立即合併並清理：

1. 合併 PR
   [執行] gh pr merge --squash

2. 切回主幹並更新
   [執行] git checkout main && git pull origin main

3. 刪除功能分支
   [執行] git branch -d feature/advanced-search

✓ 完成！功能已整合到主幹，分支已清理。
```

### 範例 3：整合長期分支

```
User: 我有個分支已經開發 3 天了，要怎麼合併回去？

Agent: 3 天已經超過 TBD 建議的短期分支時長（< 1 天）。讓我幫你安全地整合：

[使用 AskUserQuestion]
這個分支存在較久，可能累積較多與主幹的差異。建議的整合方式：
1. 謹慎 Rebase - 逐步解決衝突，保持線性歷史
2. Merge - 保留完整歷史，但產生合併提交

User: [選擇 Rebase]

Agent: 好的，我會協助你 rebase 並處理可能的衝突：

1. 取得最新主幹
   [執行] git fetch origin main

2. 開始 Rebase
   [執行] git rebase origin/main
   ⚠️  發現 5 個衝突檔案

3. 解決衝突
   [使用 resolving-conflict skill 逐一處理]
   ...

4. Rebase 完成
   [執行] git rebase --continue
   ✓ 所有衝突已解決

5. 強制推送
   [執行] git push --force-with-lease

6. 建議：未來請縮短分支存活時間
   - 將大功能拆分成多個小功能
   - 使用 feature flags 隱藏未完成功能
   - 每天至少整合一次主幹變更

現在可以建立 PR 進行 Code Review 了。
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
A: 可以！使用 feature flags 隱藏未完成的功能。這樣可以：
- 持續整合程式碼
- 減少合併衝突
- 保持主幹穩定

**Q: 緊急 hotfix 怎麼處理？**
A:
```bash
# 選項 1：直接在主幹修復
git checkout main
git pull origin main
# 修復 bug
git commit -m "fix: 緊急修復 XXX 問題"
git push origin main

# 選項 2：如果需要先在發布分支修復
git checkout release/v1.2.0
# 修復 bug
git commit -m "fix: 緊急修復 XXX 問題"
git push origin release/v1.2.0
# 然後 cherry-pick 到主幹
git checkout main
git cherry-pick [commit-hash]
git push origin main
```

**Q: 自動化測試不完善怎麼辦？**
A: TBD 依賴自動化測試來保證品質。建議：
1. 先建立基礎測試覆蓋
2. 逐步過渡到 TBD（先從小團隊或小專案開始）
3. 加強 Code Review 流程
4. 使用 feature flags 降低風險

**Q: 如何處理大型重構？**
A:
- 拆分成多個小步驟
- 使用 Branch by Abstraction 模式
- 每個步驟都可獨立運作
- 頻繁提交到主幹
- 使用 feature flags 控制切換

## 整合其他工具

**推薦的工作流程組合：**

1. 開發新功能時：
   - 使用 `tbd-flow` skill 選擇工作模式
   - 遇到衝突使用 `resolving-conflict` skill
   - 完成後使用 `reviewers:requesting-code-review` 審查

2. 提交變更時：
   - 使用 `commit-push` command 產生提交訊息

3. 整合檢查：
   - 使用 `guideline:ddd-guideline` 確保架構設計符合規範（如適用）

**CI/CD 整合建議：**
- GitHub Actions / GitLab CI
- 自動化測試（Jest, PyTest 等）
- 程式碼品質檢查（ESLint, SonarQube）
- 自動化部署（依據標籤或主幹提交）

## 參考資源

- [Trunk Based Development 官方網站](https://trunkbaseddevelopment.com/)
- [Feature Flags 最佳實踐](https://trunkbaseddevelopment.com/feature-flags/)
- [Branch by Abstraction](https://trunkbaseddevelopment.com/branch-by-abstraction/)
