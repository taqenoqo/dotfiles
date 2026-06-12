# Inappropriate Intimacy（不適切な親密さ）

<https://refactoring.guru/smells/inappropriate-intimacy>

## 兆候と症状

あるクラスが、別のクラスの内部フィールドや内部メソッドを使っています。

## 原因

必要以上に長い時間を一緒に過ごしているクラスには注意が必要です。良いクラス同士は、お互いのことをできるだけ知らないほうが望ましいものです。そのほうが保守もしやすく、再利用もしやすくなります。

## 治療法

- 最も単純なのは、[Move Method](https://refactoring.guru/move-method) や [Move Field](https://refactoring.guru/move-field) を使い、あるクラスの一部を、それが実際に使われている側のクラスへ移すことです。ただし、元のクラスが本当にその要素を必要としていない場合に限ります。
- もう1つの方法は、[Extract Class](https://refactoring.guru/extract-class) と [Hide Delegate](https://refactoring.guru/hide-delegate) を使って、コード上の関係をきちんと表に出すことです。
- クラス同士が相互依存になっているなら、[Change Bidirectional Association to Unidirectional](https://refactoring.guru/change-bidirectional-association-to-unidirectional) を使うべきです。
- この「親密さ」がサブクラスとスーパークラスの間にあるなら、[Replace Delegation with Inheritance](https://refactoring.guru/replace-delegation-with-inheritance) を検討します。

## 効果

- コード構成が改善されます。
- 保守と再利用がしやすくなります。
