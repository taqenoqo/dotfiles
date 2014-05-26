#!/bin/zsh

cd $(dirname $0)
for file in *; do
    dstFile=$HOME/.$file
    if [ "$file" != 'setup.sh' ] && [ ! -e "$dstFile" ]; then
        ln -fs "$PWD/$file" "$dstFile"
    fi
done

