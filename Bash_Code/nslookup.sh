#!/bin/bash

#Read in and loop through the sweepResults file and do an nslookup

file=$1

if [ $# -eq 0 ]
    then
        echo "No Arg, please provide the file name to read";exit
fi

while IFS= read -r line;do
        var="$line"
        echo "$var" >> lookupResults.txt
        nslookup "$var" >> lookupResults.txt
done < $file
