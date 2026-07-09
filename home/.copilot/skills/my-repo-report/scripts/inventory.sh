#!/usr/bin/env bash
# ファイル台帳: git 管理下の全ファイルを分類した TSV を stdout に出力する。
# 列: path <TAB> bytes <TAB> lines <TAB> class <TAB> reason
# class: source | generated | vendored | binary | oversized
#
# 下流のエージェントが本文を読んでよいのは class=source のファイルだけ。
# 機械生成の巨大ファイル(lockfile 等)をコンテキストに入れない関門を、
# エージェント個々の判断ではなくこのスクリプト 1 本に集約している。
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# 分類漏れの巨大ファイルを捕まえる最終防衛線
SIZE_LIMIT=300000

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# .gitattributes の linguist 宣言はリポジトリ側の明示なので最優先で尊重する。
# 誤分類の修正はスキル独自設定ではなく .gitattributes への追記で行ってもらう。
git ls-files | git check-attr --stdin linguist-generated linguist-vendored |
    awk -F': ' '$3 != "unspecified" && $3 != "unset" && $3 != "false" { print $2 "\t" $1 }' \
    > "$tmpdir/attrs"

classify_by_name() {
    local path=$1
    case "$path" in
        vendor/* | */vendor/* | third_party/* | */third_party/* | node_modules/* | */node_modules/*)
            echo "vendored	known-dir"; return ;;
        dist/* | */dist/* | __snapshots__/* | */__snapshots__/*)
            echo "generated	known-dir"; return ;;
    esac
    case "${path##*/}" in
        package-lock.json | npm-shrinkwrap.json | yarn.lock | pnpm-lock.yaml | bun.lockb | \
        Cargo.lock | Gemfile.lock | go.sum | poetry.lock | uv.lock | composer.lock | \
        flake.lock | Package.resolved | gradle.lockfile | packages.lock.json)
            echo "generated	lockfile"; return ;;
        *.min.js | *.min.css | *.js.map | *.css.map)
            echo "generated	minified"; return ;;
        *_pb2.py | *_pb2_grpc.py | *.pb.go | *_pb.ts | *.pb.cc | *.pb.h)
            echo "generated	protobuf"; return ;;
    esac
    echo ""
}

printf '# path\tbytes\tlines\tclass\treason\n'

git ls-files | while IFS= read -r path; do
    # サブモジュール・シンボリックリンク・レポート自身は台帳の対象外
    [ -f "$path" ] && [ ! -L "$path" ] || continue
    case "$path" in .repo-report/*) continue ;; esac

    bytes=$(wc -c < "$path" | tr -d ' ')

    if grep -qxF $'linguist-generated\t'"$path" "$tmpdir/attrs"; then
        class="generated"; reason="gitattributes"
    elif grep -qxF $'linguist-vendored\t'"$path" "$tmpdir/attrs"; then
        class="vendored"; reason="gitattributes"
    elif result=$(classify_by_name "$path") && [ -n "$result" ]; then
        class=${result%%$'\t'*}; reason=${result#*$'\t'}
    elif [ "$bytes" -gt 0 ] && ! LC_ALL=C grep -Iq '' "$path"; then
        class="binary"; reason="binary-content"
    elif [ "$bytes" -gt "$SIZE_LIMIT" ]; then
        class="oversized"; reason="over-${SIZE_LIMIT}-bytes"
    else
        class="source"; reason="-"
    fi

    if [ "$class" = "binary" ]; then
        lines=0
    else
        lines=$(wc -l < "$path" | tr -d ' ')
    fi

    printf '%s\t%s\t%s\t%s\t%s\n' "$path" "$bytes" "$lines" "$class" "$reason"
done
