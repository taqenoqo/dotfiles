# Feature Envy（他人のデータへの執着）

<https://refactoring.guru/smells/feature-envy>

## 兆候と症状

あるメソッドが、自分自身のデータよりも、別のオブジェクトのデータに多くアクセスしています。

## 原因

このスメルは、フィールドを data class に移したあとに現れることがあります。その場合、データに対する操作も、そのクラスへ一緒に移したほうがよいかもしれません。

## 治療法

基本ルールとして、同時に変わるものは同じ場所に置くべきです。通常、データと、そのデータを使う関数は一緒に変更されます（もちろん例外はあります）。

- あるメソッドを別の場所へ移すべきなのが明らかなら、[Move Method](https://refactoring.guru/move-method) を使います。
- メソッドの一部だけが別オブジェクトのデータにアクセスしているなら、[Extract Method](https://refactoring.guru/extract-method) でその部分を切り出して移します。
- あるメソッドが複数のクラスの機能を使っている場合は、まず最も多くの関連データを持っているクラスを見極めます。そして、そのメソッドを他の関連データと一緒にそのクラスへ置きます。あるいは、[Extract Method](https://refactoring.guru/extract-method) でメソッドを複数に分割し、それぞれを適切なクラスへ配置します。

## 効果

- データ処理のコードを1か所に集めれば、重複が減ります。
- データを扱うメソッドが実データの近くに置かれるため、コードの構成が良くなります。

## 無視してよい場合

- 振る舞いを、あえてデータ保持クラスから分離しておく設計もあります。典型的な利点は、振る舞いを動的に切り替えやすくなることです（[Strategy](https://refactoring.guru/design-patterns/strategy)、[Visitor](https://refactoring.guru/design-patterns/visitor) など）。
