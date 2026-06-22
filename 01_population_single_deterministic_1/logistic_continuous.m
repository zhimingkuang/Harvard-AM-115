%% Logistic Growth Model Simulation
close all;
clear all;

% Parameters
r  = 0.5;                   % growth rate (unit: 1/time)
K  = 10;                    % Carrying capacity (unit: # of animals)
t  = linspace(0, 10, 101);  % 101 points in time spanning [0,10]

N0 = 2;                     % initial population (unit: # of animals)

% Plot settings
figure; hold on;
hK = plot([min(t) max(t)], [K K], '-k', 'LineWidth', 5);
for i = 1:10
   N0       = 2*i;
   N        = K ./ (1 + ((K-N0)/N0).*exp(-r.*t));   % solution
   hN       = plot(t, N, 'LineWidth', 1.5);
end

% Labels and annotations
xlabel('time');
ylabel('Population N(t)');
titleString = sprintf('K = %d, r = %2.1f', K, r);
title(titleString);
set(gca, 'YLim', [0 20]);
legend([hK hN], 'carrying capacity', 'N(t)');
legend boxoff;
