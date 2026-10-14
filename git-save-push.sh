#!/usr/bin/env bash
set -e

COMMIT_MESSAGE="${1:-}"
CREATE_GITIGNORE=false
PUSH=false

if [ -z "$COMMIT_MESSAGE" ]; then
  echo "Usage: bash $0 \"commit message\" [--gitignore] [--push]"
  exit 1
fi

shift

for ARG in "$@"; do
  case "$ARG" in
    --gitignore) CREATE_GITIGNORE=true ;;
    --push) PUSH=true ;;
    *)
      echo "Error: Unknown option: $ARG"
      exit 1
      ;;
  esac
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Run this script inside a Git repository."
  exit 1
fi

if [ "$CREATE_GITIGNORE" = true ] && [ ! -f .gitignore ]; then
  cat > .gitignore <<'EOF_IGNORE'
.env
*.log
node_modules/
dist/
EOF_IGNORE
  echo ".gitignore created."
elif [ "$CREATE_GITIGNORE" = true ]; then
  echo ".gitignore already exists; leaving it unchanged."
fi

git add --all

if git diff --cached --quiet; then
  echo "No staged changes to commit."
  exit 0
fi

echo
echo "Review staged changes:"
git diff --cached

echo
read -r -p "Commit these changes? (y/N): " ANSWER

case "$ANSWER" in
  y|Y|yes|YES) ;;
  *)
    echo "Cancelled. No commit was made."
    exit 0
    ;;
esac

git commit -m "$COMMIT_MESSAGE"

if [ "$PUSH" = true ]; then
  if ! git remote get-url origin >/dev/null 2>&1; then
    echo "Error: No origin remote configured. Commit was saved locally."
    exit 1
  fi

  CURRENT_BRANCH="$(git branch --show-current)"
  read -r -p "Push $CURRENT_BRANCH to origin? (y/N): " PUSH_ANSWER

  case "$PUSH_ANSWER" in
    y|Y|yes|YES)
      git push -u origin "$CURRENT_BRANCH"
      ;;
    *)
      echo "Push cancelled. Commit remains local."
      ;;
  esac
else
  echo "Push skipped. Commit is local."
fi
