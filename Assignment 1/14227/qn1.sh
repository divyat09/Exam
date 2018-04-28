#!/bin/bash

convert_crore_digit(){
	num=$1
	fac=10000000

	if [[ $((num/fac)) -ge 1000 ]];
	then
		convert_thousand_digit $((num/fac))
	elif [[ $((num/fac)) -ge 100 ]];
	then
		convert_hundred_digit $((num/fac))
	elif [[ $((num/fac)) -ge 10 ]];
	then
		convert_tens_digit $((num/fac))
	else
		convert_ones_digit $((num/fac))
	fi

	echo -ne "crore "
	num=$1
	fac=10000000
	convert_lakh_digit $((num%fac))

}

convert_lakh_digit(){
	num=$1
	fac=100000

	if [[ $((num/fac)) -ge 10 ]];
	then
		convert_tens_digit $((num/fac))
		echo -ne "lakh "
	elif [[ $((num/fac)) -ge 1 ]];
	then
		convert_ones_digit $((num/fac))
		echo -ne "lakh "
	fi

	num=$1
	fac=100000
	convert_thousand_digit $((num%fac))
}

convert_thousand_digit(){
	num=$1
	fac=1000

	if [[ $((num/fac)) -ge 10 ]];
	then
		convert_tens_digit $((num/fac))
		echo -ne "thousand "
	elif [[ $((num/fac)) -ge 1 ]];
	then
		convert_ones_digit $((num/fac))
		echo -ne "thousand "
	fi

	num=$1
	fac=1000
	convert_hundred_digit $((num%fac))
}

convert_hundred_digit(){
	num=$1
	fac=100

	if [[ $((num/fac)) -ne 0 ]];
	then
		convert_ones_digit $((num/fac))
		echo -ne "hundred "
	fi

	num=$1
	fac=100
	convert_tens_digit $((num%fac))
}

convert_tens_special_digit(){
	num=$1
	fac=10
	case $((num%fac)) in
		0) echo -ne "ten ";;
		1) echo -ne "eleven ";;
		2) echo -ne "twelve ";;
		3) echo -ne "thirteen ";;
		4) echo -ne "fourteen ";;
		5) echo -ne "fifteen ";;
		6) echo -ne "sixteen ";;
		7) echo -ne "seventeen ";;
		8) echo -ne "eighteen ";;
		9) echo -ne "nineteen ";;
	esac
	# Nothing to write any further..no need to go to ones digit
}

convert_tens_digit(){
	num=$1
	fac=10

	if [[ $((num/fac)) -eq 1 ]];
	then
		convert_tens_special_digit $num	# Sequence of 11, 12, 13,.....
	else
		case $((num/fac)) in
			2) echo -ne "twenty ";;
			3) echo -ne "thirty ";;
			4) echo -ne "fourty ";;
			5) echo -ne "fifty ";;
			6) echo -ne "sixty ";;
			7) echo -ne "seventy ";;
			8) echo -ne "eighty ";;
			9) echo -ne "ninety ";;
		esac
		convert_ones_digit $((num%fac))	# Have to go to ones digit whenever arrive at tens digit
	fi

}

convert_ones_digit(){
	case $1 in
		1) echo -ne "one ";;
		2) echo -ne "two ";;
		3) echo -ne "three ";;
		4) echo -ne "four ";;
		5) echo -ne "five ";;
		6) echo -ne "six ";;
		7) echo -ne "seven ";;
		8) echo -ne "eight ";;
		9) echo -ne "nine ";;
	esac
	# Nothing to write any further
}

num=$1
regex='^[0-9]+$'

# Not a positive integer
if ! [[ $num =~ $regex ]];
then
	echo -ne "invalid input"
	exit -1
fi

# Remove trailing zeros by taking base 10
num=$((10#$num))

# If the number is greater than the specified case
if [[ num -gt 99999999999 ]];
then
		echo -ne "invalid input"
		exit -1
fi

if [[ num -eq 0 ]];	# Base Case
then
	echo -ne "zero"
	exit -1
fi

digits=${#num}	# Number of digits in a number

case $digits in
	1) convert_ones_digit $num;;
	2) convert_tens_digit $num;;
	3) convert_hundred_digit $num;;
	4) convert_thousand_digit $num;;
	5) convert_thousand_digit $num;;
	6) convert_lakh_digit $num;;
	7) convert_lakh_digit $num;;
	8) convert_crore_digit $num;;
	9) convert_crore_digit $num;;
	10) convert_crore_digit $num;;
	11) convert_crore_digit $num;;

esac
