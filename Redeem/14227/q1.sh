File=$1
DirCase=0
FileCase=0

while read -r line;
do
	if echo "${line}" | grep -q '<dir.*>'; then
        DirCase=1

    elif echo "${line}" | grep -q '</dir.*>'; then
        DirCase=0
        cd ..

	elif echo "${line}" | grep -q '<file.*>'; then
        FileCase=1

    elif echo "${line}" | grep -q '</file.*>'; then
		dd if=/dev/zero of="$Name" bs="${Size}" count=1
        FileCase=0

    elif echo "${line}" | grep -q '<name.*>'; then

	    Name=$(sed -e 's~<name>\(.*\)</name>~\1~' <<< "${line}")
	    Name=$(awk '{$1=$1;print}' <<< "${Name}" )
	    if( (( DirCase == 1 )) && ((FileCase==0)) ); then
	    	mkdir "${Name}"
	    	cd "${Name}"
	  	fi

    elif echo "${line}" | grep -q '<size.*>'; then
	  	Size=$(sed -e 's~<size>\(.*\)</size>~\1~' <<< "${line}")
	    Size=$(awk '{$1=$1;print}' <<< "${Size}" )

    fi

done < "$1"