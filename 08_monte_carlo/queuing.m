% Simple queuing theory simulation, M/M/1 queue
% Single server, single queue:
% Adapted from notes by Sara Billey at U. Washington

a = 1; % average number of arrivals per minute
b = 1.5; % average number of people served per minute (reduce from 1.5 to 1.1 or 0.95)
ncust = 10000; %number of customers
% Notation:
% at = arrival time of a person joining the queue
% st = service time once they reach the front
% ft = finish time after waiting and being served.
%
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

total_time = ft - at; % total time spent by each customer
wait_time = total_time - st; % time spent waiting before being served
ave_service_time = sum(st)/ncust
ave_wait_time = sum(wait_time)/ncust
ave_total_time = sum(total_time)/ncust


% Plot histogram of waiting times:
clf
subplot(2,1,1)
hist(total_time,0.25:.5:floor(max(total_time))+0.25);axis tight;
ylabel('# of occurrence');
xlabel('Total time spent (minutes))');
subplot(2,1,2)
plot(at,total_time)
xlabel('Customer arrival time (minutes)');
ylabel('Total time spent');
