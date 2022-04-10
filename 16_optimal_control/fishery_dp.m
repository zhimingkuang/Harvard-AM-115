% Fishery Model
  fprintf('\nSOLVING THE FISHERY PROBLEM\n')
 % close all  
  
% ENTER MODEL PARAMETERS
  valueFishInLake =  0.75;                  % Value of fish in the lake
  valueFishCaught =  1.;                    % Value of fish caught
  R  =  0.02;                               % growth rate per capita
  K  =  1000;                               % carrying capacity
  T  =  1000;                               % the number of time steps to model
  dt =  1/5;                                % time step size     

% CONSTRUCT ACTION SPACE
  u = [0:2:10]';                            % A discrete set of controls or actions   

% PACK MODEL STRUCTURE
  clear model
  model.func = 'fishery_fun';               % reward/transition file
  model.discount = 1;                       % discount factor (set to 1, i.e. no discount).
  model.actions = u;                        % model actions 
  model.params = {dt valueFishInLake valueFishCaught R K};                  % other parameters
  model.horizon = T;
% DEFINE APPROXIMATION SPACE
  n      = 5000;                            % degree of approximation
  fspace = fundefn('lin',n,0,K);            % function space
  snodes = funnode(fspace);                 % state collocaton nodes
% INITIALIZE POLICY, VALUE, PRICE FUNCTIONS
  vterm = valueFishInLake*snodes;           % post-terminal value function

% SOLVE BELLMAN EQUATION  
% s is fish stock 
% J is the optimal reward of the different fish stocks at different times
% u is the optimal harvesting rate
  [c,s,J,u] = dpsolve(model,fspace,snodes,vterm);

% Run the model forward with an initial condition
% If you are only changing initial condition, just run dpsimul and there is
% no need to run dpsolve again.
  sinit = 150; %initial fish population
  %[spath,xpath] = dpsimul(model,sinit,T,s,u);
  [spath,xpath] = dpsimul_discrete_action(model,sinit,T,s,u);
  
  time=(0:T)*dt;
% PLOT VALUE FUNCTION
  figure(1);
  contourf(time,s,J);colorbar
  title('Value Function');
  xlabel('Time');
  ylabel('Fish population');

  figure(2);
% PLOT state trajectory
  subplot(2,1,1)
  plot(time,spath,'-o');
  title('state trajectory');
  ylabel('Fish population');
% PLOT control trajectory
  subplot(2,1,2)
  plot((time(1:end-1)+time(2:end))/2,xpath,'-o');
  title('control trajectory');
  xlabel('Time');
  ylabel('Harvesting rate');
   
% PLOT SHADOW PRICE FUNCTION
  %how much extra value is there with an extra unit of fish at time t
  figure(3);
  p = funeval(c,fspace,s,1);
  contourf(time,s,p);colorbar
  title('Shadow Price Function (Marginal Value)');
  xlabel('Time');
  ylabel('Fish population');
 
