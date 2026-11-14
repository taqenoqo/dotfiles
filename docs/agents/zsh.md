# Zsh

## 仕様

- フレームワーク: Oh-My-Zsh（プラグイン約 20 個）
- ロード順: `.zshenv` → `$ZDOTDIR/.zshenv` → `$ZDOTDIR/.zshrc` → `$ZDOTDIR/conf.d/*.zsh`（ソート順）
- カスタムプロンプトは `$ZDOTDIR/conf.d/prompt.zsh`（ASCII アート + git/docker コンテキスト表示）

### .zshenv の分割構造

`~/.zshenv` は ZDOTDIR の解決と `$ZDOTDIR/.zshenv` の source のみを行う。
環境変数・PATH 設定はすべて `$ZDOTDIR/.zshenv` に集約している。

この構造の理由: `ZDOTDIR` は export されるため、tmux の新ウィンドウ等のサブシェルは
`ZDOTDIR` を継承した状態で起動し、`~/.zshenv` ではなく `$ZDOTDIR/.zshenv` を読む。
すべての設定を `$ZDOTDIR/.zshenv` に置くことで、どちらの起動パターンでも
同じ設定が適用される。

## 調査記録

- 対話シェルの切り分けで `HOME` を差し替えても、tmux から継承した `ZDOTDIR` が優先され本物の設定が読まれる。差し替えるなら `ZDOTDIR` を直接指定する。
