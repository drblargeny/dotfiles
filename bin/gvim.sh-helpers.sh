#!/bin/bash
# Creates Cygwin symlinks to use the gvim.sh script as if it were a vim/gvim
# installation
#
# This should only be run in the same working directory as the gvim.sh script

unset CYGWIN

ln -s gvim.sh   eview
ln -s gvim.sh   evim
ln -s gvim.sh   gex
ln -s gvim.sh   gview
ln -s gvim.sh   gvim
ln -s gvim.sh   gvimdiff
ln -s gvim.sh   rgview
ln -s gvim.sh   rgvim
ln -s gvim.sh   vimx
ln -s gvim.sh   rvim
ln -s gvim.sh   vim
ln -s gvim.sh   vimdiff
