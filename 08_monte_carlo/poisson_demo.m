%poisson process
clear all
close all
a=0.5;%average number of customers per day
N=100; %divide a day into N subintervals
Nday=1; %number of days to run
m=100000; %number of experiments
arr=zeros(N*Nday,m);

for i=1:m %loop over the different experiments
    for j=1:N*Nday %in each experiment, step forward each subinterval
        if(rand<a/N) % do the Bernoulli trial
            arr(j,i)=1; 
        end
    end
end

%total number of customers for each experiment
ncustomer=sum(arr);

%plot the histogram
maxn=max(ncustomer);
hist(ncustomer,(0:maxn))
xlabel('Total number of customers in a day')
ylabel('Number of occurrences')

pause
%theoretical distribution
numberOfArrivals(1)=0;
poissonDistribution(1)=exp(-a);
for i=2:maxn+1
    numberOfArrivals(i)=i-1;
    poissonDistribution(i)=poissonDistribution(i-1)*a/(i-1);
end
hold on;
plot(numberOfArrivals,poissonDistribution*m,'r-o','LineWidth',3);

