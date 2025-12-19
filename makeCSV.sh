#!/bin/bash

outputFile=$(mktemp)
length=64

while getopts "f:l:" OPT; do
	case $OPT in
		f)
		outputFile=$OPTARG".csv"
		;;
		l)
		length=$OPTARG
		;;
	esac
done

echo "$outputFile is outputfile"
echo "" > "$outputFile"
echo "asdf"


for (( i = 0; i < length; i++ )) ; do
	for (( j = 0; j < length; j++)) ; do
		k=$(( (i*length) + j ))
		printf $k >> "$outputFile"
		printf "," >> "$outputFile"
	done
	echo "" >> "$outputFile"
done

