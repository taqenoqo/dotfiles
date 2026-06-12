# Switch Statements（スイッチ文）

<https://refactoring.guru/smells/switch-statements>

## 兆候と症状

複雑な `switch` 文、あるいは長く連なる `if` 文がある。

## 原因

`switch` や `case` があまり出てこないことは、オブジェクト指向らしいコードの特徴のひとつです。ところが実際には、ひとつの `switch` に対応する処理がプログラムのあちこちに散らばっていることがよくあります。新しい条件を追加するたびに、その `switch` を全部探し出して修正しなければなりません。

経験則として、`switch` を見かけたら「ここはポリモーフィズムで置き換えられないか」と考えるべきです。

## 治療法

- `switch` を切り出して適切なクラスに置くには、まず [Extract Method](https://refactoring.guru/extract-method) を行い、その後で [Move Method](https://refactoring.guru/move-method) が必要になることがあります。
- `switch` が型コードに基づいていて、たとえば実行時モードの切り替えに使われているなら、[Replace Type Code with Subclasses](https://refactoring.guru/replace-type-code-with-subclasses) または [Replace Type Code with State/Strategy](https://refactoring.guru/replace-type-code-with-state-strategy) を使います。
- 継承構造を整えたら、[Replace Conditional with Polymorphism](https://refactoring.guru/replace-conditional-with-polymorphism) を適用します。
- 条件の数がそれほど多くなく、どれも異なる引数で同じメソッドを呼んでいるだけなら、ポリモーフィズムは大げさです。その場合は [Replace Parameter with Explicit Methods](https://refactoring.guru/replace-parameter-with-explicit-methods) でメソッドを小さく分け、それに合わせて `switch` を書き換えます。
- 条件分岐の選択肢のひとつが `null` であれば、[Introduce Null Object](https://refactoring.guru/introduce-null-object) を使います。

## 効果

コードの構成がよくなります。

## 無視してよい場合

- `switch` がごく単純な処理をしているだけなら、わざわざ書き換える必要はありません。
- `switch` は、生成するクラスを選ぶために [Factory Method](https://refactoring.guru/design-patterns/factory-method) や [Abstract Factory](https://refactoring.guru/design-patterns/abstract-factory) でよく使われます。
