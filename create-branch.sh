
#!/usr/bin/env bash
set -e

TICKET="${1:-}"
TYPE="${2:-feature}"

usage() {
  echo "Usage: bash $0 <ticket-id> [feature|bugfix|hotfix]"
  echo "Example: bash $0 CPD-1234 feature"
}


if [ -z "$TICKET" ]; then
  usage
  exit 1
fi

case "$TYPE" in
  feature|bugfix|hotfix) ;;
  *) echo "Invalid branch type: $TYPE"; usage; exit 1 ;;
esac

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: run this script inside a Git repository."
  exit 1
fi

if ! git symbolic-ref -q HEAD >/dev/null; then
  echo "Error: detached HEAD. Switch to a branch first."
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "Error: working tree is not clean."
  echo "Commit or stash changes, then retry."
  exit 1
fi

CURRENT_BRANCH="$(git branch --show-current)"
NEW_BRANCH="${TYPE}/${TICKET}"
BACKUP_BRANCH="backup/${CURRENT_BRANCH}-$(date +%Y%m%d-%H%M%S)"

if git show-ref --verify --quiet "refs/heads/$NEW_BRANCH"; then
  echo "Error: $NEW_BRANCH already exists."
  exit 1
fi

if git show-ref --verify --quiet "refs/heads/$BACKUP_BRANCH"; then
  echo "Error: $BACKUP_BRANCH already exists."
  exit 1
fi

echo "Current branch : $CURRENT_BRANCH"
echo "Backup branch  : $BACKUP_BRANCH"
echo "New branch     : $NEW_BRANCH"
read -r -p "Continue? (y/N): " ANSWER
case "$ANSWER" in
  y|Y|yes|YES) ;;
  *) echo "Cancelled."; exit 0 ;;
esac

git branch "$BACKUP_BRANCH" "$CURRENT_BRANCH"
git switch -c "$NEW_BRANCH"
echo "Created backup and switched to $NEW_BRANCH"
echo "Both branches are local; no push was performed."
