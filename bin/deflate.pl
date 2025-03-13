#!/usr/bin/perl
# Compresses STDIN via zlib deflate
# See: https://perldoc.perl.org/IO::Compress::Deflate#Streaming

use IO::Compress::Deflate deflate;

deflate \*STDIN => \*STDOUT;
