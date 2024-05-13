#!/bin/bash
# Searches JARs in this and subdurectories for the specified file name.

PATTERN=$1
echo PATTERN=$PATTERN
shift 1

if [ $# == 0 ]; then
	PATHS=.
else
	PATHS="$@"
fi
echo PATHS=$PATHS

find -L $PATHS -name '*.jar' | 
while read jar; do
	unzip -Z1 $jar | grep -l "$PATTERN" > /dev/null;
	if [ $? = 0 ]; then
		echo $jar;
	fi;
done;
