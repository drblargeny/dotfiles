#!/bin/bash
# Script for running Maven on a set of projects in a workspace by
# autogenerating a pom.xml
#
# NOTE: Since Maven in Windows + Cygwin may not understand /dev/fd paths used
# for here documents, we create a temp file to store the pom.xml data

# Function to clean up 
function cleanUp() {
    if [[ -a "$pom" ]]; then
        rm "$pom"
    fi
}

# Register clean up function to run after script stops
trap cleanUp EXIT

# Create temp file to store the POM
# NOTE: Need to create this in the current directory so relative paths work
pom="$(mktemp -p .)"

# Populate the pom.xml file
"$(dirname $0)/dir2pom.sh" "$pom"

# Execute Maven commands using the generated pom file
mvn -f "$pom" "$@"
