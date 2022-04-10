% EPIDEMICS Model
  fprintf('\nSOLVING THE EPIDEMICS PROBLEM WITH DYNAMIC PROGRAMMING\n')
  clear all  
  
% ENTER MODEL PARAMETERS
  a  =  2*log(2);                          % spread rate without social distancing
  b  =  log(2);                            % recover rate
  N  =  1;                                 % Total population
  dt =  0.5;                               % time step size     
  T  =  100;                               % The number of time steps to model. Set it
                                           % based on when you think a vaccine/treatment
                                           % will be available (in T*dt weeks)
% DEFINE THE RANGES AND GRIDS FOR THE STATE VARIABLES
  %The spacing between grid points here affects the solution accuracy
  %so it's useful to adjust the numbers of grid points and limits of the feasibility
  %region. Of course, check your answer in the end stays within the
  %feasibility region.
  %AS WITH ALL NUMERICAL SOLUTIONS, CHECK FOR CONVERGENCE 
  
  Smin = 0.;                            % minimum susceptible population
  Smax = 1;                             % maximum susceptible population
  SN   = 100;                           % number of points for susceptible population
  Imin = 0.;                            % minimum infected population
  Imax = 1;                             % maximum infected population
  IN   = 1000;                          % number of points for infected population                           
% CONSTRUCT ACTION SPACE
  u = [0:0.25:1]';                         % A discrete set of controls or actions   

% PACK MODEL STRUCTURE
  clear model
  model.func = 'epidemics_fun';            % reward/transition file
  model.discount = 1;                      % discount factor (set to 1, i.e. no discount).
  model.actions = u;                       % model actions 
  model.discretestates = [1 2];                         % index of discrete states    
  model.params = {dt a b N Smin Smax Imin Imax};               % other parameters
  model.horizon = T;
% DEFINE APPROXIMATION SPACE
  S_space=Smin+(Smax-Smin)*(0:SN)'/SN;         %discretize the first state variable (susceptible population)
  I_space=Imin+(Imax-Imin)*(0:IN)'/IN;        %discretize the second state variable (infected population)
  fspace = fundefn([],[],[],[],[],S_space,I_space);
  scoord = funnode(fspace);	               % state collocation grid coordinates
  snodes = gridmake(scoord);			   % state collocation grid points

% SOLVE BELLMAN EQUATION  
  [c,x,J,u] = dpsolve(model,fspace,snodes);

% x is state variable (x1 is the susceptible and x2 is the infected population)
% J is the optimal reward of the different states at different times
% u is the optimal control (social distancing)
% reshape them to view them as a function of x1 and x2
% value function
  J2=reshape(J,[numel(S_space),numel(I_space),size(J,2)]);
%optimal control
  u2=reshape(u,[numel(S_space),numel(I_space),size(u,3)]);
% Run the model forward with an initial condition
% If you are only changing initial condition, just run dpsimul and there is
% no need to run dpsolve again. Just make sure the optimal solution is
% bound by the Susceptible_space and Infected_space that you defined
% earlier
  xinit = [0.99 0.01];
  %[xpath,upath] = dpsimul_discrete_action(model,xinit,T,scoord,u); %keep discrete actions
  [xpath,upath] = dpsimul(model,xinit,T,scoord,u); %interpolate the actions
  
  time=(0:T)*dt;
% PLOT OPTIMAL SOLUTION
  figure(1);
  clf
  subplot(3,1,1)
  plot(time,squeeze(xpath(1,1,:)),'-o');
  title('Susceptible population');
  ylabel('S');
  subplot(3,1,2)
  plot(time,squeeze(xpath(1,2,:)),'-o');
  ylabel('I');
  
  title('Infected population');
  subplot(3,1,3)
  plot((time(1:end-1)+time(2:end))/2,upath,'-o');
  title('Social distancing measure');
  ylabel('u');
  xlabel('Time (weeks)');
