# Temporary Field（一時フィールド）

<https://refactoring.guru/smells/temporary-field>

## 兆候と症状

一時フィールドは、特定の状況でしか値が入りません。つまり、その場面でしかオブジェクトにとって必要ではなく、それ以外のときは空のままです。

## 原因

多くの場合、一時フィールドは大量の入力を必要とするアルゴリズムのために作られます。メソッドの引数を増やしすぎたくないため、開発者はそのデータをクラスのフィールドとして持たせる判断をします。しかし、それらのフィールドが使われるのはそのアルゴリズムの実行中だけで、普段はほとんど使われません。

この種のコードは理解しづらくなります。本来オブジェクトのフィールドには何らかの状態が入っているはずだと考えるのに、なぜかいつ見てもほぼ空だからです。

## 治療法

- 一時フィールドと、それを扱うコード一式を [Extract Class](https://refactoring.guru/extract-class) で別クラスへ切り出します。つまりメソッドオブジェクトを作る形になり、実質的には [Replace Method with Method Object](https://refactoring.guru/replace-method-with-method-object) と同じ効果が得られます。
- 一時フィールドに値があるかどうかを条件分岐で確かめているなら、その代わりに [Introduce Null Object](https://refactoring.guru/introduce-null-object) を導入します。

## 効果

コードが読みやすくなり、構成も整理されます。
