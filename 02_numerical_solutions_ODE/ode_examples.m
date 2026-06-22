F=@(t,y) 0; ode45(F,[0 10],1)
F=@(t,y) t; ode45(F,[0 10],1)
F=@(t,y) y; ode45(F,[0 10],1)
F=@(t,y) -y; ode45(F,[0 10],1)

F=@(t,y) -sin(t); ode45(F,[0 10],1)

%set options
opts=odeset('RelTol',1.e-6);
F=@(t,y) -sin(t); ode45(F,[0 10],1,opts)
