#!/bin/bash

. $(dirname $0)/utils.sh

PROGRAMM_NAME={{ project }}.{{ branch }}.celeryd
SUPERVISOR_CELERY_CONFPATH={{ supervisor_celery_confpath }}

echo "Create link to supervisor conf: $SUPERVISOR_CELERY_CONFPATH"
cmd_or_die "sudo ln -sf $DEPLOY_DIR/deploy/supervisor.celeryd.conf $SUPERVISOR_CELERY_CONFPATH"

echo "Update supervisord for celeryd"
cmd_or_die "sudo supervisorctl reread"
cmd_or_die "sudo supervisorctl reload $PROGRAMM_NAME"
