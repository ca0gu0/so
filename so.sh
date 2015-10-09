#!/bin/bash


direc=`dirname $0`
function color(){
    blue="\033[0;36m"
    red="\033[0;31m"
    green="\033[0;32m"
    close="\033[m"
    case $1 in
        blue)
            echo -e "$blue $2 $close"
        ;;
        red)AA
            echo -e "$red $2 $close"
        ;;
        green)
            echo -e "$green $2 $close"
        ;;
        *)
            echo "Input color error!!"
        ;;
    esac
}

function copyright(){
    echo "#####################"
    color blue "   SSH Login Platform   "
    echo "#####################"
    echo
}

function underline(){
    echo "-----------------------------------------"
}

function main(){

while [ True ];do


    echo "序号 |       主机      | 说明"
    underline
    awk 'BEGIN {FS=":"} {printf("\033[0;31m% 3s \033[m | %15s | %s\n",$1,$2,$6)}' $direc/password.lst
    underline
    read -p '[*] 选择主机: ' number
    pw="$direc/password.lst"
    ipaddr=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $2}}' $pw)
    port=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $3}}' $pw)
    username=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $4}}' $pw)
    passwd=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $5}}' $pw)

    case $number in
        [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
            echo $passwd | grep -q ".pem$"
            RETURN=$?
            if [[ $RETURN == 0 ]];then
                ssh -i $direc/keys/$passwd $username@$ipaddr -p $port
                echo "ssh -i $direc/$passwd $username@$ipaddr -p $port"
            else
                expect -f $direc/ssh_login.exp $ipaddr $username $passwd $port
            fi
        ;;
        "q"|"quit")
            exit
        ;;

        *)
            echo "Input error!!"
        ;;
    esac
done
}

copyright
main

