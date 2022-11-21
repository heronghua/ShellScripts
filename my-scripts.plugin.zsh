# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.
export MY_SCRIPTS_ROOT=${ZSH_CUSTOM}/plugins/my-scripts/
export MY_SCRIPTS=${MY_SCRIPTS_ROOT}/my-scripts.plugin.zsh
if [[ -f "${MY_SCRIPTS_ROOT}/log_alias_fun.sh" ]]; then
       source "${MY_SCRIPTS_ROOT}/log_alias_fun.sh"
fi

if [[ -f "${MY_SCRIPTS_ROOT}/aliases.sh" ]]; then
       source "${MY_SCRIPTS_ROOT}/aliases.sh"
fi

