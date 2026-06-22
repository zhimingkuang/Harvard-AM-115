%An example illustrating the definition 
%of a function for use in ode45
function ode45_insectoutbreak
clf

y0=5; %initial population

K=20; %carry capacity
A=1;  %parameter for the predation term (see lecture notes for details
B=1;  %parameter for the predation term (see lecture notes for details
R=0.25; %growth rate per capita without crowding

%integrate use the ode solver
[t,y]=ode45(@(t,y) f(t,y,K,R,A,B),[0 50],y0);

%plot the results
hold on;
plot(t,y,'-o')
xlabel('t');ylabel('y')
hold on;

%the following defines the function on the right hand side of the ODE to be integrated
function ydot=f(t,y,K,R,A,B)
ydot=R*y*(1-y/K)-B*y^2/(A^2+y^2);
