# TypeScript のテストには Vitest を使う

## 指摘すること

TypeScript のプロジェクトで、Vitest 以外のテストランナー (Node 標準の `node:test` など) を使っていたら指摘し、Vitest にするよう勧める。

## 理由

ユーザが、どのプロジェクトにも当てはまる好みとして示した。詳しい理由は未確認。

## 例

反している例: `node:test` と `node:assert` でテストを書き、`node --test` で実行している。

沿っている例: `vitest` の `describe` / `it` / `expect` でテストを書き、`vitest run` で実行している。

## 当てはまらない場合

未確認。

## 出所

2026-11-15、TypeScript の CLI ツールで Node 標準のテストランナーを使ってテストを書いたところ、「テストには vitest を使ってほしい」と指示された。のちに、どのプロジェクトにも当てはまる好みだと確認した。
