import numpy as np

FileName= [ 'T_1.dat', 'T_2.dat', 'T_4.dat', 'T_8.dat', 'T_16.dat']
Time_1= {}

for file in FileName:

	Output= []
	f=open( file, "r" )
	Data= f.readlines()
	for line in Data:
		Num= int(line.split(" ")[0])
		Time= int(line.split(" ")[-2])

		temp= []
		temp.append(Num)
		temp.append(Time)
		Output.append(temp)
	
	np.savetxt( 'D1'+file[1:], Output )
