#!/bin/bash

COURSE="DevOps From Current Script"

echo "Before calling Current script, Course: $COURSE"
echo "Process ID of current script: $$"

./16.Other-Script.sh

echo "With Source Command"
source ./16.Other-Script.sh

echo "After calling other script, Course: $COURSE"