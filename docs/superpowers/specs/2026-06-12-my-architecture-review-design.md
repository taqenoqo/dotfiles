# my-architecture-review スキル 設計ドキュメント

## 概要

PR 差分に対してアーキテクチャ的な問題を自動レビューする Copilot CLI スキル。
`my-code-smell-review` と同じ「finder → reviewer」パイプラインを採用し、
5つのアーキテクチャ観点ごとに専用の finder を用意する。

---

## ディレクトリ構成

```
home/.copilot/skills/my-architecture-review/
  SKILL.md                            ← エントリーポイント
  architecture-review-manager.md     ← マネージャーエージェント
  architecture-review-finder.md      ← finder テンプレート（観点・モデルで共用）
  architecture-review-reviewer.md    ← reviewer テンプレート（発見ごとに共用）
  concerns/
    layering.md          ← レイヤー違反の解説
    responsibility.md    ← 責務漏出の解説
    coupling.md          ← 密結合の解説
    solid.md             ← SOLID 違反の解説
    boundary.md          ← 境界侵害の解説
```

---

## 全体フロー

```
SKILL.md
  ↓ BASE_SHA / HEAD_SHA を取得して manager に渡す
architecture-review-manager
  ↓ 5観点 × 2モデル(gpt-5.4 / opus-4.6) = 10並列 finder 起動
  ↓ 全 finder 完了後、重複発見を排除
  ↓ 排除後の発見ごとに reviewer を並列起動
  ↓ 全 reviewer 完了後、最終レポート作成
```

---

## 各ファイルの責務

### SKILL.md（エントリーポイント）

- `git merge-base origin/main HEAD` で BASE_SHA を、`git rev-parse HEAD` で HEAD_SHA を取得
- manager テンプレートのプレースホルダ `{BASE_SHA}` / `{HEAD_SHA}` を埋めてサブエージェントに渡す

### architecture-review-manager.md

1. `/tmp` またはセッションディレクトリ下に `architecture-review-YYYY-MM-DD-hh-mm-ss/` を WORK_DIR として作成
2. 5つの観点（layering / responsibility / coupling / solid / boundary）それぞれを gpt-5.4 と opus-4.6 の2モデルで finder 起動（計10並列）
3. 全 finder 完了後、同一ファイル・同一行範囲の重複発見をマージ（複数モデルが同じ箇所を指摘した場合、1件にまとめる）
4. 重複排除後の発見ごとに reviewer をサブエージェントとして並列起動
5. 全 reviewer の完了後、`reject` 以外の結果を `{WORK_DIR}/report.md` として最終レポートを作成

**プレースホルダ:** `{BASE_SHA}`, `{HEAD_SHA}`

### architecture-review-finder.md

特定の観点に絞ってコードの問題箇所を洗い出す。

**プレースホルダ:** `{BASE_SHA}`, `{HEAD_SHA}`, `{WORK_DIR}`, `{MODEL}`, `{CONCERN_NAME}`, `{CONCERN_FILE_CONTENT}`

**出力:** `{WORK_DIR}/finder-{CONCERN_NAME}-{MODEL}.md`

**出力形式（1件ごと）:**
```
## path/to/file.ts: 10-35

レイヤー違反（Layering Violation）

解説ファイル: `./concerns/layering.md`
説明: Controller が Repository を直接 new している。

これこれこういう理由でアーキテクチャ上の問題がある。

10-15 行目付近のコードスニペット
```

**発見方法:**
- BASE〜HEAD の差分を取得し、変更ファイルとコンテキストを把握
- `{CONCERN_FILE_CONTENT}` に記載された観点に照らし合わせ、問題箇所を列挙
- 後工程で再評価するため、怪しい箇所はできるだけ多く挙げる

### architecture-review-reviewer.md

発見された1件のアーキテクチャ問題を詳細評価する。

**プレースホルダ:** `{SUB_AGENT_NUMBER}`, `{BASE_SHA}`, `{HEAD_SHA}`, `{WORK_DIR}`, `{FILE_PATH}`, `{LINE_NUMBERS}`, `{CONCERN_NAME}`, `{CONCERN_FILE_CONTENT}`, `{DESCRIPTION}`

**手順:**
1. PR 差分・コードベースの文脈を収集
2. リファクタリング後のコードを考察して出力
3. リファクタリング前後を比較して効果を評価
4. 重大度を評価し `{WORK_DIR}/result-{SUB_AGENT_NUMBER}.md` に出力
5. 自己批判的考察・追加調査を行い、必要なら結果を修正
6. 最終内容をユーザーに表示

**重大度分類（`my-code-smell-review` と共通）:**
- `must`: 意図しない混入や壊れる可能性が高い客観的誤り
- `imo`: 正解が1つでなく、作者が反論すれば議論になり得るもの
- `nits`: 正誤は明白だが比較的どうでも良いもの
- `ask`: 情報が足りず作者に質問したいもの
- `reject`: レビューコメントとして指摘するほどではないもの

**出力:** `{WORK_DIR}/result-{SUB_AGENT_NUMBER}.md`

### 最終レポート（report.md）

- `reject` 評価の指摘は除外
- PR レビューコメントとして直接コピペできる形式
- 各指摘の先頭に `[重大度]` ラベルを付与

---

## concerns/ ファイルの構成

各ファイルは「定義・典型例・リファクタリング指針」の構成で記述する。
`my-code-smell-review/smells/*.md` と同じスタイル。

| ファイル | 観点 | 主なチェック内容 |
|---|---|---|
| `layering.md` | レイヤー違反 | Controller が Repository/DB を直接参照、Presenter がビジネスロジックを持つ |
| `responsibility.md` | 責務漏出 | Service が複数ドメインをまたぐロジックを持つ、1クラスが複数の理由で変わりうる |
| `coupling.md` | 密結合 | 具象クラスへの直接依存、循環依存、不必要な import の増加 |
| `solid.md` | SOLID 違反 | SRP / OCP / LSP / ISP / DIP それぞれの典型的違反パターン |
| `boundary.md` | 境界侵害 | ドメイン層がインフラ層を知っている、レイヤー外部へのコンセプト漏れ |

---

## `my-code-smell-review` との主な差異

| 項目 | code-smell-review | architecture-review |
|---|---|---|
| finder の並列数 | 1観点 × 2モデル = 2 | 5観点 × 2モデル = 10 |
| 重複排除ステップ | なし | あり（同一箇所を複数 finder が指摘した場合マージ） |
| concerns ファイル | `smells/*.md`（23種） | `concerns/*.md`（5観点） |
| 重大度分類 | 共通 | 共通 |
| 出力形式 | PR コメント形式 | PR コメント形式 |
