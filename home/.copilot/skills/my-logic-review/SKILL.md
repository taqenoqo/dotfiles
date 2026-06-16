---
name: my-logic-review
description: エージェントではなくユーザーに呼び出されるスキル。ロジックの観点からコードをレビューする。
---

# My Logic Review

## 概要

この skill は、ロジックの観点から PR のコードをレビューする。

レビューは subagent を起動して実行する。
それによりコンテキストに依存しない、客観的なレビューを得る。

## タスク

1. **git の SHA を取得:**

    ``` sh
    BASE_SHA=$(git merge-base origin/main HEAD)
    HEAD_SHA=$(git rev-parse HEAD)
    ```

2. **カスタムエージェントの起動:**

    `logic-review-manager.md` というファイルに subagent の挙動のテンプレートが定義されています。
    ただし、 テンプレートにはいくつかのプレースホルダがあるので、それらを埋めたものを subagent に指示として渡してください。

    * **プレースホルダ:**

        + `{BASE_SHA}`: 比較のベースとなるコミット
        + `{HEAD_SHA}`: 比較の対象となるコミット
