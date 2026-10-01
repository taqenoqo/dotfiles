---
name: md-to-gslides
description: Markdown のスライド草案を、ユーザが指定した既存の Google スライドのデザインに沿った Google スライドに変換する。ユーザのブラウザに Playwright で接続し、テンプレートのコピーに紐づく Apps Script でスライドを生成する。
---

# Markdown 草案から Google スライドを作る

テンプレート (デザインの手本にしたい既存の Google スライド) をコピーし、そのコピーに紐づく Apps Script で、
テンプレートのレイアウトを使ったスライドを生成する。最後に見た目を確認し、はみ出しなどを直す。

Google Cloud プロジェクトを作れない環境や、Playwright が起動したブラウザでは Google にログインできない環境でも動くように、
通常の Chrome をデバッグポート付きで起動して接続し、Apps Script もエディタの画面から実行する。

## 前提

- macOS の Google Chrome、`playwright-cli`、`jq`
- Google の表示言語が日本語であること。画面上の要素を日本語の文言で探すため。
- ユーザが同席していること。ログインと Apps Script の承認はユーザにしてもらう。

## 手順

### 1. 入力を確認して作業ディレクトリを作る

草案の Markdown と、テンプレートの URL をユーザに確認する。

作業ディレクトリにはログイン済みの Chrome プロファイルが入るため、最後に必ず消す。

```bash
WORK=$(mktemp -d /tmp/md-to-gslides.XXXXXX)
echo '{"browser":{"cdpEndpoint":"http://127.0.0.1:9333","isolated":false}}' > $WORK/cli.config.json
```

### 2. Chrome を起動してログインしてもらう

テンプレートのコピー画面 (URL の `/edit...` を `/copy` に置き換えたもの) を開いた Chrome をバックグラウンドで起動する。

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --user-data-dir=$WORK/profile \
  --remote-debugging-port=9333 --no-first-run --no-default-browser-check \
  "https://docs.google.com/presentation/d/{TEMPLATE_ID}/copy"
```

ユーザにログインしてもらい、完了の返事を待ってから接続する。
`playwright-cli` はログ類を `open` したディレクトリの `.playwright-cli/` に書くので、作業ディレクトリで `open` する。

```bash
cd $WORK && playwright-cli -s=gslides open --config=$WORK/cli.config.json
```

### 3. テンプレートをコピーする

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
playwright-cli -s=gslides tab-select 1
```

### 5. テンプレートのレイアウトを調べる

[converter.gs](converter.gs) だけを流し込み、`inspect` を実行する (「Apps Script の実行方法」参照)。

実行ログに、レイアウトごとに次の JSON が 1 行ずつ出る。

- `id`: 後で `DECK` に書くレイアウト ID
- `name`: レイアウトの内部名。表示名とは限らず、用途を表さないこともある。
- `placeholders`: テキストを入れられるプレースホルダの `[種類, left, top, width, height]`。上から、同じ高さなら左から順に並ぶ。
- `example`: そのレイアウトを使っているテンプレート内の最初のスライドの番号と、各プレースホルダの冒頭 40 字。使われていなければ `null`。

用途が読み取れないレイアウトは、Google スライドのタブに戻って `example` のスライドをスクリーンショットで確認する。

### 6. DECK を書いて生成する

草案の各スライドに合うレイアウトを選び、`$WORK/deck.js` に書く。
テンプレートで実際に使われているレイアウトと、`example` でのプレースホルダの使い方を手本にする。

```js
const DECK = [
  { layout: '<レイアウト ID>', texts: ['タイトル', 'サブタイトル'] },
  { layout: '<レイアウト ID>', texts: ['見出し', ['項目', '\t子項目', '項目']] },
];
```

- `texts` の各要素は、`placeholders` の同じ位置のプレースホルダに入る。
  - 文字列: そのまま入れる。改行は段落になる。
  - 文字列の配列: 箇条書きにする。先頭のタブの数が階層になる。
  - `null` または省略: 触らない。スライド番号 (`SLIDE_NUMBER`) などはこれにする。
- `build` は、その時点でデッキにある全スライドを、`DECK` から生成したスライドで置き換える。
  テンプレートに元からあるスライドも消える。`DECK` を直して何度でも実行し直せるが、手順 7 の手直しも消える。

converter.gs と deck.js を連結して流し込み、`build` を実行する。

### 7. 見た目を確認して直す

Google スライドのタブ (`tab-select 0`) に戻る。生成結果はリロードしなくても反映されている。

スライドを 1 枚ずつスクリーンショットで確認する。フィルムストリップは表示中のサムネイルしか DOM に無いので、
先頭のサムネイルをクリックして Home を押してから、ArrowDown で 1 枚ずつ移動する。

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

```bash
playwright-cli -s=gslides close
kill $(lsof -ti tcp:9333 -sTCP:LISTEN)
rm -rf $WORK
```

## Apps Script の実行方法

エディタのタブで、コードを流し込んで保存し、関数 `{FUNCTION}` を選んで実行し、終わるまで待って実行ログを返す。
`{FILES}` は `inspect` なら converter.gs、`build` なら converter.gs と `$WORK/deck.js`。

```bash
CODE=$(cat {FILES} | jq -Rs .)
playwright-cli -s=gslides run-code "async page => {
  await page.evaluate(code => monaco.editor.getModels().find(m => m.uri.path.endsWith('.js')).setValue(code), $CODE);
  await page.keyboard.press('Meta+S');
  await page.getByRole('listbox', { name: '実行する関数を選択' }).click();
  await page.getByRole('option', { name: '{FUNCTION}', exact: true }).click({ timeout: 30000 });
  await page.waitForFunction(() => document.querySelector('[aria-label=\"実行する関数を選択\"]').innerText.trim() === '{FUNCTION}');
  await page.getByRole('button', { name: '選択した関数を実行' }).click();
  const log = page.getByRole('list', { name: 'ログ' }).getByRole('listitem');
  await log.and(page.locator('[aria-label\$=\". お知らせ. 実行完了.\"], [aria-label*=\". エラー. \"]'))
    .or(page.getByText('承認が必要です')).first().waitFor({ timeout: 120000 });
  return (await log.allInnerTexts()).join('\n');
}"
```

- 関数の一覧は保存が終わってから更新される。また、選んだ関数が確定するまで少し時間がかかり、その前に実行ボタンを押すと前の関数が走る。そのため、選択が反映されるのを待ってから実行する。
- 完了判定にはログ本文ではなく種別 (aria-label) を使う。ログ本文にはテンプレートの文章が含まれ得るため。
- 初回は「承認が必要です」が出て、空のログが返る。「権限を確認」を押すと承認画面が別タブで開く (押した操作がナビゲーションのエラーで終わることがあるが、開いていれば問題ない)。
  ユーザに許可してもらうと実行がそのまま続くので、実行ボタンは押さずに、上と同じ待機とログ取得だけをやり直す。
  `@OnlyCurrentDoc` により、求める権限は「このアプリケーションがインストールされている Google スライドのプレゼンテーションを表示して管理」だけになる。
