# Duplicate Code（重複コード）

<https://refactoring.guru/smells/duplicate-code>

## 兆候と症状

2つのコード片が、ほとんど同じに見える。

## 原因

重複は、複数の開発者が同じプログラムの別々の部分を同時に触っているときによく生まれる。担当が違うため、すでに似たコードが書かれていて再利用できることに気づかないまま、同じような処理を別に書いてしまうからである。

もっと見つけにくい重複もある。見た目は違っていても、実際には同じ仕事をしているコードである。この種の重複は発見も解消も難しい。

意図的に重複が作られることもある。締め切りに追われ、既存コードが目的に「ほぼ合っている」とき、経験の浅い開発者はつい copy & paste に流れやすい。また、単に整理するのを面倒がって放置される場合もある。

## 治療法

- 同じクラス内の2つ以上のメソッドに同じコードがあるなら、[Extract Method](https://refactoring.guru/extract-method) で共通処理を切り出し、両方から呼び出す
- 同じ階層レベルにある2つのサブクラスで同じコードが見つかったなら：
  - 両クラスで [Extract Method](https://refactoring.guru/extract-method) を行い、そのメソッドが使うフィールドは [Pull Up Field](https://refactoring.guru/pull-up-field) で引き上げる
  - 重複がコンストラクタ内にあるなら、[Pull Up Constructor Body](https://refactoring.guru/pull-up-constructor-body) を使う
  - 似ているが完全一致ではないなら、[Form Template Method](https://refactoring.guru/form-template-method) を使う
  - 2つのメソッドが同じ目的を別アルゴリズムで実現しているなら、より良いアルゴリズムを選び、[Substitute Algorithm](https://refactoring.guru/substitute-algorithm) を適用する
- 別々の2クラスに重複コードがあるなら：
  - そのクラス同士が継承関係にない場合は、[Extract Superclass](https://refactoring.guru/extract-superclass) で共通のスーパークラスを作り、既存の振る舞いをそこへまとめる
  - スーパークラス化が難しい、またはできないなら、一方のクラスで [Extract Class](https://refactoring.guru/extract-class) を行い、もう一方からその新しい部品を使う
- 条件だけが違い、実行しているコードが同じ条件式が大量にあるなら、[Consolidate Conditional Expression](https://refactoring.guru/consolidate-conditional-expression) で条件を統合し、[Extract Method](https://refactoring.guru/extract-method) で意味のわかる名前を持つ別メソッドに切り出す
- 条件式のすべての分岐で同じコードを実行しているなら、[Consolidate Duplicate Conditional Fragments](https://refactoring.guru/consolidate-duplicate-conditional-fragments) でその共通部分を条件分岐の外へ出す

## 効果

- 重複コードをまとめることで、コードの構造が単純になり、全体も短くなる
- 単純で短いコードは、さらに改善しやすく、保守コストも下がる

## 無視してよい場合

ごくまれに、完全に同じ2つのコード片を無理に統合すると、かえって直感的でわかりにくいコードになることがある。
