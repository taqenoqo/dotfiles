#!/usr/bin/env bash
# 変更頻度台帳: git 履歴からファイルごとの変更回数と最終変更日を集計し、
# path <TAB> commits <TAB> last_date を stdout に出力する。
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# shallow clone は履歴が浅い分だけ変更頻度が静かに歪むので、集計しない
if [[ "$(git rev-parse --is-shallow-repository)" == true ]]; then
    echo "shallow clone のため変更頻度は集計できない" >&2
    exit 1
fi

# ==> はパスの行頭には現れない前提のコミット区切りマーカー。日付を運ぶ。
# core.quotepath=false は inventory.sh と同じく非 ASCII パスの脱落防止。
git -c core.quotepath=false log --no-renames --date=short --pretty=format:'==>%ad' --name-only |
awk '
    /^==>[0-9][0-9][0-9][0-9]-/ { date = substr($0, 4); next }
    $0 != "" {
        count[$0]++
        # log は新しい順なので、最初に見た日付がそのファイルの最終変更日
        if (!($0 in last)) last[$0] = date
    }
    END { for (p in count) printf "%s\t%d\t%s\n", p, count[p], last[p] }
' | sort
