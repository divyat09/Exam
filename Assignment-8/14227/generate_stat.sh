while read -r line;
do
	while read -r line2;
	do
		str2="$line2"	
	done < "$2"

	str1="$line"
done < "$1"

echo $str1
echo $str2


for thread in $str2
do
	echo $thread
	for num in $str1
	do
		echo $num
		for ((iter=0;iter<100;iter++))
		do
			Output=$(./makeApp $num $thread)
			# Output="${Output//[!0-9]/}"
			echo $num $Output >> "T_${thread}.dat"
		done 	
	done
done
