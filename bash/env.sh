if [[ -s /etc/profile ]]; then
    source /etc/profile
fi

if [[ -d /opt/android-sdk ]]; then
    export ANDROID_HOME=/opt/android-sdk
fi

PATH=/usr/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

PATH=~/code/scripts:~/bin:~/opt/android/tools:/usr/local/bin:$PATH

export EDITOR="emacsclient -a vim"
export VISUAL=$EDITOR
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CLICOLOR=1

MACTEX_BASIC_BIN=/usr/local/texlive/2010basic/bin/universal-darwin

if [[ -d ${MACTEX_BASIC_BIN} ]]; then
    PATH=${MACTEX_BASIC_BIN}:$PATH
fi

if [[ -d "${HOME}/code/onycloud/tools/bin" ]]; then
    PATH="${HOME}/code/onycloud/tools/bin":$PATH
fi

if [[ -d "${HOME}/.cabal/bin" ]]; then
    PATH="${HOME}/.cabal/bin":$PATH
fi

export PATH

if [[ -s /home/hjiang/.rvm/scripts/rvm ]] ; then
    source $HOME/.rvm/scripts/rvm
fi

export JH_ENV_ALREADY_SET=1

export NODE_PATH=/usr/local/lib/node

# export TERM=xterm-256color

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
