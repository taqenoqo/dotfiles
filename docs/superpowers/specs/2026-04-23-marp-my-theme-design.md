# Marp my-theme デザイン仕様

## 概要

`home/.config/marp/themes/my-theme.css` をカスタマイズする。
現在は `@import 'default'` のみの最小構成であり、ここに視覚的なスタイルを追加する。

## 設計方針

- `@import 'default'` を維持し、デフォルトテーマのベストプラクティス（Markdown 要素スタイル・CSS 変数・シンタックスハイライト等）をそのまま継承する。
- 上書きは最小限に抑え、カスタマイズ箇所を明確に分離する。
- Google Fonts（M PLUS 系）を `@import url(...)` で読み込む。

---

## カラーパレット

| 変数名 | 値 | 用途 |
|--------|----|------|
| `--accent` | `#66bbee` | ヘッダーバー・斜め分割背景 |
| `--title-text` | `#003355` | 表紙タイトル・サブタイトル文字色 |
| `--on-accent` | `#ffffff` | アクセント背景上のテキスト |
| 背景 | `#ffffff` | スライド背景（default 継承） |

---

## フォント

| 用途 | フォント | 読み込み |
|------|----------|----------|
| 見出し（h1〜h6）・ヘッダーバーテキスト | M PLUS Rounded 1c | Google Fonts |
| 本文（p・li・table 等） | M PLUS 2 | Google Fonts |
| コードブロック | M PLUS Code Latin → monospace fallback | Google Fonts |

本文フォントスタック例：
```css
font-family: 'M PLUS 2', 'Noto Sans JP', sans-serif;
```

---

## タイトルスライド（`section.title`）

ユーザーは先頭スライドに `<!-- _class: title -->` を付けて使用する。

### レイアウト

- **背景**：右肩上がりの斜め分割
  - 上部（約 60%）：白背景
  - 下部（約 40%）：`#66bbee`（水色）
  - 境界は `clip-path: polygon(0 55%, 100% 35%, 100% 100%, 0 100%)` を `::before` 疑似要素で実現
- **タイトル（h1）**：左上に配置、`#003355`、M PLUS Rounded 1c
- **サブタイトル（h2）**：タイトル直下、`#003355` 70% opacity
- **著者情報（最後の p）**：右下に配置、白文字、`margin-top: auto; text-align: right`

### CSS 構造

```css
section.title {
  display: flex;
  flex-direction: column;
  padding: 60px 80px;
  position: relative;
  overflow: hidden;
}

section.title::before {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--accent);
  clip-path: polygon(0 55%, 100% 35%, 100% 100%, 0 100%);
  z-index: 0;
}

section.title > * {
  position: relative;
  z-index: 1;
}

section.title h1 { /* 左上・#003355・Rounded */ }
section.title h2 {
  /* サブタイトル：タイトル直下、#003355 70% opacity、1rem、通常ウェイト */
  color: rgba(0, 51, 85, 0.7);
  font-family: 'M PLUS Rounded 1c', sans-serif;
  font-size: 1rem;
  font-weight: 400;
  margin: 0.3em 0 0;
  border: none;
}
section.title p:last-child { /* 右下・白・margin-top: auto */ }
```

---

## 通常スライド

### ヘッダーバー（h1）

- `section h1` を絶対配置してスライド上部全幅に配置
- 背景：`#66bbee`、テキスト：白、フォント：M PLUS Rounded 1c
- 高さ：スリム（padding: 12px 60px 程度）
- `section` の `padding-top` を増やして本文がヘッダーと重ならないようにする

```css
section {
  padding: 90px 60px 50px;
  position: relative;
}

section h1 {
  position: absolute;
  top: 0; left: 0; right: 0;
  margin: 0;
  padding: 12px 60px;
  background: var(--accent);
  color: var(--on-accent);
  font-family: 'M PLUS Rounded 1c', sans-serif;
  font-size: 1.1rem;
  font-weight: 700;
  border: none;
  letter-spacing: 0.04em;
}
```

### h2〜h6

- フォント：M PLUS Rounded 1c（太字）
- default の `border-bottom` 等は維持

---

## コードブロック

- default テーマの prettylights 変数（GitHub Light 相当）をそのまま使用
- `color-scheme: light` を `section` に明示して常に Light モードで表示
- コードフォント：`'M PLUS Code Latin', ui-monospace, monospace`

---

## 使用例

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

- 箇条書き
- テキスト

---

# コードの例

​```javascript
const greet = (name) => {
  console.log(`Hello, ${name}`);
};
​```
```

---

## ページ番号

`paginate: true` 時のページ番号スタイルは `default` テーマ継承のまま変更しない。

---

## ファイル構成

```
home/.config/marp/themes/my-theme.css   ← 編集対象（単一ファイル）
```

変更量の見込み：100〜150 行（`@import 'default'` の 1177 行に対する上書き）
