#!/usr/bin/env bash
# 規模メトリクス: 定義一覧・変更頻度・台帳から、レポートのセクション
# 「規模メトリクス・ホットスポット」の本文を markdown で stdout に出力する。
# 数え上げを LLM にやらせないための関門で、レポート中の数値はすべてここ由来とする。
set -euo pipefail

WORK_DIR=${1:?usage: metrics.sh <WORK_DIR>}
DEFS="$WORK_DIR/agg/defs.tsv"
INVENTORY="$WORK_DIR/inventory.tsv"
CHURN="$WORK_DIR/churn.tsv"

TOP_N=10

# 先頭 TOP_N 行だけ通す (head と違い入力を最後まで読むので pipefail と衝突しない)
first_rows() {
    awk -v n="$TOP_N" 'NR <= n'
}

# 長い順の関数・メソッド (行数 TAB 名前 TAB 場所)
functions_by_length() {
    awk -F'\t' '$2 == "func" || $2 == "method" {
        name = ($4 == "-") ? $3 : $4 "." $3
        print $8 - $7 + 1 "\t" name "\t" $1
    }' "$DEFS" | sort -rn
}

# メソッド数が多い順のクラス (メソッド数 TAB クラス TAB 場所)
classes_by_methods() {
    awk -F'\t' '$2 == "method" && $4 != "-" { n[$1 "\t" $4]++ }
        END { for (k in n) { split(k, a, "\t"); print n[k] "\t" a[2] "\t" a[1] } }' "$DEFS" |
        sort -rn
}

# クラス数が多い順のファイル (クラス数 TAB 場所)
files_by_classes() {
    awk -F'\t' '$2 == "class" { n[$1]++ }
        END { for (p in n) print n[p] "\t" p }' "$DEFS" | sort -rn
}

# クラス数が多い順のディレクトリ (クラス数 TAB ディレクトリ)
dirs_by_classes() {
    awk -F'\t' '$2 == "class" {
        dir = $1
        sub(/\/[^\/]*$/, "", dir)
        if (dir == $1) dir = "."
        n[dir]++
    }
    END { for (d in n) print n[d] "\t" d "/" }' "$DEFS" | sort -rn
}

# 変更が多い順の、台帳にあるファイル (コミット数 TAB 場所 TAB 行数 TAB 最終変更)
hotspots() {
    awk -F'\t' '
        NR == FNR { if ($0 !~ /^#/) lines[$1] = $2; next }
        $1 in lines { print $2 "\t" $1 "\t" lines[$1] "\t" $3 }
    ' "$INVENTORY" "$CHURN" | sort -rn
}

fn_count=$(functions_by_length | wc -l | tr -d ' ')
fn_max=$(functions_by_length | awk -F'\t' 'NR == 1 { print $1 }')
class_count=$(awk -F'\t' '$2 == "class"' "$DEFS" | wc -l | tr -d ' ')
public_count=$(awk -F'\t' '$5 == "public"' "$DEFS" | wc -l | tr -d ' ')
private_count=$(awk -F'\t' '$5 == "private"' "$DEFS" | wc -l | tr -d ' ')

echo '### 関数・メソッドの長さ'
echo
echo "- 対象 ${fn_count} 件 / 最大 ${fn_max:-0} 行"
echo
echo '| 行数 | 名前 | 場所 |'
echo '|---|---|---|'
functions_by_length | first_rows | awk -F'\t' '{ print "| " $1 " | `" $2 "` | " $3 " |" }'
echo
echo '### クラスの規模'
echo
echo "- クラス総数 ${class_count} / 定義の可視性: public ${public_count}, private ${private_count}"
echo
echo '| メソッド数 | クラス | 場所 |'
echo '|---|---|---|'
classes_by_methods | first_rows | awk -F'\t' '{ print "| " $1 " | `" $2 "` | " $3 " |" }'
echo
echo '### クラスの分布'
echo
echo '| クラス数 | ファイル |'
echo '|---|---|'
files_by_classes | first_rows | awk -F'\t' '{ print "| " $1 " | " $2 " |" }'
echo
echo '| クラス数 | ディレクトリ |'
echo '|---|---|'
dirs_by_classes | first_rows | awk -F'\t' '{ print "| " $1 " | " $2 " |" }'
echo
echo '### 変更ホットスポット'
echo
echo '| コミット数 | 場所 | 行数 | 最終変更 |'
echo '|---|---|---|---|'
hotspots | first_rows | awk -F'\t' '{ print "| " $1 " | " $2 " | " $3 " | " $4 " |" }'
