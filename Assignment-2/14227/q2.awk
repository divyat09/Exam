#!/usr/bin/awk
BEGIN{
  FS=",";
  ConnectionCounter=1;
  Reverse=0;
}
{


split($NF, ByteArr, " " ) # Splitting to get number value of length out from whole string
split($1, a, " ") # Splits the first field into array a using space as splitter
split(a[5],temp, ":" )  # Spilts to remove : at end and get real value of B


#print $1  # The first field that contains ID:PORT of Sender and Receiver 
#print $NF # The last field of a line: Contains the length of data transmitted
# Indexing starts from 1 here for array a
#print a[1]  # Contains Timestamp of transmisson
#print a[3]  # Contains IP of A
#print a[5]  # Contains IP of B

Reverse=0;

if( Map[ a[3], temp[1] ] ){
  _iter= Map[ a[3], temp[1] ];
} 

else if( Map[ temp[1], a[3] ] ){
 _iter= Map[  temp[1], a[3] ];
 Reverse=1;
}

else{
  Map[ a[3], temp[1] ]= ConnectionCounter;

  _iter= ConnectionCounter;
  ConnectionCounter= ConnectionCounter +1;
  
  split(a[1], TimeArr, ":")
  STime[_iter]= TimeArr[1]*3600 + TimeArr[2]*60 + TimeArr[3]

}
      
if( Reverse==0 ){

  if(NF==8){

    split($2, SeqArr, " ")  # To obtain the Sequence assigned to Data Transfer
    split(SeqArr[2], SeqRange ,":")

    _start= SeqRange[1]
    _end= SeqRange[2]

    StartF[_iter]= _iter 
    EndF[_iter]= _iter 

    # We consider as succesful data packet where we have Sequence start:end like 312.312:312.3123
    # and if there is no end like 31.3123. then its invalid
    if( _end ){

      #If the current Sequence is already present in previous Sequences stored in SeqF
      if( SeqR[_iter, SeqArr[2]] ){
        RetransF[_iter]= RetransF[_iter] + ByteArr[2]
      }
      else{
        SeqR[_iter, SeqArr[2]]= _iter
      }

      DataPacketsF[_iter]= DataPacketsF[_iter] + 1      
    }
  }

  PacketsF[_iter]= PacketsF[_iter] + 1
  BytesF[_iter]= BytesF[_iter] + ByteArr[2]  

}

else if( Reverse==1 ){

  if(NF==8){

    split($2, SeqArr, " ")  # To obtain the Sequence assigned to Data Transfer
    split(SeqArr[2], SeqRange ,":")

    _start=SeqRange[1]
    _end= SeqRange[2]

    StartR[_iter]= _iter 
    EndR[_iter]= _iter 


    # We consider as succesful data packet where we have Sequence start:end like 312.312:312.3123
    # and if there is no end like 31.3123. then its invalid
    if( _end ){
      
      # If the current Sequence is already present in previous Sequences stored in SeqR
      if( SeqR[_iter, SeqArr[2]] ){
        RetransR[_iter]= RetransR[_iter] + ByteArr[2]
      }
      else{
        SeqR[_iter, SeqArr[2]]= _iter
      }

      DataPacketsR[_iter]= DataPacketsR[_iter] + 1
    }
  }

  PacketsR[_iter]= PacketsR[_iter] + 1
  BytesR[_iter]= BytesR[_iter] + ByteArr[2]  

}

SList[_iter]= a[3] 
RList[_iter]= temp[1]

split(a[1], TimeArr, ":")
CTime[_iter]= TimeArr[1]*3600 + TimeArr[2]*60 + TimeArr[3]


}
END{

  for( _iter=1; _iter<ConnectionCounter; _iter=_iter+1 ){
    
    if(!DataPacketsR[_iter]){
      DataPacketsR[_iter]=0;
    }

    if(!RetransR[_iter] ){
      RetransR[_iter]=0;
    }

    if(!RetransF[_iter] ){
      RetransF[_iter]=0;
    }

    print "Connection (A=" SList[_iter] " B=" RList[_iter] ")"
    print "A-->B #packets= " PacketsF[_iter] ", #datapackets= " DataPacketsF[_iter] ", #bytes= " BytesF[_iter] ", #retrans= " RetransF[_iter] ", xput=" (BytesF[_iter] - RetransF[_iter] )/(CTime[_iter]-STime[_iter]) " bytes/sec"
    print "B-->A #packets= " PacketsR[_iter] ", #datapackets= " DataPacketsR[_iter] ", #bytes= " BytesR[_iter] ", #retrans= " RetransR[_iter] ", xput=" (BytesR[_iter] )/(CTime[_iter]-STime[_iter]) " bytes/sec"    
  }

}
