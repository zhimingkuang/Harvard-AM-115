%flame propagation
%dy/dt=y^2-y^3
delta=0.0001; %initial condition
F=@(t,y) y^2-y^3; 
opts=odeset('RelTol',1.e-4);
figure
ode45(F,[0 4/delta],delta,opts);
pause
figure
ode23s(F,[0 4/delta],delta,opts);

 