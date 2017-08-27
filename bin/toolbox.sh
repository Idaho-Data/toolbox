#!/bin/bash

docker run -h toolbox \
       --name toolbox \
       --rm \
       -ti \
       --env-file toolbox.env \
       -v /home/jwatts/dev/toolbox:/opt/toolbox \
       -v /var/run/docker.sock:/var/run/docker.sock \
       idahodata/toolbox \
       bash
