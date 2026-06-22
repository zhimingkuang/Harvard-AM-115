%use dde23 to integrate the delay traffic equations
%
function doall=traffic()

close all  %close all windows

tau=0.5;   %driver response delay time in second
speed=30;  %car speed in meters per second
dc=10;     % miminum spacing below which traffic stops, in meters

%----the three second rule: spacing should be car speed times 3 seconds-----
spacing=3*speed; %3 seconds rule
lamda=speed/log(spacing/dc); %model parameter for reaction strength
%calculated to be consistent with the recommended spacing-speed relation
%and our model. in m/s
%---------------------------------------------------

%----estimates using Lincoln tunnel data----
%spacing=160; %estimated from data in lincoln tunnel in m
%lamda=10; %estimated from tunnel data in m/s
%-----------------------------------------

TMAX=100;   %total integration time
N=10;      %number of cars

%solve the system using dde23, the delayed ode solver
opts=ddeset('reltol',1.e-5);
sol=dde23(@(t,y,Z) traffic_eq(t,y,Z,N,speed,lamda),tau,@(t) traffic_hist(t,N,speed,spacing),[0,TMAX],opts);

%------------
%plot results.
%-------------
%plot position of the cars as a function of time
figure(1)
clf
hold on
for j=1:N
    plot(sol.x,sol.y(j,:),'k')
end
xlabel('time (s)')
ylabel('car position (m)')
grid on

%plot car speeds as a function of time
figure(2)
clf
hold on
plot(sol.x,sol.yp(1:N,:));
xlabel('time (seconds)')
ylabel('car velocity (m/s)')
grid on

%plot car acceleration as a function of time
figure(3)
clf
hold on
plot(sol.x,sol.yp(N+1:2*N,:));
xlabel('time (seconds)')
ylabel('car acceleration (m/s2)')
grid on

%History of car positions and velocities
function s=traffic_hist(t, N, speed, spacing)
%equal spacing and constant speed
s = [(N:-1:1)'*spacing+t*speed; ones(N,1)*speed];

function dydt=traffic_eq(t,y,Z,N,speed,lamda)

%the first N elements of y (and Z) are positions
%the second N elements of y (and Z) are speeds

dydt=zeros(2*N,1);

ylag=Z(1:N,1);
vlag=Z(N+1:2*N,1);
%decceleration
g=9.8; %maximum decceleration, limit it by grarvitational acceleration
a=g/4; %maximum acceleration. This will depend on the car.
%leading car brakes

%dposition/dt is the speed
dydt(1:N)=y(N+1:2*N);
%decceleration by the first car
deccelerate=g/2;
%deccelerate until the car stops
if(t<speed/deccelerate)
    dydt(N+1)=-deccelerate; %leading car deccelerates
end
%car acceleration depends on velocity
%difference divided by spacing
%limited by the maximum decceleration and acceleration
for j=2:N
    %this is the acceleration based on the model discussed in class
    %and bound by the maximum acceleration and decceleration
    dydt(j+N)=min(a,max(-g,lamda*(vlag(j-1)-vlag(j))/(ylag(j-1)-ylag(j))));
end

