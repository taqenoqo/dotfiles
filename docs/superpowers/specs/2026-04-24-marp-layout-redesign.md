# Marp my-theme レイアウト再構築

## 背景

現行テーマは header/footer を `position: absolute` で配置しており、コンテンツが重ならないよう `--padding-top` / `--padding-bottom` を複雑な `calc()` チェーンで計算している。これを廃止し、CSS Flexbox のフロー配置に置き換える。

## 目標

- header/footer の absolute 配置を撤廃
- `--hf-*` / `--h2-*` / `--padding-*` 変数をすべて削除
- CSS をシンプルな直値で記述
- 通常スライドで header と h2 バーを視覚的に一体化させる

## 設計

### section の基本レイアウト

```css
section {
  display: flex;
  flex-direction: column;
  padding: 0;  /* 左右 padding は各要素が持つ */
}
```

### header / footer

- `position: static`（デフォルトテーマの absolute を上書き）
- padding / font-size / line-height は直値で記述
- footer: `margin-top: auto` で常に底部に固定

### コンテンツ要素のパディング

section の左右 padding をゼロにした代わりに、h2 バー以外のすべての直下子要素に `padding-left: 60px; padding-right: 60px` を付与する。

### 通常スライド（h2 あり）

- header: `background: var(--accent)` / `color: var(--on-accent)` で h2 バーと一体化
- h2 バー: `position: static`、フル幅（section に左右 padding なし）、`background: var(--accent)`
- header → h2 バーが連続した帯として見える

### タイトルスライド（h1 あり）

- header の背景なし（現行通り透明）
- `::before` 疑似要素による斜め背景は維持
- section は全体で同じ flex 構造

## 削除する変数

以下をすべて削除し、直値に置き換える：

- `--hf-font-size`, `--hf-line-height`
- `--hf-padding-y`, `--hf-padding-x`
- `--hf-gap`
- `--padding-top`, `--padding-bottom`
- `--h2-font-size`（→ `1.4rem` 直値）
- `--h2-line-height-px`（→ 削除。h2 バー高さは flex で自動決定）
- `--h2-padding`（→ `20px` 直値で h2 バーの padding に組み込む）

## 残す変数

色だけ変数として保持する：

- `--accent`
- `--title-text`
- `--on-accent`
