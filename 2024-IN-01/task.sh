#!/bin/bash

delete=''
pushPull='' #push - 1, pull - 0
server='' #if empthy string, sync iterativly
path=''
username=''
sourcePath=''
destinationPath=''
servers=''

function rsyncExecution()  
{
	if [[ ! -z $delete ]] 
	then 
		rsync -n $sourcePath $destinationPath
		echo " Do you want to sync this files? Press y/n"
		read answer 
		if [[ $answer == 'y' ]]
		then 
			rsync --delete $sourcePath $destinationPath
		else
			echo "This files are NOT synced!"
		fi
	else
		rsync -n $sourcePath $destinationPath
		echo "Do you want to sync this files? Press y/n"
		read answer
		if [[ $answer == 'y' ]]
		then  
			rsync $sourcePath $destinationPath
		else
			echo "This files are NOT synced!"
		fi
	fi
}

for i in $@ 
do
	case $i in  

		-d)
			delete='yes'
			;;
		push)
			if [[ ! -z "$pushPull" ]]; then 
				echo "Invalid paramenter! You need to choose push XOR pull. Better luck next time!"
				exit 1
			fi
			pushPull=1
			;;
		pull)
			if [[ ! -z "$pushPull" ]]; then 
				echo "Invalid parameter! You need to choose push XOR pull. Better luck next time!"
				exit 1 
			fi
			pushPull=0
			;;
		a*)
			if ! grep -E -q "^WHERE=.*${i}.*" $ARKCONF
			then
				echo "Invalid server_name! You need to choose valid server from $ARKCONF. Better luck next time!"
				exit 1
			fi

			if [[ -z $server ]]; then 
				server=$i
			else
				echo "Multiple servers! Specify only one!"
				exit 1
			fi
			;;
		*)
			echo "Invalid parameter!"
			exit 1
			;;
	esac
done


if   ! grep -E -q 'WHAT' $ARKCONF || \
	 ! grep -E -q 'WHO' $ARKCONF  || \
	 ! grep -E -q 'WHERE' $ARKCONF 
then
	echo "Invalid configuration file! Check $ARKCONF to find the path of file!"
	exit 1
fi

path=$(grep -E -q 'WHAT' ${ARKCONF} | cut -d '=' -f2 | tr -d '"')
username=$(grep -E -q 'WHO' ${ARKCONF} | cut -d '=' -f2 | tr -d '"')
servers=$(grep -E -q 'WHERE' ${ARKCONF} | cut -d '=' -f2| tr -d '"')

if [[  -z $server ]] 
then
	if [[ ${pushPull} == "1" ]] 
	then 
		sourcePath=${path}
		for i in $servers 
		do
			destinationPath="${username}@${i}:${path}"
			rsyncExecution
		done
	else
		destinationPath=${path}
		for i in $servers 
		do
			sourcePath="${username}@${i}:${path}"
			rsyncExecution
		done
	fi
else
	if [[ ${pushPull} == "1" ]] 
	then 
		sourcePath=${path}
		destinationPath="${username}@${server}:${path}"
		rsyncExecution
	elif [[ ${pushPull} == "0" ]]
	then 
		sourcePath="${username}@${server}:${path}"
		destinationPath=${path}
		rsyncExecution
	else
		echo "Invalid parameter! You need to choose push XOR pull. Better luck next time!"
		exit 1
	fi 
fi
