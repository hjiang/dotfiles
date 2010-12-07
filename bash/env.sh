# For MacPorts
PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

PATH=~/code/scripts:~/bin:~/.gem/ruby/1.8/bin:~/opt/android/tools/:/usr/local/bin:$PATH

export EDITOR="emacsclient -a vim"
export VISUAL=$EDITOR
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CLICOLOR=1

# Clojure
# Install using ~/code/scripts/install_clojure.sh
# export CLOJURE_EXT=~/.clojure
# PATH=$PATH:~/.clojure/launchers/bash
# alias clj="rlwrap clj-env-dir"

# JRuby
# Install using install-jruby
PATH=$PATH:$HOME/opt/jruby/bin

CLOJURE_CONTRIB_JAR="/usr/local/Cellar/clojure-contrib/1.2.0/clojure-contrib.jar"
[[ -e $CLOJURE_CONTRIB_JAR ]] && export CLASSPATH=$CLASSPATH:$CLOJURE_CONTRIB_JAR

case `hostname` in
  *.google.com) export IN_GOOGLE=1 ;;
  *) export IN_GOOGLE=0 ;;
esac

if [ $IN_GOOGLE -eq 1 ]; then
  export GOOGLE_USE_CORP_SSL_AGENT=true
  export P4DIFF="diff"
  export P4MERGE=/home/build/public/eng/perforce/mergep4.tcl
  export P4EDITOR=${EDITOR}
  export P4CONFIG=.p4config
  PATH=$HOME/opt/bin:$HOME/depot_tools:/opt/bin:$PATH:/auto/build/public/google/tools:/home/build/nonconf/google3/tools:$HOME/.gem/ruby/1.8/bin:/home/build/static/projects/overlayfs
  test -e /home/build/static/projects/loas/setup-corp-loasd.sh && /home/build/static/projects/loas/setup-corp-loasd.sh -q
  # export USE_CANARY_BLAZE=head
  alias mendel=/home/build/static/projects/mendel/mendel
fi

export PATH

export JH_ENV_ALREADY_SET=1

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
