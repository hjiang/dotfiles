export GOOGLE_USE_CORP_SSL_AGENT=true
if [ -x /usr/local/scripts/ssx-agents ] ; then
    [ "$PS1" ] && eval `/usr/local/scripts/ssx-agents $SHELL`
fi
