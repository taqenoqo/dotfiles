#!/bin/zsh

cd $(dirname $0)

for file in .*
do
    if [ $file != '.git' ] && [ $file != '.gitignore' ]
    then
        ln -is "$PWD/$file" $HOME
    fi
done

