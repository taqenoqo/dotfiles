#!/bin/zsh

set -eu

cd $(dirname $0)
for file in *; do
    dstFile=$HOME/.$file
    if [[ "$file" != 'setup.sh' ]] && [[ ! -e "$dstFile" ]]; then
        ln -fs "$PWD/$file" "$dstFile"
    fi
done

chsh -s $(where zsh)

git submodule init
git submodule update

