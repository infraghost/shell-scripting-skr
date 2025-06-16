#!/bin/bash

# USERID=$(id -u)
# TIMESTAMP=$(date +%F-%H-%M-%S)
# SCRIPT_NAME=$(basename $0 | cut -d "." -f1)
# LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
# RED="\e[31m"
# GREEN="\e[32m"
# YELLOW="\e[33m"
# NO="\e[0m"

# echo "Please enter DB Password:"
# read -s mysql_root_password

# VALIDATE() {
#     if [ $1 -ne 0 ]; then
#         echo -e "$2...$RED Failure $NO"
#     else
#         echo -e "$2...$GREEN Success $NO"
#     fi
# }

# if [ $USERID -ne 0 ]; then
#     echo -e "$RED Please run this script with root access $NO"
#     exit 1
# else
#     echo -e "$GREEN You are sudo user $NO"
# fi

source ./common.sh

check_root

echo "Please enter DB Password:"
read -s mysql_root_password

# Check if MySQL is already installed
if ! rpm -q mysql-server &>>$LOGFILE; then
    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "Installing MySQL Server"
else
    echo -e "MySQL Server is already installed... $YELLOW Skipping installation $NO"
fi

# Enable MySQL to start on boot
systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

# Start MySQL service
systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"

# Check if root password is already set by trying to connect
mysql -uroot -p"${mysql_root_password}" -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]; then
    echo -e "Setting root password..."
    mysql_secure_installation --set-root-pass "${mysql_root_password}" &>>$LOGFILE
    VALIDATE $? "Setting up root password"
else
    echo -e "MySQL Root password already set... $YELLOW Skipping $NO"
fi
