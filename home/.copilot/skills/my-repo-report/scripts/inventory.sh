#!/usr/bin/env bash
# ファイル台帳: 下流エージェントが本文を読んでよいファイルの一覧を stdout に出力する。
# 列: path <TAB> lines
#
# 機械生成の巨大ファイル(lockfile 等)をコンテキストに入れない関門を、
# エージェント個々の判断ではなくこのスクリプト 1 本に集約している。
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# 分類漏れの巨大ファイルを捕まえる最終防衛線
SIZE_LIMIT=300000

# git 内蔵のバイナリ判定に委ねるための空ツリー(全内容を追加扱いさせる基準)
EMPTY_TREE=$(git hash-object -t tree /dev/null)

# 外部コード・ビルド成果物が置かれる既知ディレクトリ。トップ直下・ネスト配下の双方を除外する。
GENERATED_DIRS=(
    vendor
    third_party
    node_modules
    dist
    __snapshots__
)

# 本文を読ませない機械生成ファイルの basename パターン(glob)。
# ロックファイル名は完全一致、生成物は拡張子 glob で拾う。
GENERATED_FILE_GLOBS=(
    # 各種パッケージマネージャの lockfile
    package-lock.json
    npm-shrinkwrap.json
    yarn.lock
    pnpm-lock.yaml
    bun.lockb
    Cargo.lock
    Gemfile.lock
    go.sum
    poetry.lock
    uv.lock
    composer.lock
    flake.lock
    Package.resolved
    gradle.lockfile
    packages.lock.json
    # ミニファイ済み・ソースマップ
    *.min.js
    *.min.css
    *.js.map
    *.css.map
    # Protocol Buffers 等の生成コード
    *_pb2.py
    *_pb2_grpc.py
    *.pb.go
    *_pb.ts
    *.pb.cc
    *.pb.h
)

# core.quotepath=false: 非 ASCII パスが引用符付きで出力されると
# ファイル存在チェックに失敗し、台帳から静かに脱落するのを防ぐ
git_raw() {
    git -c core.quotepath=false "$@"
}

# git のバイナリ判定に委ねる。空ツリーとの diff で追加行数が "-" ならバイナリ。
is_binary() {
    local path=$1
    [[ "$(git_raw diff --numstat "$EMPTY_TREE" -- "$path" | cut -f1)" == - ]] && return 0
    return 1
}

# パスが除外対象ディレクトリのいずれかの配下にあるか。
is_in_generated_dir() {
    local path=$1 dir
    for dir in "${GENERATED_DIRS[@]}"; do
        [[ "$path" == "$dir"/* || "$path" == */"$dir"/* ]] && return 0
    done
    return 1
}

# basename が機械生成ファイルのパターンのいずれかに一致するか。
is_generated() {
    local name=$1 glob
    for glob in "${GENERATED_FILE_GLOBS[@]}"; do
        [[ "$name" == $glob ]] && return 0
    done
    return 1
}

# 下流エージェントが本文を読んでよいファイル(source)かを判定する。
# vendored・生成物・バイナリ・巨大ファイルはいずれも除外する。
is_source() {
    local path=$1 bytes=$2

    is_in_generated_dir "$path" && return 1
    is_generated "${path##*/}" && return 1

    # バイナリは内容で、巨大ファイルはサイズで弾く
    is_binary "$path" && return 1
    [[ "$bytes" -gt "$SIZE_LIMIT" ]] && return 1
    return 0
}

printf '# path\tlines\n'

git_raw ls-files | while IFS= read -r path; do
    # サブモジュール・シンボリックリンク・レポート自身は台帳の対象外
    [[ ! -f "$path" || -L "$path" ]] && continue
    [[ "$path" == .repo-report/* ]] && continue

    bytes=$(wc -c < "$path" | tr -d ' ')
    is_source "$path" "$bytes" || continue

    lines=$(wc -l < "$path" | tr -d ' ')
    printf '%s\t%s\n' "$path" "$lines"
done
