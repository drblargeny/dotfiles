#!/bin/bash
# Script to run a git command in all the git folders in a directory

# Test for required commands:
# git
if ! which git >/dev/null 2>&1; then
  echo 'git command not found' 1>&2
  exit 1
fi

# Define function to run the git command with some output for debugging
function runGit() {
    # First argument is the directory to change to
    pushd "$1" >/dev/null
    # Remaining arguments are for git
    shift 1
    # Output the directory name so we can see which folder any output applies to
    pwd
    # Run the git command
    git "$@"
    # Return to the main directory
    popd >/dev/null
}
export -f runGit

# Wrap all operations so that the output can be redirected/captured at once
(
  # Indicate that we're starting the process
  echo "[START] git $@"

  # Enumerate all the projects in the current directory
  find -L . -maxdepth 2 -name .git -printf %h\\n |
    # Check if the parallel command exists
    if (parallel --help >/dev/null 2>&1); then
      # Run using parallel
      echo Executing in parallel
      parallel runGit '{}' "$@"
    else
      # Run sequentially in a loop
      echo Executing sequentially
      while read gitDir; do
        runGit "$gitDir" "$@"
      done
    fi

  # Indicate that we're done
  echo "[DONE] git $@"

) 2>&1
