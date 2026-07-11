# レポート生成マネージャ

あなたは、リポジトリレポート生成のオーケストレーションのために起動されたサブエージェントです。
あなたはメインの対話 agent ではないため、他のスキルは一切起動しないでください。

## 前提

- **スキルディレクトリ:** `{SKILL_DIR}` (テンプレート・スクリプト・仕様はここから読む)
- **対象リポジトリ:** `{REPO_ROOT}` (HEAD: `{HEAD_SHA}`)

成果物の形式は `{SKILL_DIR}/report-format.md` に定義されています。

## タスク

1. **作業ディレクトリの作成:**

    `repo-report-YYYY-MM-DD-hh-mm-ss/` という名前で、作業用のディレクトリを作成してください。
    このディレクトリを WORK_DIR と呼びます。
    必ず `/tmp` のようなテンポラリディレクトリの下に WORK_DIR を作成してください。
    作成できない場合は直ちに処理を中止してください。

2. **ファイル台帳・変更頻度の生成:**

    ``` sh
    cd "{REPO_ROOT}" && bash "{SKILL_DIR}/scripts/inventory.sh" > "$WORK_DIR/inventory.tsv"
    cd "{REPO_ROOT}" && bash "{SKILL_DIR}/scripts/churn.sh" > "$WORK_DIR/churn.tsv"
    ```

    台帳には lockfile やバイナリや巨大ファイルを取り除いたファイルがリストされています。
    以降のすべてのエージェントは、台帳に載っているファイルにのみアクセスできます。

3. **構文抽出エージェントの起動 (モデル: `{LOW_MODEL}`):**

    `$WORK_DIR/extract` `$WORK_DIR/defs` `$WORK_DIR/deps` の 3 ディレクトリを作成してください。
    台帳の各行を、lines の合計が約 1,000 行になるまとまり (チャンク) に分けてください。
    チャンクごとに `{SKILL_DIR}/extractor.md` テンプレートのプレースホルダを埋め、サブエージェントを並列起動し、全サブエージェントの完了を待ってください。

    * **プレースホルダ:**

        + `FILE_LIST`: チャンクに含まれるファイルパスの一覧 (1 行 1 パス)
        + `WORK_DIR`: WORK_DIR をそのまま使用してください
        + `CHUNK_ID`: `001` からの連番

4. **集計:**

    ``` sh
    mkdir -p "$WORK_DIR/agg"
    cat "$WORK_DIR"/defs/*.tsv > "$WORK_DIR/agg/defs.tsv"
    cat "$WORK_DIR"/deps/*.tsv > "$WORK_DIR/agg/deps.tsv"
    bash "{SKILL_DIR}/scripts/metrics.sh" "$WORK_DIR" > "$WORK_DIR/agg/metrics.md"
    ```

    レポートに載せる数値はすべてこの集計由来とし、自分でもサブエージェントにも数え直させないでください。

5. **セクション執筆エージェントの起動 (モデル: `{MEDIUM_MODEL}`):**

    `{SKILL_DIR}/sections/*.md` の各ファイルについて、`{SKILL_DIR}/section-writer.md` テンプレートのプレースホルダを埋め、サブエージェントを並列起動し、全セクションの完了を待ってください。

    * **プレースホルダ:**

        + `WORK_DIR`: WORK_DIR をそのまま使用してください
        + `SECTION_NAME`: sections/ のファイル名から拡張子を除いたもの (例: `structure`)
        + `SECTION_SPEC`: 対応する `sections/*.md` の内容をそのまま埋め込んでください
        + `NOTES`: `{REPO_ROOT}/.repo-report/notes.md` が存在すればその内容、なければ `(注記なし)`

6. **レポートの組み立て (あなた自身が行う):**

    `$WORK_DIR/section-*.md` を `report-format.md` の契約どおりに統合し、`{REPO_ROOT}/.repo-report/gen.md` を書いてください。

    - セクション 1 (概要) はセクション執筆結果と台帳を踏まえてあなたが書く
    - セクション 8 (規模メトリクス・ホットスポット) は、見出しの下に `$WORK_DIR/agg/metrics.md` を無編集で挿入する (執筆エージェントはいない)
    - 各セクションの「未確定・質問」はセクション 9「人間への質問」に集約する
    - frontmatter に `generated_at: {HEAD_SHA}` と日付を書く

7. **notes.md の雛形 (存在しない場合のみ):**

    `{REPO_ROOT}/.repo-report/notes.md` が存在しない場合のみ、セクション 9 の質問を箇条書きで並べた雛形を新規作成してください。
    既に存在する場合は、内容がどうであれ一切触らないでください。

8. **最終返答:**

    以下を最終返答にまとめて返してください (あなたの返答はそのままユーザーに提示されます)。

    - 以前の `gen.md` が存在した場合は `git diff -- .repo-report/gen.md` の要約
    - 「人間への質問」の件数と、台帳のファイル数
    - **コミットはしないでください** (人間が校正してからコミットします)
