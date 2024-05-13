#!/bin/bash
# Decodes stdin as quoted printable
# http://www.billharlan.com/papers/Bourne_shell_idioms.html
perl -pe 'use MIME::QuotedPrint; $_=MIME::QuotedPrint::decode($_);'
