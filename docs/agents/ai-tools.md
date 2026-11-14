# AI ツール (グローバル指示・Claude Code・Copilot CLI)

## 設計方針

- ツール共通の指示は `home/.agents/AGENTS.md` に置き、Claude Code (`home/.claude/CLAUDE.md` から `@` で取り込む) と Copilot CLI (`home/.copilot/copilot-instructions.md` からリンク) で共有する。
- Copilot CLI だけに関係する指示 (ハーネスのツールの使い方など) は `home/.copilot/instructions/*.instructions.md` に置き、共有の指示に混ぜない。

## 調査記録

- `home/.config/zsh/conf.d/alias.zsh` の `copilot` alias は `--add-dir "$HOME/.agents"` と `--add-dir "$HOME/dotfiles/"` を付けている。したがって、これら配下への参照だけでは許可ダイアログの直接原因になりにくい。
- Copilot の許可ダイアログに `.../Workspace/<repo>/.agents/AGENTS.md` のようなパスが出る場合は、リポジトリ相対の `.agents/AGENTS.md` を読もうとしている可能性を優先して疑う。
- Copilot CLI の `fetch_copilot_cli_documentation` ツールは、パッケージ内の `README.md` を読もうとして ENOENT になり、help 出力しか返さない。`README.md` が同梱されているのは `~/.copilot/pkg/darwin-arm64/0.0.402/` だけで、1.0.94 以降には無い。詳しい仕様は公式ドキュメント (`https://docs.github.com/api/article/body?pathname=/en/copilot/reference/copilot-cli-reference/cli-command-reference`) を読む。
- Copilot CLI は、`kill $(lsof …)` のように kill の PID をコマンド置換で渡すと実行を拒否する。PID を調べてから数値で渡すこと。
