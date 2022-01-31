%An example illustrating the definition 
%of a function for use in ode45
function ode_function

y0=1;
r=-1;

[t,y]=ode45(@(t,y) f(t,y,r),[0 5],y0);
close all
plot(t,y,'-o')
xlabel('t');ylabel('y')

function ydot=f(t,y,r)
ydot=r*y^2;
