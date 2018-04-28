#!/usr/bin/awk
BEGIN{
  FS="[\"]"
  state1=0
  StringCounter=0
  LineCommented=0
}
{
	LineCommented=0

	for(i=1; i<=NF; i++){

		if( (i%2 == 0) && (state1==0) ){

			StringCounter=  StringCounter + 1;
		}
		else{

			if( (state1==0) && (match( $i, "//" )) ){
				CommentCounter= CommentCounter + 1;
				break;
			}
			else if( (state1==0) && (match( $i, "/(*)" )) ){
				state1=1; 
				prevLine= NR;
			}

			if( (state1==1) && (match( $i, "(*)/") ) ){
				state1=0; 

				if( (NR == prevLine) && ( LineCommented==0 )){

					CommentCounter= CommentCounter + 1 + NR - prevLine
					LineCommented=1	# Already have one commented line, no need to comment same line again
				}
				else if( NR != prevLine ){

					CommentCounter= CommentCounter + 1 + NR - prevLine
					LineCommented=1
				}
			}
		}
	}

}
END{
	print CommentCounter "," StringCounter
}
