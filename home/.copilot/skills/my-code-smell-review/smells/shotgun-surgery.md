# Shotgun Surgery（散弾銃手術）

<https://refactoring.guru/smells/shotgun-surgery>

## 兆候と症状

何かを少し直すだけでも、あちこちのクラスに細かな修正を大量に入れなければならない。

## 原因

本来ひとつにまとまっているべき責務が、多数のクラスへ分散してしまっている。これは [Divergent Change](https://refactoring.guru/smells/divergent-change) を過剰に適用した結果として起こることがある。

## 治療法

- [Move Method](https://refactoring.guru/move-method) と [Move Field](https://refactoring.guru/move-field) を使って、分散した振る舞いをひとつのクラスへ集約する。適切な受け皿となるクラスがなければ、新しく作る
- 同じクラスへ寄せ集めた結果、元のクラスがほとんど空になるなら、[Inline Class](https://refactoring.guru/inline-class) で不要になったクラスを取り除く

## 効果

- 構造が整理される
- 重複コードが減る
- 保守しやすくなる
