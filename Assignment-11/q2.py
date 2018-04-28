import numpy as np
import matplotlib.pyplot as plt

f=open("test.csv",'r')
TestData= f.readlines()
f.close()

f=open("train.csv",'r')
TrainData= f.readlines()
f.close()

XTrain=[]
YTrain=[]
New_XTrain= []

# Step 1
TrainData= TrainData[1:]
for data in TrainData:
	data.replace("\n","")
	XTrain.append( float( data.split(",")[0] ) )
	YTrain.append( float( data.split(",")[1] ) )

for data in XTrain:
	temp=[]
	temp.append(1)
	temp.append(data)
	New_XTrain.append(temp)

XTrain= np.array(XTrain)
New_XTrain= np.array( New_XTrain )
YTrain= np.array( YTrain )

# Step 2
w=np.random.rand(2)

# Step 3
plt.ion()
plt.figure(1)

plt.title("Using w: Step 3")
plt.scatter( XTrain, YTrain )
plt.plot( XTrain, w[0]+XTrain*w[1], 'r' )
plt.show()
plt.pause(2)

# Step 4
w_direct= np.linalg.inv( np.matmul( np.transpose( New_XTrain ), New_XTrain ) )
w_direct= np.matmul( w_direct, np.matmul( np.transpose( New_XTrain), YTrain ) )

plt.clf()
plt.title("Using w_direct: Step 4")
plt.scatter( XTrain, YTrain )
plt.plot( XTrain, w_direct[0]+XTrain*w_direct[1],'r' )
plt.draw()
plt.pause(4)

# Step 5
eta=0.00000001
n_train= len(YTrain)
N=2
Count=0

for nepoch in range(0,N):
	for j in range(0, n_train):

		gradient=  ( YTrain[j] - np.matmul( New_XTrain[j] , w ))*New_XTrain[j]
		w= w + eta*gradient

		if j%100==0:

			plt.clf()
			plt.title("Using w: Step 5: Iter_" + str(Count))
			plt.scatter( XTrain, YTrain )
			plt.plot( XTrain, w[0]+XTrain*w[1],'r' )
			plt.pause(0.3)
			plt.draw()
			Count += 1

# print w
# print w_direct

# Step 6
plt.clf()
plt.title("Using w: Step 6")
plt.scatter( XTrain, YTrain )
plt.plot( XTrain, w[0]+XTrain*w[1],'r' )
plt.draw()
plt.pause(2)

#Step7
f=open("test.csv",'r')
TestData= f.readlines()
f.close()

XTest=[]
YTest=[]

TestData= TestData[1:]
for data in TrainData:
	temp=[]
	data.replace("\n","")
	temp.append(1)
	temp.append(float( data.split(",")[0] ))
	
	XTest.append( temp )
	YTest.append( float( data.split(",")[1] ) )

XTest= np.array( XTest )
YTest= np.array( YTest )

Y_Pred_1= np.matmul(XTest, w)
print('RMSE: Using W: ', np.sqrt(np.mean( (YTest - Y_Pred_1)**2) ))

Y_Pred_2= np.matmul(XTest, w_direct)
print('RMSE: Usign W_Direct: ', np.sqrt(np.mean( (YTest - Y_Pred_2)**2) ))
