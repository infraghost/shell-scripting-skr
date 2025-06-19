#!/bin/bash
# touch -d 20250530 sample.java
# touch -d 20250530 sample.py
# touch -d 20250530 sample-1.log
# touch -d 20250530 sample.txt
# touch -d 20250530 sample-2.log


#Uncomment for MAC; Comment for Linux and remove -e in echo "echo "test"
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# NO='\033[0m'
#Uncomment for Linux; Comment for MAC and place -e in echo "echo -e "test"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NO="\e[0m"

echo "Please enter DB Password:"
read -s SOURCE_DIRECTORY

#Checking if folder exist or not
if [ -d $SOURCE_DIRECTORY ]
then
    echo "$GREEN Source Directory is exists $NO"
else
    echo "$RED Source Directory does not exists $NO"
fi

# find /tmp/app-logs -name "*.log" -mtime +14

FILES=$(find /tmp/app-logs -name "*.log" -mtime +14)

echo "Deleting $FILES"