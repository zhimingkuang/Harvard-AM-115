%what happens to a  perturbation to car density (e.g. congestion)?
clear all;close all;

N=50; %number of cars
Tmax=60; % time of integration

%note the direction congestion propagates when we change the initial car
%density.
rho0=0.2; %initial car density is low
rho0=0.8; %initial car density is high
amp=0.1; %A smaller perturbation--> linear wave
%amp=0.5;  %A large perturbation--> nonlinear wave
rho(:,1)=rho0+amp*exp(-(((1:N)'-N/2)/5).^2);  % add the perturbation to rho
rho(find(rho>1))=1;

%initial car position
x(1,1)=0;
for i=1:N-1
    x(i+1,1)=x(i,1)+1./rho(i,1); %Inter-car spacing is the inverse of car density
end

t(1)=0;
dt=0.1;
%Forward Euler integration
for it=1:Tmax/dt
    t(it+1)=t(it)+dt; % increment the time by dt.
    u=1-rho(:,it);  % speed is given by 1-density
    
    x(end,it+1)=x(end,it)+u(end)*dt; %leading car
    rho(end,it+1)=rho(end,it); %leading car doesn't change its car density
    
    for i=N-1:-1:1
        x(i,it+1)=x(i,it)+u(i)*dt;  %update car position based on car speed
        rho(i,it+1)=1/(x(i+1,it+1)-x(i,it+1)); %update car density based on car positions
        % density(i) is 1/spacing from i to i+1.
    end
hold off
plot(x(:,it),rho(:,it),'o')
hold on;
plot(x(N/2,it),rho(N/2,it),'ro') %middle car
axis([0 N/rho0 min(rho(:,1))-0.015 max(rho(:,1))+0.015]);
%axis([0 max(x(:,1)) 0 1]);
grid on
xlabel('Car position');ylabel('Car density');
drawnow
end

figure
clf
hold on
for i=1:N
plot(x(i,:),t)
%plot(t,x(i,:))
end
%axis([50 100 -inf inf])
%axis([-inf inf 50 110])
xlabel('Car position')
ylabel('Time');
title('Car trajectories');
