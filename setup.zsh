#!/bin/zsh

set -eu
cd $(dirname $0)

for src in */*; do
    local tgt="$HOME/.${src:t}"
    ln -sbTn "${src:A}" "$tgt"
done

git pull --recurse-submodules
git submodule update --init --recursive

