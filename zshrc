# if [[ "$JH_ENV_ALREADY_SET" == "" ]]; then
#  source ~/.zshenv
#fi
. ~/.zshenv
. ~/code/dotfiles/zsh/config
. ~/code/dotfiles/zsh/aliases

eval `keychain --eval --agents ssh id_dsa`


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
