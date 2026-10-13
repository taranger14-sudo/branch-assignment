#!/usr/bin/env bash

if [ ! -f .gitignore ]; then
  cat > .gitignore <<EOF_IGNORE
.env
*.log
node_modules/
dist/
EOF_IGNORE
  echo ".gitignore created. Review its rules for your project."
else
  echo ".gitignore already exists; leaving it unchanged."
fi
