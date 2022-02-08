function do_all=sheep_rabbit
% plot phase portrait of predator-prey models used in APM115
% based on Mesterton-Gibbons
% (arrows over phase plane):

close all; clear all; 

% quiver of version 1: Inter-species competition
% ---------------
N=20;
x1=0; x2=5.0; dx=(x2-x1)/N;
y1=0; y2=5.0; dy=(y2-y1)/N;
dimx=length(x1:dx:x2);
dimy=length(y1:dy:y2);
u= zeros(dimx,dimy);
v=zeros(dimx,dimy);
[x,y] = meshgrid(x1:dx:x2,y1:dy:y2);

a1=4;
b1=2;
a2=3;
b2=1;
for i=1:dimx; for j=1:dimy
    X=[x(i,j) y(i,j)]; t=0;
    U=rhs1(t,X,a1,a2,b1,b2);
    u(i,j)=U(1); v(i,j)=U(2);
end; end
quiver(x,y,u,v,2.0)
h1=title('Version 1');
h2=xlabel('Rabbit');
h3=ylabel('Sheep');
set([gca,h1,h2,h3],'fontsize',18)
axis([x1 x2 y1 y2]);axis tight;
pause
hold on;

% phase space trajectory of version 1:
% -------------------------------
tspan=[0 10];
X0=[2 1]
[T X]=ode23s(@(t,X) rhs1(t,X,a1,a2,b1,b2),tspan,X0);
size(X)
plot(X(:,1),X(:,2),'k')
axis([x1 x2 y1 y2]);
pause

tspan=[0 10];
X0=[3 3];
[T,X] = ode23s(@(t,X) rhs1(t,X,a1,a2,b1,b2),tspan,X0);
plot(X(:,1),X(:,2),'r')
axis([x1 x2 y1 y2]);
pause

tspan=[0 10];
X0=[3 1.7];
[T,X] = ode23s(@(t,X) rhs1(t,X,a1,a2,b1,b2),tspan,X0);
plot(X(:,1),X(:,2),'g')
axis([x1 x2 y1 y2]);
pause
%Eventually one goes to extinct, the other goes to infinity.
% ========================================================================
figure
% quiver of version 2: add some intra-species competition
% ---------------
N=20;
x1=0; x2=4.0; dx=(x2-x1)/N;
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
c1=3;
c2=3;
for i=1:dimx; for j=1:dimy
    X=[x(i,j) y(i,j)]; t=0;
    U=rhs2(t,X,a1,a2,b1,b2,c1,c2);
    u(i,j)=U(1); v(i,j)=U(2);
end; end
plot([0 4],a1/b1-c1/b1*[0 4],'k')
hold on
plot(a2/b2-c2/b2*[0 4],[0 4],'r')
legend('dx/dt=0','dy/dt=0')
axis([0 4 0 4]);
quiver(x,y,u,v,1.0)
h1=title('Version 2 (with carrying capacity)');
h2=xlabel('Rabbit');
h3=ylabel('Sheep');
set([gca,h1,h2,h3],'fontsize',18)

pause
hold on;

% phase space trajectory:
% -------------------------------
tspan=[0 20];
X0=[3 3];
[T,X] = ode23s(@(t,X) rhs2(t,X,a1,a2,b1,b2,c1,c2),tspan,X0);
plot(X(:,1),X(:,2))
pause

% ========================================================================
figure
%another example with different parameters
% quiver of version 2:
% ---------------
N=20;
x1=0; x2=4.0; dx=(x2-x1)/N;
y1=0; y2=4.0; dy=(y2-y1)/N;
dimx=length(x1:dx:x2);
dimy=length(y1:dy:y2);
u=zeros(dimx,dimy);
v=zeros(dimx,dimy);
[x,y] = meshgrid(x1:dx:x2,y1:dy:y2);

a1=3;
b1=2;
a2=2;
b2=1;
c1=1;
c2=1;
for i=1:dimx; for j=1:dimy
    X=[x(i,j) y(i,j)]; t=0;
    U=rhs2(t,X,a1,a2,b1,b2,c1,c2);
    u(i,j)=U(1); v(i,j)=U(2);
end; end
plot([0 4],a1/b1-c1/b1*[0 4],'k')
hold on
plot(a2/b2-c2/b2*[0 4],[0 4],'r')
legend('dx/dt=0','dy/dt=0')
axis([0 4 0 4]);
quiver(x,y,u,v,1.0)
h1=title('Version 2 (a different parameter set)');
h2=xlabel('Rabbit');
h3=ylabel('Sheep');
set([gca,h1,h2,h3],'fontsize',18)

pause
hold on;

% phase space trajectory:
% -------------------------------
tspan=[0 20];
X0=[3 3];
[T,X] = ode23s(@(t,X) rhs2(t,X,a1,a2,b1,b2,c1,c2),tspan,X0);
plot(X(:,1),X(:,2))
pause

function U=rhs1(t,X,a1,a2,b1,b2);
x=X(1);
y=X(2);
u=x*(a1 - b1*y);
v=y*(a2 - b2*x);
U=[u;v];

function U=rhs2(t,X,a1,a2,b1,b2,c1,c2);
x=X(1);
y=X(2);
u=x*( a1 - c1*x - b1*y);
v=y*( a2 - b2*x - c2*y);
U=[u;v];


