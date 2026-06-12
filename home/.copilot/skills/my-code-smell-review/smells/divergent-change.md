# Divergent Change（発散的変更）

<https://refactoring.guru/smells/divergent-change>

## 兆候と症状

クラスに変更を加えるたびに、関係の薄い多くのメソッドまで一緒に直さなければならない状態です。たとえば、新しい商品タイプを追加するだけで、商品の検索・表示・注文に関するメソッドをまとめて変更する必要があります。

## 原因

このように変更があちこちへ発散するのは、プログラムの構造がよくないか、いわゆる「コピペ実装」が積み重なっていることが原因である場合がよくあります。

## 治療法

- [Extract Class](https://refactoring.guru/extract-class) で、そのクラスの振る舞いを分割します。
- 別々のクラスが同じ振る舞いを持っているなら、継承でまとめることを検討します（[Extract Superclass](https://refactoring.guru/extract-superclass) と [Extract Subclass](https://refactoring.guru/extract-subclass)）。

## 効果

- コードの構成が改善されます。
- 重複コードが減ります。
- 保守が楽になります。
