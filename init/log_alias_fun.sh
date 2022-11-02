#!/bin/bash
#INFO WARN ERROR is 001
#DEBUG is 010
#VERBOSE is 100
#VERBOSE open all DEBUG open DEBUG and INFO ,Default INFO open
export LOG_LEVEL=1

echoGreen(){

	echo -e "\033[32m $1 \033[0m"

}

echoRed(){

	echo -e "\033[31m $1 \033[0m"
}

LOGI(){
	if [[ $LOG_LEVEL -gt 1 || $LOG_LEVEL == 1 ]];then
		echo -e "\033[32m $1 \033[0m"
	fi

}

LOGD(){
	if [[ $LOG_LEVEL -gt 2 || $LOG_LEVEL == 2 ]];then
		echo -e "\033[34m $1 \033[0m"
	fi

}

LOGV(){
	if [[ $LOG_LEVEL -gt 4 || $LOG_LEVEL == 4 ]];then
		echo $1
	fi
}

logPaint(){
	if [ $# -gt 0 ];then
		exec 0<$1;
	fi
	
	while read line
	do
	  if [[ $line =~ ^[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}\ +[0-9]+\ +[0-9]+\ +I ]];then
		echo -e "\033[32m $line \033[0m"
	  fi
	  if [[ $line =~ ^[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}\ +[0-9]+\ +[0-9]+\ +D ]];then
		echo -e "\033[34m $line \033[0m"
	  fi
	  if [[ $line =~ ^[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}\ +[0-9]+\ +[0-9]+\ +E ]];then
		echo -e "\033[31m $line \033[0m"
	  fi
	  if [[ $line =~ ^[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}\ +[0-9]+\ +[0-9]+\ +W ]];then
		echo -e "\033[33m $line \033[0m"
	  fi
	
	done<&0;
	
	exec 0>&-;


}

