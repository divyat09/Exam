directory_read(){
	name="$1"
	
	for d in "$name"/*;
        do
		if [[ -d "$d"  ]]; then
			directory_read "$d"		
			echo -n $IntCount
			echo -n " "
			echo -n $LinCount
			echo ""

        elif [[ -f "$d" ]]; then
        	L1=$(grep -oE '?' "$d" | wc -l)
			L2=$(grep -oE '!' "$d" | wc -l)
			L3=$(grep -oE '\.' "$d" | wc -l)
			F=$(grep -oE '\.[0-9]' "$d" | wc -l)

			temp=0
			temp=$(($L1+$L2))
			temp=$(($temp+$L3))
			temp=$(($temp-$F))
			echo "temp"
			echo $temp
			LinCount=$(($LinCount+$temp))				
			I=$(grep -oE '[,\s\b!?][0-9]+[,!? \s\b]' "$d" | wc -l)
			IntCount=$(($IntCount+$I))
        fi
	done
}

input="$1"
directory_read "$input"