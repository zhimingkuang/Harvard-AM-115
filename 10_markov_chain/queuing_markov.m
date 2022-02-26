%queuing problem

N=10000; %number of trials
nt=100; %number of time steps
p=0.05;
q=0.08;

%Simulation
state=ones(N,1);
for i=1:nt
disp(['probability=  ' num2str(hist(state,[1 2 3])/numel(state))]);
    for j=1:N
        r=rand;
        if(state(j)==1)
            if(r<p)
            state(j)=2;
            end
        elseif(state(j)==2)
            if(r<p)
                state(j)=3;
            elseif(r<p+q)
                state(j)=1;
            end
        else
            if(r<q)
                state(j)=2;
            end
        end
    end
 
end
pause
 
%eigenanalysis
A=[[1-p q 0];[p 1-p-q q];[0 p 1-q]]
[v d]=eig(A);
d
v/norm(v,1)