---
name: model-resolution
description: エージェントが利用モデルを選定する際は必ず呼ばれる必要があるスキル。ユーザが仕様を推奨している具体的なモデル名を解決する。
---

# Model Resolution

## 概要

この skill は、呼び出し元が使いたいモデルについて、利用可能な具体的なモデル名を解決する。
呼び出し元がモデルに要求する性能を `low` / `medium` / `high` と大まかに分け、そこから具体的なモデル名を解決する。

## 手順

1. 要求されているモデル性能を `low` / `medium` / `high` に分類する。
2. `~/.config/ai/models.yaml` が存在する場合はそれを読み、モデル名を解決する。
3. そのファイルがない、あるいは該当する値がない場合は `defaults.yaml` を読み、モデル名を解決する。
4. `~/.config/ai/models.yaml` からも `defaults.yaml` からも該当する値がない場合は、エラーを返す。
5. 最終返答は次の形式にする。

```text
Requested tier: medium
Recommended model: gpt-5.4
Source: ~/.config/ai/models.yaml
```

## ルール

* 具体モデル名を返すときは、どのファイルから解決したかも添える。
* `~/.config/ai/models.yaml` に該当値がある場合は、必ず `defaults.yaml` より優先する。
