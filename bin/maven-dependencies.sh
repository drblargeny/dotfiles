#!/bin/bash
# Extracts the Maven dependencies from the specified pom.xml files
xmlstarlet sel -N 'mvn=http://maven.apache.org/POM/4.0.0' -t -m '//mvn:dependency' -f -o $'\t' -v 'mvn:groupId' -o ':' -v 'mvn:artifactId' -o ':' -v 'mvn:version' -n "$@"
