#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NO="\e[0m"

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2...$RED Failure $NO"
    else
        echo -e "$2...$GREEN Success $NO"
    fi
}

check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e "$RED Please run this script with root access $NO"
        exit 1
    else
        echo -e "$GREEN You are sudo user $NO"
    fi
}