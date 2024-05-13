#!/bin/bash
# Script to generate a Maven pom.xml based on the projects in the current path

# Check to see if a file name was given
if [[ $# == 1 ]]; then
  # If so, we'll write to the file
  cat > "$1"
else
  # Otherwise, we write to stdout
  cat
fi <<pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <!-- Use some coordinate for a local workspace -->
  <!-- It probably won't be used/uploaded as a project itself so we don't have an explicit convention for this at the moment -->
  <groupId>scgapps-workspace</groupId>
  <!-- Use the current path name for the artifact ID -->
  <artifactId>$(
    # Read the absolute path of the current directory
    readlink -f . | \
    # Convert that path so that it only contains Java identifier characters
    sed -E '
    # Convert forward and back slashes into periods
    s/[\\\/]+/./g
    # Convert non-identifier, period, and underscore characters into underscores
    s/[^[:alnum:]_.]/_/g
    # Remove any non-identifier characters at the beginning of the name
    s/^[^[:alnum:]]+//
')</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>pom</packaging>

  <!-- List of modules/projects that are in the workspace -->
  <modules>
    <!-- Each module should use the relative path name for the project.  Maven
         will find the respective pom.xml files and also determine the correct
         build order -->
$(  # Find all the pom.xml files in folders directly under the current directory
    # NOTE: This now supports .* folders, which makes it easier to have some projects checked out for builds and remain hidden from JRebel
    find -L . -mindepth 2 -maxdepth 2 -name pom.xml | \
    # Convert those pom.xml file paths into <module> tags
    sed '
      # Prepend each path with a start tag and indentation
      s/^\.\//        <module>/
      # Replace everything after the first / (i.e. the /pom.xml part) with the end tag
      s/\/.*$/<\/module>/
' )
  </modules>

</project>
pom.xml

