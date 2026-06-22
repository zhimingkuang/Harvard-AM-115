% running_fun: Function file for the Hill-Keller model
function [out] = running_fun(flag,x,p,e,distance,k,sigma);
%x is the state that includes velocity and energy
%p is the control, which is the propulsive acceleration to apply
%e is shock to the system (not present in this case)

%loop over all values of the state. 
for i=1:size(x,1);
    v_init=x(i,1);    %
    e_init=x(i,2);
    fun=@(dt) p(i)*dt-(v_init-p(i)/k)*(exp(-k*dt)-1)-k*distance;
    %Use zero finding to find the time to traverse the distance (Eq. 4 in the notes)
    %Bound the solution by the impossibly fast speed of 15m/s and the
    %unlikely slow speed of 0.01 m/s.
    dti=fzero(fun,[distance/15 distance/0.01]); 
    cost(i,1)=dti;
    newx(i,1)=p(i)/k+(v_init-p(i)/k)*exp(-k*dti);
    newx(i,2)=e_init+(sigma-p(i)^2/k)*dti+p(i)*(k*v_init-p(i))/k^2*(exp(-k*dti)-1);
end

switch flag
case 'f'; % REWARD FUNCTION
    out=-cost;
    %make sure the fish population is not
    %negative by setting the corresponding reward
    %to -inf
    negativeIndex=find(newx(:,1)<0|newx(:,2)<0);
    out(negativeIndex)=-inf;
case 'g'; % STATE TRANSITION FUNCTION
  out = newx;
end
