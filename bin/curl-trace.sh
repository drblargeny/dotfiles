#!/usr/bin/env bash
# Reads the output of the "curl -trace" command and outputs the raw HTTP
# conversation.

# Mark the parts of HTTP conversation
sed -E '
# Find each start of a part and insert an end marker before it
# This prevents parts from being merged together/lost during sed processing
/^(<=|=>) (Recv|Send) (header|data)/i --' | \
# Reformat each of the parts
sed -nE '
# Select each part from the start to the end
/^(<=|=>) (Recv|Send) (header|data)/,/^[^0-9a-fA-F]/ {
    # Replace any non-end marker with an end marker
    s/^==.*/--/
    # Simplify  the header
    s/^(<=|=>).*/\1/
    # Remove the hex address prefix
    s/^[0-9a-fA-F]+: //
    # Remove the translated bytes section
    s/^(.{47}).*/\1/
    # Remove all spaces
    s/ *//g
    p
}' | \
# Use awk to convert the sections because it can more easily track changes
# between the types of sections to insert extra line breaks
awk '
# Process lines from the simplified start marker to the end marker
($1 == "<=" || $1 == "=>"),($1 == "--"){
    # Check if the line starts with a hex number
    if ($1 ~ /^[0-9a-fA-F]/) {
        # It does, so this is a data line
        # Output the line
        print
    } else if ($1 != lastdir) {
        # Not a data line, and it seems to be different from the last non-data
        # line. This probably indicates a change from send to receive; so add
        # an extra line break (encoded in hex)
        print "0a"
        # Update the variable to track the current direction
        lastdir = $1
    }
}
' | \
# Data should now be a big stream of hex data, so convert it from hex
xxd -r -ps
