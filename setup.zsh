#!/bin/zsh

set -eu
cd $(dirname $0)

for src in */*; do
    local tgt="$HOME/.${src:t}"
    ln -siTn "${src:A}" "$tgt"
done

git pull --recurse-submodules
git submodule update --init --recursive

chsh -s $(where zsh)

