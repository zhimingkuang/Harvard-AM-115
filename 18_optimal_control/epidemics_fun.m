% epidemics_fun: Function file for the epidemic model
function [out] = epidemics_fun(flag,x,u,e,dt,a,b,N,Smin,Smax,Imin,Imax);
%x(:,1) is the susceptible population
%x(:,2) is the infected population
%u is the social distancing policy 

%describe the effect of social distancing on the spread rate
%you should consider other behaviors.
modified_a=a*(1-u);
NewInfectionRate=modified_a.*x(:,1).*x(:,2)/N;
NewS=x(:,1)-dt*NewInfectionRate;
NewI=x(:,2)+dt*(NewInfectionRate-b*x(:,2));
switch flag
case 'f'; % REWARD FUNCTION
    %Cost to the economy per unit time. You should consider other behaviors.
    %However, there should be no cost with zero control (no social distancing)
    EconomicCost=0.02*u;
    %Cost to health and human life per unit time
    HumanCost=NewInfectionRate;
    out = -(EconomicCost+HumanCost)*dt;
    %make sure the state variables are within bound
    %by setting the out-of-bound reward to -inf
    negativeIndex=find(NewS<Smin|NewS>Smax|NewI<Imin|NewI>Imax);
    out(negativeIndex)=-Inf;
case 'g'; % STATE TRANSITION FUNCTION
    out(:,1) = NewS;
    out(:,2) = NewI;
end


