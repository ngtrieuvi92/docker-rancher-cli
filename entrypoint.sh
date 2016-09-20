#!/bin/bash
#
DIR="/data"
# init
# look for empty director

EXECUTE_SCRIPT="/data/${RANCHER_EXECUTE_SCRIPT:-run.sh}" 
if [ "$(ls -A $DIR)" ]; then
    if [ -f "$EXECUTE_SCRIPT" ]; then 
     echo "start script $EXECUTE_SCRIPT"   
     . $EXECUTE_SCRIPT
    else 
     echo "$EXECUTE_SCRIPT is not found!"
     exit 1
    fi
else 
    echo "No volumne mount, execute /scripts/run.sh"
    . /scripts/run.sh
fi