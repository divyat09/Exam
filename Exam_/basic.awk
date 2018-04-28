BEGIN{
	FS=",";
	ConnectionCounter=1;
    Reverse=0;
}

{
	# This prints total number of records and total number of fields
	#print NF;
	#print NR;

	# Take care to start the index from 1
	#for(i=1;i<=NF;i++){
	#	print $i, " "
	#}
	#print "\n"

	split( $1, a, " ");
	split( $NR, Len, " ");
	split( a[5], temp , ":" )

	# Indexing in awk arrays starts from 1.
	DataLen= Len[2];

	Reverse= 0;
	if( Map[ a[3], temp[1] ] ){
		_iter= Map[ a[3], temp[1] ];
	} 
	else if( Map[ temp[1], a[3] ] ){
		_iter= Map[ a[3], temp[1] ];
		Reverse= 1;
	}
	else{
	  	Map[ a[3], temp[1] ]= ConnectionCounter;
	  	_iter= ConnectionCounter;
  		ConnectionCounter= ConnectionCounter +1;

		split(a[1], TimeArr, ":")
	 	STime[_iter]= TimeArr[1]*3600 + TimeArr[2]*60 + TimeArr[3]

	}


	if(Reverse == 0){
		if( NF==8 ){
			split( $2, Arr ," " )
			split( Arr[2], Arr1, ":" )

			start= Arr1[1];
			end= Arr1[2];

			if(end){

			      if( SeqR[_iter, Arr[2]] ){
			        RetransF[_iter]= RetransF[_iter] + Len[2]
			      }
			      else{
			        SeqR[_iter, Arr[2]]= _iter
			      }

			      DataPacketsF[_iter]= DataPacketsF[_iter] + 1      
			    }

			}

			PacketsF[_iter]= PacketsF[_iter] + 1
			BytesF[_iter]= BytesF[_iter] + Len[2] 

		}

	}

	elif(Reverse == 0){
		if( NF==8 ){
			split( $2, Arr ," " )
			split( Arr[2], Arr1, ":" )

			start= Arr1[1];
			end= Arr1[2];

			if(end){

			      if( SeqR[_iter, Arr[2]] ){
			        RetransR[_iter]= RetransR[_iter] + Len[2]
			      }
			      else{
			        SeqR[_iter, Arr[2]]= _iter
			      }

			      DataPacketsR[_iter]= DataPacketsR[_iter] + 1      
			    }

			}

			PacketsR[_iter]= PacketsR[_iter] + 1
			BytesR[_iter]= BytesR[_iter] + Len[2] 

		}

	}

SList[_iter]= a[3] 
RList[_iter]= temp[1]

split(a[1], TimeArr, ":")
CTime[_iter]= TimeArr[1]*3600 + TimeArr[2]*60 + TimeArr[3]


}

END{
	
}