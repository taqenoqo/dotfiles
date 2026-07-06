#!/bin/sh
set -eu

file="home/.config/vim/after/ftplugin/gitcommit.vim"

grep -Fq "\\ '--first-parent'," "$file"
grep -Fq "\\ '--no-merges'," "$file"
