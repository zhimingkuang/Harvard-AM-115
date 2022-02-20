function k=Pvar(mu)
%generates a Poisson random variate with mean mu (which is our a in the
%equation)
r=rand; %uniform [0,1]
p=exp(-mu);  %p will be the Poisson probability
ptot=p;  %ptot accumulates the prob variate<=k
k=0; %the trial variate
while r>ptot
    k=k+1;
    p=p*mu/k; %probability of k+1 using the recursive relation
    ptot=ptot+p;
end
