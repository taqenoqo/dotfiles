# モデル解決スキル 設計ドキュメント

## 概要

現在の harness / ローカル環境に応じた**具体的なモデル名**を返す個人用スキル。
このスキル自身はモデル選定ロジックを持たず、外部で決定された抽象 tier
（`low` / `medium` / `high`）に対して、ローカル設定ファイルまたは内蔵
フォールバックから対応するモデル名を解決する。

---

## 目的

- エージェントがモデル選定を必要とする場面で、現在環境向けの具体モデル名を
  一貫して参照できるようにする
- ローカルごとの差分は専用設定ファイルに閉じ込める
- スキル本体は discovery しやすい薄い reference skill に保つ

---

## ディレクトリ構成

```
home/.copilot/skills/model-resolution/
  SKILL.md              ← エントリーポイント
  defaults.md           ← 設定ファイルがない場合の内蔵フォールバック

home/.config/ai/
  models.yaml           ← ローカル優先のモデル対応表
```

---

## 全体フロー

```
外部ロジック
  ↓ requested tier を決める（low / medium / high）
model-resolution/SKILL.md
  ↓ 現在の harness 名と requested tier を受け取る
  ↓ ~/.config/ai/models.yaml を読む
  ↓ 該当エントリがあれば具体モデル名を返す
  ↓ なければ defaults.md のフォールバックを返す
```

---

## 各ファイルの責務

### SKILL.md（エントリーポイント）

- モデル選定が必要な場面で使うことを description で discovery させる
- 呼び出し元がすでに決めた `low` / `medium` / `high` を入力として扱う
- 現在の harness 名に対応する `~/.config/ai/models.yaml` の値を読む
- 該当値がなければ `defaults.md` を参照する
- 最終的に、現在環境で使うべき**具体モデル名**だけを返す

### defaults.md

- `models.yaml` が存在しない場合の既定値を記載する
- harness ごとに `low` / `medium` / `high` の対応を書く
- スキル本文を肥大化させず、既定値の見通しをよくする

### `~/.config/ai/models.yaml`

- ローカルごとの差分をここに閉じ込める
- 役割は「抽象 tier を具体モデル名へ写像すること」のみ
- タスク分類や複雑度判定は持たない

---

## 設定ファイル仕様

`models.yaml` は harness ごとに `low` / `medium` / `high` を持つ最小構成とする。

```yaml
copilot-cli:
  low: gpt-5-mini
  medium: gpt-5.4
  high: claude-opus-4.6
```

必要なら複数 harness を並べてよい。

```yaml
copilot-cli:
  low: gpt-5-mini
  medium: gpt-5.4
  high: claude-opus-4.6

codex:
  low: gpt-5-mini
  medium: gpt-5.4
  high: gpt-5.4
```

---

## 優先順位

1. `~/.config/ai/models.yaml` に現在の harness と requested tier の対応がある場合はそれを採用する
2. `models.yaml` が存在しない、または該当 harness / tier がない場合は `defaults.md` を採用する

このスキルは `AGENTS.md` や `CLAUDE.md` などの探索は行わない。探索先を
1ファイルに固定し、挙動を安定させる。

---

## 入出力の前提

### 入力

- 現在の harness 名（例: `copilot-cli`, `codex`, `claude-code`）
- 外部ロジックが決めた requested tier（`low` / `medium` / `high`）

### 出力

- 現在環境で使うべき具体モデル名
- 可能なら解決元
  - `Source: ~/.config/ai/models.yaml`
  - `Source: defaults.md`

出力例:

```text
Requested tier: medium
Recommended model: gpt-5.4
Source: ~/.config/ai/models.yaml
```

---

## スコープ外

- `low` / `medium` / `high` の判定ロジック
- subagent の自動起動
- モデル選定結果の強制適用
- harness ごとの agent_type ルーティング

これらは呼び出し元または別のロジックが担う。本スキルは**具体モデル名の供給**
だけに責務を絞る。

---

## 期待される効能

- 「今の環境で low tier は何か」が毎回ぶれない
- skill 側に環境固有のモデル名を埋め込みすぎずに済む
- モデル更新時は `models.yaml` の変更だけでローカル反映できる
- タスク判定ロジックと具体モデル名辞書を分離できる
