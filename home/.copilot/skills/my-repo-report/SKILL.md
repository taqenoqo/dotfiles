---
name: my-repo-report
description: エージェントではなくユーザーに呼び出されるスキル。リポジトリの構造地図(ディレクトリ責務・依存・ユーティリティ目録・慣習)を対象リポジトリの .repo-report/gen.md に生成する。成果物は my-pr-review 等の他スキルから参照される前提。
---

# My Repo Report

## 概要

リポジトリ全体を調査し、構造地図レポートを対象リポジトリの `.repo-report/gen.md` に生成する。
成果物の形式は `report-format.md` に定義されている(セクション構成は契約なので変えないこと)。

- `gen.md` は再生成のたびに全体を上書きする。校正はコミット前に人間が行う。
- `.repo-report/notes.md` は人間が書く注記。**読むだけで、絶対に編集しない**(手順 8 の新規作成のみ例外)。

## タスク

1. **前提確認:**

    ``` sh
    REPO_ROOT=$(git rev-parse --show-toplevel)
    HEAD_SHA=$(git rev-parse HEAD)
    ```

    git リポジトリでなければ中止してユーザーに報告してください。

2. **作業ディレクトリの作成:**

    `repo-report-YYYY-MM-DD-hh-mm-ss/` という名前で、作業用のディレクトリを作成してください。
    このディレクトリを WORK_DIR と呼びます。
    必ず `/tmp` のようなテンポラリディレクトリ、あるいは、セッションディレクトリの下に WORK_DIR を作成してください。
    作成できない場合は直ちに処理を中止してください。

3. **ファイル台帳の生成:**

    ``` sh
    cd "$REPO_ROOT" && bash <このスキルのディレクトリ>/scripts/inventory.sh > "$WORK_DIR/inventory.tsv"
    ```

    以降のすべてのエージェントは、台帳で `class=source` のファイルだけ本文を読めます。
    lockfile やバイナリ等を誤ってコンテキストに入れない関門なので、例外を作らないでください。

4. **モデル解決:**

    `model-resolution` スキルで `low` と `high` の 2 つのモデル名を解決してください。

5. **構文抽出エージェントの起動(low モデル):**

    台帳の `class=source` の行を、lines の合計が約 2,000 行になるまとまり(チャンク)に分けてください。
    チャンクごとに `extractor.md` テンプレートのプレースホルダを埋め、サブエージェントを並列起動し、全チャンクの完了を待ってください。

    * **プレースホルダ:**

        + `{FILE_LIST}`: チャンクに含まれるファイルパスの一覧(1 行 1 パス)
        + `{WORK_DIR}`: WORK_DIR をそのまま使用してください
        + `{CHUNK_ID}`: `001` からの連番

6. **セクション執筆エージェントの起動(high モデル):**

    `sections/*.md` の 4 ファイルそれぞれについて、`section-writer.md` テンプレートのプレースホルダを埋め、サブエージェントを並列起動し、全員の完了を待ってください。

    * **プレースホルダ:**

        + `{WORK_DIR}`: WORK_DIR をそのまま使用してください
        + `{SECTION_NAME}`: sections/ のファイル名から拡張子を除いたもの(例: `structure`)
        + `{SECTION_SPEC}`: 対応する `sections/*.md` の内容をそのまま埋め込んでください
        + `{NOTES}`: `$REPO_ROOT/.repo-report/notes.md` が存在すればその内容、なければ `(注記なし)`

7. **レポートの組み立て(あなた自身が行う):**

    `{WORK_DIR}/section-*.md` を `report-format.md` の契約どおりに統合し、`$REPO_ROOT/.repo-report/gen.md` を書いてください。

    - セクション 1(概要)はセクション執筆結果と台帳を踏まえてあなたが書く
    - 各セクションの「未確定・質問」はセクション 8「人間への質問」に集約する
    - セクション 9(付録)には台帳の generated / vendored / binary / oversized の件数と一覧を書く
    - frontmatter に `generated_at: $HEAD_SHA` と日付を書く

8. **notes.md の雛形(存在しない場合のみ):**

    `$REPO_ROOT/.repo-report/notes.md` が存在しない場合のみ、セクション 8 の質問を箇条書きで並べた雛形を新規作成してください。
    既に存在する場合は、内容がどうであれ一切触らないでください。

9. **結果の提示:**

    - 以前の `gen.md` が存在した場合は `git diff -- .repo-report/gen.md` の要約をユーザーに提示してください
    - 「人間への質問」の件数と、台帳分類サマリ(source / generated / vendored / binary / oversized の件数)を報告してください
    - **コミットはしないでください**(人間が校正してからコミットします)
