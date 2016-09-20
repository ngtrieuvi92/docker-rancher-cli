#!/bin/bash
#
DIR="/data"
# init
# look for empty director
$EXEC_FILE=${RANCHER_EXECUTE_SCRIPT:-run.sh}
EXECUTE_SCRIPT="/data/$EXEC_FILE" 
if [ "$(ls -A $DIR)" ]; then
    if [ -f "$EXECUTE_SCRIPT" ]; then 
     echo "Starting script $EXECUTE_SCRIPT"   
     . $EXECUTE_SCRIPT
    else 
     echo "$EXECUTE_SCRIPT is not found!"
     exit 1
    fi
else 
    echo "No volumne mount, execute /scripts/run.sh"
    . /scripts/run.sh
fi