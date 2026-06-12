# Incomplete Library Class（不完全なライブラリクラス）

<https://refactoring.guru/smells/incomplete-library-class>

## 兆候と症状

遅かれ早かれ、[libraries](https://en.wikipedia.org/wiki/Library_(computing)) は利用者の要求を満たせなくなる。しかし、その問題に対するもっとも直接的な解決策であるライブラリ自体の変更は、読み取り専用であるため実行できないことが多い。

## 原因

ライブラリの作者が必要な機能を用意していない、あるいは実装を断っている。

## 治療法

- ライブラリクラスに少数のメソッドを補いたいなら、[Introduce Foreign Method](https://refactoring.guru/introduce-foreign-method) を使う。
- クラスライブラリに対して大きな変更が必要なら、[Introduce Local Extension](https://refactoring.guru/introduce-local-extension) を使う。

## 効果

- コードの重複を減らせる。ライブラリを一から作り直さなくても、既存のものを土台として活用できる。

## 無視してよい場合

- ライブラリを拡張すると、その後ライブラリ側の変更に追随するための追加作業が発生することがある。
