#!perl -n
##############################
# Un-escapes URI encoded lines
##############################
# NOTE: This does not convert plus '+' to space ' '
#       If this is desired, pipe data through tr '+' ' ' first

# Use the URI::Escape module, which may need to be installed
use URI::Escape;

# avoid \n on last field
chomp;

# Unescape the URI data
# And add a newline at the end
print uri_unescape($_),"\n"

