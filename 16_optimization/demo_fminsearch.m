%demo fminsearch
banana = @(x)100*(x(2)-x(1)^2)^2+(1-x(1))^2;
[X,Y]=meshgrid(0:0.01:2);
Z=100*(Y-X.^2).^2+(1-X).^2;
%what's the minimum value of Z? where is it?

hold off
meshc(X,Y,Z)
hold on

[x,fval] = fminsearch(banana,[-1.2, 1])
plot3(x(1),x(2),fval,'rd','MarkerSize',15)
