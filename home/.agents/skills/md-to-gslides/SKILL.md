---
name: md-to-gslides
description: Markdown のスライド草案を、ユーザが指定した既存の Google スライドのデザインに沿った Google スライドに変換する。生成済みのスライドへ草案の変更を反映することもできる。ユーザのブラウザに Playwright で接続し、テンプレートのコピーに紐づく Apps Script でスライドを生成する。
---

# Markdown 草案から Google スライドを作る

テンプレート (デザインの手本にしたい既存の Google スライド) をコピーし、そのコピーに紐づく Apps Script で、
テンプレートのレイアウトを使ったスライドを生成する。最後に見た目を確認し、はみ出しなどを直す。

生成したデッキの URL は草案に書き残す。草案を直して再び実行すると、同じデッキの変わったページだけを作り直す。
変わっていないページに Google スライド上で加えた手直しは残り、スクリプトの承認もやり直さずに済む。

Google Cloud プロジェクトを作れない環境や、Playwright が起動したブラウザでは Google にログインできない環境でも動くように、
通常の Chrome をデバッグポート付きで起動して接続し、Apps Script もエディタの画面から実行する。

## 前提

- macOS の Google Chrome、`playwright-cli`、`jq`
- Google の表示言語が日本語であること。画面上の要素を日本語の文言で探すため。
- ユーザが同席していること。ログインと Apps Script の承認はユーザにしてもらう。

## 手順

### 1. 入力を確認して作業ディレクトリを作る

草案の Markdown を確認する。front matter に `gslides:` (生成済みのデッキの URL) があれば、そのデッキへの反映になる。
無ければ新規作成なので、テンプレートの URL をユーザに確認する。

作業ディレクトリにはログイン済みの Chrome プロファイルが入るため、最後に必ず消す。
`deck.js` やスクリーンショットなどの中間ファイルも、すべてここに置く。

```bash
WORK=$(mktemp -d /tmp/md-to-gslides.XXXXXX) && echo '{"browser":{"cdpEndpoint":"http://127.0.0.1:9333","isolated":false}}' > $WORK/cli.config.json && echo $WORK
```

シェルの変数は呼び出しをまたいで残らない。以降のコードの `$WORK` は、表示されたパスに置き換えて書く。

### 2. Chrome を起動してログインしてもらう

Chrome をバックグラウンドで起動する。`{URL}` は、新規ならテンプレートのコピー画面 (URL の `/edit...` を `/copy` に置き換えたもの)、
反映なら `gslides:` の URL。

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --user-data-dir=$WORK/profile \
  --remote-debugging-port=9333 --no-first-run --no-default-browser-check "{URL}"
```

ユーザにログインしてもらい、完了の返事を待ってから接続する。
`playwright-cli` はログ類を `open` したディレクトリの `.playwright-cli/` に書くので、作業ディレクトリで `open` する。

```bash
cd $WORK && playwright-cli -s=gslides open --config=$WORK/cli.config.json
```

組織が管理するプロファイルでは、拡張機能やお知らせのタブが勝手に開き、タブの番号がずれる。
タブを切り替えるときは毎回 `playwright-cli -s=gslides tab-list` で番号を確かめてから `tab-select` する。
`chrome://` のタブは閉じようとすると固まるので閉じない。まず Google スライドのタブを選ぶ。

### 3. テンプレートをコピーする

新規のときだけ行う。

```bash
playwright-cli -s=gslides run-code "async page => {
  await page.getByRole('button', { name: 'コピーを作成' }).click();
  await page.waitForURL(/\/edit/);
}"
```

以降はこのコピーを編集する。Gemini などの案内ダイアログが出たら Escape で閉じる。

### 4. Apps Script を開く

メニューの「拡張機能 > Apps Script」から開く。エディタは別タブで開く。

```bash
playwright-cli -s=gslides run-code "async page => {
  const editorOpened = page.context().waitForEvent('page');
  await page.locator('#docs-extensions-menu').click();
  await page.locator('.goog-menu:visible [role=menuitem]').filter({ hasText: 'Apps Script' }).click();
  const editor = await editorOpened;
  await editor.waitForFunction(() => window.monaco, null, { timeout: 60000 });
}"
```

開いたら Apps Script のタブを選ぶ。

### 5. テンプレートのレイアウトを調べる

反映のときは、先にエディタから前回の `DECK` を `$WORK/deck.js` に取り出す (`inspect` を実行すると上書きされるため)。
前回の `DECK` に無いレイアウトが要るときだけ、この後の `inspect` を行う。

```bash
playwright-cli -s=gslides run-code "async page => page.evaluate(() => monaco.editor.getModels().find(m => m.uri.path.endsWith('.js')).getValue())" \
  | awk '/^### Result$/ { f = 1; next } /^### / { f = 0 } f' | jq -r . | sed -n '/^const DECK/,$p' > $WORK/deck.js
```

[converter.gs](converter.gs) だけを流し込み、`inspect` を実行する (「Apps Script の実行方法」参照)。

実行ログに、レイアウトごとに次の JSON が 1 行ずつ出る。

- `id`: 後で `DECK` に書くレイアウト ID
- `name`: レイアウトの内部名。表示名とは限らず、用途を表さないこともある。
- `placeholders`: テキストを入れられるプレースホルダの `[種類, left, top, width, height]`。上から、同じ高さなら左から順に並ぶ。
- `example`: そのレイアウトを使っているテンプレート内の最初のスライドの番号と、各プレースホルダの冒頭 40 字。使われていなければ `null`。

用途が読み取れないレイアウトは、Google スライドのタブに戻って `example` のスライドをスクリーンショットで確認する。

### 6. DECK を書いて生成する

草案は、front matter の後を `---` でスライドに区切る。見出しの階層で、スライドの役割が決まる。

- `#`: 表紙。直後に `##` があればサブタイトルになる。
- `##` だけのスライド: 中扉
- `###`: 本文のスライドの見出し。続く部分が本文になる。

草案の各スライドを、役割に合うレイアウトに入れて `$WORK/deck.js` に書く。
テンプレートで実際に使われているレイアウトと、`example` でのプレースホルダの使い方を手本にする。
草案の文言はそのまま写す (要約・言い換え・書き足しをしない)。曖昧な箇所や誤字があれば、書く前にユーザに確認する。
反映のときは、取り出した前回の `DECK` のうち、草案で変わったページの要素だけを書き換える。
変わっていないページの要素は一字も変えない (変えると作り直しになり、手直しが消える)。

```js
const DECK = [
  { layout: '<レイアウト ID>', texts: ['タイトル', 'サブタイトル'] },
  { layout: '<レイアウト ID>', texts: ['見出し', '段落\n- 項目\n\t- 子項目\n1. 手順\n`code` を含む段落'] },
];
```

- `texts` の各要素は、`placeholders` の同じ位置のプレースホルダに入る。
  - 文字列: 草案の Markdown を次の書き方で入れる。改行は段落になる。
    - `- ` で始まる行は箇条書き、`1. ` のように数字とピリオドで始まる行は番号付きの箇条書き、それ以外は普通の段落になる。
    - 箇条書きの階層は行頭のタブの数で表す。草案のスペースの字下げはタブに、`*` や `+` の記号は `-` に置き換える。
    - 連続する箇条書きの行は 1 つのリストになる。入れ子の行は、記号が違っても親のリストに入る (番号を途切れさせないため)。
    - `` `...` `` は、バッククォートを外して等幅フォントにする。
  - `null` または省略: 触らない。スライド番号 (`SLIDE_NUMBER`) などはこれにする。
- `build` は、前回の `build` と同じ要素のページを作り直さずに残し、`DECK` の順に並べ直す。手直しも残る。
  - それ以外の要素からは新しくページを作る。前回から変わったページや無くなったページは消え、その手直しも消える。
  - 生成の記録が無いページ (Google スライド上で手で足したページ) は残し、直前に残る生成済みページの後ろに付ける。
  - 初回だけは、テンプレートに元からあるページを全部消す。

converter.gs と deck.js を連結して流し込み、`build` を実行する。
`build` は最後に、再利用・新規・削除・手動の枚数をログに出す。画面を見る前に、草案から見込んだ枚数と合っているかを確かめる。
新規のときは、生成できたら草案の front matter に `gslides: <コピーしたデッキの URL>` を書き足す。
front matter は、ファイルの 1 行目の `---` から始める (無ければ 1 行目に作る)。

### 7. 見た目を確認して直す

Google スライドのタブに戻る。生成結果はリロードしなくても反映されている。
リロードすると Apps Script のタブが閉じるので、リロードしない (閉じたら手順 4 で開き直す)。

スライドを 1 枚ずつスクリーンショットで確認する。フィルムストリップは表示中のサムネイルしか DOM に無いので、
先頭のサムネイルをクリックして Home を押してから、ArrowDown で 1 枚ずつ移動する。

```bash
playwright-cli -s=gslides run-code "async page => {
  await page.locator('.punch-filmstrip-thumbnail').first().click();
  await page.keyboard.press('Home');
  await page.waitForTimeout(700);
  await page.locator('#canvas').screenshot({ path: '$WORK/slide.png' });
}"
```

2 枚目からは、Home の代わりに ArrowDown を押す。

```bash
playwright-cli -s=gslides run-code "async page => {
  await page.keyboard.press('ArrowDown');
  await page.waitForTimeout(700);
  await page.locator('#canvas').screenshot({ path: '$WORK/slide.png' });
}"
```

文字がはみ出しているテキストボックスは、キャンバス上でそのボックスの中央をクリックして編集状態にし、
Meta+A で全選択してから、収まるまで Meta+Shift+Comma (1pt ずつ縮小) を押す。Escape を 2 回押して編集状態を抜ける。

### 8. 後片付け

コピーしたスライドの URL をユーザに伝えてから片付ける。
`kill` には、`lsof` で調べた PID を数値で直接渡す (コマンド置換を使うと、ハーネスによっては実行を拒否される)。

```bash
playwright-cli -s=gslides close
lsof -ti tcp:9333 -sTCP:LISTEN
kill <上で表示された PID>
rm -rf $WORK
```

## Apps Script の実行方法

エディタのタブで、コードを流し込んで保存し、関数 `{FUNCTION}` を選んで実行する。
`{FILES}` は `inspect` なら converter.gs、`build` なら converter.gs と `$WORK/deck.js`。
`CODE` の代入から実行までを、1 回のシェルの呼び出しで行う。

```bash
CODE=$(cat {FILES} | jq -Rs .) && playwright-cli -s=gslides run-code "async page => {
  await page.evaluate(code => monaco.editor.getModels().find(m => m.uri.path.endsWith('.js')).setValue(code), $CODE);
  await page.keyboard.press('Meta+S');
  await page.waitForFunction(() => document.querySelector('[aria-label=\"ドライブにプロジェクトを保存\"]').disabled, null, { timeout: 30000 });
  await page.getByRole('listbox', { name: '実行する関数を選択' }).click();
  await page.getByRole('option', { name: '{FUNCTION}', exact: true }).click({ timeout: 30000 });
  await page.waitForFunction(() => document.querySelector('[aria-label=\"実行する関数を選択\"]').innerText.trim() === '{FUNCTION}', null, { timeout: 30000 });
  await page.getByRole('button', { name: '選択した関数を実行' }).click();
}"
```

続けて、終わるまで待って実行ログを返す。

```bash
playwright-cli -s=gslides run-code "async page => {
  const log = page.getByRole('list', { name: 'ログ' }).getByRole('listitem');
  await log.and(page.locator('[aria-label\$=\". お知らせ. 実行完了.\"], [aria-label*=\". エラー. \"]'))
    .or(page.getByText('承認が必要です')).first().waitFor({ timeout: 120000 });
  return (await log.allInnerTexts()).join('\n');
}"
```

- 保存が終わる前に関数を選ぶと、保存の後で選択が元に戻り、前の関数が走る。保存ボタンが押せなくなる (未保存の変更が無くなる) のを待ってから選ぶ。
  念のため、選択が反映されたのを確かめてから実行する。
- 完了判定にはログ本文ではなく種別 (aria-label) を使う。ログ本文にはテンプレートの文章が含まれ得るため。
- 初回は「承認が必要です」が出て、空のログが返る。「権限を確認」を押すと承認画面が別タブで開く (押した操作がナビゲーションのエラーで終わることがあるが、開いていれば問題ない)。
  ユーザに許可してもらうと実行がそのまま続くので、実行し直さずに、待機とログ取得のコードだけをもう一度実行する。
  `@OnlyCurrentDoc` により、求める権限は「このアプリケーションがインストールされている Google スライドのプレゼンテーションを表示して管理」だけになる。
