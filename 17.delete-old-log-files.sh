#!/bin/bash

#gtouch -d "2025-06-01 10:30" mysql.log
#gtouch -d "2025-06-01 10:30" sample
#gtouch -d "2025-06-01 10:30" script-1.java
#gtouch -d "2025-06-01 10:30" script-1.log



#Uncomment for MAC; Comment for Linux and remove -e in echo "echo "test"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NO='\033[0m'
#Uncomment for Linux; Comment for MAC and place -e in echo "echo -e "test"
# RED="\e[31m"
# GREEN="\e[32m"
# YELLOW="\e[33m"
# NO="\e[0m"

LOG_DIRECTORY=$1

# Check if input is provided
if [ -z "$LOG_DIRECTORY" ]; then
    echo "${RED}Error: No directory path provided.${NO}"
    echo "${YELLOW}RUN: sh $0 /path/to/directory${NO}"
    exit 1
fi

# Check if the directory exists
if [ -d "$LOG_DIRECTORY" ]; then
    echo "${GREEN}Valid directory: $LOG_DIRECTORY${NO}"
else
    echo "${RED}Error: Directory does not exist - $LOG_DIRECTORY${NO}"
    exit 1
fi

FILES=$(find $LOG_DIRECTORY -name "*.log" -mtime +14)

#echo $FILES

while IFS= read -r line
do
    echo "Deleting file: $line"
    rm -f $line
done <<< "$FILES"