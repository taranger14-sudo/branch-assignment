# Shell Scripting + Git Branch Automation Workshop

## Files

* `first-script.sh` - Demonstrates basic Bash commands.
* `welcome.sh` - Demonstrates the first argument (`$1`).
* `student.sh` - Demonstrates `$0`, `$1`, `$2`, and `$#`.
* `create-gitignore.sh` - Creates `.gitignore` only when it does not exist.
* `create-branches.sh` - Validates input and repository state, creates a backup branch, and creates a working branch.
* `git-save-push.sh` - Stages, reviews, commits, and optionally pushes changes.

## How to Run

Run the scripts from Git Bash or a Linux terminal.

```bash
bash first-script.sh
bash welcome.sh Rahul
bash student.sh Rahul DevOps
bash create-gitignore.sh
bash create-branches.sh CPD-1234 feature
bash git-save-push.sh "CPD-1234: fix validation" --gitignore
bash git-save-push.sh "CPD-1234: fix validation" --push
```

## Important Notes

* Test branch and commit scripts in a disposable repository first.
* `create-branches.sh` requires a clean working tree and creates local branches only.
* `git-save-push.sh` stages all repository changes using `git add --all`.
* Review the staged diff carefully before confirming a commit.
* The optional `--gitignore` argument creates a sample `.gitignore` only if one does not already exist. Review its rules for your project.
* Pushing requires an `origin` remote and appropriate permissions.


