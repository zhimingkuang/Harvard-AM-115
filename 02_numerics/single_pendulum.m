%Integrate the single pendulum problem

F=@(t,y) [y(2); -sin(y(1))];

%A higher order method
%small angle
ode45(F,[0 4*pi],[0.1; 0]);

%large angle
%opts=odeset('reltol',1.e-4);%default
ode45(F,[0 20*pi],[pi-0.1; 0]);

%smaller error tolerance
opts=odeset('reltol',1.e-5);
ode45(F,[0 20*pi],[pi-0.1; 0],opts);



