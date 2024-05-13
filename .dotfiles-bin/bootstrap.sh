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

  # Setup the repo to exclude files in the IGNORE_FILE file
  #echo '*' >> "${GIT_DIR}/info/exclude"
  dotfiles config --local core.excludesfile $IGNORE_FILE

  # Set upstream for git push
  dotfiles push --set-upstream origin master

  # If running in Cygwin Windows, ignore file permissions
  if [ -f /usr/bin/cygpath ] ; then
    dotfiles config --local core.filemode false
  fi
fi

# Then restore the files in place and do a merge when there are conflicts
# 1. Refresh the index based on the current changes
dotfiles reset --refresh
# 2. Restore any deleted files
dotfiles status --short | sed -E '/^ ?D/!d;s/^ ?D +//' | while read f; do
  dotfiles restore "$f"
done
# 3. Stash the modifications
dotfiles stash push -m 'Original profile'

echo Original profile stashed.  Restart shell to enable $CONFIG_COMMAND command to process changes.
echo 
echo Then restore the stashed changes:
echo $CONFIG_COMMAND stash pop
echo 
echo For each modified file, use the difftool to compare and merge the files
echo $CONFIG_COMMAND difftool .bashrc
