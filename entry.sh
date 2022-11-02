current_script_path=$(dirname $(realpath ${BASH_SOURCE[0]}))
current_script_name=${BASH_SOURCE[0]}
if [[ -f "${current_script_path}/init/auto_source.sh" ]]; then
       source "${current_script_path}/init/auto_source.sh"
fi
if [[ -f "${current_script_path}/sourcable/auto_source.sh" ]]; then
       source "${current_script_path}/sourcable/auto_source.sh"
fi
