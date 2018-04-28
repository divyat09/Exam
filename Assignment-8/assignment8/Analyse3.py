import numpy as np

FileName= [ 'T_1.dat', 'T_2.dat', 'T_4.dat', 'T_8.dat', 'T_16.dat']

Time_1= {}
for file in FileName:

	Num=[]
	Time=[]
	SpeedUpOutput=[]

	f=open( file, "r" )
	Data= f.readlines()
	for line in Data:
		Num.append( int(line.split(" ")[0]) )
		Time.append( int(line.split(" ")[-2]) )

	UniqueVals= np.unique( Num )

	start=0
	for iter_ in range(0, len(UniqueVals)):

		if file== 'T_1.dat':
			temp= []
			temp.append( UniqueVals[iter_] )
			Time_1[  UniqueVals[iter_] ] = np.mean( Time[start : 100 + start ])
			temp.append( np.mean( Time[start : 100 + start ]) / Time_1[  UniqueVals[iter_] ] )
			SpeedUpOutput.append(temp)	

		else:
			temp= []
			temp.append( UniqueVals[iter_] )
			temp.append( np.mean( Time[start : 100 + start ]) / Time_1[ UniqueVals[iter_] ] )
			SpeedUpOutput.append(temp)	
			
		start= start + 100

	np.savetxt( 'D3'+file[1:], SpeedUpOutput )