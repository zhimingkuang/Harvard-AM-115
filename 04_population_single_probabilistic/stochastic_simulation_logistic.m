
% simulation of the stochastic logistic equations.
% For APM 115, based on "modelling biological populations in space
% and time, Eric Renshaw.

close all; clear all

% set parameters for logistic equation: X_t=R*X*(1-X/K)
R                        = 1.0;
K                        = 50;
dimP                     = K*10; % number of points at which pdf is defined.  Needs to be larger than carrying capacity:

%corresponding birth-death probability
%see lecture notes for the mapping
mu                       = R/K;
lambda                   = R*(1-(1/K));
 
% simulate the stochastic logistic equation, using section 3.4.
nsteps              = 2500;
N                   = zeros(nsteps, 1);
N(1)                = 3;

t                   = 1;
dt                  = 1.e-3;
%Think about what happens if dt is too large. And why?
while (t<nsteps) && (N(t)>0)
    r=rand(1);
  if (r<lambda*N(t)*dt)
    N(t+1) = N(t)+1;
  elseif (r<(lambda*N(t)+mu*N(t)*(N(t)-1))*dt)
    N(t+1)= N(t)-1;
  else
    N(t+1)=N(t);
  end
  
  t = t+1;
end

figure;

plot(N, '-r'); %an example of the time series
ylabel('N(t)');
xlabel('time steps');
title('stochastic simulation');

