import numpy as np

FileName= [ 'T_1.dat', 'T_2.dat', 'T_4.dat', 'T_8.dat', 'T_16.dat']

for file in FileName:

	Num=[]
	Time=[]
	MeanOutput=[]

	f=open( file, "r" )
	Data= f.readlines()
	for line in Data:
		Num.append( int(line.split(" ")[0]) )
		Time.append( int(line.split(" ")[-2]) )

	UniqueVals= np.unique( Num )
	
	start=0
	for iter_ in range(0, len(UniqueVals)):
		temp=[]
		temp.append( UniqueVals[iter_] )
		temp.append( np.mean( Time[start : 100 + start ] ) )
		temp.append( np.std( Time[start : 100 + start ] ) )
		MeanOutput.append(temp)

		start= start + 100

	np.savetxt( 'D2'+file[1:], MeanOutput )