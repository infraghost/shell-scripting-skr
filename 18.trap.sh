#!/bin/bash

set -e

handle_error(){
    echo "Error Occured at line number: $1, error command is $2"
}


trap 'handle_error ${LINENO} "${BASH_COMMAND}"' ERR

apt install gittttt -t