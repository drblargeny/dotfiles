#!perl -n
##################################
# Escapes lines using URI encoding
##################################

# Use the URI::Escape module, which may need to be installed
use URI::Escape;

# avoid \n on last field
chomp;

# Unescape the URI data
# And add a newline at the end
print uri_escape($_),"\n"

