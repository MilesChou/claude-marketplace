# Changelog - Orik Plugin

All notable changes to this plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2025-10-19

### Added

- 初始版本發布
- 實作 ORIK 逆向工程雙階段流程
- 新增 `/orik:ngised-ceps` 指令（實作 → 設計）
  - 從現有程式碼逆向分析技術設計
  - 自動識別程式碼範圍和結構
  - 自動偵測技術堆疊
  - 建立元件依賴圖和資料流追蹤
  - 提取 API 端點和介面契約
  - 逆向工程資料模型和實體關係
  - 生成技術設計文件 (.orik/reverse/*/design.md)
  - 生成分析元資料 (.orik/reverse/*/analysis.json)
- 新增 `/orik:stnemeriuqer-ceps` 指令（設計 → 需求）
  - 從技術設計推導原始需求規格
  - 識別功能需求和使用者角色
  - 提取業務規則和流程
  - 推導非功能性需求（效能、安全、可用性）
  - 生成 EARS 格式需求文件
  - 建立需求追溯矩陣
  - 生成需求文件 (.orik/reverse/*/requirements.md)
  - 生成規格資料 (.orik/reverse/*/spec.json)
  - 生成驗證清單 (.orik/reverse/*/validation-checklist.md)
- 提供置信度評估機制（高/中/低）
- 提供完整的使用流程和場景說明
- 說明與 Kiro Plugin 的關係和互補性
