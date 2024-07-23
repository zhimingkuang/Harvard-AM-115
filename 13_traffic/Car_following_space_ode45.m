% A car following model where acceleration is based on distance from the
% car ahead
function run()
clear all

ncars=10;  %number of cars
TMAX=50;   %total integration time

%The leading car's velocity is prescribed and not part of the
%solution. Therefore, there are 2*ncars-1 unknowns: ncars positions and
%ncars-1 velocities

%initialize so that the cars are separated by a distance of 1 and moving at
%a velocity of 1
opts=odeset('RelTol',1.e-4);
sol=ode45(@(t,y) F(t,y,ncars),[0 TMAX],[(ncars:-1:1)';ones(ncars-1,1)],opts);

t=linspace(0, TMAX);
y=deval(sol,t); %evaluate (interpolate) the solution at times specified by t)

clf
subplot(3,1,1)
for i=1:ncars
    plot(t,y(1:ncars,:))
end
xlabel('Time')
ylabel('Car position');

subplot(3,1,2)
plot(t,response2Police(t));
hold on;
for i=1:ncars
    plot(t,y(ncars+1:end,:))
end
xlabel('Time')
ylabel('Velocity');

subplot(3,1,3)
for i=1:numel(t)
    plot(y(2:ncars,i),y(ncars+1:end,i),'-o')
    xlabel('Car position');
    ylabel('Velocity');
    axis([-inf inf 0. 2]);
    pause(0.1)
end

end

function dydt=F(t,y,ncars)
%reading out the position and speeds of the cars from the y vector
position(1:ncars,1)=y(1:ncars);
%leading car velocity is prescribed and not part of the solution
%leading car experiencing a velocity perturbation (passing by a police car)
speed(1,1)=response2Police(t);
%the speeds of the following cars are given by the last ncar-1 component of
%the y vector
speed(2:ncars,1)=y(ncars+1:2*ncars-1);
%acceleration depends on inter-car spacing
%assumes a normal spacing of 1
acceleration(2:ncars,1)=1*(position(1:ncars-1)-position(2:ncars)-1);
dydt=[speed;acceleration(2:ncars)];
end

%leading car experiencing a velocity perturbation (passing by a police car)
function v=response2Police(t)
v=1-0.2*t.*exp(1-t);
end