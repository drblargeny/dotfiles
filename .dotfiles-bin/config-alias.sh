#!/bin/bash
# Test to see if we're running the Windows version of Git in Cygwin
(git --version | grep -i windows > /dev/null) && GIT_FOR_WINDOWS=1 || GIT_FOR_WINDOWS=0

# Set up alias for config command, which manages the main configuration
if [[ "$GIT_FOR_WINDOWS" == 1 ]]; then
  alias config='git --git-dir="$(cygpath -w "$HOME/.dotfiles/")" --work-tree="$(cygpath -w "$HOME")"'
else
  alias config='git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
fi

# Check if an overlay directory is present
if [[ -d "$HOME"/.dotfiles-overlay ]]; then
  # Set up the config alias for maintaining the overlay directory
  if [[ "$GIT_FOR_WINDOWS" == 1 ]]; then
    alias config.='git --git-dir="$(cygpath -w "$HOME/.dotfiles-overlay/")" --work-tree="$(cygpath -w "$HOME")"'
  else
    alias config.='git --git-dir="$HOME/.dotfiles-overlay/" --work-tree="$HOME"'
  fi
fi
