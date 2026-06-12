# Dead Code（死んだコード）

<https://refactoring.guru/smells/dead-code>

## 兆候と症状

変数、引数、フィールド、メソッド、クラスが、もはや使われていません。多くの場合、そのコードはすでに役目を終えています。

## 原因

ソフトウェアの要件変更や修正対応のあと、古いコードを掃除する時間が取れず、そのまま残ってしまうことがあります。

また、複雑な条件分岐の中で、エラーや別の事情によって到達不能になった分岐として見つかることもあります。

## 治療法

死んだコードを手早く見つけるには、優れた [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment) を使うのが近道です。

- 未使用のコードや不要なファイルを削除します。
- 不要なクラスで、サブクラスやスーパークラスが使われている場合は、[Inline Class](https://refactoring.guru/inline-class) や [Collapse Hierarchy](https://refactoring.guru/collapse-hierarchy) を適用できます。
- 不要な引数を取り除くには、[Remove Parameter](https://refactoring.guru/remove-parameter) を使います。

## 効果

- コード量が減ります。
- 保守がシンプルになります。
