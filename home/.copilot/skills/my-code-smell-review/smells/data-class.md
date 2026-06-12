# Data Class（データクラス）

<https://refactoring.guru/smells/data-class>

## 兆候と症状

Data Class とは、フィールドと、それにアクセスするための素朴なメソッド（getter / setter）しか持たないクラスのことです。こうしたクラスは、他のクラスに使われる単なるデータの入れ物になっています。追加の振る舞いをほとんど持たず、自分が保持しているデータを自律的に扱うこともできません。

## 原因

作ったばかりのクラスに public フィールドが数個だけあり、場合によっては getter / setter が少し付いている、というのは珍しいことではありません。ただし、オブジェクトの本当の力は、データだけでなく、そのデータに対する振る舞いや操作も一緒に持てる点にあります。

## 治療法

- クラスに public フィールドがあるなら、[Encapsulate Field](https://refactoring.guru/encapsulate-field) を使って直接アクセスできないようにし、getter / setter 経由でのみ触れるようにします。
- 配列などのコレクションにデータを保持している場合は、[Encapsulate Collection](https://refactoring.guru/encapsulate-collection) を使います。
- そのクラスを利用しているクライアントコードを見直します。すると、本来は data class 自身に置いたほうが自然な処理が見つかることがあります。その場合は、[Move Method](https://refactoring.guru/move-method) や [Extract Method](https://refactoring.guru/extract-method) を使って、その機能を data class 側へ移します。
- クラスに意味のあるメソッドを十分に持たせた後は、クラス内部のデータに広すぎるアクセスを許している古いアクセサメソッドを整理したくなるでしょう。その際は、[Remove Setting Method](https://refactoring.guru/remove-setting-method) や [Hide Method](https://refactoring.guru/hide-method) が役立ちます。

## 効果

- コードの理解しやすさと整理のしやすさが向上します。特定のデータに対する操作が、コード全体に散らばるのではなく、1か所にまとまります。
- クライアントコード内の重複を見つけやすくなります。
