#!/bin/bash

. $(dirname $0)/utils.sh

# Variables
SUPERVISOR_PROGRAMM_NAME={{ project }}.{{ branch }}.celeryd

# Restart supervisor programm
echo "Update supervisord for celeryd"
cmd_or_die "sudo supervisorctl restart $SUPERVISOR_PROGRAMM_NAME"
