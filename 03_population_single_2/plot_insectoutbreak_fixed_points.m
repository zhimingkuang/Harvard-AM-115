function plot_insectoutbreak_fixed_points(r,k,color)
%Input:
%r and k are the nondimensional growth rate per capita and carrying
%capacity
%color is the color for the plot
%Output: None, but can be used to identify the non-zero fixed points

x=(0:0.01:1)*k; %a set of value for x

plot(x,insect_growth(r,k,x),color,'linewidth',2)
xlabel('x (insection population nondimensional)','FontSize',15);
ylabel('dlnx/dtau','FontSize',15);
grid on
hold on;
plot(x,x*0,'g','linewidth',2)
%non-zero fixed points are where the green line crosses the dlnx/dtau curve
end

%defines the time tendency of x
function dlnxdtau=insect_growth(r,k,x)

%note the dot before * and /, so it's .* and ./, which is how Matlab does
%element-wise multiplication and division for a vector (x in this case)
dlnxdtau=r.*(1-x/k)-x./(1+x.^2);

end