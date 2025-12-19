#!/bin/bash

outputFile=$(mktemp)
length=4
countFlag=false

usage(){
	cat << EOF
Usage: $(basename "$0") [-f FILE] [-h] [-l LENGTH [-h HEIGHT]] [-v FILLVAL] [-c]

This script makes a CSV file according to user specifications. At least one option must be specified
Setting FILLVAL will override any equation given

Options:
	-f FILE 	Set file to put CSV in
	--length INT
	-l INT		Set length of matrix (default 4), if -h not set then also becomes height
	--height HEIGHT
	-h HEIGHT	Control height of CSV
	-v INT		Default value to set when not counting, default is 1
	--count
	-c		Value at index is index
	--equation	Replace at index with a valid equation
			Put in the form of "k+2" where k is the index, works with any valid Bash math expression
EOF
exit 1
}

# user must use at least one argument
if [[ $# -eq 0 ]]; then
	usage
fi

# parsing arguments
VALID_ARGS=$(getopt -o "chf:l:v:h:" --long length:,height:,count,equation: -- "$@")
eval set -- "$VALID_ARGS" # sets the args to the file
while true; do
	case "$1" in
		-f)
			if [[ "${2: -4}" == ".csv" ]]; then
				outputFile="$2";
			else
				outputFile="$2.csv";
			fi
			shift 2 ;;
		-l | --length)
			length="$2"
			shift 2	;;
		-h | --height)
			height="$2"
			shift 2	;;
		-c | --count)
			countFlag=true
			shift	;;
		-v)
			fillVal="$2"
			shift 2	;;
		--)
			shift
			break ;;
		--equation)
			myEq="$2"
			shift 2 ;;
		*)
			echo "Hitting other"
			usage	;;
	esac
done

# set values if no option specified
fillVal=${fillVal:-1}
height=${height:-$length}
outputFile="${outputFile:?$(mktemp)}"
myEq="${myEq:-k}"

echo "CSV created at $outputFile"
echo "" > "$outputFile"


for (( i = 0; i < length; i++ )) ; do
	for (( j = 0; j < height; j++)) ; do
		k=$(( (i*height) + j ))
		if $countFlag; then
			printf $k >> "$outputFile";
		elif [ -z fillVal ]; then
			printf $fillVal >> "$outputFile";
		else
			k="$(($myEq))"
			printf $k >> "$outputFile";
		fi
		printf "," >> "$outputFile"
	done
	echo "" >> "$outputFile"
done;


nano "$outputFile"
