#!/bin/bash
# Test to see if we're running the Windows version of Git in Cygwin
(git --version | grep -i windows > /dev/null) && GIT_FOR_WINDOWS=1 || GIT_FOR_WINDOWS=0

# Establish the directories for the config command, which manages the main configuration
if [[ "$GIT_FOR_WINDOWS" == 1 ]]; then
  DOTFILES_GIT_DIR="$(cygpath -w "$HOME/.dotfiles/")"
  DOTFILES_WORK_TREE="$(cygpath -w "$HOME")"
else
  DOTFILES_GIT_DIR="$HOME/.dotfiles/"
  DOTFILES_WORK_TREE="$HOME"
fi

# Set up alias for config command, which manages the main configuration
alias config='git --git-dir="$DOTFILES_GIT_DIR" --work-tree="$DOTFILES_WORK_TREE"'

# Check if an overlay directory is present
if [[ -d "$HOME"/.dotfiles-overlay ]]; then
  # Establish the directories for the config. command, which manages the overlay configuration
  if [[ "$GIT_FOR_WINDOWS" == 1 ]]; then
    DOTFILES_OVERLAY_DIR="$(cygpath -w "$HOME/.dotfiles-overlay/")"
  else
    DOTFILES_OVERLAY_DIR="$HOME/.dotfiles-overlay/"
  fi

  # Set up the config. alias for maintaining the overlay directory
  alias config.='git --git-dir="$DOTFILES_OVERLAY_DIR" --work-tree="$DOTFILES_WORK_TREE"'
fi
