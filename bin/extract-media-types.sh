#!/bin/bash
# Generates a list of valid MIME/Media Types based on the current IANA Registry

# Get the latest XML version of the registry
curl 'https://www.iana.org/assignments/media-types/media-types.xml' |
# Parse it using xmlstarlet
xmlstarlet sel -N 'a=http://www.iana.org/assignments' -t \
    -m 'a:registry/a:registry/a:record' \
    --if 'a:file[@type="template"]' -v 'a:file[@type="template"]/text()' -n \
    --else -v ../@id -o '/' -v 'a:name/text()' -n

