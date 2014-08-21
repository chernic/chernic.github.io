#!/bin/sh
export PS4='+[$LINENO]'

BreakPoint()
{
    while [ "y" != "$AUTO_FLAG_yn" ]
    do
        read -p "\033[33mDo you Make Sure to Continue? [y/n/q] \033[0m" AUTO_FLAG_yn;
        [ "$AUTO_FLAG_yn" == "q" ] && exit 0;
    done
    AUTO_FLAG_yn="n"
}

NotRootOut()
{
    [ "0" != "$(id -u)" ] && echo "Error: You must be root to run this script" && exit 1 
}

GetIPAddress()
{
    IPAddress=`ifconfig eth0 | grep 'inet addr' | cut -d ":" -f 2 | cut -d " " -f 1`
}

ReadConf()
{
    # 全局配置实际路径
		LOCAL_PATH=$(dirname "$0");
    # 获取脚本同名配置
		CONF_FILE="$1"
    # 加载日志函数
    if [ -f $LOCAL_PATH/$CONF_FILE ];then
        echo -e "$CONF_FILE is \033[32mFound.\033[0m"
        source $LOCAL_PATH/$CONF_FILE
    else
        echo -e "$CONF_FILE is \033[31mNot Found.\033[0m"
    fi
}

NotRootOut;
ReadConf "Global.conf";
ReadConf "$(basename $0 .sh).conf";
ReadConf "log.sh";
LOG_INFO "Load Configures Done.\n"

############### Template Version 0.1.2 ##############
# MD5 html 头部校检替换
#####################################################
# Template
#####################################################
# Version : 0.0.11
# Make by Chernic.Y.Chen @ China
# E-Mail : iamchernic@gmail.com
# Date : 2014-7-22
# v0.0.1(2014-8-22) : File Created
# v0.1.0(2014-8-22) : EditHead() Done.

HeadFlag="<!-- The End of Head -->"
HeadFile="tmp/HeadFile.htm"
HeadMD5="tmp/HeadFile.md5"

TailFlag="<!-- The End of Tail-->"
TailFile="tmp/TailFile.htm"
TailMD5="tmp/TailFile.md5"

EditHead()
{
	awk "!i++, /$HeadFlag/" ListX > $HeadFile
	md5sum $HeadFile > $HeadMD5
	OriMd5=$(cut -d ' ' -f1 $HeadMD5)

	for i in $(find . -name "List*.htm")
	do
		TmpMd5=$(awk "!i++, /$HeadFlag/" $i | md5sum | cut -d ' ' -f1)
		if [ ! $OriMd5==$TmpMd5 ];then
			echo "Happy That Our FileHead Update ^-^"
			sed -i "
			1{
				x
				r $HeadFile
			}
			2{
				H
				x
			}
			{
				/^[[:space:]]*$/d
			}
			" $i
		else
			echo "$HeadFile is the Same As $i"
		fi
	done
}

EditHead;