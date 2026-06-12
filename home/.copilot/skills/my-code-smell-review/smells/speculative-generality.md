# Speculative Generality（過剰な一般化の先回り）

<https://refactoring.guru/smells/speculative-generality>

## 兆候と症状

使われていないクラス、メソッド、フィールド、引数があります。

## 原因

将来必要になるかもしれない機能を「念のため」に見越してコードを書くことがあります。しかし、その将来の機能が結局実装されないまま終わることも少なくありません。すると、コードは理解しづらくなり、保守もしにくくなります。

## 治療法

- 使われていない abstract class を取り除くには、[Collapse Hierarchy](https://refactoring.guru/collapse-hierarchy) を試します。
- 別クラスへの不要な委譲は、[Inline Class](https://refactoring.guru/inline-class) で解消できます。
- 使われていないメソッドには、[Inline Method](https://refactoring.guru/inline-method) を使って整理します。
- 未使用の引数を持つメソッドは、[Remove Parameter](https://refactoring.guru/remove-parameter) で見直します。
- 未使用のフィールドは、そのまま削除できます。

## 効果

- コードがスリムになります。
- 保守しやすくなります。

## 無視してよい場合

- フレームワークを作っている場合は、そのフレームワーク自身では使っていなくても、利用者にとって必要な機能をあらかじめ用意しておくのは十分に合理的です。
- 要素を削除する前に、それが unit test で使われていないか確認してください。クラス内部の特定情報を取り出したり、テスト用の特別な操作を行ったりするために必要になっていることがあります。
