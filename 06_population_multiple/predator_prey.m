function do_all=predator_prey
% plot phase portrait of predator-prey models used in APM115
% based on Mesterton-Gibbons
% (arrows over phase plane):

close all; clear all; 


% quiver of 4.72:
% ---------------
N=40;
x1=1; x2=5.0; dx=(x2-x1)/N;
y1=0; y2=4.0; dy=(y2-y1)/N;
dimx=length(x1:dx:x2);
dimy=length(y1:dy:y2);
u=zeros(dimx,dimy);
v=zeros(dimx,dimy);
[x,y] = meshgrid(x1:dx:x2,y1:dy:y2);

a1=4;
b1=2;
a2=3;
b2=1;
epsilon=1/30;
for i=1:dimx; for j=1:dimy
    X=[x(i,j) y(i,j)]; t=0;
    U=rhs472(t,X,a1,a2,b1,b2);
    u(i,j)=U(1); v(i,j)=U(2);
end; end
quiver(x,y,u,v,2.0)
h1=title('4.72');
h2=xlabel('prey');
h3=ylabel('predator');
set([gca,h1,h2,h3],'fontsize',18)
pause
hold on;

% phase space trajectory of 4.72:
% -------------------------------
tspan=[0:0.01:10];
X0=[2 2];
[T,X] = ode45(@(t,X) rhs472(t,X,a1,a2,b1,b2),tspan,X0);
plot(X(:,1),X(:,2),'b')
pause

tspan=[0:0.01:10];
X0=[3 3];
[T,X] = ode45(@(t,X) rhs472(t,X,a1,a2,b1,b2),tspan,X0);
plot(X(:,1),X(:,2),'r')
pause

tspan=[0:0.01:10];
X0=[3 1.7];
[T,X] = ode45(@(t,X) rhs472(t,X,a1,a2,b1,b2),tspan,X0);
plot(X(:,1),X(:,2),'g')
pause

% ========================================================================
figure
% quiver of 4.74:
% ---------------
N=40;
x1=1; x2=5.0; dx=(x2-x1)/N;
y1=0; y2=4.0; dy=(y2-y1)/N;
dimx=length(x1:dx:x2);
dimy=length(y1:dy:y2);
u=zeros(dimx,dimy);
v=zeros(dimx,dimy);
[x,y] = meshgrid(x1:dx:x2,y1:dy:y2);

a1=4;
b1=2;
a2=3;
b2=1;
epsilon=1/30;
for i=1:dimx; for j=1:dimy
    X=[x(i,j) y(i,j)]; t=0;
    U=rhs474(t,X,a1,a2,b1,b2,epsilon);
    u(i,j)=U(1); v(i,j)=U(2);
end; end
quiver(x,y,u,v,2.0)
h1=title('4.74');
h2=xlabel('prey');
h3=ylabel('predator');
set([gca,h1,h2,h3],'fontsize',18)
pause
hold on;

% phase space trajectory of 4.74:
% -------------------------------
tspan=[0:0.01:20];
X0=[3 3];
[T,X] = ode45(@(t,X) rhs474(t,X,a1,a2,b1,b2,epsilon),tspan,X0);
plot(X(:,1),X(:,2))
pause

% ========================================================================

figure
% quiver of 10.24 and 10.26:
% --------------------------
N=40;
x1=1; x2=20.0; dx=(x2-x1)/N;
y1=3; y2=15.0; dy=(y2-y1)/N;
dimx=length(x1:dx:x2);
dimy=length(y1:dy:y2);
u=zeros(dimx,dimy);
v=zeros(dimx,dimy);
[x,y] = meshgrid(x1:dx:x2,y1:dy:y2);

lambda=5;
mu=0.15;
theta=10;
a2=1; % equivalent to rescaling y
K=30; % carying capacity of prey w/o predator
% using the non dim parameters that are specified in the textbook to
% calculate the dimensional parameters:
c1=sqrt(theta*mu*a2*K); % from multiplying theta & mu eqns
a1=lambda*a2;
b1=theta*a2/c1;
for i=1:dimx; for j=1:dimy
    X=[x(i,j) y(i,j)]; t=0;
    U=rhs1024_1026(t,X,a1,a2,b1,b2,c1,K,epsilon);
    u(i,j)=U(1); v(i,j)=U(2);
end; end
quiver(x,y,u,v,2.0)
h1=title('10.24 and 10.26');
h2=xlabel('prey');
h3=ylabel('predator');
set([gca,h1,h2,h3],'fontsize',18)
pause
hold on;

% phase space trajectories of 10.24 and 10.26:
% -------------------------------------------

tspan=[0:0.01:50];
X0=[3 3];
[T,X] = ode45(@(t,X) rhs1024_1026(t,X,a1,a2,b1,b2,c1,K,epsilon),tspan,X0);
M=length(X(:,1));
% plot only the limit cycle (by starting after the time series
% converged to it):
plot(X(floor(M/2):M,1),X(floor(M/2):M,2))
hold on
pause
% plot trajectory spiraling in into the limit cycle:
plot(X(1:floor(M/5),1),X(1:floor(M/5),2),'r')
pause
% integrate and plot trajectory spiraling out to the limit cycle:
tspan=[0:0.01:20];
X0=[7 7];
[T,X] = ode45(@(t,X) rhs1024_1026(t,X,a1,a2,b1,b2,c1,K,epsilon),tspan,X0);
M=length(X(:,1));
plot(X(:,1),X(:,2),'g')

function U=rhs472(t,X,a1,a2,b1,b2);
x=X(1);
y=X(2);
u=x*( a1 - b1*y);
v=y*(-a2 + b2*x);
U=[u;v];

function U=rhs474(t,X,a1,a2,b1,b2,epsilon);
x=X(1);
y=X(2);
u=x*( a1*(1-epsilon*x) - b1*y);
v=y*(-a2 + b2*x);
U=[u;v];

function U=rhs1024_1026(t,X,a1,a2,b1,b2,c1,K,epsilon);
x=X(1);
y=X(2);
u=x*(a1*(1-x/K)-b1*c1*y/(b1*x+c1));
v=a2*y*(1-y/(b2*x));
U=[u;v];

