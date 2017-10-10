#!/bin/bash

# build
# docker pull continuumio/miniconda3
docker build -t idahodata/toolbox .

PWD=`pwd`
LOCAL_USER_ID=`id -u`
LOCAL_GROUP_ID=`id -g`

# create Docker environment variables file
#
# needed for mapping the local user & group to the
# container's "docker" user
rm toolbox.env
cat <<ENV >toolbox.env
LOCAL_USER_ID=$LOCAL_USER_ID
LOCAL_GROUP_ID=$LOCAL_GROUP_ID
ENV

CMD="docker run -h toolbox \
       --name toolbox \
       --rm \
       -ti \
       --env-file toolbox.env \
       -v $PWD:/opt/toolbox \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v $HOME/.gitconfig:/home/docker/.gitconfig \
       -v $HOME/.ssh:/home/docker/.ssh \
       idahodata/toolbox \
       /bin/bash"

echo $CMD
eval $CMD
