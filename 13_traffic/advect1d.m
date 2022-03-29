%A demo for solving 1D advection equation
%A Gaussian bump will cycle through and come back to its original position.
%This example illustrates the CFL number, the upwind scheme and its
%diffusive nature

%Define the domain
nx=100;
x(2:nx)=linspace(0,1,nx-1);
%1 and nx will be used as ghost cells

method=5
%1: upwind
%2: downwind
%3: centered differencing
%4: Lax-Wendroff
%5: Flux limiter (Monotonized central difference or MC limiter)

%Initial condition
y0=exp(-((x-0.4)/0.1).^2);
%y0(:)=0;
%y0(5:10)=1;
previous_y=y0;

%advection speed
c=0.1;

%define time step
dx=x(3)-x(2);
dt=dx/c*0.7;

tend=50;
nt=floor(tend/dt);

for it=1:nt
  %ghost cells for periodic boundary condition
  previous_y(1)=previous_y(nx-1);
  previous_y(nx)=previous_y(2);
  if (method==5) %use flux limiter
      for i=2:nx-1
        theta(i)=(previous_y(i-1)-previous_y(i))/(previous_y(i)-previous_y(i+1));
        phi(i)=max(0,min(min((1+theta(i))/2,2),2*theta(i)));
      end
  end
  for i=2:nx-1
      switch method
          case 1,
            %upwind
            flux_in=previous_y(i-1)*c;  
            flux_out=previous_y(i)*c;
          case 2,
            %downwind
            flux_in=previous_y(i)*c;  
            flux_out=previous_y(i+1)*c;
          case 3,
            %use an average to compute the fluxes
            flux_in=(previous_y(i-1)+previous_y(i))/2*c;  
            flux_out=(previous_y(i)+previous_y(i+1))/2*c;
          case 4,
            %Lax-Wendroff
            flux_in=(previous_y(i-1)+previous_y(i))/2*c+dt/dx*c.^2/2*(previous_y(i-1)-previous_y(i));  
            flux_out=(previous_y(i)+previous_y(i+1))/2*c+dt/dx*c.^2/2*(previous_y(i)-previous_y(i+1));
          case 5,
            %MC flux limiter
            cflm=c*dt/dx;%cflm and cflp could be different for variable wave speeds.
            cflp=c*dt/dx;
            flux_in=previous_y(i-1)*c+0.5*cflm*dx/dt*(1-cflm)*phi(i-1)*(previous_y(i)-previous_y(i-1));
            flux_out=previous_y(i)*c+0.5*cflp*dx/dt*(1-cflp)*phi(i)*(previous_y(i+1)-previous_y(i));;
          otherwise,
              display('Unknown method');
      end   
            y(i)=previous_y(i)+(flux_in-flux_out)*dt/dx;
  end
  previous_y=y;
if(mod(it,floor(nt/50))==0)
  hold off;
  plot(x(2:nx-1),y(2:nx-1),'-o')
  hold on;
  plot(mod(x(2:nx-1)+c*it*dt,1),y0(2:nx-1),'r*')
  %axis([0 1 -1 1.5]);
  grid
  pause(0.2)
end
end
