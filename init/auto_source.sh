init_current_script_path=$(dirname $(realpath ${BASH_SOURCE[0]}))
init_current_script_name=${BASH_SOURCE[0]}
for i in `ls ${init_current_script_path}`; 
do
    if [[ "${init_current_script_path}/$i" == "${init_current_script_name}" ]]; then
           continue 
    fi
    source ${init_current_script_path}/${i}
    LOGI "source ${init_current_script_path}/${i}"
done

