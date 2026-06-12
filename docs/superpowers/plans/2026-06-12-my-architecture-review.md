# my-architecture-review スキル 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `my-code-smell-review` と同じ「finder → reviewer」パイプラインで、アーキテクチャ観点のコードレビューを行う Copilot CLI スキルを作成する。

**Architecture:** SKILL.md がエントリーポイントとして git SHA を取得し、manager サブエージェントを起動する。manager は5観点 × 2モデル = 10並列 finder を起動し、重複排除後に発見ごとに reviewer を並列起動して最終レポートを生成する。

**Tech Stack:** Copilot CLI skills（Markdown テンプレート）、gpt-5.4、claude-opus-4.6

---

## ファイル構成

| ファイル | 操作 | 役割 |
|---|---|---|
| `home/.copilot/skills/my-architecture-review/SKILL.md` | 新規作成 | エントリーポイント |
| `home/.copilot/skills/my-architecture-review/architecture-review-manager.md` | 新規作成 | マネージャーエージェントのテンプレート |
| `home/.copilot/skills/my-architecture-review/architecture-review-finder.md` | 新規作成 | finder エージェントのテンプレート（観点・モデルで共用） |
| `home/.copilot/skills/my-architecture-review/architecture-review-reviewer.md` | 新規作成 | reviewer エージェントのテンプレート（発見ごとに共用） |
| `home/.copilot/skills/my-architecture-review/concerns/layering.md` | 新規作成 | レイヤー違反の解説 |
| `home/.copilot/skills/my-architecture-review/concerns/responsibility.md` | 新規作成 | 責務漏出の解説 |
| `home/.copilot/skills/my-architecture-review/concerns/coupling.md` | 新規作成 | 密結合の解説 |
| `home/.copilot/skills/my-architecture-review/concerns/solid.md` | 新規作成 | SOLID 違反の解説 |
| `home/.copilot/skills/my-architecture-review/concerns/boundary.md` | 新規作成 | 境界侵害の解説 |

---

### Task 1: スキルディレクトリと SKILL.md の作成

**Files:**
- Create: `home/.copilot/skills/my-architecture-review/SKILL.md`

- [ ] **Step 1: ディレクトリ作成**

```bash
mkdir -p home/.copilot/skills/my-architecture-review/concerns
```

- [ ] **Step 2: SKILL.md を作成**

`home/.copilot/skills/my-architecture-review/SKILL.md` を以下の内容で作成する:

```markdown
---
name: my-architecture-review
description: エージェントではなくユーザーに呼び出されるスキル。アーキテクチャの観点からコードをレビューする。
---

# My Architecture Review

## 概要

この skill は、アーキテクチャの観点からコードをレビューする。

レビューは subagent を起動して実行する。
それによりコンテキストに依存しない、客観的なレビューを得る。

## タスク

1. **git の SHA を取得:**

    ``` sh
    BASE_SHA=$(git merge-base origin/main HEAD)
    HEAD_SHA=$(git rev-parse HEAD)
    ```

2. **カスタムエージェントの起動:**

    `architecture-review-manager.md` というファイルに subagent の挙動のテンプレートが定義されています。
    ただし、 テンプレートにはいくつかのプレースホルダがあるので、それらを埋めたものを subagent に指示として渡してください。

    * **プレースホルダ:**

        + `{BASE_SHA}`: 比較のベースとなるコミット
        + `{HEAD_SHA}`: 比較の対象となるコミット
```

- [ ] **Step 3: プレースホルダ確認**

```bash
grep -c 'BASE_SHA\|HEAD_SHA' home/.copilot/skills/my-architecture-review/SKILL.md
```

期待値: `2`（両方のプレースホルダが存在すること）

- [ ] **Step 4: コミット**

```bash
git add home/.copilot/skills/my-architecture-review/SKILL.md
git commit -m "Add SKILL.md for my-architecture-review"
```

---

### Task 2: concerns/ ファイルの作成（5観点）

**Files:**
- Create: `home/.copilot/skills/my-architecture-review/concerns/layering.md`
- Create: `home/.copilot/skills/my-architecture-review/concerns/responsibility.md`
- Create: `home/.copilot/skills/my-architecture-review/concerns/coupling.md`
- Create: `home/.copilot/skills/my-architecture-review/concerns/solid.md`
- Create: `home/.copilot/skills/my-architecture-review/concerns/boundary.md`

- [ ] **Step 1: `concerns/layering.md` を作成**

```markdown
# レイヤー違反（Layering Violation）

<https://martinfowler.com/bliki/LayeredArchitecture.html>

## 兆候と症状

レイヤードアーキテクチャにおいて、上位レイヤーが下位レイヤーを直接知りすぎているか、
あるいは下位レイヤーが上位レイヤーを参照している。

例:
- Controller（プレゼンテーション層）が Repository や DB クエリを直接呼び出している
- Service（ビジネス層）が HTTP リクエスト・レスポンスオブジェクトを参照している
- Repository（データ層）がビジネスロジックを持っている
- Presenter / View が DB モデルを直接扱っている

## 原因

「急いで動かしたい」というプレッシャーや、レイヤーの役割の理解不足から、
最短距離で実装するために層を飛ばして直接アクセスしてしまう。
小さいコードベースでは問題が見えにくく、後から修正しにくい技術的負債になりやすい。

## 治療法

- 下位レイヤーへのアクセスは必ず隣接する層を経由する
- Controller はビジネスロジックを持たず、Service に委譲する
- Service はデータアクセスを直接行わず、Repository インターフェース経由でアクセスする
- 依存の方向を一方向に保ち、循環参照を作らない
- インターフェース（抽象）を使い、具象実装への直接依存を避ける

## 効果

- 各レイヤーを独立してテスト・差し替えできるようになる
- プレゼンテーション層を変更してもビジネスロジックに影響しない
- データストアを変更してもビジネスロジックに影響しない
```

- [ ] **Step 2: `concerns/responsibility.md` を作成**

```markdown
# 責務漏出（Responsibility Leakage）

<https://martinfowler.com/bliki/SingleResponsibilityPrinciple.html>

## 兆候と症状

あるクラスやモジュールが、本来持つべき責務以外の処理を担っている。
または、本来別のモジュールが担うべき処理がこのモジュールに漏れ込んでいる。

例:
- Service クラスが複数の独立したドメインロジックを1つにまとめている
- Repository クラスがビジネスルールの検証を行っている
- Controller クラスが複雑なデータ変換・整形ロジックを持っている
- ユーティリティクラスが特定のドメインに強く依存した処理を持っている
- 1つのクラスが変更される理由が2つ以上ある

## 原因

既存のクラスに「ちょっとだけ似た処理」を追加し続けることで、
気づかないうちに複数の責務が混在するようになる。
「新しいクラスを作るのが面倒」という心理も原因になりやすい。

## 治療法

- 1クラス・1モジュールは1つの責務のみを持つ（Single Responsibility Principle）
- クラスを変更する理由が複数あれば、クラスを分割する
- ドメインサービス・アプリケーションサービス・インフラサービスの役割を明確に分ける
- Extract Class リファクタリングで責務を分離する

## 効果

- クラスの目的が明確になり、読みやすくなる
- 1つの変更が他の責務に影響しなくなる
- テストが書きやすくなる（テスト対象が明確になる）
```

- [ ] **Step 3: `concerns/coupling.md` を作成**

```markdown
# 密結合（Tight Coupling）

<https://martinfowler.com/ieeeSoftware/coupling.pdf>

## 兆候と症状

クラスやモジュール間の依存が過度に強く、一方を変更すると他方にも影響が波及する。

例:
- 具象クラスを直接 new して使っている（インターフェース経由でない）
- 循環依存がある（A が B に依存し、B が A に依存）
- あるモジュールが他モジュールの内部実装（プライベートなメソッドや構造）に依存している
- 変更の波及を防ぐために大量の import が必要になっている
- テストのためにモック/スタブへの差し替えが困難

## 原因

設計初期に「とりあえず動く」形で実装し、インターフェースの抽出を後回しにしていると、
具象クラスへの直接依存が積み重なる。
依存性注入（DI）パターンの未適用も原因になりやすい。

## 治療法

- 具象クラスではなくインターフェース（抽象）に依存する（Dependency Inversion Principle）
- 依存性注入（DI）を使い、依存オブジェクトを外部から渡す
- 循環依存は設計の問題を示すことが多く、責務の分離や中間インターフェースの導入で解消する
- 関連する変更が一緒に起きるものはまとめ、独立して変更されるものは分離する

## 効果

- コンポーネントを独立してテスト・差し替えできるようになる
- 変更の影響範囲が局所化される
- コードの再利用性が上がる
```

- [ ] **Step 4: `concerns/solid.md` を作成**

```markdown
# SOLID 原則違反（SOLID Violations）

<https://en.wikipedia.org/wiki/SOLID>

## 単一責任原則（SRP: Single Responsibility Principle）

### 兆候と症状

- クラスやモジュールが変更される理由が2つ以上ある
- 1つのクラスがデータ変換・バリデーション・保存・通知など複数の処理を担っている

### 治療法

- クラスを分割し、各クラスが1つの責務のみを持つようにする

---

## 開放閉鎖原則（OCP: Open/Closed Principle）

### 兆候と症状

- 新機能追加のたびに既存クラスの内部を修正しなければならない
- 長い if-else や switch 文が機能追加のたびに伸び続けている

### 治療法

- ポリモーフィズム（継承・インターフェース）や Strategy パターンを使い、既存コードを変更せずに拡張できる設計にする

---

## リスコフの置換原則（LSP: Liskov Substitution Principle）

### 兆候と症状

- サブクラスが親クラスの前提条件を強めたり事後条件を弱めたりしている
- サブクラスのメソッドが NotImplementedException を投げている
- ポリモーフィックな呼び出し箇所で instanceof チェックが必要

### 治療法

- サブクラスは親クラスと置き換え可能な振る舞いを持つように設計する
- 置き換えできない場合は継承でなく委譲を検討する

---

## インターフェース分離原則（ISP: Interface Segregation Principle）

### 兆候と症状

- インターフェースが大きすぎて、実装クラスが使わないメソッドを実装している
- インターフェースに無関係なメソッドが混在している

### 治療法

- 小さく役割の明確なインターフェースに分割する

---

## 依存性逆転原則（DIP: Dependency Inversion Principle）

### 兆候と症状

- 上位モジュールが下位モジュールの具象クラスに直接依存している
- new で具象クラスを直接生成している

### 治療法

- 上位モジュールはインターフェース（抽象）に依存し、具体的な実装は外部から注入する（依存性注入）
```

- [ ] **Step 5: `concerns/boundary.md` を作成**

```markdown
# 境界侵害（Boundary Violation）

<https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html>

## 兆候と症状

アーキテクチャの境界（ドメイン / アプリケーション / インフラ / プレゼンテーション）が侵食されている。
依存の方向がアーキテクチャの設計意図に反している。

例:
- ドメイン層（エンティティ、値オブジェクト）がインフラ層（ORM、HTTP クライアント、外部 API）を知っている
- ドメインモデルが特定のフレームワークのアノテーション・基底クラスに依存している
- ユースケース層がフレームワーク固有のオブジェクト（HTTPRequest、DBSession 等）を直接受け取っている
- インフラ層の概念（テーブル構造、API レスポンス形状）がドメインモデルに漏れている
- 複数の境界コンテキスト（Bounded Context）間で内部実装が直接共有されている

## 原因

フレームワークやライブラリの使い方を優先し、ドメインモデルの設計を後回しにしたときに起きやすい。
「フレームワークが推奨する設計」に従うだけでは、ドメインの純粋性が損なわれることがある。

## 治療法

- 依存の方向は常に外側（インフラ・プレゼンテーション）から内側（ドメイン）へ向ける
- ドメイン層はフレームワーク・ライブラリに依存しない pure なコードにする
- アンチコラプションレイヤー（ACL）を設け、外部の概念がドメインに入り込まないようにする
- DTO / ViewModel を使い、層をまたぐデータ変換を明示的に行う
- Bounded Context 間の通信はインターフェース経由で行い、実装を直接共有しない

## 効果

- ドメインロジックをフレームワークなしで単体テストできるようになる
- フレームワークの変更・アップグレードがドメインに影響しなくなる
- ドメインモデルが業務ルールを純粋に表現できるようになる
```

- [ ] **Step 6: concerns ファイルが5つ揃っていることを確認**

```bash
ls home/.copilot/skills/my-architecture-review/concerns/
```

期待値: `boundary.md  coupling.md  layering.md  responsibility.md  solid.md`

- [ ] **Step 7: コミット**

```bash
git add home/.copilot/skills/my-architecture-review/concerns/
git commit -m "Add concerns files for my-architecture-review"
```

---

### Task 3: architecture-review-finder.md の作成

**Files:**
- Create: `home/.copilot/skills/my-architecture-review/architecture-review-finder.md`

- [ ] **Step 1: `architecture-review-finder.md` を作成**

```markdown
# アーキテクチャ問題発見エージェント

あなたは、特定のレビュータスクのために起動されたサブエージェントです。
あなたはメインの対話 agent ではありませんので、 `using-superpowers` などのスキル実行は不要です。

## レビュー対象となる差分

**Base コミット:** `{BASE_SHA}`
**Head コミット:** `{HEAD_SHA}`

## あなたの観点

**観点:** `{CONCERN_NAME}`

{CONCERN_FILE_CONTENT}

## あなたのタスク

あなたは上記の観点に特化してアーキテクチャ上の問題を見つけることに集中するエージェントです。

1. **PR 情報の収集:**

    BASE と HEAD の差分を作成したり、このプロジェクトのコードベースを分析したりして、レビューに必要な情報を収集してください。

2. **アーキテクチャ問題の発見:**

    上記の観点に照らし合わせ、問題箇所をできるだけ多く見つけ (後で再評価するので今はできるだけ多く)、
    以下の形式で問題を列挙した md レポートを `{WORK_DIR}/finder-{CONCERN_NAME}-{MODEL}.md` に作成し、そのレポートのフルパス、および、全内容をユーザーに返してください。

    例:

    ```
    ## hoge/fuga.ts: 10-35

    レイヤー違反（Layering Violation）

    解説ファイル: `./concerns/layering.md`
    説明: Controller が Repository を直接 new している。

    これこれこういう理由でアーキテクチャ上の問題がある。

    10-15 行目付近のコードスニペット
    ```
```

- [ ] **Step 2: 必須プレースホルダが全て含まれているか確認**

```bash
for p in BASE_SHA HEAD_SHA WORK_DIR CONCERN_NAME MODEL CONCERN_FILE_CONTENT; do
  grep -q "$p" home/.copilot/skills/my-architecture-review/architecture-review-finder.md \
    && echo "OK: $p" || echo "MISSING: $p"
done
```

期待値: 全て `OK:` であること

- [ ] **Step 3: コミット**

```bash
git add home/.copilot/skills/my-architecture-review/architecture-review-finder.md
git commit -m "Add architecture-review-finder.md"
```

---

### Task 4: architecture-review-reviewer.md の作成

**Files:**
- Create: `home/.copilot/skills/my-architecture-review/architecture-review-reviewer.md`

- [ ] **Step 1: `architecture-review-reviewer.md` を作成**

```markdown
# アーキテクチャ問題評価エージェント

あなたは発見されたアーキテクチャ問題を評価するためのサブエージェントです。
あなたはメインの対話 agent ではありませんので、 `using-superpowers` などのスキル実行は不要です。

* **あなたのエージェント番号:** `{SUB_AGENT_NUMBER}`
* **調査対象コード:** `{FILE_PATH}`: `{LINE_NUMBERS}`
* **観点:** `{CONCERN_NAME}`

## レビュー対象となる差分

**Base コミット:** `{BASE_SHA}`
**Head コミット:** `{HEAD_SHA}`

## 検出理由

{DESCRIPTION}

## あなたのタスク

1. **PR 情報の収集:**

    BASE と HEAD の差分を作成したり、このプロジェクトのコードベースを分析したりして、レビューに必要な情報を収集してください。

2. **リファクタリング後のコードの予想:**

    発見されたアーキテクチャ問題について、リファクタリング後のコードがどのようになるかを考察し、出力してください。

3. **リファクタリング前後の比較:**

    リファクタリング後のコードと、リファクタリング前のコードを比較して、リファクタリングの効果を評価してください。

4. **評価:**

    評価を以下の形式で返してください。
    結果は `{WORK_DIR}/result-{SUB_AGENT_NUMBER}.md` に出力してください。

    ```
    # {SUB_AGENT_NUMBER}: {CONCERN_NAME}

    * 重大度: (
        must: 意図しない混入だったり壊れる可能性が高いもので客観的誤りといえるもの,
        imo: 正解が1つではなく、作者が反論すれば議論になり得るもの,
        nits: 正誤は明白なものの、比較的どうでも良いもの,
        ask: より情報が必要で、作者に質問したいもの,
        reject: レビューコメントとして指摘するほどではないもの)

    ## 検出理由

    {DESCRIPTION}

    ## リファクタリング前のコード

    {PRE_REFACTORING_CODE_SNIPPET}

    ## リファクタリング後のコード

    {POST_REFACTORING_CODE_SNIPPET}

    ## 評価

    これこれこういう理由で、このコードはアーキテクチャ上問題がある。
    どのようなリファクタリングを適用するべきである。
    作者に対して質問がある場合は、質問もここに記載する。
    ```

5. **評価の修正:**

    `{WORK_DIR}/result-{SUB_AGENT_NUMBER}.md` に出力された最終的な評価を、批判的に考察してください。
    疑わしい箇所を見つけて追加の調査を行い、訂正したほうが良い箇所がある場合は、修正してください。

6. **結果出力:**

    `{WORK_DIR}/result-{SUB_AGENT_NUMBER}.md` のフルパス、及び、最終的なその内容をユーザーに表示してください。

---

{CONCERN_FILE_CONTENT}
```

- [ ] **Step 2: 必須プレースホルダが全て含まれているか確認**

```bash
for p in SUB_AGENT_NUMBER FILE_PATH LINE_NUMBERS CONCERN_NAME BASE_SHA HEAD_SHA WORK_DIR DESCRIPTION CONCERN_FILE_CONTENT; do
  grep -q "$p" home/.copilot/skills/my-architecture-review/architecture-review-reviewer.md \
    && echo "OK: $p" || echo "MISSING: $p"
done
```

期待値: 全て `OK:` であること

- [ ] **Step 3: step 4・5・6 で `result-{SUB_AGENT_NUMBER}.md` のパスが一貫していることを確認**

```bash
grep 'result-' home/.copilot/skills/my-architecture-review/architecture-review-reviewer.md
```

期待値: `result-{SUB_AGENT_NUMBER}.md` が step 4, 5, 6 の全てで使われていること（`{SUB_AGENT_NUMBER}.md` のみの行がないこと）

- [ ] **Step 4: コミット**

```bash
git add home/.copilot/skills/my-architecture-review/architecture-review-reviewer.md
git commit -m "Add architecture-review-reviewer.md"
```

---

### Task 5: architecture-review-manager.md の作成

**Files:**
- Create: `home/.copilot/skills/my-architecture-review/architecture-review-manager.md`

- [ ] **Step 1: `architecture-review-manager.md` を作成**

```markdown
# アーキテクチャレビュー用マネージャーエージェント

あなたは、特定のレビュータスクのために起動されたサブエージェントです。
あなたはメインの対話 agent ではありませんので、 `using-superpowers` などのスキル実行は不要です。

## レビュー対象となる差分

**Base コミット:** `{BASE_SHA}`
**Head コミット:** `{HEAD_SHA}`

## あなたのタスク

あなたはアーキテクチャ上の問題を見つけるため、各種サブエージェントを働かせるマネージャーです。

1. **作業ディレクトリの作成:**

    `architecture-review-YYYY-MM-DD-hh-mm-ss/` という名前で、作業用のディレクトリを作成してください。
    このディレクトリを WORK_DIR と呼びます。
    必ず `/tmp` のようなテンポラリディレクトリ、あるいは、セッションディレクトリの下に WORK_DIR を作成してください。
    作成できない場合は直ちに処理を中止してください。

2. **アーキテクチャ問題発見エージェントの起動:**

    `./architecture-review-finder.md` というテンプレートを読み込み、テンプレート内のプレースホルダを以下に置き換え、
    それをサブエージェントへの指示として、サブエージェントを起動してください。

    以下の5観点それぞれを `gpt-5.4` と `claude-opus-4.6` の2種類のモデルで best effort で起動し（計10並列）、それぞれの結果を待ちます。

    **観点一覧:**
    * `layering` : `./concerns/layering.md` の内容を `{CONCERN_FILE_CONTENT}` に使用
    * `responsibility` : `./concerns/responsibility.md` の内容を `{CONCERN_FILE_CONTENT}` に使用
    * `coupling` : `./concerns/coupling.md` の内容を `{CONCERN_FILE_CONTENT}` に使用
    * `solid` : `./concerns/solid.md` の内容を `{CONCERN_FILE_CONTENT}` に使用
    * `boundary` : `./concerns/boundary.md` の内容を `{CONCERN_FILE_CONTENT}` に使用

    **プレースホルダの置き換え:**

    * `{BASE_SHA}`: Base コミットハッシュをそのまま使用してください。
    * `{HEAD_SHA}`: Head コミットハッシュをそのまま使用してください。
    * `{WORK_DIR}`: WORK_DIR をそのまま使用してください。
    * `{MODEL}`: モデルの種類（`gpt-5.4` または `claude-opus-4.6`）。
    * `{CONCERN_NAME}`: 観点名（例: `layering`）。
    * `{CONCERN_FILE_CONTENT}`: 対応する concerns ファイルの全内容。

3. **重複発見の排除:**

    2の全 finder の結果から、同一ファイル・重複または近接した行範囲（10行以内）を指摘している発見を1件にまとめてください。
    複数の観点から同じ箇所が指摘された場合も、最も詳細な説明を残して1件にしてください。

4. **発見した各アーキテクチャ問題のレビュー:**

    `./architecture-review-reviewer.md` というテンプレートを読み込み、テンプレート内のプレースホルダを以下に置き換え、
    `{WORK_DIR}/prompt-{SUB_AGENT_NUMBER}.md` というファイルに書き出してください。

    それをサブエージェントへの指示として、サブエージェントを起動してください。
    排除後の全ての発見について、発見ごとにサブエージェントを並列起動してください。

    **プレースホルダの置き換え:**

    + `{SUB_AGENT_NUMBER}`: サブエージェントの番号を 1 から順に割り当ててください。
    + `{BASE_SHA}`: Base のコミットハッシュをそのまま使用してください。
    + `{HEAD_SHA}`: Head のコミットハッシュをそのまま使用してください。
    + `{WORK_DIR}`: WORK_DIR をそのまま使用してください。
    + `{FILE_PATH}`: アーキテクチャ問題が見つかったファイルのパスを、リポジトリのルートからの相対パスで指定してください。
    + `{LINE_NUMBERS}`: アーキテクチャ問題が見つかった行番号 (例: `10-25`)
    + `{CONCERN_NAME}`: 発見された観点名（例: `layering`）
    + `{CONCERN_FILE_CONTENT}`: 対応する concerns ファイルの全内容をそのまま使用してください。ファイルは `./concerns/` ディレクトリにあります。
    + `{DESCRIPTION}`: 2のレポートに書かれている説明をそのまま書いてください。

5. **最終レポートの作成:**

    4の各結果は `{WORK_DIR}/result-{SUB_AGENT_NUMBER}.md` に入っているはずです。
    それを元に、 `{WORK_DIR}/report.md` を作成してください。
    ここには、以下の形式で指摘事項を列挙した、最終的なレポートを書いてください。

    GitHub の PR のレビューコメントは、分割した複数コード行についてレビューコメントを書くことができないため、
    多少冗長であってもそれぞれ指摘が必要な箇所ごとに、以下のような形式で、レビューコメントを作成してください。

    重大度が `reject` と評価されている場合は、ここに記載しないでください。

    ```
    ## dir/filename.ts : 10-55

    github の PR のレビューコメントとして直接コピペできるような、AI感の少ない丁寧なレビューコメントを書く。
    先頭行には `[重大度]` のラベルをつける。

    例:

    [imo]
    [Layering Violation](https://martinfowler.com/bliki/LayeredArchitecture.html) の不吉な匂いがします。
    Controller が直接 Repository を new しており、依存の方向がドメイン層からインフラ層に向かっています。
    L20-L25 の処理は UserRepository インターフェースを注入する形に変更することで、
    テスト時にモックに差し替えられるようになり、またレイヤーの依存方向も正しくなります。
    ```
```

- [ ] **Step 2: 必須プレースホルダが全て含まれているか確認**

```bash
for p in BASE_SHA HEAD_SHA; do
  grep -q "$p" home/.copilot/skills/my-architecture-review/architecture-review-manager.md \
    && echo "OK: $p" || echo "MISSING: $p"
done
```

期待値: 全て `OK:` であること

- [ ] **Step 3: 5観点が全て記載されているか確認**

```bash
for c in layering responsibility coupling solid boundary; do
  grep -q "$c" home/.copilot/skills/my-architecture-review/architecture-review-manager.md \
    && echo "OK: $c" || echo "MISSING: $c"
done
```

期待値: 全て `OK:` であること

- [ ] **Step 4: コミット**

```bash
git add home/.copilot/skills/my-architecture-review/architecture-review-manager.md
git commit -m "Add architecture-review-manager.md"
```

---

### Task 6: 最終確認

- [ ] **Step 1: 全ファイルが揃っているか確認**

```bash
find home/.copilot/skills/my-architecture-review/ -type f | sort
```

期待値（9ファイル）:
```
home/.copilot/skills/my-architecture-review/SKILL.md
home/.copilot/skills/my-architecture-review/architecture-review-finder.md
home/.copilot/skills/my-architecture-review/architecture-review-manager.md
home/.copilot/skills/my-architecture-review/architecture-review-reviewer.md
home/.copilot/skills/my-architecture-review/concerns/boundary.md
home/.copilot/skills/my-architecture-review/concerns/coupling.md
home/.copilot/skills/my-architecture-review/concerns/layering.md
home/.copilot/skills/my-architecture-review/concerns/responsibility.md
home/.copilot/skills/my-architecture-review/concerns/solid.md
```

- [ ] **Step 2: reviewer のファイルパスが一貫していることを最終確認**

```bash
# result- プレフィックスのないパスが reviewer に存在しないことを確認
grep '{SUB_AGENT_NUMBER}.md' home/.copilot/skills/my-architecture-review/architecture-review-reviewer.md | grep -v 'result-'
```

期待値: 出力なし（全て `result-{SUB_AGENT_NUMBER}.md` になっている）

- [ ] **Step 3: git log で全コミットを確認**

```bash
git --no-pager log --oneline -5
```

期待値: Task 1〜5 のコミットが全て確認できること
