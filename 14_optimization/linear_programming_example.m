clear all;close all;
%the cup factory example (from Sara Billey)

%objective function
%x(1) is the number of beer mugs and x(2) is champaign cup
f=[-25; -20];
%The constraints
A=[[20 12];[1/15 1/15];[-1 0];[0 -1]]; 
b=[1800; 8; 0; 0];


[x,fval,flag,output,lambda] = linprog(f,A,b);

%solution
x
%maximum utility function
disp(['maximum profit ='])
disp(-fval)
%Lagrange multipliers give the shadow price
%gain in profit if the amount of supply is increased.
%gain in profit if the family is willing to work an extra hour.
lambda.ineqlin
