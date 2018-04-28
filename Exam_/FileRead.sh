while read -r line;
do
	str1="$line"
done < "$1"

while read -r line;
do
	str2="$line"
done < "$2"

echo $str1
echo $str2


for thread in $str2
do

	for num in $str1
	do
		for ((iter=0;iter<100;iter++))
		do
			#echo $num $thread
		done 	
	done
done
