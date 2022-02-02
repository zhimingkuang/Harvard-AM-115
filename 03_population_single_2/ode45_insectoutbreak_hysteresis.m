%An example illustrating the definition 
%of a function for use in ode45
function ode45_insectoutbreak_hysteresis

y0=5;
K=20;
A=1;
B=1;
R=0.25;
[t,y]=ode45(@(t,y) f(t,y,K,R,A,B),[0 200],y0);
hold on;
plot(t,y,'-or')
xlabel('t');ylabel('y')
hold on;
%Define the right hand side
%K,R,A,B are the parameters in the notes (with the same names)
function ydot=f(t,y,K,R,A,B)
if(t>50&&t<100) %vary parameter R as a function of time t.
    R=1.; 
else
    R=0.25;
end
ydot=R*y*(1-y/K)-B*y^2/(A^2+y^2);
