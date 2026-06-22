%% PINN for 1D diffusion: u_t = alpha u_xx
% based on code here:
%https://www.mathworks.com/help/deeplearning/ug/solve-partial-differential-equations-with-lbfgs-method-and-deep-learning.html
% Requires: Deep Learning Toolbox (dlnetwork, dlgradient)

clear; clc;

%% Problem setup
alpha = 1;
L = 50;
T = 100;

% Training sample sizes
Nf = 10000;   % collocation points (PDE residual)
Nb = 20;    % boundary points
Ni = 21;    % initial condition points

%% Build network u(x,t) ~ NN([x;t])
numBlocks = 8;
fcOutputSize = 20;
fcBlock = [
    fullyConnectedLayer(fcOutputSize)
    tanhLayer];

layers = [
    featureInputLayer(2)
    repmat(fcBlock,[numBlocks 1])
    fullyConnectedLayer(1)];

net = dlnetwork(layers);
net = dlupdate(@double,net);

%% Sample training points

% Collocation points in interior (0<x<L, 0<t<T)
xf = L * rand(1, Nf);
tf = T * rand(1, Nf);

% Initial condition points: t=0, x in [0,L]
xi = L*rand(1,Ni);
ti = zeros(1, Ni);
ui = exp(-((xi-25)/20).^2); %u(x,0) A broad Gaussion to illustrate fixed BC

% Boundary points: x=0 and x=L, t in [0,T]
tb = T * rand(1, Nb); %random points uniformly distributed in time [0, T]
xb0 = zeros(1, Nb);   %location of the boundary conditions for the time points, here just 0 and L
xbL = L * ones(1, Nb);

% Here we set boundary condition to stay the same as the initial values.
ub0 = exp(-((xb0-25)/20).^2);
ubL = exp(-((xbL-25)/20).^2);

% Target IC and BC
X0 = [xi xb0 xbL];
T0 = [ti tb tb];
U0 = [ui ub0 ubL];

dlX = dlarray(xf,"CB");
dlT = dlarray(tf,"CB");
dlX0 = dlarray(X0,"CB");
dlT0 = dlarray(T0,"CB");
dlU0 = dlarray(U0,"CB");


%% Training loop
solverState = lbfgsState;
maxIterations = 300;
gradientTolerance = 1e-4;
stepTolerance = 1e-4;

accfun = dlaccelerate(@modelLoss);
lossFcn = @(net) dlfeval(accfun,net,dlX,dlT,dlX0,dlT0,dlU0,alpha,L,T);

monitor = trainingProgressMonitor( ...
    Metrics="TrainingLoss", ...
    Info=["Iteration" "GradientsNorm" "StepNorm"], ...
    XLabel="Iteration");

iteration = 0;

while iteration < maxIterations && ~monitor.Stop
    iteration = iteration + 1;
    [net, solverState] = lbfgsupdate(net,lossFcn,solverState);

    updateInfo(monitor, ...
        Iteration=iteration, ...
        GradientsNorm=solverState.GradientsNorm, ...
        StepNorm=solverState.StepNorm);

    recordMetrics(monitor,iteration,TrainingLoss=solverState.Loss);

    monitor.Progress = 100*iteration/maxIterations;

    if solverState.GradientsNorm < gradientTolerance || ...
            solverState.StepNorm < stepTolerance || ...
            solverState.LineSearchStatus == "failed"
        break
    end
end

%% ---- Finite difference solution for comparison ---- 

fprintf('\n--- Computing Finite Difference Solution ---\n');

% Define the number of grid points (interior points only, following professor)
m = 49;
dx = 1;
x_fd = linspace(dx, m*dx, m)';  % x = 1, 2, ..., 49

% Initial condition on FD grid
y0 = exp(-((x_fd - 25)/20).^2);  % Broad Gaussian

% Define the Laplacian operator
e1 = ones(m,1);
A = spdiags([e1 -2*e1 e1], [-1 0 1], m, m);

% Boundary vector - fixed to initial values at boundaries
b = zeros(m,1);
b(1) = y0(1);      % left boundary value (at x=0)
b(end) = y0(end);  % right boundary value (at x=50)

% Define RHS of ODE system
F = @(t,y) alpha * (A*y + b) / dx^2;

% Solve ODE system using ode45
[t_fd, y_fd] = ode45(F, [0 T], y0);

% y_fd has size (length(t_fd), m)
% Transpose to match PINN format (space, time)
u_fd = y_fd';  % Now size (m, length(t_fd))

fprintf('Finite Difference: %d time steps, %d spatial points (interior)\n', ...
    length(t_fd), m);

%% ---- Comparison plots ----

nx = 151; 
nt = 101;

xg = linspace(0, L, nx);
tg = linspace(0, T, nt);

[X, TT] = meshgrid(xg, tg);

dlXeval = dlarray([X(:)'/L; TT(:)'/T], "CB");
uPred = predict(net, dlXeval);
uPred = reshape(gather(extractdata(uPred)), nt, nx);

% Create extended x array including boundaries for plotting FD solution
x_extended = [0; x_fd; L];

% Extend FD solution to include boundaries
u_fd_extended = zeros(length(x_extended), length(t_fd));
u_fd_extended(1, :) = b(1);       % left boundary (constant)
u_fd_extended(2:end-1, :) = u_fd; % interior points
u_fd_extended(end, :) = b(end);   % right boundary (constant)

% Find indices for the three time points in the FD solution
[~, idx_fd_t0]   = min(abs(t_fd - 0));
[~, idx_fd_tmid] = min(abs(t_fd - T/2));
[~, idx_fd_tT]   = min(abs(t_fd - T));

% Create comparison plots
figure('Position', [100, 100, 1500, 500]);

% t = 0
subplot(1, 3, 1);
plot(xg, uPred(1,:), 'k-', 'LineWidth', 2, 'DisplayName', 'PINN'); 
hold on;
plot(x_extended, u_fd_extended(:, idx_fd_t0), 'r--', 'LineWidth', 1.5, ...
    'MarkerSize', 6, 'MarkerFaceColor', 'r', 'DisplayName', 'Numerical Solution');
xlabel('x'); 
ylabel('u(x,t)');
title('t = 0');
legend('Location', 'best');
grid on; 
xlim([0, L]); 
ylim([-0.1, 1.1]);

% t = T/2
subplot(1, 3, 2);
plot(xg, uPred(round(nt/2),:), 'k-', 'LineWidth', 2, 'DisplayName', 'PINN'); 
hold on;
plot(x_extended, u_fd_extended(:, idx_fd_tmid), 'r--', 'LineWidth', 1.5, ...
    'MarkerSize', 6, 'MarkerFaceColor', 'r', 'DisplayName', 'Numerical Solution');
xlabel('x'); 
ylabel('u(x,t)');
title(sprintf('t = %.1f', T/2));
legend('Location', 'best');
grid on; 
xlim([0, L]); 
ylim([-0.1, 1.1]);

% t = T
subplot(1, 3, 3);
plot(xg, uPred(end,:), 'k-', 'LineWidth', 2, 'DisplayName', 'PINN'); 
hold on;
plot(x_extended, u_fd_extended(:, idx_fd_tT), 'r--', 'LineWidth', 1.5, ...
    'MarkerSize', 6, 'MarkerFaceColor', 'r', 'DisplayName', 'Numerical Solution');
xlabel('x'); 
ylabel('u(x,t)');
title(sprintf('t = %.1f', T));
legend('Location', 'best');
grid on; 
xlim([0, L]); 
ylim([-0.1, 1.1]);

sgtitle('1D Heat Equation: PINN vs Numerical Solution (Method of Lines)', ...
    'FontSize', 14, 'FontWeight', 'bold');

%% ---- Local functions ----
function [loss,gradients] = modelLoss(net,X,T,X0,T0,U0,alpha,Xscale,Tscale)

%scale the inputs for the neural net, which works better inputs of range [0 1]
X=X/Xscale;
T=T/Tscale;
X0=X0/Xscale;
T0=T0/Tscale;
alpha=alpha*Tscale/Xscale^2;

% Make predictions for the input points.
XT = cat(1,X,T);
U = forward(net,XT);

% Calculate derivatives with respect to X and T.
X = stripdims(X);
T = stripdims(T);
U = stripdims(U);
Ux = dljacobian(U,X,1);
Ut = dljacobian(U,T,1);

% Calculate second-order derivatives with respect to X.
Uxx = dljacobian(Ux,X,1);

% Calculate mseF. Enforce equation.
f = Ut - alpha*Uxx;
mseF = mean(f.^2,"all");

% Calculate mseU. Enforce initial and boundary conditions.
XT0 = cat(1,X0,T0);
U0Pred = forward(net,XT0);
mseU=mean((U0Pred-U0).^2,"all");
% Calculated loss to be minimized by combining errors.
loss = mseF + mseU;

% Calculate gradients with respect to the learnable parameters.
gradients = dlgradient(loss,net.Learnables);

end