# Marp my-theme 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `home/.config/marp/themes/my-theme.css` に水色アクセント・M PLUS フォント・斜め分割タイトルスライドを実装する。

**Architecture:** `@import 'default'` を維持し、CSS カスタムプロパティ・フォントオーバーライド・`section.title` クラスの追加で実現。単一ファイルへの追記のみ。

**Tech Stack:** Marp CLI v4.3.1、CSS（Google Fonts via @import）

---

## ファイル構成

| ファイル | 操作 | 内容 |
|----------|------|------|
| `home/.config/marp/themes/my-theme.css` | 編集 | テーマ本体（全変更） |
| `~/dotfiles/home/.config/marp/themes/test/marp-test.md` | 作成（一時） | 動作確認用テストスライド |

---

### Task 1: テストスライド作成とベースライン確認

**Files:**
- Create: `~/dotfiles/home/.config/marp/themes/test/marp-test.md`（一時ファイル）

- [ ] **Step 1: テストスライドを格納するディレクトリを作成する**

```bash
mkdir -p ~/dotfiles/home/.config/marp/themes/test
```

- [ ] **Step 2: テストスライドを作成する**

```markdown
---
marp: true
theme: my-theme
---

<!-- _class: title -->
# プレゼンテーションタイトル
## サブタイトル
著者名 · 2026-04-23

---

# スライドタイトル

本文テキストが読みやすく表示されること。

- 箇条書き項目 A
- 箇条書き項目 B
- 箇条書き項目 C

---

# コードの例

コードブロックが正しく表示されること。

​```javascript
const greet = (name) => {
  console.log(`Hello, ${name}`);
};
greet('world');
​```

---

# 見出しと本文

## h2 見出し

本文テキスト。**太字**と*イタリック*と`インラインコード`。

### h3 見出し

> blockquote テキスト

| カラム A | カラム B |
|----------|----------|
| セル 1   | セル 2   |
```

- [ ] **Step 2: ベースライン（変更前）をレンダリングして確認**

```bash
marp --theme ~/.config/marp/themes/my-theme.css ~/dotfiles/home/.config/marp/themes/test/marp-test.md --html -o ~/dotfiles/home/.config/marp/themes/test/marp-test-before.html
open ~/dotfiles/home/.config/marp/themes/test/marp-test-before.html
```

現時点では `default` テーマのまま表示される。これがベースライン。

---

### Task 2: Google Fonts インポートと CSS 変数

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

- [ ] **Step 1: Google Fonts @import と CSS 変数を追加する**

`home/.config/marp/themes/my-theme.css` を以下の内容に書き換える（`@import 'default'` は必ず先頭に残す）：

```css
/* @theme my-theme */

@import 'default';
@import url('https://fonts.googleapis.com/css2?family=M+PLUS+2:wght@400;500;600;700&family=M+PLUS+Rounded+1c:wght@400;700&family=M+PLUS+Code+Latin:wght@400;700&display=swap');

/* ── カスタムプロパティ ── */
section {
  --accent: #66bbee;
  --title-text: #003355;
  --on-accent: #ffffff;
}
```

- [ ] **Step 2: レンダリングして変数が読み込まれることを確認**

```bash
marp --theme ~/.config/marp/themes/my-theme.css ~/dotfiles/home/.config/marp/themes/test/marp-test.md --html -o ~/dotfiles/home/.config/marp/themes/test/marp-test.html
open ~/dotfiles/home/.config/marp/themes/test/marp-test.html
```

期待値：見た目はまだ `default` のまま（変数追加のみなので変化なし）。エラーが出ないことを確認。

- [ ] **Step 3: コミット**

```bash
cd ~/dotfiles
git add home/.config/marp/themes/my-theme.css
git commit -m "feat(marp): add Google Fonts imports and CSS custom properties"
```

---

### Task 3: 本文・コードフォントの適用

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

- [ ] **Step 1: section ベーススタイル（フォント・カラースキーム・パディング）を追加する**

CSS 変数ブロックの直後に追記：

```css
/* ── ベーススタイル ── */
section {
  color-scheme: light;
  font-family: 'M PLUS 2', 'Noto Sans JP', sans-serif;
  padding: 90px 60px 50px;
  position: relative;
}

/* コードフォント */
section code,
section pre {
  font-family: 'M PLUS Code Latin', ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
}
```

- [ ] **Step 2: レンダリングして本文フォントが変わることを確認**

```bash
marp --theme ~/.config/marp/themes/my-theme.css ~/dotfiles/home/.config/marp/themes/test/marp-test.md --html -o ~/dotfiles/home/.config/marp/themes/test/marp-test.html
open ~/dotfiles/home/.config/marp/themes/test/marp-test.html
```

期待値：本文が M PLUS 2 に変わる。コードブロックが M PLUS Code Latin に変わる。

- [ ] **Step 3: コミット**

```bash
cd ~/dotfiles
git add home/.config/marp/themes/my-theme.css
git commit -m "feat(marp): apply M PLUS 2 body font and M PLUS Code Latin for code"
```

---

### Task 4: 見出しフォント（h1〜h6）の適用

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

- [ ] **Step 1: h2〜h6 に M PLUS Rounded 1c を適用する**

追記：

```css
/* ── 見出しフォント ── */
section h1,
section h2,
section h3,
section h4,
section h5,
section h6 {
  font-family: 'M PLUS Rounded 1c', sans-serif;
}
```

- [ ] **Step 2: レンダリングして見出しフォントが丸文字になることを確認**

```bash
marp --theme ~/.config/marp/themes/my-theme.css ~/dotfiles/home/.config/marp/themes/test/marp-test.md --html -o ~/dotfiles/home/.config/marp/themes/test/marp-test.html
open ~/dotfiles/home/.config/marp/themes/test/marp-test.html
```

期待値：h1〜h6 がすべて M PLUS Rounded 1c（丸文字）で表示される。

- [ ] **Step 3: コミット**

```bash
cd ~/dotfiles
git add home/.config/marp/themes/my-theme.css
git commit -m "feat(marp): apply M PLUS Rounded 1c to all headings"
```

---

### Task 5: 通常スライドのヘッダーバー（h1）

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

- [ ] **Step 1: h1 を絶対配置の水色ヘッダーバーにする**

追記：

```css
/* ── 通常スライド: h1 ヘッダーバー ── */
section h1 {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  margin: 0;
  padding: 12px 60px;
  background: var(--accent);
  color: var(--on-accent);
  font-size: 1.1rem;
  font-weight: 700;
  border: none;
  letter-spacing: 0.04em;
}
```

- [ ] **Step 2: レンダリングしてヘッダーバーを確認**

```bash
marp --theme ~/.config/marp/themes/my-theme.css ~/dotfiles/home/.config/marp/themes/test/marp-test.md --html -o ~/dotfiles/home/.config/marp/themes/test/marp-test.html
open ~/dotfiles/home/.config/marp/themes/test/marp-test.html
```

期待値：
- 通常スライドの h1 がスライド上部全幅の水色バー（白文字）になる
- 本文コンテンツがヘッダーバーと重ならない（padding-top: 90px が効いている）

- [ ] **Step 3: コミット**

```bash
cd ~/dotfiles
git add home/.config/marp/themes/my-theme.css
git commit -m "feat(marp): add slim accent-colored h1 header bar for content slides"
```

---

### Task 6: タイトルスライド（`section.title`）

**Files:**
- Modify: `home/.config/marp/themes/my-theme.css`

- [ ] **Step 1: section.title の斜め分割レイアウトを実装する**

追記：

```css
/* ── タイトルスライド ── */
section.title {
  display: flex;
  flex-direction: column;
  padding: 60px 80px;
  overflow: hidden;
}

/* 右肩上がりの斜め分割（水色エリア） */
section.title::before {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--accent);
  clip-path: polygon(0 55%, 100% 35%, 100% 100%, 0 100%);
  z-index: 0;
}

/* 子要素を疑似要素の前面に */
section.title > * {
  position: relative;
  z-index: 1;
}

/* h1: ヘッダーバー上書き → タイトル用スタイルに */
section.title h1 {
  position: static;
  background: none;
  color: var(--title-text);
  font-size: 2.4rem;
  font-weight: 700;
  padding: 0;
  letter-spacing: 0.02em;
  margin: 0 0 0.2em;
}

/* h2: サブタイトル */
section.title h2 {
  color: rgba(0, 51, 85, 0.7);
  font-family: 'M PLUS Rounded 1c', sans-serif;
  font-size: 1rem;
  font-weight: 400;
  margin: 0.3em 0 0;
  border: none;
  padding: 0;
}

/* 最後の p: 著者情報（右下・白） */
section.title p:last-child {
  margin-top: auto;
  text-align: right;
  color: var(--on-accent);
  font-size: 0.9rem;
  padding-bottom: 0;
}
```

- [ ] **Step 2: レンダリングしてタイトルスライドを確認**

```bash
marp --theme ~/.config/marp/themes/my-theme.css ~/dotfiles/home/.config/marp/themes/test/marp-test.md --html -o ~/dotfiles/home/.config/marp/themes/test/marp-test.html
open ~/dotfiles/home/.config/marp/themes/test/marp-test.html
```

期待値：
- タイトルスライド（1枚目）に右肩上がりの水色斜め分割が表示される
- タイトル（h1）が左上に `#003355` で表示される
- サブタイトル（h2）がタイトル直下にやや薄い `#003355` で表示される
- 著者名（最後の p）が右下に白文字で表示される
- 通常スライド（2枚目以降）のレイアウトが崩れていない

- [ ] **Step 3: コミット**

```bash
cd ~/dotfiles
git add home/.config/marp/themes/my-theme.css
git commit -m "feat(marp): add diagonal split title slide layout"
```

---

### Task 7: 最終確認とクリーンアップ

- [ ] **Step 1: PDF でもレンダリングして確認**

```bash
marp --theme ~/.config/marp/themes/my-theme.css ~/dotfiles/home/.config/marp/themes/test/marp-test.md --pdf -o ~/dotfiles/home/.config/marp/themes/test/marp-test.pdf
open ~/dotfiles/home/.config/marp/themes/test/marp-test.pdf
```

期待値：すべてのスライドが意図通りのデザインで表示される。

- [ ] **Step 2: 一時ファイルを削除**

```bash
rm ~/dotfiles/home/.config/marp/themes/test/marp-test.md ~/dotfiles/home/.config/marp/themes/test/marp-test.html ~/dotfiles/home/.config/marp/themes/test/marp-test-before.html ~/dotfiles/home/.config/marp/themes/test/marp-test.pdf
```

- [ ] **Step 3: コミット履歴を確認**

```bash
cd ~/dotfiles
git log --oneline -6
```

---

## 完成後の my-theme.css 全体像

```css
/* @theme my-theme */

@import 'default';
@import url('https://fonts.googleapis.com/css2?family=M+PLUS+2:wght@400;500;600;700&family=M+PLUS+Rounded+1c:wght@400;700&family=M+PLUS+Code+Latin:wght@400;700&display=swap');

section { --accent: #66bbee; --title-text: #003355; --on-accent: #ffffff; }
section { color-scheme: light; font-family: ...; padding: ...; position: relative; }
section code, section pre { font-family: ...; }
section h1, ... h6 { font-family: 'M PLUS Rounded 1c', ...; }
section h1 { position: absolute; top: 0; ... background: var(--accent); ... }
section.title { display: flex; flex-direction: column; ... }
section.title::before { clip-path: polygon(0 55%, 100% 35%, 100% 100%, 0 100%); ... }
section.title h1 { position: static; color: var(--title-text); ... }
section.title h2 { ... }
section.title p:last-child { margin-top: auto; text-align: right; ... }
```
