#!/bin/bash

. $(dirname $0)/utils.sh

# Variables
GIT_BRANCH_CREATE={{ git_branch_create }}

# Create project branch
if [[ ! "$BRANCH" = "master" ]] && [[ "$GIT_BRANCH_CREATE" = "yes" ]]; then
    cmd "sudo chown -R $USER:$USER $SOURCE_DIR"
    cmd "git --work-tree $SOURCE_DIR --git-dir $SOURCE_DIR/.git push origin origin:refs/heads/$BRANCH"
    cmd "git --work-tree $SOURCE_DIR --git-dir $SOURCE_DIR/.git fetch origin"
    cmd "git --work-tree $SOURCE_DIR --git-dir $SOURCE_DIR/.git checkout --track origin/$BRANCH"
    cmd "sudo chown -R $SITE_USER:$SITE_GROUP $SOURCE_DIR"
fi
