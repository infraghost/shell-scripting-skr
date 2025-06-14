#!/bin/bash
USERID=(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
RED="\e[31m"
GREEN="\e[32m"
NO="\e[0m"
echo "Please enter DB Password:"
read -s mysql_root_password

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2...$RED Failure $NO"
    else
        echo -e "$2...$GREEN Success $NO"
    fi
}
if [ $USERID -ne 0 ]; then
    echo "Please run this script with root access"
    exit 1
else
    echo "You are sudo user"
fi

dnf install mysql-server -y >>$LOGFILE
VALIDATE $? "Installing MySql Server"

systemctl enable mysqld $ >>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySql Server"

mysql -h db.thehsk.xyz -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]; then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root Password Setup"
else
    echo "MySQL Root passwd is already setup... $GREEN SKIPPING $NO"
fi
