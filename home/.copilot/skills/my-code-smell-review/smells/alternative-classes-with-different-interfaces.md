# Alternative Classes with Different Interfaces（異なるインターフェースを持つ代替クラス）

<https://refactoring.guru/smells/alternative-classes-with-different-interfaces>

## 兆候と症状

2つのクラスが同じ役割を果たしているのに、メソッド名だけが違っている。

## 原因

後からそのクラスを作った開発者が、すでに同等の機能を持つクラスが存在していることを知らなかったのかもしれません。

## 治療法

クラスのインターフェースを、できるだけ共通の形にそろえていきます。

- 代替クラス間でメソッド名をそろえるために、[Rename Method](https://refactoring.guru/rename-method) を使います。
- メソッドのシグネチャや実装を一致させるために、[Move Method](https://refactoring.guru/move-method)、[Add Parameter](https://refactoring.guru/add-parameter)、[Parameterize Method](https://refactoring.guru/parameterize-method) を使います。
- 重複しているのが機能の一部だけなら、[Extract Superclass](https://refactoring.guru/extract-superclass) を試します。この場合、既存のクラスはそのサブクラスになります。
- どの手法を使うか決めて実装し終えたら、クラスの片方を削除できることがあります。

## 効果

- 不要な重複コードがなくなり、コード全体の無駄が減ります。
- コードが読みやすく理解しやすくなります。最初のクラスとまったく同じ役割を持つ2つ目のクラスが、なぜ存在するのか悩まずに済みます。

## 無視してよい場合

クラスの統合が不可能だったり、できても見合わないほど難しかったりすることがあります。たとえば、代替クラスがそれぞれ別のライブラリにあり、独自の版を持っているようなケースです。
