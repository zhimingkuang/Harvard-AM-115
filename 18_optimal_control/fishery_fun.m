% fishery_fun: Function file for the fishery model
function [out,out2] = fishery_fun(flag,x,u,e,dt,a,b,R,K);
%x is the fish population
%u is the harvesting rate

%the new fish population
newx=x+(R*x.*(1-x/K)-u)*dt;
switch flag
case 'f'; % REWARD FUNCTION
    out=b*u*dt;
    %make sure the fish population is not
    %negative by setting the corresponding reward
    %to -inf
    negativeIndex=find(newx<0);
    out(negativeIndex)=-inf;
case 'g'; % STATE TRANSITION FUNCTION
  out = newx;
end
