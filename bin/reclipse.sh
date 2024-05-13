#!/bin/bash
# Script to automate the process of cleaning out cruft that accumulates within
# a set of Eclipse workspaces.
# 
# !WARN! Do not run this against any workspace that Eclipse is running
# 
# To use:
#	specify any workspace paths as arguments to this script
# OR
#	allow the script to use a pre-defined ECLIPSE_WORKSPACES env variable

# Produce a stream of workspace paths
# Check if we have to quit due to lack of args
if [[ $# == 0 ]]; then    
    if [[ -z "$ECLIPSE_WORKSPACES" ]]; then
        # no ECLIPSE_WORKSPACES defined, quit
        echo 'No args provided and no ECLIPSE_WORKSPACES value defined' 1>&2
        exit 1
    elif which cygpath > /dev/null; then
        # In case it's set to a windows path
        readlink -f $(cygpath "$ECLIPSE_WORKSPACES")
    else
        readlink -f "$ECLIPSE_WORKSPACES"
    fi
else
    for a in "$@"; do
    	readlink -f "$a"
    done
fi |
# make input paths unique
sort -u |
# Look for .metadata paths within a reasonable depth of the workspace paths
xargs -rd '\n' bash -c 'find "$@" -maxdepth 3 -name .metadata -type d' -- |
# make .metadata paths unique
sort -u |
# Process each METADATA path
while read METADATA; do
    # record the time required to clear each workspace
    time (
        # Extract the actual workspace path
        WORKSPACE=${METADATA%/.metadata}
        echo Workspace: $WORKSPACE 1>&2

        # Check for workspace lock file
        if [[ -f $METADATA/.lock ]]; then
            # Test to see if another process holds a lock on it
            echo Detected lock file > $METADATA/.lock
            if [[ $? == 0 ]]; then
                # Able to write to file, i.e. no process locking it.
                # remove the lock file
                rm $METADATA/.lock
            else
                # Unable to write to file, i.e. process is locking it
                # Must be an open workspace, skip processing it
                echo Skipping active workspace $WORKSPACE 1>&2
                continue
            fi
        fi

        # Clear these files
        (
        # Java indices
        find $METADATA/.plugins/org.eclipse.jdt.core -maxdepth 1 -name '*.index' -o -name savedIndexNames.txt
        # JSP indices
        find $METADATA/.plugins/org.eclipse.jst.jsp.core/jspsearch -maxdepth 1 -name '*.index'
        find $METADATA/.plugins/org.eclipse.jst.jsp.core/taglibindex -maxdepth 1 -name '*.dat'
        find $METADATA/.plugins/org.eclipse.jst.jsp.core/translators -maxdepth 1 -name '*.translator'
        ) |
        xargs -rd \\n rm -rf

        # JBoss debug/deployment info
        find $METADATA/.plugins/org.jboss.ide.eclipse.as.core/jboss-eap*/deploy \
             $METADATA/.plugins/org.jboss.ide.eclipse.as.core/jboss-eap*/tempDeploy \
            -mindepth 1 -maxdepth 1 |
        xargs -rd \\n rm -rf

        # Fixing org.eclipse.wst.common.component files with <dependent-object/> lines
        grep -qEl '<dependent-object\s*/>' $WORKSPACE/*/.settings/org.eclipse.wst.common.component | 
            while read FILE; do 
                echo $FILE; 
                sed -ri 's/<dependent-object[:space:]*\/>//' $FILE
            done;
    )
done

