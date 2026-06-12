# Middle Man（仲介役）

<https://refactoring.guru/smells/middle-man>

## 兆候と症状

あるクラスが、別のクラスに処理を委譲することしかしないなら、そもそもそのクラスは本当に必要なのか、という状態になっている。

## 原因

この臭いは、[Message Chains](https://refactoring.guru/smells/message-chains) を過剰に排除しようとした結果として生じることがある。

また、もともとそのクラスが担っていた有用な処理が少しずつ別のクラスへ移され、最後には委譲しかしない空っぽの殻のような存在だけが残ってしまう場合もある。

## 治療法

- そのクラスのメソッドの大半が別クラスへの委譲になっているなら、[Remove Middle Man](https://refactoring.guru/remove-middle-man) を検討する。

## 効果

- コードのかさばりを減らせる。

## 無視してよい場合

理由があって作られた Middle Man は削除しない。

- クラス間の依存を避けるために、あえて仲介役が置かれていることがある。
- [Proxy](https://refactoring.guru/design-patterns/proxy) や [Decorator](https://refactoring.guru/design-patterns/decorator) のように、意図的に Middle Man を作るデザインパターンもある。
