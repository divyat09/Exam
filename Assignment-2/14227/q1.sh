directory_read(){
  echo "$1"
  name="$1"
	
  # While providing input in this case, directory name should not end with '/'
  # To allow space in the name of directory, change IFS
  
  OIFS="$IFS"
  IFS=$'\n'
  for d in "$name"/*;
  do
    # Directory Case
    if [ -d "$d" ]; then
      directory_read $d

    # File Case
    elif [ -f "$d" ]; then

      # To check if the file is Valid i.e. it has '.c' extension
      Valid=$(find "$d" -name '*.c')  # find directory/file -name search_pattern
      if [ $Valid ]; then
        
        temp=$(awk -f q1.awk "$d")
        
        IFS=','        # space is set as delimiter
        read temp1 temp2 <<< "$temp"    # str is read into an array as tokens separated by IFS

        TotalCommentCount=$(($TotalCommentCount + $temp1))
        TotalStringCount=$(($TotalStringCount + $temp2))
      fi
    fi
  done
  IFS="$OIFS"
}

OIFS="$IFS"
IFS=$''

#find -name "* *" -type d | rename 's/ /_/g'
input="$1"
echo "$input"
directory_read "$input"

echo -ne "Total Lines of Comment: "
echo $TotalCommentCount
echo -ne "Total Strings: "
echo $TotalStringCount
