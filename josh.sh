#!/bin/bash

docker volume create toolbox-data
docker volume inspect toolbox-data
docker build -t idahodata/toolbox .



LOCAL_USER_ID=`id -u`
LOCAL_GROUP_ID=`id -g`
echo >toolbox.env <<EOF
LOCAL_USER_ID=`id -u`
LOCAL_GROUP_ID=`id -g`
EOF

