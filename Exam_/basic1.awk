#!/usr/bin/awk
BEGIN{
  FS=" ";
}
{
	# Initialisation

	if(NR ==1){
		for(i=1;i<=NF;i++){
			if($i =="USER")
			{
				UserId= i;
			}
			else if($i =="PID")
			{
				ProcessId= i;
			}
			else if($i =="LWP")
			{
				ThreadId= i;
			}
			else if($i =="SZ")
			{
				MemId= i;
			}
			else if($i =="TIME")
			{
				TimeId= i;
			}
		}
	}	
	else{

		if( !Status1[ $UserId] )
		{
			Status1[ $UserId ]= 1
			Counter1+= 1
		}	

		if( !Status2[ $UserId, $ProcessId ] )
		{
			Status2[ $UserId, $ProcessId ]= 1
			Counter2[ $UserId ]+= 1
			Counter5[ $UserId ]+= $MemId
		}	

		if( !Status3[ $UserId, $ProcessId, $ThreadId ] )
		{
			Status3[ $UserId, $ProcessId, $ThreadId ]= 1
			Counter3[ $UserId ]+= 1
			
			split($TimeId, TimeArr, ":")
			TimeVal= TimeArr[1]*3600 + TimeArr[2]*60 + TimeArr[3]
			Counter4[ $UserId ]+= TimeVal
		}	
	}

}
END{
	#print UserId
	#print ProcessId
	#print ThreadId
	#print MemId
	#print TimeId

	print "Number of Users: " Counter1
	print "\n"
	for (key in Status1){
		print key
		print "Total Number of Processors: " Counter2[key]
		print "Total Number of Threads: "Counter3[key]
		print "Total CPU Consumption: "Counter4[key]
		print "Total Memory Consumption: "Counter5[key]
		print "\n"
	}
}