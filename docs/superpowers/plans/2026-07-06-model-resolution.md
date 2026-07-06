# モデル解決スキル Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `low` / `medium` / `high` の tier を、現在の `copilot-cli` 環境で使う具体モデル名へ安定して解決する個人用 skill を追加する。

**Architecture:** `home/.config/ai/AGENTS.md` に共有の誘導文を追加し、モデル選定時に `model-resolution` skill を参照させる。skill 本体は `~/.config/ai/models.yaml` を最優先で読み、該当エントリがない場合だけ `defaults.md` のフォールバックを返す。初期の実モデル対応は `copilot-cli` のみを扱う。

**Tech Stack:** Copilot CLI custom skills（Markdown）、共有 AI 指示（AGENTS.md）、YAML 設定ファイル

## Global Constraints

- この skill は**具体モデル名の供給だけ**を担当し、`low` / `medium` / `high` の判定ロジックは持たない。
- ローカル上書きは `~/.config/ai/models.yaml` だけを探索対象にし、`AGENTS.md` や `CLAUDE.md` の探索には広げない。
- `~/.config/ai/models.yaml` に現在の harness と requested tier の対応があればそれを優先し、なければ `defaults.md` を使う。
- 初期の具体モデル対応は `copilot-cli` のみとし、`low=gpt-5-mini`、`medium=gpt-5.4`、`high=claude-opus-4.6` を使う。
- `home/.copilot/skills/model-resolution/` を編集する前に、必ず `superpowers:writing-skills` を invoke して RED-GREEN-REFACTOR に従う。

---

## ファイル構成

| ファイル | 操作 | 役割 |
|---|---|---|
| `home/.config/ai/AGENTS.md` | 変更 | モデル選定時に `model-resolution` skill を使う共有指示を追加する |
| `home/.config/ai/models.yaml` | 新規作成 | `copilot-cli` 用の `low` / `medium` / `high` → 具体モデル名のローカル対応表 |
| `home/.copilot/skills/model-resolution/defaults.md` | 新規作成 | `models.yaml` に該当値がないときの内蔵フォールバック |
| `home/.copilot/skills/model-resolution/SKILL.md` | 新規作成 | 現在の harness と requested tier から具体モデル名を返す entry skill |

---

### Task 1: 共有誘導文を `home/.config/ai/AGENTS.md` に追加する

**Files:**
- Modify: `home/.config/ai/AGENTS.md`

**Interfaces:**
- Consumes: 既存の共有 AI 指示ファイル
- Produces: `model-resolution` skill をモデル選定時に使う明示的な共有ルール

- [ ] **Step 1: 追加前に `model-resolution` の共有誘導文がまだないことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && rg -n "model-resolution" home/.config/ai/AGENTS.md
```

Expected: no matches, exit code `1`

- [ ] **Step 2: `## モデル選定` セクションを追加する**

`home/.config/ai/AGENTS.md` に以下の patch を適用する:

```diff
*** Begin Patch
*** Update File: home/.config/ai/AGENTS.md
@@
 * 特定のコマンド、ツール、ソフトウェア、ライブラリ、フレームワーク、サービスなどに関する作業や質問の場合、最新情報をインターネットで検索すること。
+
+## モデル選定
+
+* モデル選定が必要な場合は、まず `model-resolution` skill を使って現在の harness での具体モデル名を取得すること。
+* `low` / `medium` / `high` の tier 判定は呼び出し元で行い、この skill には tier を渡すこと。
+* `~/.config/ai/models.yaml` に現在の harness の対応があればそれを優先し、なければ skill の内蔵フォールバックを使うこと。
*** End Patch
```

- [ ] **Step 3: 追加した 3 行が入ったことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && rg -n 'model-resolution|models.yaml|内蔵フォールバック' home/.config/ai/AGENTS.md
```

Expected: 3 matches

- [ ] **Step 4: コミットする**

```bash
cd /Users/okamoto_n/dotfiles && git add home/.config/ai/AGENTS.md && git commit -m "ai: add model-resolution guidance"
```

---

### Task 2: `copilot-cli` 用のローカルモデル対応表を作成する

**Files:**
- Create: `home/.config/ai/models.yaml`

**Interfaces:**
- Consumes: Task 1 の共有ルール（`~/.config/ai/models.yaml` を最優先する）
- Produces: `copilot-cli.low`, `copilot-cli.medium`, `copilot-cli.high`

- [ ] **Step 1: `models.yaml` がまだ存在しないことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && test -f home/.config/ai/models.yaml
```

Expected: exit code `1`

- [ ] **Step 2: `models.yaml` を作成する**

`home/.config/ai/models.yaml` を以下の内容で作成する:

```yaml
copilot-cli:
  low: gpt-5-mini
  medium: gpt-5.4
  high: claude-opus-4.6
```

- [ ] **Step 3: `copilot-cli` と 3 tier の対応が入ったことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && rg -n "^copilot-cli:$|^  low: gpt-5-mini$|^  medium: gpt-5.4$|^  high: claude-opus-4.6$" home/.config/ai/models.yaml
```

Expected: 4 matches

- [ ] **Step 4: コミットする**

```bash
cd /Users/okamoto_n/dotfiles && git add home/.config/ai/models.yaml && git commit -m "ai: add local model mapping"
```

---

### Task 3: フォールバック定義 `defaults.md` を作成する

**Files:**
- Create: `home/.copilot/skills/model-resolution/defaults.md`

**Interfaces:**
- Consumes: Task 2 の `copilot-cli.low|medium|high` 契約
- Produces: `models.yaml` に該当値がないときに読む `copilot-cli` 向け既定マッピング

- [ ] **Step 1: skill ディレクトリを作成し、`defaults.md` がまだ存在しないことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && mkdir -p home/.copilot/skills/model-resolution && test -f home/.copilot/skills/model-resolution/defaults.md
```

Expected: exit code `1`

- [ ] **Step 2: `defaults.md` を作成する**

`home/.copilot/skills/model-resolution/defaults.md` を以下の内容で作成する:

```markdown
# model-resolution defaults

`~/.config/ai/models.yaml` に現在の harness と requested tier の対応がない場合だけ、
このファイルの既定値を使う。

## copilot-cli

- `low`: `gpt-5-mini`
- `medium`: `gpt-5.4`
- `high`: `claude-opus-4.6`

## 返答形式

```text
Requested tier: <low|medium|high>
Recommended model: <model-name>
Source: defaults.md
```

## ルール

- requested tier は呼び出し元が決める。このファイルは tier 判定をしない。
- `AGENTS.md` や `CLAUDE.md` は探索しない。
- `models.yaml` の該当値がある場合は、必ずそちらを優先する。
```

- [ ] **Step 3: 既定マッピングと返答形式が入ったことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && rg -n "^## copilot-cli$|gpt-5-mini|gpt-5.4|claude-opus-4.6|^## 返答形式$|Source: defaults.md" home/.copilot/skills/model-resolution/defaults.md
```

Expected: 6 matches

- [ ] **Step 4: コミットする**

```bash
cd /Users/okamoto_n/dotfiles && git add home/.copilot/skills/model-resolution/defaults.md && git commit -m "ai: add model-resolution defaults"
```

---

### Task 4: `model-resolution` skill を作成する

**Files:**
- Create: `home/.copilot/skills/model-resolution/SKILL.md`

**Interfaces:**
- Consumes: `~/.config/ai/models.yaml`、`defaults.md`、Task 1 の共有誘導文
- Produces: `model-resolution` skill（入力: requested tier と harness 名、出力: 具体モデル名と解決元）

- [ ] **Step 1: `superpowers:writing-skills` を invoke してから作業を始める**

この task を始める前に、この会話で `writing-skills` skill を invoke する。
`home/.copilot/skills/model-resolution/` 以下を編集するのは、その後に限定する。

- [ ] **Step 2: `SKILL.md` がまだ存在しないことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && test -f home/.copilot/skills/model-resolution/SKILL.md
```

Expected: exit code `1`

- [ ] **Step 3: `SKILL.md` を作成する**

`home/.copilot/skills/model-resolution/SKILL.md` を以下の内容で作成する:

```markdown
---
name: model-resolution
description: Use when the agent must turn a requested low, medium, or high capability tier into a concrete model name for the current harness, especially before any task or subagent dispatch that requires explicit model selection.
---

# Model Resolution

## 概要

この skill は、呼び出し元がすでに決めた `low` / `medium` / `high` を、
現在の harness で使う具体モデル名に変換する。

この skill は tier 判定をしない。具体モデル名だけを返す。

## 手順

1. requested tier と現在の harness 名を確認する。
2. `~/.config/ai/models.yaml` を読む。
3. 現在の harness に requested tier の対応があれば、それを返す。
4. なければ `defaults.md` を読む。
5. `defaults.md` に該当 tier の対応があれば、それを返す。
6. 返答は次の形式にする。

```text
Requested tier: medium
Recommended model: gpt-5.4
Source: ~/.config/ai/models.yaml
```

## ルール

- `low` / `medium` / `high` の判定はしない。
- `AGENTS.md` や `CLAUDE.md` を探索しない。
- 具体モデル名を返すときは、どのファイルから解決したかも添える。
- `~/.config/ai/models.yaml` に該当値がある場合は、必ず `defaults.md` より優先する。
```

- [ ] **Step 4: skill の discovery 条件と参照先が入ったことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && rg -n "^name: model-resolution$|^description: Use when the agent must turn a requested low, medium, or high capability tier into a concrete model name for the current harness, especially before any task or subagent dispatch that requires explicit model selection\\.$|models.yaml|defaults.md|Source: ~/.config/ai/models.yaml|判定はしない" home/.copilot/skills/model-resolution/SKILL.md
```

Expected: 6 matches

- [ ] **Step 5: `SKILL.md` と `defaults.md` の対応が矛盾しないことを確認する**

Run:

```bash
cd /Users/okamoto_n/dotfiles && rg -n "gpt-5-mini|gpt-5.4|claude-opus-4.6" home/.copilot/skills/model-resolution/SKILL.md home/.copilot/skills/model-resolution/defaults.md home/.config/ai/models.yaml
```

Expected: each model name appears in `defaults.md` and `models.yaml`, and `SKILL.md` does not introduce a conflicting model list

- [ ] **Step 6: コミットする**

```bash
cd /Users/okamoto_n/dotfiles && git add home/.copilot/skills/model-resolution/SKILL.md home/.copilot/skills/model-resolution/defaults.md && git commit -m "ai: add model-resolution skill"
```

---

## Self-Review

1. **Spec coverage:** spec の 4 要件（shared instruction, local YAML, fallback doc, thin skill）がすべて task に対応していることを確認する。
2. **Placeholder scan:** placeholder 系の赤信号パターンが plan 内に残っていないことを確認する。
3. **Type consistency:** `low` / `medium` / `high`、`copilot-cli`、`~/.config/ai/models.yaml`、`defaults.md` の表記が task 間で一貫していることを確認する。
