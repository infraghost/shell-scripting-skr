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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disable Default Node.js"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enable Node.js Version 20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Install Node.js"

id expense &>>$LOGFILE
if [ $? -ne 0 ]; then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Create User Expense"
else
    echo "User Expense already exists $RED Skipping $NO"
fi

mkdir -p /app
VALIDATE $? "Create App Directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Download Backend Code"

cd /app
unzip /tmp/backend.zip
VALIDATE $? "Unzip Backend Code"

npm install &>>$LOGFILE
VALIDATE $? "Install Dependencies"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copy Service File"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Reload Systemd Daemon"

systemctl start backend
VALIDATE $? "Start Backend Service"

systemctl enable backend
VALIDATE $? "Enable Backend Service"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Install MySQL Client"

mysql -h db.thehsk.xyz -uroot -p${mysql_root_password} </app/schema/backend.sql
VALIDATE $? "Apply Database Schema"

systemctl restart backend
VALIDATE $? "Restart Backend Service"
