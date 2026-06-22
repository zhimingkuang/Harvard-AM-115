close all;
%read in the data
fileID=fopen('us_census_data.csv');
data=textscan(fileID,'%d %f','HeaderLines',3,'Delimiter',',');

figure
plot(data{1},data{2},'-o','LineWidth',5)
xlabel('Year');ylabel('Population (millions)');
axis([-inf inf 0 350]);grid on;
title('US population with time');
set(gca,'FontSize',18)

year=data{1}; % year of the census
pop=data{2};  % population in millions

%compute annual per capita growth rate with centered difference
annual_growth_rate=(pop(3:end)-pop(1:end-2))./pop(2:end-1)/20;

figure
plot(year(2:end-1),annual_growth_rate,'-o','LineWidth',5);
xlabel('Year');ylabel('Annual per capita growth rate');
axis([-inf inf 0 0.04]);grid on;
title('Annual growth rate with time');
set(gca,'FontSize',18)

figure
plot(pop(2:end-1),annual_growth_rate,'-o','LineWidth',5);
xlabel('Popluation (millions)');ylabel('Annual per capita growth rate');
axis([-inf inf 0 0.04]);grid on;
title('Annual growth rate against population');
set(gca,'FontSize',18)
