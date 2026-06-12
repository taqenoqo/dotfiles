# Long Method（長すぎるメソッド）

<https://refactoring.guru/smells/long-method>

## 兆候と症状

メソッドのコードが長すぎる。一般には、10行を超えるメソッドを見たら「本当にこの長さが必要か」と考え始めるべきである。

## 原因

Hotel California のように、このメソッドには何かが足され続ける一方で、取り除かれることはほとんどない。コードは読むより書くほうが楽なので、このコードスメルは、メソッドが巨大で扱いにくい怪物になるまで見過ごされがちである。

また、新しいメソッドを作るより、既存のメソッドに数行足すほうが心理的には楽に感じられることが多い。「たった2行だし、わざわざ新しいメソッドにするほどでもないか……」という発想で1行、また1行と増えていき、やがてスパゲッティコードが生まれる。

## 治療法

経験則として、メソッドの中で「ここはコメントで補足したい」と感じたら、その部分は新しいメソッドに切り出すべきである。説明が必要なら、たとえ1行でも独立したメソッドに分ける価値がある。しかも、そのメソッドに説明的な名前が付いていれば、実装を読まなくても何をしているかが伝わる。

- メソッド本体を短くするには [Extract Method](https://refactoring.guru/extract-method) を使う。
- ローカル変数やパラメータが抽出の邪魔になるなら、[Replace Temp with Query](https://refactoring.guru/replace-temp-with-query)、[Introduce Parameter Object](https://refactoring.guru/introduce-parameter-object)、[Preserve Whole Object](https://refactoring.guru/preserve-whole-object) を検討する。
- それでも難しい場合は、[Replace Method with Method Object](https://refactoring.guru/replace-method-with-method-object) でメソッド全体を別オブジェクトに移すことを試す。
- 条件分岐やループは、コードを別メソッドへ移せるサインになりやすい。条件分岐には [Decompose Conditional](https://refactoring.guru/decompose-conditional)、ループには [Extract Method](https://refactoring.guru/extract-method) を使うとよい。

## 効果

- オブジェクト指向のコードでは、短いメソッドを持つクラスほど長く健全に保たれる。メソッドや関数は長くなるほど理解も保守も難しくなる。
- 長いメソッドは、望ましくない重複コードの格好の隠れ場所にもなる。
