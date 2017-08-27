#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}
groupmod -g $GROUP_ID docker
useradd --shell /bin/bash -u $USER_ID -o -c "" -g docker -m docker
echo docker:docker >/tmp/passwd && chpasswd </tmp/passwd && rm /tmp/passwd
adduser docker sudo
echo "docker ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

chown -R docker:docker /var/run/docker.sock
chown -R docker:docker /opt/conda/

# install bash-git-prompt with
# custom prompt
cat <<GIT_COLORS >/home/docker/.git-prompt-colors.sh
# This is the custom theme template for gitprompt.sh
source /opt/toolbox/vendor/bash-git-prompt/prompt-colors.sh
override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom"
  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${ResetColor} [${USER}@${HOSTNAME%%.*}] ${Yellow}${PathShort}${ResetColor}"
  GIT_PROMPT_START_ROOT="${GIT_PROMPT_START_USER}"
}
reload_git_prompt_colors "Custom"
GIT_COLORS

cat <<BASHRC >/home/docker/.bashrc
GIT_PROMPT_THEME="Custom"
source /opt/toolbox/vendor/bash-git-prompt/gitprompt.sh
BASHRC

exec /usr/local/bin/gosu docker "$@"
