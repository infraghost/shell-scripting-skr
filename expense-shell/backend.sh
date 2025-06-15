#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
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
    echo -e "$RED Please run this script with root access $NO"
    exit 1
else
    echo -e "$GREEN You are sudo user $NO"
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs Version 20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
else
    echo "User with name $RED expense $NO already created; so $YELLOW SKIPPING $NO"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

cd /app
rm -rf /app/* &>>$LOGFILE
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracted backend code"

npm install &>>$LOGGING
VALIDATE $? "Installing nodejs dependencies"

cp /home/ec2-user/shell-scripting-skr/expense-shell/backend.service /etc/systemd/system/backend.service
VALIDATE $? "Copied backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Reloading Daemon"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Enabling Backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling Backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySql Clinet"

mysql -h db.thehsk.xyz -uroot -p"${mysql_root_password}" < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Loading Schema"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"