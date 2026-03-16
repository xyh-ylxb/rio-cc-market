#!/bin/sh

set -eu

RED=$(printf '\033[0;31m')
GREEN=$(printf '\033[0;32m')
YELLOW=$(printf '\033[1;33m')
BLUE=$(printf '\033[0;34m')
NC=$(printf '\033[0m')

GIT_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_DIR="$GIT_ROOT/.worktrees"

detect_default_branch() {
  if git symbolic-ref refs/remotes/origin/HEAD >/dev/null 2>&1; then
    git symbolic-ref --short refs/remotes/origin/HEAD | sed 's#^origin/##'
    return
  fi

  if git show-ref --verify --quiet refs/heads/main; then
    printf 'main\n'
    return
  fi

  if git show-ref --verify --quiet refs/heads/master; then
    printf 'master\n'
    return
  fi

  git rev-parse --abbrev-ref HEAD
}

ensure_gitignore() {
  if [ ! -f "$GIT_ROOT/.gitignore" ]; then
    printf '.worktrees\n' > "$GIT_ROOT/.gitignore"
    return
  fi

  if ! grep -q '^\.worktrees$' "$GIT_ROOT/.gitignore"; then
    printf '\n.worktrees\n' >> "$GIT_ROOT/.gitignore"
  fi
}

copy_env_files() {
  worktree_path="$1"
  found=0

  printf '%sCopying environment files...%s\n' "$BLUE" "$NC"

  for source in "$GIT_ROOT"/.env*; do
    if [ ! -f "$source" ]; then
      continue
    fi

    name=$(basename "$source")
    if [ "$name" = ".env.example" ]; then
      continue
    fi

    found=1
    dest="$worktree_path/$name"
    if [ -f "$dest" ]; then
      cp "$dest" "${dest}.backup"
      printf '  %sbacked up %s to %s.backup%s\n' "$YELLOW" "$name" "$name" "$NC"
    fi

    cp "$source" "$dest"
    printf '  %scopied %s%s\n' "$GREEN" "$name" "$NC"
  done

  if [ "$found" -eq 0 ]; then
    printf '  %sno local .env files found%s\n' "$YELLOW" "$NC"
  fi
}

create_worktree() {
  branch_name="${1:-}"
  from_branch="${2:-$(detect_default_branch)}"

  if [ -z "$branch_name" ]; then
    printf '%sError: branch name required%s\n' "$RED" "$NC" >&2
    exit 1
  fi

  worktree_path="$WORKTREE_DIR/$branch_name"

  if [ -e "$worktree_path" ]; then
    printf '%sWorktree already exists at %s%s\n' "$YELLOW" "$worktree_path" "$NC"
    exit 1
  fi

  printf '%sCreating worktree %s from %s%s\n' "$BLUE" "$branch_name" "$from_branch" "$NC"
  mkdir -p "$WORKTREE_DIR"
  ensure_gitignore
  git worktree add -b "$branch_name" "$worktree_path" "$from_branch"
  copy_env_files "$worktree_path"
  printf '%sCreated %s%s\n' "$GREEN" "$worktree_path" "$NC"
}

list_worktrees() {
  printf '%sAvailable worktrees:%s\n' "$BLUE" "$NC"

  if [ ! -d "$WORKTREE_DIR" ]; then
    printf '%sNo worktrees found%s\n' "$YELLOW" "$NC"
    return
  fi

  found=0
  for worktree_path in "$WORKTREE_DIR"/*; do
    if [ ! -e "$worktree_path/.git" ]; then
      continue
    fi

    found=1
    name=$(basename "$worktree_path")
    branch=$(git -C "$worktree_path" rev-parse --abbrev-ref HEAD 2>/dev/null || printf 'unknown')
    printf '  %s -> %s\n' "$name" "$branch"
  done

  if [ "$found" -eq 0 ]; then
    printf '%sNo worktrees found%s\n' "$YELLOW" "$NC"
  fi
}

switch_worktree() {
  worktree_name="${1:-}"

  if [ -z "$worktree_name" ]; then
    printf '%sError: worktree name required%s\n' "$RED" "$NC" >&2
    exit 1
  fi

  worktree_path="$WORKTREE_DIR/$worktree_name"
  if [ ! -e "$worktree_path/.git" ]; then
    printf '%sError: worktree not found: %s%s\n' "$RED" "$worktree_name" "$NC" >&2
    exit 1
  fi

  printf 'cd %s\n' "$worktree_path"
}

copy_env_to_worktree() {
  worktree_name="${1:-}"

  if [ -z "$worktree_name" ]; then
    if [ "${PWD#"$WORKTREE_DIR"/}" != "$PWD" ]; then
      copy_env_files "$PWD"
      return
    fi
    printf '%sError: provide a worktree name or run inside a worktree%s\n' "$RED" "$NC" >&2
    exit 1
  fi

  worktree_path="$WORKTREE_DIR/$worktree_name"
  if [ ! -e "$worktree_path/.git" ]; then
    printf '%sError: worktree not found: %s%s\n' "$RED" "$worktree_name" "$NC" >&2
    exit 1
  fi

  copy_env_files "$worktree_path"
}

cleanup_worktrees() {
  if [ ! -d "$WORKTREE_DIR" ]; then
    printf '%sNo worktrees to clean up%s\n' "$YELLOW" "$NC"
    return
  fi

  found=0
  for worktree_path in "$WORKTREE_DIR"/*; do
    if [ ! -e "$worktree_path/.git" ]; then
      continue
    fi

    found=1
    printf '%sRemoving %s%s\n' "$YELLOW" "$worktree_path" "$NC"
    git worktree remove "$worktree_path"
  done

  if [ "$found" -eq 0 ]; then
    printf '%sNo inactive worktrees found%s\n' "$YELLOW" "$NC"
  fi
}

usage() {
  cat <<'EOF'
Usage:
  worktree-manager.sh create <branch-name> [base-branch]
  worktree-manager.sh list
  worktree-manager.sh switch <worktree-name>
  worktree-manager.sh copy-env [worktree-name]
  worktree-manager.sh cleanup
EOF
}

command="${1:-}"

case "$command" in
  create)
    shift
    create_worktree "${1:-}" "${2:-}"
    ;;
  list|ls)
    list_worktrees
    ;;
  switch|go)
    shift
    switch_worktree "${1:-}"
    ;;
  copy-env)
    shift
    copy_env_to_worktree "${1:-}"
    ;;
  cleanup|clean)
    cleanup_worktrees
    ;;
  *)
    usage
    exit 1
    ;;
esac
