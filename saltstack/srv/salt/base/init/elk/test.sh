#!/bin/bash
echo  "test salt" > /tmp/testsalt.txt
echo $1
echo $2
echo $3

if [ "$3"x = "yy"x ]
then
   echo "ok"
fi
