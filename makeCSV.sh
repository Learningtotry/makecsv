#!/bin/bash

outputFile=$(mktemp)
length=64
# TODO: add a width integer possibility

usage(){
	cat << EOF
Usage: $(basename "$0") [-f FILE] [-h] [-l INT] [-l INT -w INT]

This script makes a CSV file according to user specifications

Options:
	-h 		Display this help message
	-f FILE 	Set file to put CSV in
	-l INT		Set size of matrix, if -w is not set
	-w INT		Control width if -l is set
	-v INT		Default value to set when not counting, default is 1
	-c		Value at index is index
EOF
exit 1
}

if [[ $# -eq 0 ]]; then
	usage
	exit
fi


countFlag=false
while getopts "f:l:hcv:w:" OPT; do
	case $OPT in
		f)
		if [[ ${ $OPTARG: -3 } == ".csv" ]]; then
			break
		fi
		outputFile=$OPTARG".csv"
		;;
		l)
		length=$OPTARG
		;;
		h)
		usage
		break
		;;
		c)
		countFlag=true
		;;
		v)
		fillVal=$OPTARG
		;;
		w)
		width=$OPTARG
		;;
		*)
		break;;
	esac
done

fillVal=${fillVal:-1}

outputFile="${outputFile:?$(mktemp)}"

echo "$outputFile is outputfile"
echo "" > "$outputFile"


if $countFlag; then
	for (( i = 0; i < length; i++ )) ; do
		for (( j = 0; j < length; j++)) ; do
			k=$(( (i*length) + j ))
			printf $k >> "$outputFile"
			printf "," >> "$outputFile"
		done
		echo "" >> "$outputFile"
	done
else
	for (( i = 0; i < length; i++ )) ; do
		for (( j = 0; j < length; j++)) ; do
			k=$(( (i*length) + j ))
			printf $fillVal >> "$outputFile"
			printf "," >> "$outputFile"
		done
		echo "" >> "$outputFile"
	done;
fi



