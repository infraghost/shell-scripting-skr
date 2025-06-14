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

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Install Nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enable Nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Start Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Remove default html"

curl -o /tmp/frontend.zip https://expenses-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Download frontend"

cd /usr/share/nginx/html
rm -rf /tmp/frontend/* &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzip frontend"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copy expense.conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restart Nginx"
