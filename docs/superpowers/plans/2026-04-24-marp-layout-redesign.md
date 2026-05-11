# Marp my-theme レイアウト再構築 実装プラン

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** header/footer の absolute 配置を廃止し、Flexbox フローに置き換えることで calc() チェーンを含む全変数を削除してシンプルな CSS にする。

**Architecture:** `section` を `display: flex; flex-direction: column; padding: 0` にし、header/footer を通常フローに戻す。左右パディングは各コンテンツ要素が持つ。通常スライドの header と h2 バーは同じ accent 色で視覚的に一体化。

**Tech Stack:** CSS (Marp テーマ、`@import 'default'` を継承)

---

### Task 1: section 基本スタイルの書き換え

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

変数ブロックと section のレイアウト指定を書き換える。`--hf-*`, `--h2-*`, `--padding-*` をすべて削除し、色変数のみ残す。`display: flex; flex-direction: column; padding: 0` を追加。

- [ ] **Step 1: section {} ブロックを書き換える**

```css
/* ── カスタムプロパティ ── */
section {
  --accent: #66bbee;
  --title-text: #003355;
  --on-accent: #ffffff;

  color-scheme: light;
  font-family: 'M PLUS 2', 'Noto Sans JP', sans-serif;
  display: flex;
  flex-direction: column;
  padding: 0;
}
```

現行の `section {}` ブロック（7〜38行）全体をこの内容に置き換える。

- [ ] **Step 2: section:not(:has(h1)) {} ブロックを削除する**

55〜84行のブロック（変数宣言と padding-top 指定）を削除する。

---

### Task 2: header / footer ルールの書き換え

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

既存の `section header`, `section footer` ルールをすべて書き換え。`position: relative` で z-index を有効にしつつ flex フロー内に留める。`top`/`bottom`/`left` は削除。

- [ ] **Step 1: 既存の header/footer 関連ルールをすべて置き換える**

ファイル内の以下のブロックを削除する：
- `/* header/footer は全スライド共通で常に上下端に固定 */` ブロック（z-index のみ）
- `section header { top: ...; left: ...; font-size: ...; line-height: ...; }` ブロック
- `section footer { bottom: ...; left: ...; font-size: ...; line-height: ...; }` ブロック

代わりに以下を追加する：

```css
/* ── header / footer ── */
section header,
section footer {
  position: relative; /* flex フロー内に留めつつ z-index を有効化 */
  z-index: 2;
  font-size: 18px;
  line-height: 1;
  padding: 12px;
}

section footer {
  margin-top: auto; /* 常に底部に固定 */
}
```

---

### Task 3: コンテンツ要素への左右パディング付与

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

section の左右 padding を 0 にした代わりに、直下コンテンツ要素へ付与。h2 バーはこの値をそのまま使う（背景は section 端まで広がり、テキストは 60px 内側から始まる）。

- [ ] **Step 1: グローバルコンテンツパディングルールを追加する**

コードフォントルールの後に追加：

```css
/* ── コンテンツ要素の左右パディング ── */
section > :not(header):not(footer) {
  padding-left: 60px;
  padding-right: 60px;
}
```

---

### Task 4: 通常スライドの h2 バー書き換え

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

`section:not(:has(h1)) h2` を absolute から static に変更。高さ・box-sizing・明示的な height を削除。背景とパディングを直値で記述。

- [ ] **Step 1: section:not(:has(h1)) header ルールを追加する**

```css
/* ── 通常スライド: header を h2 バーと色で一体化 ── */
section:not(:has(h1)) header {
  background: var(--accent);
  color: var(--on-accent);
  padding-bottom: 0; /* h2 バーと隙間なく繋げる */
}
```

- [ ] **Step 2: section:not(:has(h1)) h2 ルールを書き換える**

現行の `section:not(:has(h1)) h2 { ... }` ブロック（86〜106行）を以下に置き換える：

```css
/* ── 通常スライド: h2 ヘッダーバー ── */
section:not(:has(h1)) h2 {
  background: var(--accent);
  color: var(--on-accent);
  font-size: 1.4rem;
  font-weight: 700;
  margin: 0;
  padding-top: 20px;
  padding-bottom: 12px;
  border: none;
  letter-spacing: 0.04em;
}
```

`position`, `top`, `left`, `right`, `box-sizing`, `height`, `padding-left`/`right` の指定はすべて削除（左右は Task 3 のグローバルルールから継承）。

---

### Task 5: タイトルスライドの書き換え

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

タイトルスライドも global flex を継承。左右パディングを 80px に上書き。`padding-top`/`padding-bottom` の直値指定を削除。

- [ ] **Step 1: section:has(h1) {} を書き換える**

現行：
```css
section:has(h1) {
  display: flex;
  flex-direction: column;
  padding: var(--padding-top) 80px var(--padding-bottom);
  overflow: hidden;
  position: relative;
}
```

新しい内容：
```css
/* ── タイトルスライド（h1 を含むスライドが自動適用） ── */
section:has(h1) {
  overflow: hidden;
  position: relative; /* ::before の absolute 基準 */
}

section:has(h1) > :not(header):not(footer) {
  padding-left: 80px;
  padding-right: 80px;
}
```

`display: flex; flex-direction: column` は `section {}` グローバルルールから継承されるため削除。`padding-top`/`padding-bottom` は header/footer がフロー内に入るため不要。

- [ ] **Step 2: section:has(h1) > *:not(header):not(footer) のコメントを更新する**

現行コメント「`header/footer は絶対配置を維持するため除外`」を削除し、実態に合わせる：

```css
/* 子要素を ::before 疑似要素の前面に */
section:has(h1) > *:not(header):not(footer) {
  position: relative;
  z-index: 1;
}
```

---

### Task 6: 最終確認とコミット

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

- [ ] **Step 1: 残存する旧変数参照がないか確認する**

```bash
grep -n -- '--hf-\|--h2-\|--padding-\|position: absolute\|calc(' \
  home/.config/marp/themes/my-theme.css
```

Expected: `section:has(h1)::before` の `position: absolute` のみがマッチし、他はゼロ。

- [ ] **Step 2: ファイル全体を目視確認する**

```bash
cat home/.config/marp/themes/my-theme.css
```

チェック項目：
- `section {}` に色変数 3 つだけ
- `section header/footer` に `position: relative; z-index: 2` あり
- `section:not(:has(h1)) h2` に `position` なし
- `section:has(h1)` に `display: flex` なし（継承）

- [ ] **Step 3: コミットする**

```bash
git add home/.config/marp/themes/my-theme.css
git commit -m "refactor(marp): replace absolute header/footer layout with flexbox flow"
```
