#!/bin/bash

LOCAL_USER_ID=`id -u`
LOCAL_GROUP_ID=`id -g`

rm toolbox.env
cat <<ENV >toolbox.env
LOCAL_USER_ID=$LOCAL_USER_ID
LOCAL_GROUP_ID=$LOCAL_GROUP_ID
ENV
