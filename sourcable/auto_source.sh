sourcable_current_script_path=$(dirname $(realpath ${BASH_SOURCE[0]}))
sourcable_current_script_name=${BASH_SOURCE[0]}
LOGV "sourcable_current_script_path $sourcable_current_script_path sourcable_current_script_name $sourcable_current_script_name"
for i in `ls ${sourcable_current_script_path}`; 
do
    if [[ "${sourcable_current_script_path}/$i" == "${sourcable_current_script_name}" ]]; then
           continue 
    fi
    LOGI "source ${sourcable_current_script_path}/${i}"
    source ${sourcable_current_script_path}/${i}
done

