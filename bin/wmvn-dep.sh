#/bin/bash

# Setup function to clean up after execution
#-------------------------------------------

function deleteTemp() {
  if [ -f "$1" ]; then
    rm "$1"
  fi
}

function cleanUp() {
  deleteTemp "$tmp1"
  deleteTemp "$tmp2"
}

trap cleanUp EXIT

#-------------------------------------------

# Create temp files
tmp1="$(mktemp --tmpdir "$(basename $0)"'.XXX')"
tmp2="$(mktemp --tmpdir "$(basename $0)"'.XXX')"

# Function to search for artifactId matches
function matchArtifactId() {
  sed 's/^/<artifactId>/;s/$/<\/artifactId>/' |
  grep -l -f - */pom.xml |
  xargs -rd\\n xmlstarlet sel -N x="http://maven.apache.org/POM/4.0.0" -t -m /x:project/x:artifactId -v 'text()' -n |
  sort -u
}

# Store the command line args to use as patterns
for artifactId in "$@"; do
  echo "$artifactId"
done > "$tmp1"

# Do intial search for matching dependencies
matchArtifactId < "$tmp1" > "$tmp2"

# Repeate search until no new dependencies are found
while !(diff "$tmp1" "$tmp2" > /dev/null 2>&1); do
  # Copy the currently found dependencies
  cp "$tmp2" "$tmp1"
  # Do subsequent search for dependencies that were previously found
  matchArtifactId < "$tmp1" > "$tmp2"
done

# Output the list of found dependencies
cat "$tmp2"
