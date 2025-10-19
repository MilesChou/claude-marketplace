# 建立短期分支

適合需要 Code Review 或較複雜功能的開發模式，強調分支存活時間短（< 1 天）。

## 核心原則

**短期分支的關鍵特徵：**
- 存活時間 < 1 天（最多不超過 2 天）
- 頻繁整合主幹變更（每 2-4 小時）
- 小批次提交
- PR 通過後立即合併
- 合併後立即刪除分支

## 執行步驟

### 1. 確保主幹是最新的

```bash
git checkout main
git pull origin main
```

從最新的主幹開始，減少後續衝突。

### 2. 建立描述性的短期分支

```bash
git checkout -b feature/[簡短描述]
```

**命名規範：** `feature/`、`fix/`、`refactor/`、`docs/`、`test/` 開頭，使用 kebab-case，保持簡短。

### 3. 進行開發

開始實作功能，保持小批次提交。

**開發循環：**

#### 3-1. 實作一個小功能

專注於可獨立運作的小單元。

#### 3-2. 頻繁提交

```bash
# 檢查變更
git status
git diff

# 加入變更
git add .

# 提交（使用 Conventional Commits）
git commit -m "類型(範圍): 簡短描述"
```

**提交頻率建議：**
- 每完成一個子功能就提交
- 每 30 分鐘到 1 小時提交一次
- 提交前確保程式碼可編譯

**提交範例：**
```bash
git commit -m "feat(auth): 新增 email 格式驗證"
git commit -m "test(auth): 新增 email 驗證測試案例"
git commit -m "refactor(auth): 抽取驗證邏輯到獨立函式"
```

#### 3-3. 頻繁整合主幹變更

**重要：每 2-4 小時執行一次**

```bash
# 取得主幹最新變更
git fetch origin main

# Rebase 到主幹
git rebase origin/main
```

**如果遇到衝突：**
1. 使用 `resolving-conflict` skill 解決
2. 執行 `git rebase --continue`
3. 繼續開發

**為什麼要頻繁整合？**
- 減少最後合併時的衝突
- 確保功能在最新程式碼上運作
- 及早發現整合問題

#### 3-4. 推送分支

```bash
# 首次推送
git push -u origin feature/[分支名稱]

# 後續推送
git push --force-with-lease
```

### 4. 建立 Pull Request

功能完成後：

```bash
gh pr create --title "類型: 標題" --body "摘要、變更內容、測試狀態"
```

### 5. Code Review 循環

#### 5-1. 等待 CI 和 Review

- 確保所有 CI 檢查通過
- 回應 reviewer 的評論
- 根據 feedback 進行修改

#### 5-2. 修改程式碼

```bash
# 根據 review 修改程式碼
git add .
git commit -m "refactor: 根據 review 調整驗證邏輯"

# 推送更新
git push
```

#### 5-3. 持續整合主幹

在 review 期間，仍要持續整合主幹變更：

```bash
git fetch origin main
git rebase origin/main
git push --force-with-lease
```


## 時間管理

**目標：** 總開發時間 < 1 天，每 2-4 小時整合主幹一次。

**超時處理：**
- 評估是否可拆分成多個小功能
- 使用 feature flags 隱藏未完成功能，仍每天合併到主幹

## 常見問題

**Q: Review 時間過長怎麼辦？**
A: 標註急迫性、主動通知 reviewer，團隊約定 Review SLA（如 4 小時內回覆）。

**Q: 分支上有多個提交，要 squash 嗎？**
A: 推薦 Squash Merge，保持主幹歷史簡潔。

**Q: 如何處理依賴其他 PR 的情況？**
A: 推薦等待 PR-A 合併後再開始 PR-B，或從 PR-A 分支建立，待 PR-A 合併後 rebase。

**Q: 多人協作同一個短期分支可以嗎？**
A: 不推薦。替代方案：拆分任務（每人一個分支）或 Pair Programming。

## 最佳實踐

**DO：** 保持分支短期（< 1 天）、頻繁整合主幹（每 2-4 小時）、小批次提交、快速 Review、立即合併、立即清理。

**DON'T：** 分支存活過久（> 2 天）、累積多個 PR、延遲合併、保留已合併分支、跳過整合。

## 相關工具

- `commit-push` command - 產生提交訊息並推送
- `resolving-conflict` skill - 解決整合衝突
- `reviewers:requesting-code-review` - 請求 Code Review
