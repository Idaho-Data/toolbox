#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback
HOME=/home/docker

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}
groupmod -g $GROUP_ID docker
useradd --shell /bin/bash -u $USER_ID -o -c "" -g docker -m docker
echo docker:docker >/tmp/passwd && chpasswd </tmp/passwd && rm /tmp/passwd
adduser docker sudo
echo "docker ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

chown -R docker:docker /var/run/docker.sock
chown -R docker:docker /opt/conda/

# install LS_COLORS
wget https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS -O $HOME/.dircolors
echo 'eval $(dircolors -b $HOME/.dircolors)' >> $HOME/.bashrc

# install bash-git-prompt with
# custom prompt
cat <<GIT_COLORS >$HOME/.git-prompt-colors.sh
# This is the custom theme template for gitprompt.sh
source /opt/toolbox/vendor/bash-git-prompt/prompt-colors.sh
override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom"
  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${ResetColor} [${USER}@${HOSTNAME%%.*}] ${Yellow}${PathShort}${ResetColor}"
  GIT_PROMPT_START_ROOT="${GIT_PROMPT_START_USER}"
}
reload_git_prompt_colors "Custom"
GIT_COLORS

cat <<BASHRC >$HOME/.bashrc
TERM=vt100
DEBIAN_FRONTEND=teletype
GIT_PROMPT_THEME="Custom"
source /opt/toolbox/vendor/bash-git-prompt/gitprompt.sh
alias ls='ls --color=auto'
BASHRC


exec /usr/local/bin/gosu docker "$@"
