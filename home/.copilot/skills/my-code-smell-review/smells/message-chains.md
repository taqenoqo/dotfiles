# Message Chains（メッセージチェーン）

<https://refactoring.guru/smells/message-chains>

## 兆候と症状

コードの中に、`$a->b()->c()->d()` のような呼び出しの連鎖が現れる。

## 原因

メッセージチェーンは、クライアントが別のオブジェクトを取得し、そのオブジェクトがさらに別のオブジェクトを取りに行き……という連鎖で発生する。こうした連鎖があると、クライアントはクラス構造をたどることに依存してしまう。そのため、オブジェクト同士の関係が変わるたびにクライアント側も修正が必要になる。

## 治療法

- メッセージチェーンを取り除くには、[Hide Delegate](https://refactoring.guru/hide-delegate) を使う。
- ただし、連鎖の末端にあるオブジェクトをなぜ使っているのかを考えたほうがよいこともある。その機能を [Extract Method](https://refactoring.guru/extract-method) で切り出し、[Move Method](https://refactoring.guru/move-method) を使って連鎖の先頭側へ移すほうが自然な場合もある。

## 効果

- 連鎖に含まれるクラス間の依存を減らせる。
- 肥大化したコードを減らせる。

## 無視してよい場合

委譲の隠蔽をやりすぎると、実際にどこで機能が実現されているのか見えにくいコードになってしまう。つまり、[Middle Man](https://refactoring.guru/smells/middle-man) の臭いも同時に避ける必要がある。
