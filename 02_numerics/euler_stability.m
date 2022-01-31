%A script that illustrates the stability of Euler's method
lambda=-1+5i;

%define time span
t0=0; tend=20;

%set initial condition
y0=1;

%timestep
dt=0.1;
%dt=1.; 
%dt=0.03;

%the number of timesteps (no adaptive timesteps yet)
nt=round((tend-t0)/dt+1.e-6);

%initialize
clear y t y_b_euler;
t(1)=t0; %First time
y(1)=y0; %Initialize forward Euler Solution
y_b_euler(1)=y0; %Initialize backward Euler Solution

%Euler's method
for i=1:nt;
    t(i+1)=t(i)+dt;
    y(i+1)=y(i)+dt*lambda*y(i);    %Forward Euler
    y_b_euler(i+1)=y_b_euler(i)/(1-dt*lambda);    %Backward Euler
end

%exact solution
nt_exact=10000;
t_exact=(1:nt_exact+1)*(tend-t0)/nt_exact+t0;
y_exact=y0*exp(lambda*t_exact);

%plotting the results
figure(1)
set(0,'DefaultAxesfontsize',20);
set(0,'Defaultlinelinewidth',1.2);
hold off
plot(t_exact,real(y_exact),'r');
xlabel('time');ylabel('y');axis([t0 tend -inf inf]);

pause

hold on;
plot(t,real(y_b_euler),'g-o');
legend('Exact solution','Backward Euler' );

pause

plot(t,real(y),'-o');
legend('Exact solution','Backward Euler','Forward Euler' );
