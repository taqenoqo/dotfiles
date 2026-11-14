# AI ツール (グローバル指示・Claude Code・Copilot CLI)

## 設計方針

- ツール共通の指示は `home/.agents/AGENTS.md` に置き、Claude Code (`home/.claude/CLAUDE.md` から `@` で取り込む) と Copilot CLI (`home/.copilot/copilot-instructions.md` からリンク) で共有する。
- Copilot CLI だけに関係する指示 (ハーネスのツールの使い方など) は `home/.copilot/instructions/*.instructions.md` に置き、共有の指示に混ぜない。
- リポジトリの `AGENTS.md` は、常に要る規則と索引だけにし、設計方針と調査記録は `docs/agents/` の領域ごとの文書に置く。1 ファイルに足し続けた結果、7 か月で 3.5KB から 65KB になり、毎セッション全文が読まれるのに、1 回の作業で使うのは数項目だった (ユーザと相談して分割)。
    - グローバル指示の「AGENTS.md の更新」も、「多くの場合は更新が必要となるだろう」と足す方向にだけ促していたのをやめ、記録する基準と、足すときに削除・統合も行うことを定めた。
    - `@` での取り込みで分けても意味がない。取り込んだファイルは一緒に読み込まれる (調査記録)。必要なときにエージェントが自分で読む、索引からの参照にする。
    - グローバル指示では、合う文書が無いときの動き (`docs/agents/` に作り、`AGENTS.md` に案内を 1 行足す) まで定めている。「別の文書が案内されていれば、そちらに書く」だけでは、文書が 1 つも無い新規のリポジトリで、作るか `AGENTS.md` に書くかが割れる。置き場所を決め打ちにしたのは、リポジトリごとに形がばらつかないようにするため。
    - 項目の取捨選択はまだしていない。分割は移動だけで、103 項目の調査記録はそのまま残っている。

## 調査記録

- AI 向け文書の大きさについて、一次情報で確認できた目安 (2026-11)。
    - Claude Code: `CLAUDE.md` は 1 ファイル 200 行未満が目安で、長いと守られにくくなる。`@` での取り込みは整理にはなるが、読み込む量は減らない。`.claude/rules/` の `paths` 付きの規則は、該当ファイルを触るときだけ読まれる (https://code.claude.com/docs/en/memory)。
    - Codex: `AGENTS.md` はルートから作業ディレクトリまでを連結して読み、合計が `project_doc_max_bytes` (既定 32KiB) に達すると、それ以降を読まない (https://learn.chatgpt.com/docs/agent-configuration/agents-md)。
    - ETH Zurich の論文 (arXiv 2602.11988): コンテキストファイルは一般に成功率を上げず、推論コストを 20% 以上増やす。役に立つのは、そのリポジトリ特有の決まりごと。

- `home/.config/zsh/conf.d/alias.zsh` の `copilot` alias は `--add-dir "$HOME/.agents"` と `--add-dir "$HOME/dotfiles/"` を付けている。したがって、これら配下への参照だけでは許可ダイアログの直接原因になりにくい。
- Copilot の許可ダイアログに `.../Workspace/<repo>/.agents/AGENTS.md` のようなパスが出る場合は、リポジトリ相対の `.agents/AGENTS.md` を読もうとしている可能性を優先して疑う。
- Copilot CLI の `fetch_copilot_cli_documentation` ツールは、パッケージ内の `README.md` を読もうとして ENOENT になり、help 出力しか返さない。`README.md` が同梱されているのは `~/.copilot/pkg/darwin-arm64/0.0.402/` だけで、1.0.94 以降には無い。詳しい仕様は公式ドキュメント (`https://docs.github.com/api/article/body?pathname=/en/copilot/reference/copilot-cli-reference/cli-command-reference`) を読む。
- Copilot CLI は、`kill $(lsof …)` のように kill の PID をコマンド置換で渡すと実行を拒否する。PID を調べてから数値で渡すこと。
