#!/usr/bin/awk
BEGIN{
 FS="="        # FS is field separator; to determine different fields in one line or record
}
{
# sepstr $0 prints the whole current line or the current record
# NR represents the line number or the record number i.e Line 1, Line 2 of the program

#   print "LN "NR " --> " $0;
   print "LN "NR sepstr $0;

# NF represents the number of fields in a record i.e. individual tokens in a line separeted by =
# sepstr $i will print the ith token in current line / record ( tokens separated by = )

   for(i=1;i<=NF;i++){
#        print i " --> " $i
        print i sepstr $i
   }
}
END{
}
