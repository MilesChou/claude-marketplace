# Domain-Driven Design (DDD) Plugin

提供 DDD 戰略設計的系統化分析工具，協助透過結構化提問和訪談產出領域分析文件。

## Skills 清單

### `ddd-strategic-design`

DDD 戰略設計指引，透過四個階段協助完成領域分析：

**執行流程：**

1. **輸入診斷** - 分析現有資訊，識別缺口並提出澄清問題
2. **領域探索** - 透過漸進式提問發掘業務概念、邊界和規則
3. **訪談規劃** - 為 PM、領域專家、終端使用者生成訪談問題集
4. **成果產出** - 產出 Bounded Context 分析、Context Map、Ubiquitous Language

**適用場景：**

- 分析系統的領域邊界
- 規劃利害關係人訪談
- 從混亂資訊中萃取領域知識
- 建立標準 DDD 戰略文件

**參考資料：**

包含訪談問題範本和輸出格式指南：
- `pm-questions.md` - Product Manager 訪談框架
- `expert-questions.md` - 領域專家訪談框架
- `user-questions.md` - 終端使用者訪談框架
- `output-templates.md` - 文件產出範本

## 提問原則

- 由廣到窄，一次一問
- 使用 "為什麼" 挖掘業務規則
- 使用 "如果" 發現邊界案例
- 使用 "誰" 識別利害關係人

## 注意事項

- 適合複雜領域，簡單系統可能不需要
- 需要與業務專家密切合作
- 領域邊界會隨理解深入而調整

## 版本記錄

請參閱 [CHANGELOG.md](./CHANGELOG.md) 查看詳細的版本變更記錄。
