#!/bin/bash
# Script to run git-dir.sh in each of the specified folders.

# Confirm some workspaces were provided
if [[ $# == 0 ]]; then
  echo "Usage: $0 path..." >&2
  exit 1
fi;

# Default the Git operation, if needed.
if [[ -z "$GIT_COMMAND" ]]; then
  GIT_COMMAND="pull --ff-only --all"
fi

# Wrap all operations so that the output can be redirected/captured at once
(
  # Indicate that we're starting the process
  echo 'Starting update...' 1>&2

  # Iterate over each workspace folder
  for a in "$@"; do
    # Run Git operation on all directories in the folder
    (cd "$a"; pwd; "${0%/*}/git-dir.sh" $GIT_COMMAND)
  done

  # Indicate that we're done iterating
  echo 'Update complete!' 1>&2
) 2>&1 | \
  # Pipe all output to a pager so that it can be reviewed
  # --HILITE-UNREAD   highlights first new line after multiline page change
  # +F    activates 'tail' mode and follows latest output
  less -p '^(From|Updating|(error|fatal):)' --HILITE-UNREAD +F
