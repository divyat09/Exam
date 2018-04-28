TrainData= csvread('train.csv');
TestData= csvread('test.csv');

size(TrainData)
TrainData(1,:)=[];
size(TrainData)

size(TestData)
TestData(1,:)=[];
size(TestData)

NTrain= length(TrainData);
NTest= length(TestData);

XTrain= zeros(NTrain,1);
YTrain=zeros(NTrain,1);
New_XTrain= zeros(NTrain,2);

% Step 1

for i=1:NTrain
	XTrain(i)= TrainData(i,1);
	YTrain(i)= TrainData(i,2);
endfor

New_XTrain(:, 1)= 1;
New_XTrain(:, 2)= XTrain;

% Step 2
w= rand(2,1);

% Step 3
figure(1);
hold on;
scatter( XTrain, YTrain );
plot( XTrain, w(1) + XTrain*w(2), 'r' );
title('Using w: Step 3');
hold off;

% Step 4
w_direct= inv( New_XTrain' * New_XTrain);
w_direct= w_direct * New_XTrain' * YTrain;

figure(2);
hold on;
scatter( XTrain, YTrain );
plot( XTrain, w_direct(1) + XTrain*w_direct(2), 'r' );
title('Using w direct: Step 4')
hold off;

% Step 5
eta=0.00000001;
N=2;
Count=0;

for nepoch=1:N
	disp('Here')
	for j=1:NTrain
		gradient=  ( YTrain(j) - New_XTrain(j) * w ) * New_XTrain(j);
		w= w + eta*gradient;

		if mod(j,100)==0
            
                figure(j);
                hold on;
		title('Using w: Step 5: Iter');
		scatter( XTrain, YTrain );
		plot( XTrain, w(1) + XTrain*w(2), 'r' );
		Count += 1;
		hold off;
        endif
	endfor
endfor

% Step 6
figure(3)
hold on;
scatter( XTrain, YTrain );
plot( XTrain, w(1) + XTrain*w(2), 'r' );
title('Using w: Step 6');
hold off;

% Step 7

XTest= zeros(NTest,1);
YTest=zeros(NTest,1);
New_XTest= zeros(NTest,2);

for i=1:NTest
	XTest(i)= TestData(i,1);
	YTest(i)= TestData(i,2);
endfor

New_XTest(:, 1)= 1;
New_XTest(:, 2)= XTest;

Y_Pred_1= New_XTest * w;
disp( sqrt( mean( (YTest - Y_Pred_1).^2) ));

Y_Pred_2= New_XTest * w_direct;
disp( sqrt( mean( (YTest - Y_Pred_2).^2) ));
