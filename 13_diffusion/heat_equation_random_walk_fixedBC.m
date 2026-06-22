%solve the 1D heat equation

%define the number of grid points
m=21;

%Define the grid
x=linspace(-15,15,m)';

%initial condition
y0=exp(-(x/5).^2);
N=floor(y0*1.e6);

for it=1:10;
    N2=zeros(m,1);
    for i=1:numel(x);
        for particles=1:N(i)
            r=rand;
            %equal probability to go left and right
            %the boundary conditions are no flux
            if r<0.5
                if i>1
                    N2(i-1)=N2(i-1)+1;
                else %bounce back from the wall
                    N2(i)=N2(i)+1;
                end
            end
            if r>=0.5
                if i<m
                    N2(i+1)=N2(i+1)+1;
                else%bounce back from the wall
                    N2(i)=N2(i)+1;
                end
            end
        end
    end
    %now allow for enough flux so that the end points are fixed
    N2(1)=N(1);
    N2(m)=N(m);
    N=N2;
    bar(x,N2/1.e6);
    axis([-inf inf 0 1])
    pause(0.1);
end

