function [tt,results]=simulate1D(n,nc,pt)
%this function packages the simulation steps of intializng the population
%vector and iterating the epidemic and census functions unit I=0
%the censuses are accumulated in a matrix, results
t=0;
pop=initial1D(n,0,0); %set up an intial population of susceptibles
pop(floor(n/2))='i'; %put an infected individual in the middle
[s,i,r]=census1D(pop);
results=[s,i,r]; %start the results matrix
tt=t;
while i>0
    pop=epidemic1D(nc,pt,pop);
    [s,i,r]=census1D(pop);
    results=[results;[s,i,r]];
    t=t+1;
    tt=[tt;t];
end

    