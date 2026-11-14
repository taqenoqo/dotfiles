# Tmux

## 仕様

- プレフィックス: `Ctrl-T`
- `prefix+x` は確認付きでウインドウを閉じ、`prefix+X` は確認付きでペインを閉じる。
- 自動ウインドウ名は、アクティブペインの論理カレントディレクトリをホーム自身なら `~`、ホーム直下なら `~/name`、それ以外なら `parent/name` とする。`conf.d/tmux.zsh` が `chpwd` 時にペインオプションへ `$PWD` を渡して自動リネーム中のウインドウだけ即時更新する。未設定時は tmux の物理パスを使う。`prefix+,` で手動変更した名前は維持される。
- `prefix+c` と `prefix+C` は、幅に関係なく1ペインの新規ウインドウをカレントディレクトリで開く。
- 新しい tmux セッションの起動時には Note/Memo（ディレクトリがある場合）と通常作業用の各ウインドウを1ペインで作る。Note/Memo では対象ディレクトリへ移動して Vim を起動する。
- 起動時のウインドウには `new-window -c <dir> -e STARTUP_COMMAND=<cmd>` でディレクトリとコマンドを渡し、`.zshrc` が初期化後に `STARTUP_COMMAND` を unset してから実行する。
- 起動処理はプレースホルダーへ戻って通常作業用ウインドウを末尾に作成した後、プレースホルダーを削除する。ウインドウは Note, Memo, 通常作業用の順に並ぶ。
- `prefix+Enter` は、ペインを入れ替えず、左60%の主ペインと右40%の縦積みへ整形する。
- `prefix+s` は現在のウインドウ内で同期入力を切り替え、`prefix+S` はセッション選択を開く。

## 設計方針

- 起動処理で `send-keys` を使ってシェルにコマンドを打ち込まない。シェルの初期化中に端末を触るコマンドが1つでもあると、送った入力が黙って捨てられる (詳細は調査記録)。
- tmux の動作検証をユーザの tmux サーバで行わない (`kill-server` などで作業中のセッションを壊した実例がある)。`env -u TMUX TMUX_TMPDIR=/tmp/<dir>` でソケットごと分離し、`script -q /dev/null zsh -i` でログイン直後の起動を再現する。`TMUX` を外さないと分離にならない (詳細は調査記録)。

## 調査記録

- tmux の `automatic-rename-format` では、`b:` と `d:` がそれぞれ basename と dirname を返し、`#{HOME}` は tmux のグローバル環境の `HOME` を展開する。`#{b:#{d:pane_current_path}}` は二段階に適用されず dirname を返すため、末尾2階層の抽出には `s|^.*/([^/]+)/([^/]+)$|\1/\2|` を使う。
- `#{pane_current_path}` はシンボリックリンクを解決した物理パスを返す。論理 `$PWD` を使うには zsh の `chpwd` からペイン固有のユーザーオプションへ渡す。
- tmux の `rename-window` は `automatic-rename` を無効にする。zsh の論理パス更新では、自動リネーム中のウインドウだけを更新した後に同オプションを再有効化し、手動名は保持する。
- 継承された `automatic-rename` は `show-options -w -v` では空になる。ペインの実効値は `tmux display-message -p '#{automatic-rename}'` で判定する。
- tmux は `-S` も `-L` も無いと、`TMUX_TMPDIR` より環境変数 `TMUX` のソケットを優先する (`tmux.c` の `getenv("TMUX")`)。エージェントは tmux のペイン内で動くので `TMUX` が設定されており、`TMUX_TMPDIR` だけを変えた検証の `kill-server` がユーザの tmux サーバを落とした。
- tmux は target-pane にフォーマットを展開しない。`swap-pane -s '#{pane_id}'` は `can't find pane: #{pane_id}` で失敗する。`-s` を省略すればカレントペインが使われる (マークされたペインがある場合のみそちらが優先)。
- sudo 1.9.17 は、コマンドを実際に実行すると、stdin/stdout/stderr をすべてリダイレクトしても端末の先行入力を捨てる。認証に失敗して実行しなかった場合は捨てない。`$ZDOTDIR/.zshrc.local` の `sudo -n pmset` がこれに当たり、tmux が `send-keys` で送った `cd` と `vim` が画面にエコーされたまま実行されなかった。`( sudo … & )` でバックグラウンド実行すれば捨てない。
