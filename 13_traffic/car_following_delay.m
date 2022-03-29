%use dde23 to integrate the delay traffic equations
%One can explore the bahavior for different values of response lag delta 
%and reaction strength (lambda)

function doall=traffic()

N=20;      %number of cars after the first
delta=ones(N,1)*0.5;   %driver response delay time
lambda = 1; %reaction strength

TMAX=30;   %total integration time

%solve the system using dde23, the delayed ode solver
opts=ddeset('reltol',1.e-5);
sol=dde23(@(t,y,Z) traffic_eq(t,y,Z,lambda),delta,@(t) traffic_hist(t,N),[0,TMAX],opts);

%plot results. plot each car offset by 1, which is the distance between
%them for the way we've chosen constants. assume the car has length
%zero.
figure(1)
clf
hold on
for j=1:N
    plot(sol.x,sol.y(j,:),'k')
end
xlabel('time')
ylabel('car position')

figure(2)
clf
hold on
for j=1:N
    plot(sol.x,sol.y(j,:)-sol.x,'k')
end
grid on
xlabel('time')
ylabel('car displacement')

figure(3)
clf
hold on
plot(sol.x,sol.yp)
xlabel('time')
ylabel('car velocity')

%History of car positions
%Given the input time t, it will give a vector storing the poistions of the cars
function s=traffic_hist(t,N)
%equal spacing of 1 with a velocity of 1
s = (N:-1:1)+t;

%Compute the current car velocity based on past history of car spacing
%i.e. compute the current acceleration based on past history of velocity
%difference
function dydt=traffic_eq(t,y,Z,lambda)
%the elements of Z are values of y for the different lags. One lag per column. 
ylag=diag(Z);

%define the output as a column vector
dydt=zeros(2,1);
%leading car experiencing a velocity perturbation
%from e.g. passing by a police car
dydt(1)=1-0.2*t*exp(1-t);

%car speed depends on car spacing (ie. acceleration depends on velocity
%difference
for j=2:numel(ylag)
    dydt(j)=lambda*(ylag(j-1)-ylag(j));
end



