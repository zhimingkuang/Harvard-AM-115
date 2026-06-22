%A script that illustrates Euler's method
lambda=-1;

%lambda=-1+1i; %a complex number case

%define time span
t0=0; tend=1;

%set initial condition
y0=1;

%timestep
dt=0.25; 

%the number of timesteps (no adaptive timesteps yet)
nt=round((tend-t0)/dt+realmin);

%initialize
clear y t;
y(1)=y0;
t(1)=t0;

%Euler's method
for i=1:nt;
    t(i+1)=t(i)+dt;
    y(i+1)=y(i)+dt*lambda*y(i);    
end

%exact solution
nt_exact=100;
t_exact=(1:nt_exact+1)*(tend-t0)/nt_exact+t0;
y_exact=y0*exp(lambda*t_exact);

figure(1)
set(0,'DefaultAxesfontsize',20);
set(0,'Defaultlinelinewidth',1.2);
hold off
h1=plot(t,y);xlabel('time');ylabel('y');axis([t0 tend -inf inf]);
hold on;
h2=plot(t_exact,y_exact,'r');
plot(t,y,'o');

dtratio=nt_exact/((tend-t0)/dt); %the ratio of the timestep used in computing 
                                 %the exact solution and the numerical solution

%plot exact solutions for each of the sub-intervals in the numerical solution
%using the numerical solution at the beginning of the sub-interval as the
%initial condition.
for i=2:nt
    irange=((i-1)*dtratio+1:i*dtratio);
    h3=plot(t_exact(irange),y_exact(irange)*y(i)/y0/exp(lambda*t(i)),'--');
end
%turn off legend display for this item
set(get(get(h3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
legend('Euler','Exact solution');
%alternative implementation
%legend([h1 h2],{'Euler','Exact solution'}); %select the plot handles to use in legend
