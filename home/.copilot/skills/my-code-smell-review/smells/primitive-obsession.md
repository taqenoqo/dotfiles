# Primitive Obsession（プリミティブへの執着）

<https://refactoring.guru/smells/primitive-obsession>

## 兆候と症状

- 通貨、範囲、電話番号のような特別な文字列など、本来は小さなオブジェクトで表せるものにプリミティブ型を使っている。
- 管理者権限を持つユーザーを表すために `USER_ADMIN_ROLE = 1` のような定数を使うなど、定数で情報を符号化している。
- データ配列のフィールド名として文字列定数を使っている。

## 原因

ほかの多くのコードスメルと同じく、Primitive Obsession も「とりあえずこれでいいか」という弱い瞬間に生まれる。「ただデータを入れるフィールドが1つ欲しいだけだし！」と考え、わざわざ新しいクラスを作るよりプリミティブ型のフィールドを追加して済ませてしまう。そして同じことを繰り返すうちに、クラスは巨大で扱いにくいものになっていく。

プリミティブ型は、しばしば型の代用品として使われる。本来は独立したデータ型で表すべきものを、許容される値の一覧として数値や文字列の集合で表し、それぞれに定数名を付けて運用する。そのため、そうした定数がコード全体に散らばりやすい。

もうひとつの典型例は、フィールドを配列で擬似的に表現してしまうケースである。クラスの中にさまざまなデータを詰め込んだ大きな配列があり、そこから値を取り出すために、クラス内で定義した文字列定数を配列インデックスとして使う。

## 治療法

- プリミティブ型のフィールドが多いなら、意味のまとまりごとにクラスへまとめられないか考える。できれば、そのデータに関する振る舞いも同じクラスへ移す。この場合は [Replace Data Value with Object](https://refactoring.guru/replace-data-value-with-object) を使う。
- プリミティブ型の値がメソッド引数として使われているなら、[Introduce Parameter Object](https://refactoring.guru/introduce-parameter-object) や [Preserve Whole Object](https://refactoring.guru/preserve-whole-object) を検討する。
- 複雑なデータが変数の中で符号化されているなら、[Replace Type Code with Class](https://refactoring.guru/replace-type-code-with-class)、[Replace Type Code with Subclasses](https://refactoring.guru/replace-type-code-with-subclasses)、[Replace Type Code with State/Strategy](https://refactoring.guru/replace-type-code-with-state-strategy) を使う。
- 変数の中に配列があるなら、[Replace Array with Object](https://refactoring.guru/replace-array-with-object) を使う。

## 効果

- プリミティブ型の代わりにオブジェクトを使うことで、コードの柔軟性が高まる。
- コードの理解しやすさと整理のしやすさが向上する。特定のデータに対する操作が1か所にまとまり、あちこちに散らばらなくなる。奇妙な定数がなぜ存在するのか、なぜ配列の中に押し込められているのかを推測しなくて済む。
- 重複コードを見つけやすくなる。
