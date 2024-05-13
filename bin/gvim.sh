#!/bin/bash
# Wrapper to start Vim for Windows from within cygwin
#
# NOTE: two assupmtions are made: 
# 1. the GUI version should always be opened regardless of whether vim or gvim was called 
# 2. when a vim command is called (i.e. non-GUI), the -f flag is implied to prevent forking
# 
# INSTALLATION: replace the original vim* gvim* scripts/binaries with a link to this script
# 
# TODO writing filename args to a file may be more efficient than using bash arrays

# Convert TEMP and TMP back to windows paths
export TMP=`cygpath -w "$USERPROFILE/AppData/Local/Temp"`
export TEMP=`cygpath -w "$TMP"`

# Unset SHELL variable so vim knows to use Windows commands
export SHELL=

# Max # of characters allowed on a Windows command line
# http://support.microsoft.com/kb/830473
MAX_CHARS=2047

# Determine which batch file to run
if [[ $0 =~ 'diff' ]]; then
	COMMAND="gvimdiff.bat"
else
	COMMAND="gvim.bat"
fi

# Determine if gvim was called
if [[ $0 =~ 'gvim' ]]; then
	echo GUI
else
	echo 'Console (i.e. Non-forked GUI) (see -f)'
	COMMAND="$COMMAND -f"
fi

# options - gathers the command line options (these should be present for all subsequent invocations)
# filenames - gathers the file names
let options_n=0
let filenames_n=0

let only_files=0
let next_as_option=0

# Process each argument
for arg in "$@"; do
#	echo $arg
	# Check to see if the next arg should be a filename
	# 1. it's not flagged as being part of a compound option
	# 2. it doesn't start with - or +
	# 3. OR we're only processing files at this point
	if [[ $next_as_option == 0 && ( "$arg" =~ ^[^+-] || $only_files == 1 ) ]]; then
		# Not an option, so treat it as a file name
		filenames[$filenames_n]=`cygpath -w "$arg"`
		let filenames_n=$filenames_n+1
	else 
		# Decode the option
		# Assume it's not a compound option
		let next_as_option=0
		if [[ "$arg" == '--' ]]; then
			# Only file names come afterwards
			let only_files=1
		else			
			# Store the option
			options[$options_n]="$arg"
			let options_n=$options_n+1

			# Detect compound options
			if [[ "$arg" =~ ^-([tqcSTuUiswWP]|-cmd|-startuptime)$ ]]; then
				let next_as_option=1
			fi
		fi
	fi
done

# Output info about arguments
echo $# total args
echo $options_n options
echo $filenames_n filenames

# Run the command
if [[ $filenames_n > 0 ]]; then
	# Convert args into stream and send them to xargs
	for arg in "${filenames[@]}"; do
		echo "$arg"
	done | exec xargs -s $MAX_CHARS -d '\n' $COMMAND "${options[@]}" --
else
	# No file args, so we can run this once without xargs
	exec $COMMAND "${options[@]}" 
fi 2>&1 > /dev/null
