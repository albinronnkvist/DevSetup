#!/bin/bash

# Configure basics in ~/.gitconfig
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
EOL

# Configure aliases in ~/.gitconfig
cat <<'EOL' >> ~/.gitconfig
[alias]
	i = "init"                              # Initialize a new Git repository
	l = "log --oneline --graph --decorate --all" # Show a decorated one-line graphical log of all branches
	lf = "log --oneline --graph --decorate --all --pretty=full" # Show a decorated one-line graphical log of all branches
	s = "status -sb"                        # Show the status of the working directory in short format
	df = "diff"                             # Show changes between commits, commit and working tree, etc.
	b = "branch"                            # List, create, or delete branches
	co = "checkout"                         # Switch branches or restore working tree files
	cob = "checkout -b"                     # Create and switch to a new branch
	com = "checkout main"                   # Switch to the main branch
	d = "!f() { git branch -d \"$1\"; }; f" # Delete a local branch
	da = "!f() { git branch | grep -v 'main' | grep -v '\\*' | xargs git branch -D; }; f" # Delete all branches except main and the currently checked-out branch
	a = "add ."                             # Add all changes to the staging area
	c = "commit -m"                         # Commit changes to the repository
	cmm = "!f() { \
        echo 'Enter commit title: '; \
        read title; \
        echo 'Enter commit description (end with Ctrl-D): '; \
        desc=$(cat); \
        git commit -m \"$title\" -m \"$desc\"; \
    }; f"                                   # Commit with two messages
	ac = "!f() { git add . && git commit -m \"$1\"; }; f" # Add and commit all changes with a message
	acmm = "!f() { \
        echo 'Enter commit title: '; \
        read title; \
        echo 'Enter commit description (end with Ctrl-D): '; \
        desc=$(cat); \
        git add . && git commit -m \"$title\" -m \"$desc\"; \
    }; f" # Add and commit all changes with two messages
	aca = "!f() { git add . && git commit --amend --no-edit; }; f" # Add all changes, commit and amend
	us = "reset --soft HEAD^"             	# Undo the last commit but keep the changes in the working directory
	uh = "reset --hard HEAD^" 							# Reset the working directory to the last commit, discarding all changes
	cdf = "clean -df"                       # Remove all untracked files and directories, but not ignored files
	cdfx = "clean -dfx"                     # Remove all untracked files and directories
	pull = "pull"                           # Fetch from and integrate with another repository or a local branch
	p = "push"                              # Update remote refs along with associated objects
	po = "push -u origin"                   # Push changes to the origin remote and set upstream tracking
	pls = "push --force-with-lease"         # Force push but ensure no upstream changes have been made
	rb = "rebase"                           # Reapply commits on top of another base tip
	rbm = "rebase main"                     # Reapply commits on top of the main branch
	rbc = "rebase --continue"               # Continue the rebase process after resolving conflicts
	rba = "rebase --abort"                  # Abort the rebase process and return to the original branch
	rbi = "!f() { git rebase -i HEAD~$1; }; f" # Start an interactive rebase for the last specified number of commits
	new-pr = "!f() { \
		branch_name=\"$1\"; \
		git checkout main && \
		git pull && \
		git checkout -b \"$branch_name\" && \
		git push -u origin \"$branch_name\" && \
		git commit --allow-empty -m 'make pull request' && \
		git push && \
		gh pr create --title \"$branch_name\" --draft --head \"$branch_name\" --base main; \
	}; f" # Checks out the main branch, Pulls the latest changes from the remote, Checks out a new branch with a user-specified name, Pushes the new branch to the remote. Starts a draft pull request with the title set to the same as the branch name.
EOL

echo "Git configured successfully."