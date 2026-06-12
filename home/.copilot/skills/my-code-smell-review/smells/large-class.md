# Large Class（大きすぎるクラス）

<https://refactoring.guru/smells/large-class>

## 兆候と症状

クラスにフィールド、メソッド、コード行が多すぎる。

## 原因

クラスはたいてい小さく始まる。しかしプログラムが成長するにつれて、機能が少しずつ積み上がり、やがて肥大化していく。

Long Method と同じで、新しい機能のために新しいクラスを作るより、既存クラスに追加してしまうほうが、開発者にとって心理的な負担が小さいことが多い。

## 治療法

クラスがあまりに多くの役割を背負っているなら、分割を考えるべきである。

- 巨大クラスの振る舞いの一部を別コンポーネントとして切り出せるなら、[Extract Class](https://refactoring.guru/extract-class) が役立つ。
- 振る舞いの一部に複数の実装パターンがある、またはごくまれなケースでしか使われないなら、[Extract Subclass](https://refactoring.guru/extract-subclass) を使う。
- クライアントが利用できる操作や振る舞いの一覧をはっきりさせたいなら、[Extract Interface](https://refactoring.guru/extract-interface) が有効である。
- 巨大クラスが画面やGUIを担当している場合は、データや振る舞いの一部を別のドメインオブジェクトへ移すことも考えられる。その際、同じデータを2か所に保持しつつ整合性を保つ必要があるなら、[Duplicate Observed Data](https://refactoring.guru/duplicate-observed-data) が助けになる。

## 効果

- 開発者は、そのクラスに属する大量の属性を頭の中で抱え続けなくてよくなる。
- 大きなクラスを分割すると、コードや機能の重複を避けられることが多い。
