% Generated with Claude Code,
% Corrected and verified by Zhiming Kuang (June 28, 2026).
% Spruce Budworm Model — Level II Parameters (with T_E)
% Ludwig, Jones & Holling (1978) — extended formulation
%
% State variables:
%   B — budworm density  (larvae/acre)
%   S — branch density   (branches/acre)
%   E — foliage energy   (dimensionless, 0–1)

%% Parameters (Level II)
r_B   = 1.6;      % intrinsic budworm growth rate       (1/year)
K_B   = 200;      % max budworm density                 (larvae/branch)  [range: 100–300]
beta  = 28000;    % max budworm predation rate          (larvae/acre/year) [range: 20000–36000]
alpha = 1.5;      % half-max density for predation      (larvae/branch)  [range: 1–2]
r_S   = 0.15;     % intrinsic branch growth rate        (1/year)
K_S   = 24000;    % max branch density                  (branches/acre)
K_E   = 1.0;      % max E level                         (dimensionless)
r_E   = 1.0;      % intrinsic E growth rate             (1/year)
P     = 0.0015;   % consumption rate of E               (1/larvae)
T_E   = 0.01;     % E threshold parameter               (dimensionless)

params = [r_B, K_B, beta, alpha, r_S, K_S, K_E, r_E, P, T_E];

%% Initial conditions  [B; S; E]
y0 = [200; 20000; 0.5];

%% Time span (years)
tspan = [0, 150];

%% Solve
[t, y] = ode45(@(t, y) budworm_rhs(t, y, params), tspan, y0);

%% Plot
figure;
subplot(3,1,1)
plot(t, y(:,1), 'b', 'LineWidth', 1.5)
ylabel('B (larvae/acre)')
title('Budworm Density')
grid on

subplot(3,1,2)
plot(t, y(:,2), 'g', 'LineWidth', 1.5)
ylabel('S (branches/acre)')
title('Branch Density')
grid on

subplot(3,1,3)
plot(t, y(:,3), 'r', 'LineWidth', 1.5)
ylabel('E (dimensionless)')
title('Foliage Energy')
xlabel('Time (years)')
grid on

%% ODE right-hand side
function dydt = budworm_rhs(~, y, params)
    r_B   = params(1);
    K_B   = params(2);
    beta  = params(3);
    alpha = params(4);
    r_S   = params(5);
    K_S   = params(6);
    K_E   = params(7);
    r_E   = params(8);
    P     = params(9);
    T_E   = params(10);

    B = y(1);
    S = y(2);
    E = y(3);

    dB = r_B * B * (1 - (B / (K_B*S)) * (T_E^2 + E^2) / E^2) ...
         - beta * B^2 / ((alpha*S)^2 + B^2);
    dS = r_S * S * (1 - (S * K_E) / (E * K_S));
    dE = r_E * E * (1 - E/K_E) - P * (B/S) * E^2 / (T_E^2 + E^2);

    dydt = [dB; dS; dE];
end
