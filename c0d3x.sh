#!/bin/bash

Black='\033[0;30m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
White='\033[0;37m'
Gray='\033[1;30m'
LRed='\033[1;31m'
LGreen='\033[1;32m'
LYellow='\033[1;33m'
LBlue='\033[1;34m'
LPurple='\033[1;35m'
LCyan='\033[1;36m'
Magenta='\033[1;95m'
DGray='\033[1;90m'
Underline='\033[5m'
Italic='\033[3m'
RC='\033[0m'  #Reset Color


helpFunction()
{
   echo ""
   echo "Usage-1: $0 -f 200,301,302,403 -t targets.txt -o out.txt"
   echo  ""
   echo "Usage-2: command | $0 -f 200,301,302,403 -t targets.txt -o out.txt"
   echo ""
   echo -e "\t-f Filter by status code (separated by comma)"
   echo -e "\t-o save the output to a file"
   echo -e "\t-t Read target list from a file"
   echo -e "\t-r Raw output"
   echo ""
   exit 1
}

while getopts "f:o:t:r" opt; do
   case "$opt" in
      f ) filter="$OPTARG" ;;
      o ) outputFile="$OPTARG";;
      t ) targetFile="$OPTARG" ;;
      r ) rawout="enabled" ;;
      ? ) helpFunction ;;
   esac
done

function urlChecker {

    function checkStatusCode {

        if [ "$rawout" = "enabled" ];then

            echo "$2"

        else

            if [ $statusCode -ge '100' ] && [ $statusCode -le '199' ]; then 

                echo -e "${Gray}[${White}+${Gray}] ${LBlue}$statusCode ${Gray}- ${LYellow}$2${RC}"

            elif [ $statusCode -ge '200' ] && [ $statusCode -le '299' ]; then

                echo -e "${Gray}[${White}+${Gray}] ${Green}$statusCode ${Gray}- ${LYellow}$2${RC}"

            elif [ $statusCode -ge '300' ] && [ $statusCode -le '399' ]; then

                echo -e "${Gray}[${White}+${Gray}] ${LBlue}$statusCode ${Gray}- ${LYellow}$2${RC}"

            elif [ $statusCode -ge '400' ] && [ $statusCode -le '499' ]; then

                echo -e "${Gray}[${White}+${Gray}] ${LPurple}${Italic}$statusCode${RC} ${Gray}- ${LYellow}$2${RC}"

            elif [ $statusCode -ge '500' ] && [ $statusCode -le '599' ]; then

                echo -e "${Gray}[${White}+${Gray}] ${Red}${italic}$statusCode${RC} ${Gray}- ${LYellow}$2${RC}"

            fi

        fi

    }


    if [ ! -z "$filter" ] && [ ! -z "$outputFile" ]; then

        filter=$(echo "$filter" | sed 's/,/|/g')

        statusCode=$(curl -s -o /dev/null -I --connect-timeout 5 --retry 0 --max-time 5 -w "%{http_code}" $1 | egrep "$filter")

        if [ ! -z $statusCode ]; then

            echo "$1" >> $outputFile

            checkStatusCode $statusCode $1

        fi

    elif [ ! -z "$filter" ]; then

        filter=$(echo "$filter" | sed 's/,/|/g')

        statusCode=$(curl -s -o /dev/null -I --connect-timeout 5 --retry 0 --max-time 5 -w "%{http_code}" $1 | egrep "$filter")

        if [ ! -z $statusCode ]; then

            checkStatusCode $statusCode $1

        fi

    elif [ ! -z "$outputFile" ]; then

        statusCode=$(curl -s -o /dev/null -I --connect-timeout 5 --retry 0 --max-time 5 -w "%{http_code}" $1)

        if [ ! -z $statusCode ]; then

            echo "$1" >> $outputFile

            checkStatusCode $statusCode $1

        fi

    else

        statusCode=$(curl -s -o /dev/null -I --connect-timeout 5 --retry 0 --max-time 5 -w "%{http_code}" $1)

        if [ -z $statusCode ]; then

            statusCode="000"

        fi

        checkStatusCode $statusCode $1

    fi

}

if [ ! -z $targetFile ]; then

    if [ ! -z $outputFile ]; then

        cat /dev/null > $outputFile

    fi

    totalTargets=$(cat $targetFile | wc -l)

    echo "Testing $totalTargets from $targetFile"

    for url in $(cat $targetFile); do

        urlChecker $url
    
    done

else

    if [ -t 0 ]; then

        helpFunction

    else

        if [ ! -z $outputFile ]; then

            cat /dev/null > $outputFile

        fi

        while IFS= read url; do

            urlChecker $url

        done

    fi

fi
