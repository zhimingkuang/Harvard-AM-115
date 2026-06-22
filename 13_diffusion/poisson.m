
%solve a Poisson problem with boundary values set to zero.

%===================================================
%A 1D Possion, i.e. an ODE 
m=5; %size of the problem
e1=ones(m,1); % build a vector of ones
A=spdiags([e1 -2*e1 e1],[-1 0 1],m,m); %build the Laplacian matrix with diagonals
f=ones(m,1);
%b=randn(m,1);
u=A\f;

%---------problems with periodic boundary condition
A(1,m)=1; A(m,1)=1; % periodic boundary condition
u=A\f;

%pindown the value at one point
A(m,1)=0;A(m,m-1)=0;A(m,m)=1;
f(m,1)=0; %this sets u(m)=0
u=A\f;

%===================================================
%A 2D Poisson problem
m=50; %size of the problem
%m=5; %a smaller test problem

%define the domain with a build-in Matlab function 
%D=numgrid('S',m);
%D=numgrid('L',2*m+1);
D=numgrid('A',2*m+1);

%produce the Laplacian matrix (can be messy to generate yourself)
A=-delsq(D);

b=ones(size(A,1),1); %source term, boundary values are set to zero
u=A\b;

%convert the vector to the domain shape
subs=find(D>0); %points where the domain is defined)
U=D;
U(subs)=u(D(subs));
contour(U); %plot the results

%-------------------------------------------
%How you may define your own domain
h=0.2;
[x, y]=meshgrid(-1:h:1);
xv = [-0.5 -0.5   0   0  1  1 -1 -1 -0.5];
yv = [  0  -0.5 -0.5 -1 -1  1  1  0 0];
[in, on]=inregion(x,y,xv,yv);
p=find(in-on);
n=length(p);
L=zeros(size(x));
L(p)=1:n;
%--------------------------------------

%Poisson solver with FFT for problems with periodic boundaries

Lx=20;Ly=20; %size of the domain

nx=128;ny=128; %number of grid points in each direction

%construct the domain mesh 
x2=linspace(-Lx/2,Lx/2,nx+1); x=x2(1:nx); %x-values
y2=linspace(-Ly/2,Ly/2,ny+1); y=y2(1:ny); %y-values
[X,Y]=meshgrid(x,y); 

%the source (right hand side of the Poisson equation)
omega=exp(-X.^2-Y.^2); %generate 2D Gaussian
%compute x and y wavenumbers
kx=(2*pi/Lx)*[0:nx/2-1 -nx/2:-1];
ky=(2*pi/Ly)*[0:ny/2-1 -ny/2:-1];
%set the undetermined constant (zero wavenumber) to zero

kx(1)=1.e-6;ky(1)=1.e-6; 
[KX,KY]=meshgrid(kx,ky); %2D wavenumbers

%now solve the PDE in one line!
psi=real(ifft2(-fft2(omega)./(KX.^2+KY.^2))); %solution



