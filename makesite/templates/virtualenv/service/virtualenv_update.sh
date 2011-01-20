#!/bin/sh
VIRTUALENVDIR={{ virtualenvdir  }}
PIP_PROJECTFILE={{ pip_projectfile }}

REQ_SUM=$(md5sum $PIP_PROJECTFILE)
OLD_REQ_SUM=$(cat $VIRTUALENVDIR/.reqsum)

if [ -f $PIP_PROJECTFILE ]; then
    echo "  * Update virtualenv requirements '$PIP_PROJECTFILE'."
    if [ "$REQ_SUM" = "$OLD_REQ_SUM" ]; then
        echo "  * Changes not found."
    else
        sudo pip -E $VIRTUALENVDIR install -r $PIP_PROJECTFILE
        sudo rm -rf $VIRTUALENVDIR/.reqsum && sudo sh -c "md5sum $PIP_PROJECTFILE > $VIRTUALENVDIR/.reqsum"
    fi
fi
