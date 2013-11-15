if [[ -s /etc/profile ]]; then
    source /etc/profile
fi

if [[ -d /opt/android-sdk ]]; then
    export ANDROID_HOME=/opt/android-sdk
fi

PATH=/usr/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

PATH=~/code/scripts:~/bin:/usr/local/bin:$PATH

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

if [[ -d "/usr/local/opt/ruby/bin" ]]; then
    PATH="/usr/local/opt/ruby/bin:$PATH"
fi

if [[ -d "$HOME/code/arcanist/bin" ]]; then
    PATH="$HOME/code/arcanist/bin:$PATH"
fi

if [[ -d "/usr/local/share/npm/bin" ]]; then
    PATH="/usr/local/share/npm/bin:$PATH"
fi

RUBY_BINDIR=`brew info ruby|grep /bin|tr -d ' '`
if [[ -d "${RUBY_BINDIR}" ]]; then
    PATH="${RUBY_BINDIR}:$PATH"
fi

export PATH

if [[ -s /home/hjiang/.rvm/scripts/rvm ]] ; then
    source $HOME/.rvm/scripts/rvm
fi

export JH_ENV_ALREADY_SET=1

export NODE_PATH=$NODE_PATH:/usr/local/lib/node:/usr/local/lib/node_modules

export MEIWEISQ_PASSWORD=''

# export TERM=xterm-256color

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

if [[ -d /usr/local/opt/curl-ca-bundle/share/ ]]; then
    export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
fi

if [[ -d /usr/local/opt/android-sdk ]]; then
    export ANDROID_HOME=/usr/local/opt/android-sdk
fi
