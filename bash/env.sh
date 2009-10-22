# For MacPorts
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

export PATH=~/code/scripts:~/bin:$PATH

export EDITOR=vim
export VISUAL=$EDITOR
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR

export LC_ALL=en_US.UTF-8

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
  export PATH=$HOME/opt/bin:$HOME/depot_tools:/opt/bin:$PATH:/auto/build/public/google/tools:/home/build/nonconf/google3/tools:$HOME/.gem/ruby/1.8/bin:/home/build/static/projects/overlayfs
  test -e /home/build/static/projects/loas/setup-corp-loasd.sh && /home/build/static/projects/loas/setup-corp-loasd.sh -q
  # export USE_CANARY_BLAZE=head
fi
