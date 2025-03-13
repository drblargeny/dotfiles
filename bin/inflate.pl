#!/usr/bin/perl
# Uncompresses STDIN via zlib inflate
# See: https://perldoc.perl.org/IO::Uncompress::Inflate#OneShot-Examples
# See: https://perldoc.perl.org/IO::Compress::Deflate#Streaming

use IO::Uncompress::Inflate inflate;

inflate \*STDIN => \*STDOUT;
