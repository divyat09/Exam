#!/bin/bash

# Indentation Function
indent(){

  it=0
  while [ $it -lt $1 ];
  do
    echo -ne "   "
    it="$(($it+1))"
  done

}

# Print Function
print(){

  # if [[ $4 -eq 0 ]];
  # then
  #   echo -ne "(F) "
  # elif [[ $4 -eq 1 ]];
  # then
  #   echo -ne "(D) "
  # fi

  name=$1
  echo -ne "${name##*/}"  # Stripping ##*/ so as to only print the name of directory and not path
  echo -ne "-"
  echo -ne $2
  echo -ne "-"
  echo $3

}

# Main Function
directory_read(){

  name=$1

  for d in $name/*;
  do
    # Directory Case
    if [ -d "$d" ]; then

      # Increasing level of Identation as we go to sub_directory
      spacing="$(($spacing+1))"
      directory_read "$d" $spacing  # Recusrive Call to sub_directory

    # File Case
    elif [ -f "$d" ]; then

      # Parameter Computation
      l=$(wc -l < "$d")   # wc -l < file would not print the filename and give only the count
      a=$(grep -E -o '(^| |-|\b)[0-9]+( |$|\. |\.$)' "$d" | wc -l)
      b=$(grep -E -o '\.[0-9]+( |$|\. |\.$)' "$d" | wc -l)

      # Printing the File
      indent $spacing
      print $d $l $(($a-$b))
      # print $d $l $(($a-$b)) 0

    fi
  done

  # Parameter Computation for Directory Case
  name=$1

  a=$(grep -rE -o '(^| |-|\b)[0-9]+( |$|\. |\.$)' "$name" | wc -l)  # -rE does a recusive search among all the files
  b=$(grep -rE -o '\.[0-9]+( |$|\. |\.$)' "$name" | wc -l)
  intcount=$(($a-$b))

  lincount=0
  for f in $(find $name -type f);
  do
    lincount=$(($lincount + $(wc -l < $f)))
  done

  # Printing Directory

  spacing="$(($spacing-1))"
  indent $spacing
  print $name $lincount $intcount
  # print $name $lincount $intcount 1

}

input=$1
spacing=1
directory_read $input $spacing
