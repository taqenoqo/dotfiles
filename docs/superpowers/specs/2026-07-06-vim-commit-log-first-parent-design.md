# `leader cg` の履歴収集を first-parent に限定する設計

## 背景

`home/.config/vim/after/ftplugin/gitcommit.vim` の `CopilotCommitMessage` は、最近のコミット件名をプロンプトに含めて件名生成の語調を寄せている。
現在は `git log --no-merges --format=%s --max-count=20` を使っているため、マージコミット自体は除外できるが、履歴探索は first-parent に限定されず、マージ先ブランチの件名が候補に混ざる。

## 目的

`leader cg` に渡す最近のコミット件名を、現在のブランチの第1親系列だけから取得する。
そのうえで、既存どおりマージコミット自体は候補に含めない。

## 採用方針

`s:recent_commit_subjects()` の `git log` 引数へ `--first-parent` を追加する。
最終的なコマンドは `git log --first-parent --no-merges --format=%s --max-count=20` とする。

この方針により、次の性質を保つ。

- 影響範囲は最近の件名収集だけに限定される
- マージコミット自体は引き続き除外される
- 失敗時は空配列を返し、件名生成全体の挙動は変えない

## 代替案

1. `--first-parent` のみを追加してマージコミットを候補に含める
   - 今回の要望では不要なので不採用
2. Vim 変数で挙動を切り替えられるようにする
   - 将来要件がない段階では過剰なので不採用

## 実装メモ

- 変更対象は `home/.config/vim/after/ftplugin/gitcommit.vim` のみ
- `s:recent_commit_subjects()` の引数配列に `--first-parent` を追加する

## 確認観点

- `leader cg` が組み立てる最近のコミット件名取得コマンドに `--first-parent` が含まれること
- 差分が最小で、他のプロンプト生成ロジックやエラーハンドリングに影響しないこと
