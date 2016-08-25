#!/bin/zsh

set -eu
autoload -Uz

cd $(dirname $0)

for src_file in *; do
    if [[ ${0:a} != ${src_file:a} ]]; then
	link_file="$HOME/.${src_file:t}"
	if [[ -L $link_file ]]; then
	    ln -snfv "${src_file:A}" "$link_file"
	else
	    ln -sniv "${src_file:A}" "$link_file"
	fi
    fi
done

