%illustrate the central limit theorem

%define probability for a single process
clf
s=[1/3 1/3 1/3];  %uniform distribution
% s=[1/10 2/5 1/2]; % a more weird distribution

N=40; %number of positive bins
p=zeros(2*N+1,1);
x=(1:2*N+1)-N-1;

nT=50; %number of trials

nP=50;%number of processes

for i=1:nT;
    %compute the sum of nP i.i.d processes
    v=0;
    for ip=1:nP;
        r=rand;
        if(r<s(1))
            v=v-1;
        elseif(r<s(1)+s(2));
            v=v+0;
        else
            v=v+1;
        end
    end
    if(N+1+v>0&N+1+v<2*N+1)
        p(N+1+v)=p(N+1+v)+1;
    end
end

bar(x,p/max(p));axis tight;grid on;