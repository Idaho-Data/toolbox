#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}
useradd --shell /bin/bash -u $USER_ID -o -c "" -m docker
echo docker:docker >/tmp/passwd && chpasswd </tmp/passwd && rm /tmp/passwd
adduser docker sudo
echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

chown -R docker:docker /opt/conda/

exec /usr/local/bin/gosu docker "$@"
