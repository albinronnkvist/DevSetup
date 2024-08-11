#!/bin/bash

# Configure git in .gitconfig
cat <<EOL > ~/.gitconfig
[user]
    email = $EMAIL
    name = Albin
[core]
    editor = code --wait
[init]
    defaultBranch = main
[pull]
    rebase = true
[alias]
    i = init
    l = log --oneline --graph --decorate --all
    lf = log --oneline --graph --decorate --all --pretty=full
    s = status -sb
    df = diff
    b = branch
    co = checkout
    cob = checkout -b
    com = checkout main
    d = "!f() { git branch -d \"\$1\"; }; f"
    da = "!f() { git branch | grep -v 'main' | grep -v '\\*' | xargs git branch -D; }; f"
    a = add .
    c = commit -m
    cmm = "!f() { \
        echo 'Enter commit title: '; \
        read title; \
        echo 'Enter commit description (end with Ctrl-D): '; \
        desc=\$(cat); \
        git commit -m \"\$title\" -m \"\$desc\"; \
    }; f"
    ac = "!f() { git add . && git commit -m \"\$1\"; }; f"
    acmm = "!f() { \
        echo 'Enter commit title: '; \
        read title; \
        echo 'Enter commit description (end with Ctrl-D): '; \
        desc=\$(cat); \
        git add . && git commit -m \"\$title\" -m \"\$desc\"; \
    }; f"
    aca = "!f() { git add . && git commit --amend --no-edit; }; f"
    us = reset --soft HEAD^
    uh = reset --hard HEAD^
    cdf = clean -df
    pull = pull
    p = push
    po = push -u origin
    pls = push --force-with-lease
    rb = rebase
    rbm = rebase main
    rbc = rebase --continue
    rba = rebase --abort
    rbi = "!f() { git rebase -i HEAD~\$1; }; f"
    new-pr = "!f() { \
        branch_name=\"\$1\"; \
        git checkout main && \
        git pull && \
        git checkout -b \"\$branch_name\" && \
        git push -u origin \"\$branch_name\" && \
        gh pr create --title \"\$branch_name\" --draft --head \"\$branch_name\" --base main; \
    }; f"
EOL
echo "Git configuration set"