#!/bin/bash
# Script to bootstrap the dotfiles project and load it onto a new system.
# 
# Based on:
#   https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/#install-your-dotfiles-onto-a-new-system-or-migrate-to-this-setup-
#
# NOTE: Unlike the dotfiles aliases/scripts that are defined for managing 
#       changes after installation, this script does not force the cloned
#       repository to be located in HOME.  Instead, it checks things out 
#       in the current directory.

# Define the location of the dotfiles repo
GIT_URL="$1"
if [ -z "$GIT_URL" ]; then
  echo Missing URI
  exit 1
fi

# Define the .git folder 
GIT_DIR="${2:-.dotfiles}"

# Define the branch to use
GIT_BRANCH="${3:-main}"

if [ "$GIT_DIR" == '.dotfiles' ]; then
  CONFIG_COMMAND=config
  IGNORE_FILE=.dotfiles-ignore
else
  CONFIG_COMMAND=config.
  IGNORE_FILE=.dotfiles-ignore-overlay
fi

# Define the worktree folder
TREE_DIR='.'

# Define function for manipulating the bare repository
# NOTE: This is a function instead of an alias so that it can work within the
#       context of this script
function dotfiles() {
  git --git-dir="$GIT_DIR" --work-tree="$TREE_DIR" "$@"
}

# Check if Git directory exists
if [[ ! -d "$GIT_DIR" ]]; then
  # Add dotfiles Git directory to .gitignore
#  echo "${GIT_DIR}" >> .gitignore
  # And clone the repo if it doesn't
  git clone --bare "$GIT_URL" "$GIT_DIR" && echo 'Clone complete' 1>&2

  # Stop treating this as a bare repository
  dotfiles config core.bare false

  # Enable the ref log
  dotfiles config core.logallrefupdates true

  # Set remote fetch info
  dotfiles config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'

  # Automatically assume --set-upstream for default push
  dotfiles config push.autosetupremote true

  # Assign upstream for fetch/pull
  # Try to use main, and fall back to master
  dotfiles branch --set-upstream-to=origin/"$GIT_BRANCH"

  # Setup the repo to exclude files in the IGNORE_FILE file
  #echo '*' >> "${GIT_DIR}/info/exclude"
  dotfiles config --local core.excludesfile $IGNORE_FILE

  # If running in Cygwin Windows, ignore file permissions
  if [ -f /usr/bin/cygpath ] ; then
    dotfiles config --local core.filemode false
  fi

  # Set upstream for push
  dotfiles branch "$GIT_BRANCH" -u origin/"$GIT_BRANCH"
fi

# Then restore the files in place and do a merge when there are conflicts
# 1. Refresh the index based on the current changes
dotfiles reset
# 2. Restore any deleted files
dotfiles status --short | sed -E '/^ ?D/!d;s/^ ?D +//' | while read f; do
  dotfiles restore "$f"
done

echo Source this to enable the $CONFIG_COMMAND command to manage changes
echo . ~/.dotfiles-bin/config-alias.sh
echo 
echo Then review the current differences
echo $CONFIG_COMMAND status
echo 
echo For each modified file, use the difftool to compare and merge the files.
echo Recommend starting with .bashrc to ensure $CONFIG_COMMAND is auto-loaded.
echo $CONFIG_COMMAND difftool .bashrc
