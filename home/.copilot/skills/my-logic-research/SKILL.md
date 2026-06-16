---
name: my-logic-research
description: ユーザーに呼び出されるスキル。PR の差分コードに対して、全コードパスを網羅するユースケースと主要分岐を列挙し、各主要分岐について個別の Mermaid sequenceDiagram と補足を整理するレポートを生成する。
---

# My Logic Research

## 概要

PR の差分コードに対して、全コードパスを網羅するユースケースと主要分岐を列挙し、
各ユースケース配下の主要分岐ごとに、どの条件でどの関数・外部依存・状態遷移が起こるかを
個別の Mermaid sequenceDiagram として整理する。

PR レビューの前工程として使うこともできるし、単独で PR の理解のために使うこともできる。

レポートには以下が含まれる:
- `purpose-report.md`: PR の目的、背景、期待される振る舞い
- `usecase-report.md`: PR のコードが呼ばれるユースケースと主要分岐の一覧
- `logic-report.md`: ユースケースごとに主要分岐別の Mermaid sequenceDiagram と補足
- `library-report.md`: 使用されている関数・ライブラリの仕様（重複なし、リンク付き）

## タスク

1. **git の SHA を取得:**

    ``` sh
    BASE_SHA=$(git merge-base origin/main HEAD)
    HEAD_SHA=$(git rev-parse HEAD)
    ```

2. **作業ディレクトリの作成:**

    `logic-research-YYYY-MM-DD-hh-mm-ss/` という名前で、作業用のディレクトリを作成してください。
    必ずセッションディレクトリ、あるいは `/tmp` の下に作成してください。

3. **カスタムエージェントの起動:**

    `logic-researcher.md` というファイルにサブエージェントの挙動のテンプレートが定義されています。
    プレースホルダを埋めたものをサブエージェントに指示として渡してください。
    モデルは `../shared/models.md` の **high-1** を使用してください。

    * **プレースホルダ:**

        + `{BASE_SHA}`: Base コミットハッシュ
        + `{HEAD_SHA}`: Head コミットハッシュ
        + `{WORK_DIR}`: 作成した作業ディレクトリのパス
