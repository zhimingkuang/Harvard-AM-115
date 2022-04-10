% SUSHI_DP Sushi Restaurant Model
% Discrete Dynamic Programming
fprintf('\nSUSHI_DP SUSHI RESTAURANT MODEL\n')
close all
%include the path to the dynamical programming library
cepath='./CompEcon-master/';
path([cepath 'CEtools;' cepath 'CEdemos'],path);

% ENTER MODEL PARAMETERS
price   = 20;                             % sushi price ($/lb) when sold
cost    = 10;                             % sushi cost ($/lb) when bought
holdcost=  2;                             % opportunity cost, cost of shelf space
%Note: if there is no holding cost, then as long as you can adjust the next
%day, there won't be waste. In that case, there are multiple optimal solutions.

T=20;                                     % how many days to run the simulation for
%Define the probability mass function of the demand (a discretiziation of
%the true probability distribution function).
demand=50+10*(-2:1:2);                    %The set of possible demand values
prob=ones(size(demand));                  %Probability mass function, assumed uniform here
%prob=[1 2 3 2 1];                          %A different PMF
prob=prob/sum(prob);                      %total probability is 1
% Construct the state space. Both states are needed to evolve the system
% and compute the profit
maxdemand=max(demand);
s1 = (0:10:maxdemand)';                   % The set of carryover from the day before
s2 = (0:10:maxdemand)';                   % The set of amounts sold in the day before
S  = gridmake(s1,s2);                     % combined state grid
n  = length(S);                           % total number of states

% Space of possible actions
purchase=(0:10:maxdemand);                % in 10-lb increments
m=numel(purchase);                        % number of actions

% Construct reward function, which is a nxm matrix in this case
f=price*S(:,2)*ones(1,m)-cost*ones(n,1)*purchase-holdcost*S(:,1)*ones(1,m);
% Construct state transition probability matrix
g = [];
for j=1:m %action
    g1=zeros(n,n); %for a particular action
    for i=1:n %state
        for k=1:numel(demand) %demand
            if(demand(k)<S(i,1)) %demand less than carryover from the day before
                carryover=purchase(j); %what you buy today will be carried over to tomorrow
                sold=demand(k); %amount sold equals demand
            elseif(demand(k)<S(i,1)+purchase(j))%demand greater than carryover 
                                                %but less than carryover+purchase
                carryover=S(i,1)+purchase(j)-demand(k);
                sold=demand(k);
            else               %demand greater than inventory 
                carryover=0;   %no carry over
                sold=S(i,1)+purchase(j);%sell all inventory
            end
            l=getindex([carryover sold],S); %find the index of the new state
            g1(i,l)=g1(i,l)+prob(k); %add the probability of this outcome to the transition matrix
        end
    end
    g=[g;g1]; %stack them up to build the full transition probability matrix
end
g=sparse(g); %the matrix is in general sparse. turn it into a sparse for more efficient computation
% Pack model structure
clear model
model.reward     = f;
model.transprob  = g;
model.discount   = 1; %infinite horizon problem requires a discount rate less than 1
model.horizon    = T;
model.vterm= price*S(:,2); %value of final state. fish tossed away so no holding cost 

% Solve the discrete dynamic programming problem
[J,u,pstar] = ddpsolve(model);
% J is the optimal reward of the different states at different times
% u is the optimal control (purchase policy)
% pstar is the optimal transition matrix
% reshape them to view them as a function of s1 and s2
% The following is an example for the first time.
itime=1; % time index
uu=reshape(u(:,itime),[numel(s1) numel(s2)]);
contourf(s1,s2,purchase(uu));colorbar
xlabel('Fish sold the day before (lb)');
ylabel('Fish carried over from the day before (lb)');
title('Optimal purchase amount (lb)');
