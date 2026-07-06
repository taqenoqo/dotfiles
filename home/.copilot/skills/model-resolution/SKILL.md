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
