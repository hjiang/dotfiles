if [[ -s /etc/profile ]]; then
    source /etc/profile
fi

if [[ -d /opt/android-sdk ]]; then
    export ANDROID_HOME=/opt/android-sdk
fi

# For MacPorts
PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

PATH=~/code/scripts:~/bin:~/opt/android/tools/:/usr/local/bin:$PATH

export EDITOR="emacsclient -a vim"
export VISUAL=$EDITOR
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CLICOLOR=1

export PATH

if [[ -s /home/hjiang/.rvm/scripts/rvm ]] ; then
    source $HOME/.rvm/scripts/rvm
fi

export JH_ENV_ALREADY_SET=1

export auto_proxy=file:///home/hjiang/code/dotfiles/proxy.pac

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
