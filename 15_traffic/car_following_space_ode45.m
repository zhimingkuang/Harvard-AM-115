% A car following model where acceleration is based on distance from the
% car ahead
function run()
clear all

ncars=10;%number of cars

%The leading car's velocity is prescribed and not part of the
%solution. Therefore, there are 2*ncars-1 unknowns: ncars positions and
%ncars-1 velocities

%initialize so that the cars are separated by a distance of 1 and moving at
%a velocity of 1
sol=ode45(@(t,y) F(t,y,ncars),[0 20],[(ncars:-1:1)';ones(ncars-1,1)]);

t=linspace(0, 20);
y=deval(sol,t);
subplot(3,1,1)
for i=1:ncars
    plot(t,y(1:ncars,:))
end
xlabel('Time')
ylabel('Car position');
subplot(3,1,2)
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
speed(1,1)=1+randn(1)*0.01;
%the speeds of the following cars are given by the last ncar-1 component of
%the y vector
speed(2:ncars,1)=y(ncars+1:2*ncars-1);

%acceleration depends on inter-car spacing
%assumes a normal spacing of 1
acceleration(2:ncars,1)=position(1:ncars-1)-position(2:ncars)-1;
dydt=[speed;acceleration(2:ncars)];
end
