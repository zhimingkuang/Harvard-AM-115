%Integrate the single pendulum problem for the stick-balancing problem

g=9.8;  %gravity in m/s2
L=0.1;    %length of the pendulum in meters
F=@(t,y) [y(2); -g/L*sin(y(1))]; %define the inline function

%large angle
opts=odeset('reltol',1.e-5);
[t,y]=ode45(F,[0 1],[pi-0.05; 0],opts); %start being ~3 degrees off balance
plot(t,y(:,1)*180/pi); %convert to degrees
xlabel('Time (s)');ylabel('Angle (degree)'); 

pause
%zoom in to see the time it takes to fall off by ~10 degree
%note that the average response time is ~0.3s. And it will take longer for
%us to move our arms to compensate for the motion of the stick.
axis([-inf inf 160 180])


