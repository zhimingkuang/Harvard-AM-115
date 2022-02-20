% profits and losses:
saleprofit = 20; % profit from selling one tank
lostloss = 10; % loss from losing a customer
overstockloss = .50; % cost of each tank overstock per night


a = 1/3; % probability of a customer each day
%by Sara Billey at U. Washington
days_for_delivery = 2; % days from order to delivery of new tanks
stock = 1; % number of tanks in stock
deliv = -1; % number of days until delivery of tank on order
% -1 means none on order
total_cust = 0;
total_sold = 0;
total_lost = 0;
disp(['week ' 'weekday ' 'stock ' 'customers ' 'sold ' 'lost ']);
for week = 1:104
    for weekday = 1:7
        sold = 0;
        lost = 0;
        if deliv == 0
            stock = stock+1; % a new tank is delivered
        end
        if deliv >= 0
            deliv = deliv-1; % days till next delivery
        end
        random_num = rand(1); % generate random number
        if random_num < a % use this number to tell if a customer arrived, assumes a is small
            customers = 1;
        else
            customers = 0;
        end
        if customers==1
            if stock>0 % we have a tank to sell the customer
                sold = sold+1;
                stock = stock-1;
                if deliv < 0
                    deliv = days_for_delivery; % we sold a tank and now order
                    % another one.
                end
            else
                lost = lost+1; % we didn?t have a tank and lost a customer
            end
        end % if customers==1
        % keep track of total statistics:
        total_cust = total_cust + customers;
        total_sold = total_sold + sold;
        total_lost = total_lost + lost;
        disp([week weekday stock customers sold lost]); % display results for
        % this day
    end % loop on weekday
end % loop on week
% output total statistics now....
disp(['customers ' 'sold  '  'lost']);
disp([total_cust total_sold total_lost]);