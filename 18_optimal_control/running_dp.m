% EPIDEMICS Model
  cepath='./CompEcon-master4students/';
  path([cepath 'CEtools;' cepath 'CEdemos'],path);
  fprintf('\nSOLVING THE Running PROBLEM WITH DYNAMIC PROGRAMMING\n')
  clear all  
  
% ENTER MODEL PARAMETERS
  Pmax=12;  %maximum acceleration (m/s^2)
  k=1.1;    %coefficent for the resistive acceleration (1/s)
  E0=2400;  %energy reserve at the beginning of the race (m^2/s^2) 
  sigma=40; %rate of energy resupply from oxygen intake (m^2/s^3)
  D =  2;  %distance for each interval (m)  
  T =  200;%the number of intervals to model. 
  
% DEFINE THE RANGES AND GRIDS FOR THE STATE VARIABLES
  %The spacing between grid points here affects the solution accuracy
  %so it's useful to adjust the numbers of grid points and limits of the feasibility
  %region. Of course, check your answer in the end stays within the
  %feasibility region.
  %AS WITH ALL NUMERICAL SOLUTIONS, CHECK FOR CONVERGENCE 
  
  Vmin = 0.;                            % minimum velocity (m/s)
  Vmax = 12;                            % maximum velocity(m/s)
  VN   = 20;                            % number of points for velocity
  Emin = 0.;                         % minimum energy
  Emax = 2400;                          % maximum energy
  EN   = 20;                            % number of points for energy
% CONSTRUCT ACTION SPACE
  u = [1:1:Pmax]';                      % A discrete set of controls or actions   

% PACK MODEL STRUCTURE
  clear model
  model.func = 'running_fun';              % reward/transition file
  model.discount = 1;                      % discount factor (set to 1, i.e. no discount).
  model.actions = u;                       % model actions 
  model.params = {D k sigma};               % other parameters
  model.horizon = T;
% DEFINE APPROXIMATION SPACE
  V_space=Vmin+(Vmax-Vmin)*(0:VN)'/VN;         %discretize the first state variable 
  E_space=Emin+(Emax-Emin)*(0:EN)'/EN;        %discretize the second state variable 
  fspace = fundefn([],[],[],[],[],V_space,E_space);
  scoord = funnode(fspace);	               % state collocation grid coordinates
  snodes = gridmake(scoord);			   % state collocation grid points

% SOLVE BELLMAN EQUATION  
  [c,x,J,u] = dpsolve(model,fspace,snodes);

% x is state variable (x1 is the velocity and x2 is the energy)
% J is the optimal reward of the different states at different positions
% u is the optimal control (propulsive acceleration)
% reshape them to view them as a function of x1 and x2
% value function
  J2=reshape(J,[numel(V_space),numel(E_space),size(J,2)]);
%optimal control
  u2=reshape(u,[numel(V_space),numel(E_space),size(u,3)]);
% Run the model forward with an initial condition
% If you are only changing initial condition, just run dpsimul and there is
% no need to run dpsolve again. 
  xinit = [0. E0];
  [xpath,upath] = dpsimul_discrete_action(model,xinit,T,scoord,u); %keep discrete actions
  %[xpath,upath] = dpsimul(model,xinit,T,scoord,u); %interpolate the actions
  
  position=(0:T)*D;
% PLOT OPTIMAL SOLUTION
  figure(1);
  clf
  subplot(3,1,1)
  plot(position,squeeze(xpath(1,1,:)),'-o');
  title('Velocity (m/s)');
  ylabel('V');
  set(gca,'FontSize',15)
  subplot(3,1,2)
  plot(position,squeeze(xpath(1,2,:)),'-o');
  ylabel('E');
  set(gca,'FontSize',15)
  title('Energy (m^{2}s^{-2})');
  subplot(3,1,3)
  %plot((position(1:end-1)+position(2:end))/2,upath,'-o');
  %The optimal value varies a lot due to discretization
  %so we plot the moving average
  plot((position(1:end-1)+position(2:end))/2,movmean(upath,floor(T/20)),'-o');
  title('Propulsive acceleration (ms^{-2})');
  ylabel('P');
  xlabel('Position (meters)');
  set(gca,'FontSize',15)
  
  display('Predicted World Record (seconds)')
  -J2(1,end,1) 
  %this is the optimal reward 
  %when we start with zero velocity (first index is 1)
  %and energy reserve of E0 (second index is the maximum energy storage)
  
  
