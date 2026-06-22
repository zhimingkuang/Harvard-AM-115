%solve the 1D heat equation

%define the number of grid points
m=51;

%grid spacing
dx=1;
%Define the grid
x=linspace(dx,m*dx,m)';

time_e=100; %integration time

%initial condition
y0=exp(-((x-26)/20).^2); %A broad Gaussion to illustrate fixed BC

%Define diffusivity
D=1;

%define the Laplacian operator
e1=ones(m,1); % build a vector of ones
A=spdiags([e1 -2*e1 e1],[-1 0 1],m,m); %diagonals

%assume fixed y values at boundaries
b=zeros(m,1);
b(1)=y0(1); b(end)=y0(end); 
% take to be the same as nearby initial values but doesn't have to be so

%If it is the no flux boundary condition, modify A as the follows
%Think about why.
%A(1,1)=-1;
%A(m,m)=-1;
%b(:)=0;

%-------------------------------------------
%use ode solvers for this; method of lines
%-------------------------------------------

F=@(t,y) D*(A*y+b)/dx^2;

[t y]=ode45(F,[0 time_e],y0);
for i=1:size(y,1);
    plot(x,y(i,:),'r-o');
    pause(0.01);
end


