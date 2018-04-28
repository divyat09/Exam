a="A is not same as B"

echo $a
echo "$a"

for item in $a;
do
	echo "$item"
done

for item in "$a";
do
	echo "$item"
done
