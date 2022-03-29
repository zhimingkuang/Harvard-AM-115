clear all;close all;
%amounts of goods or commodity bundle

%initial guess
x0(1,1)=1; %1 math book
x0(2,1)=1; %1 unit of food

%utility function
u=@(x) -x(1)*x(2);

%cost c=A*x;
A=[2 1]; %1 book costs $2 and 1 unit of food costs $1
b=5; %total budget
%our constraint is Ax<b

[x,fval,flag,output,lambda] = fmincon(u,x0,A,b);

%solution
x
%maximum utility function
disp(['maximum utility function ='])
disp(-u(x))
%Lagrange multiplier
lambda
