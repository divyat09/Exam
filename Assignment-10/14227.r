# Part 1
Num_Samples= 50000
Rate= 0.2
X <- rexp(Num_Samples, rate=Rate)
#plot(X, xlab="Num", ylab="Samples")

# Part 2
NumRow= 500
NumCol= 100

limit <- 100
num <- 1
counter <- 1
Y_Vec <- matrix(NA, nrow=NumRow, ncol=NumCol)

for(i in 1:length(X))
{
	# print(counter)
	Y_Vec[ num, counter]= X[i]

	if( counter == limit ){
		counter <- 0
		num <- num + 1
	}
	counter <- counter + 1

}

# Part 3

for(iter1 in 1:5){
	
	# PDF PLotting
	pdata <- rep(0, 100);
	for(iter2 in 1:NumCol){
	    val=round( Y_Vec[ iter1, iter2], 0 );
	    if(val <= 100){
	       pdata[val] = pdata[val] + 1/100;
	    }
	}

	xcols <- c(0:99)
	str(pdata)
	str(xcols)
	plot(xcols, pdata, "l", xlab="Samples", ylab="PDF")

	# CDF PLotting
	cdata <- rep(0, 100)
	cdata[1] <- pdata[1]
	for(i in 2:100){
	    cdata[i] = cdata[i-1] + pdata[i]
	}
	plot(xcols, cdata, "o", col="blue", xlab="Samples", ylab="CDF");

}


Y_Mean= c()
Y_Var= c()

for(i in 1:NumRow){
	Y_Mean[i]= mean( Y_Vec[i,] ) 
	Y_Var[i]= sd( Y_Vec[i,] ) 
}

print("Mean of first 5 sample vectors")
print(Y_Mean[1:5])
print("S.D. of first 5 sample vectors")
print(Y_Var[1:5])

# Part 4

# Frequency Plotting
tab <- table(round(Y_Mean));
str(tab);
plot(tab, "h", xlab="Samples", ylab="Frequency");

# PDF PLotting
pdata <- rep(0, 100);
for(iter in 1:NumRow){
    val=round( Y_Mean[iter], 0 );
    if(val <= 100){
       pdata[val] = pdata[val] + 1/100;
    }
}

xcols <- c(0:99)
str(pdata)
str(xcols)
plot(xcols, pdata, "l", xlab="Samples", ylab="PDF");

# CDF PLotting
cdata <- rep(0, 100)
cdata[1] <- pdata[1]
for(iter in 2:100){
    cdata[iter] = cdata[iter-1] + pdata[iter]
}
plot(xcols, cdata, "o", col="blue", xlab="Samples", ylab="CDF");


# Part 5
Z_Mean= mean(Y_Mean)
Z_SD= sd(Y_Mean)

print("Mean of Z")
print(Z_Mean)
print("S.D. of Z")
print(Z_SD)

# Part 6
print("Original Distribution Mean")
print(1/Rate)
print("Original Distribution S.D.")
print( sqrt(1/(Rate*Rate)) )
