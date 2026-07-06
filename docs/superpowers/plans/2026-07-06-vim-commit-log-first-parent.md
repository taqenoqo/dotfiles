# Vim Commit Log First-Parent Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `leader cg` が参照する最近のコミット件名を、第1親系列だけから取得するようにする

**Architecture:** 既存の `s:recent_commit_subjects()` が組み立てる `git log` 引数だけを最小差分で更新する。追加の設定や分岐は入れず、確認は対象ヘルパーの引数列を直接見て行う。

**Tech Stack:** Vimscript, Git CLI

## Global Constraints

- 変更対象の本体は `home/.config/vim/after/ftplugin/gitcommit.vim` のみに限定する
- 最近の件名取得コマンドは `git log --first-parent --no-merges --format=%s --max-count=20` にする
- マージコミット自体は候補に含めない
- 失敗時は空配列を返し、件名生成全体の挙動は変えない
- 追加の設定項目や切り替えオプションは入れない

---

## File Structure

- Modify: `home/.config/vim/after/ftplugin/gitcommit.vim`
  - `s:recent_commit_subjects()` の `git log` 引数配列に `--first-parent` を追加する

### Task 1: first-parent への本体変更

**Files:**
- Modify: `home/.config/vim/after/ftplugin/gitcommit.vim:3-11`

**Interfaces:**
- Consumes: `home/.config/vim/after/ftplugin/gitcommit.vim` にある `s:recent_commit_subjects()` の `systemlist([...])` 引数配列
- Produces: `git log --first-parent --no-merges --format=%s --max-count=20` を含む実装

- [ ] **Step 1: Inspect the current helper**

```vim
function! s:recent_commit_subjects() abort
  let l:subjects = systemlist([
        \ 'git',
        \ '--no-pager',
        \ 'log',
        \ '--no-merges',
        \ '--format=%s',
        \ '--max-count=20',
        \ ])
```

- [ ] **Step 2: Write the minimal implementation**

```vim
function! s:recent_commit_subjects() abort
  let l:subjects = systemlist([
        \ 'git',
        \ '--no-pager',
        \ 'log',
        \ '--first-parent',
        \ '--no-merges',
        \ '--format=%s',
        \ '--max-count=20',
        \ ])
```

- [ ] **Step 3: Verify the focused change**

Run: `rg --fixed-strings --context 4 --line-number --glob 'gitcommit.vim' -- '--first-parent' home/.config/vim/after/ftplugin`
Expected: one match inside `s:recent_commit_subjects()` alongside `--no-merges`

- [ ] **Step 4: Commit**

```bash
git add home/.config/vim/after/ftplugin/gitcommit.vim
git commit -m "vim のコミット件名履歴を first-parent に限定する"
```
