#!/bin/bash
alias reboot='shutdown -r'
alias mat="nohup /opt/mat/MemoryAnalyzer >/dev/null 2>&1 &"
alias sendEmailUsing12Account="sendEmail heronghua1989@126.com"
alias adb="adb wait-for-device"

export TOOLS_FOR_AOSP_BUILD="git-core gnupg flex bison gperf build-essential zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip"

sendEmail(){

        smtp="smtp.126.com 25" # 邮件服务器地址+25端口
        smtp_domain="126.com" # 发送邮件的域名，即@后面的
        FROM="heronghua1989@126.com" # 发送邮件地址
        RCPTTO=$1 # 收件人地址
        username_base64="aGVyb25naHVhMTk4OUAxMjYuY29t" # 用户名base64编码
        password_base64="$MAIL_126_PWD_BASE64_ENCODED" # 密码base64编码
		#read content from inputstream
		if [ $# -gt 2 ];then
		  exec 0<$2;
		fi
		content=$(cat<&0)
		#waiting inputstream read successfully
		wait
		exec 0>&-

        local_ip=`ifconfig|grep Bcast|awk -F: '{print $2}'|awk -F " " '{print $1}'|head -1`
        local_name=`uname -n`
        ( for i in "ehlo $smtp_domain" "AUTH LOGIN" "$username_base64" "$password_base64" "MAIL FROM:<$FROM>" "RCPT TO:<$RCPTTO>" "DATA";do
                echo $i
                sleep 4
        done
        echo "Subject:server alert"
        echo "From:<$FROM>"
        echo "To:<$RCPTTO>"
        echo ""
		echo "content : $content"
        echo "server $local_name up, ip:$local_ip"
        echo "."
        sleep 2
        echo "quit" )|telnet $smtp

}

convertPathIfNeeded(){
	if [[ "`uname`" == ming* ]];then 
		echo `cygpath --path --mixed "$1"`
	else
		echo $1
	fi
}

#This method  is used for dump hprofile from android device or emulator .It will always dump until you break it with Ctrl + C
#usage : pullHProfile com.archermid.demo 
pullHProfile(){

	output=./output
	rm ${output} -rf && mkdir  ${output}
	processName=$1
        productModel=`adb shell getprop ro.product.model`

	pullTimeRetain=30
	#wait and pull
 
	while true
	do
		timeInfo=`date +%Y%m%d_%H%M%S_%N`
		
        	hProfilePathInPhone="/data/local/tmp/"_${productModel}_${timeInfo}.hprof

		adb shell am dumpheap ${processName} ${hProfilePathInPhone}

		if read -r  -t ${pullTimeRetain} -p "Type Y if you want to pull profile right now otherwise it will pull after ${pullTimeRetain} seconds." input
		then
			case $input in
			[Yy])
			(
				
				adb pull ${hProfilePathInPhone} ${output}

				hprof-conv ${output}/_${productModel}_${timeInfo}.hprof ${output}/_${productModel}_${timeInfo}_converted.hprof

				echoGreen "hprofile dump and convert successfully to ${output}/_${productModel}_${timeInfo}_converted.hprof"
			)
			#dump once
			break
			;;
			esac
		else 
			#continus dump
			(
				adb pull ${hProfilePathInPhone} ${output}

				hprof-conv ${output}/_${productModel}_${timeInfo}.hprof ${output}/_${productModel}_${timeInfo}_converted.hprof

				echoGreen "hprofile dump and convert successfully to ${output}/_${productModel}_${timeInfo}_converted.hprof"
			)
		fi
	done
	
}

#usage replaceLineInFileUnderDirectory --rawDirectory=~/folder/ --lineFrom='//Debug' --lineTo='Debug'
#This function can be used for replace String from lineFrome to lineTo under folder $rawDirectory,usually used for open debug log which is written hard code.
replaceLineInFileUnderDirectory(){

	#split parameters
	
	for parameter in $*
	
	do 
		if [[ $parameter == --rawDirectory* ]];then
			rawDirectory=`echo $parameter |sed "s/--rawDirectory=//"`
		elif [[ $parameter == --lineFrom* ]];then
			lineFrom=`echo $parameter |sed "s/--lineFrom=//"`
		elif [[ $parameter == --lineTo* ]];then
			lineTo=`echo $parameter |sed "s/--lineTo=//"`
		
		fi
		
	
	done

	
	if [[ ! -d "$rawDirectory" ]] && [[ ! -f "$rawDirectory" ]];then
		echoRed "Directory \"$rawDirectory\" does not exists!"
	fi
	
	
	#implement replacement
	if [ -f $rawDirectory ];then

		LOGI "File detected $rawDirectory"
		sed -i "s/$lineFrom/$lineTo/g" $rawDirectory

	elif [ -d $rawDirectory ];then
		LOGI "Sub directory \"$rawDirectory\" found"
		for dir in $rawDirectory/*
		do
			replaceLineInFileUnderDirectory --rawDirectory=$dir --lineFrom=$lineFrom --lineTo=$lineTo
		done
	fi
	
	
}

# This function is used to convert argb color to hex color
argbColorToHexColor(){

	local result=""

	for i in $@;do

		result=$result`printf "%-x" $i`
	done
	
	echo $result|clip||echo $result|xsel||echo $result|pbcopy

	printf "The result is :\n\n$result\nAnd cliped to clipboard"
}

flashLoad(){
	if [ "$1" == "" ];then
	    return 0
	fi
		
	adb reboot bootloader
	export ANDROID_PRODUCT_OUT=$1
	sleep 10
    fastboot -w flashall

}
