% Simple queuing theory simulation, M/M/1 queue
% Single server, single queue:
% Adapted from notes by Sara Billey at U. Washington
a = 1; % average number of arrivals per minute
b = 1.2; % average number of people served per minute (reduce from 1.5 to 1.1 or 0.95)
ncust = 10000; %number of customers

profit_margin=0.2; %(price-cost)/cost
time_guarantee=20; %guaranteed time

%compute the average number of arrivals per minute given the time guarantee
a=customerResponse(time_guarantee);
[at,ft,st]=queuingSimulation(a,b,ncust);
%   at = arrival time of a person joining the queue
%   st = service time once they reach the front
%   ft = finish time after waiting and being served.
total_time = ft - at; % total time spent by each customer

%total profit (normalized by cost) over all customers
profit=computeProfit(time_guarantee, total_time, profit_margin); 

%compute profit (normalized by cost) per minute, which is what
%the restaurant cares about
profit_per_minute=profit/ft(end)

%Customer response to the time guarantee
function a=customerResponse(time_guarantee);
%Input: time_guarantee, If exceeded, no charge for the food
%Output: the average number of arrivals per minute given the time guarantee

    %right now it's a dummy place holder. You need replace this
    a=1; 
end

%Compute profit (normalized by cost) per minute
function profit=computeProfit(time_guarantee, total_time, profit_margin)
    profit=0;
    for i=1:numel(total_time)
        if(total_time(i)<time_guarantee)
            profit=profit+profit_margin;%making a profit
        else
            profit=profit-1; %giving out free food
        end
    end
end
%The function that simulates a M/M/1 queue
function [at,ft,st]=queuingSimulation(a,b,ncust)
%Inputs:
%   a: average number of arrivals per minute
%   b: average number of people served per minute (reduce from 1.5 to 1.1 or 0.95)
%   ncust: number of customers to simulate
%Outputs:
%   at = arrival time of a person joining the queue
%   st = service time once they reach the front
%   ft = finish time after waiting and being served.
    
    % initialize arrays:
    at = zeros(ncust,1);
    ft = zeros(ncust,1);
    % Generate random arrival times assuming Poisson process:
    r = rand(ncust,1);
    iat = -1/a * log(r); % Generate inter-arrival times, exponential distribution
    at(1) = iat(1); % Arrival time of first customer
    for i=2:ncust
        at(i) = at(i-1) + iat(i); % arrival times of other customers
    end
    % Generate random service times for each customer:
    r = rand(ncust,1);
    st = -1/b * log(r); % service time for each customer, follow an expoential distribution
    % Compute time each customer finishes:
    ft(1) = at(1)+st(1); % finish time for first customer
    for i=2:ncust
        % compute finish time for each customer as the larger of
        % arrival time plus service time (if no wait)
        % finish time of previous customer plus service time (if wait)
        ft(i) = max(at(i)+st(i), ft(i-1)+st(i));
    end
end
