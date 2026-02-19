clear all; close all;

%% 3-game "World Series" Simulation
% Main script - run this section to execute examples

% Example usage:
% plot_world_series_histogram(0.5, 10000, 44);
plot_world_series_histogram(0.7, 10000, 44);
% plot_world_series_histogram(0.99, 10000, 44);
plot_likelihood(31, 44, 10000);

%% Functions

function games_won_losing_team = world_series_game(p)
    % Generate a 3-game "world series". p is the probability that the better 
    % team wins the game; the series is over after a team has won two games.
    % Returns number of games the losing team won (0 or 1).
    
    games = rand(1, 3) < p;
    
    if games(1) && games(2)  % team 1 wins first two games
        games_won_losing_team = 0;
    elseif ~games(1) && ~games(2)  % team 2 wins first two games
        games_won_losing_team = 0;
    else  % series goes to 3rd game
        games_won_losing_team = 1;
    end
end

function results = simulate_world_series(p, n_series)
    % Simulate n_series world series with probability p
    if nargin < 2
        n_series = 44;
    end
    
    results = zeros(1, n_series);
    for i = 1:n_series
        results(i) = world_series_game(p);
    end
end

function all_results = run_simulations(p, N, n_series)
    % Run n_series world series N times
    if nargin < 2
        N = 10000;
    end
    if nargin < 3
        n_series = 44;
    end
    
    all_results = zeros(1, N);
    for i = 1:N
        % number of sweeps (0s) in n_series world series
        all_results(i) = sum(simulate_world_series(p, n_series) == 0);
    end
end

function pdf = get_pdf(p, N, n_series)
    % Get PDF of number of sweeps across n_series world series for p
    if nargin < 2
        N = 10000;
    end
    if nargin < 3
        n_series = 44;
    end
    
    all_results = run_simulations(p, N, n_series);
    pdf = zeros(1, n_series + 1);
    for i = 0:n_series
        pdf(i + 1) = mean(all_results == i);  % +1 for MATLAB 1-indexing
    end
end

function L = likelihood(p, x, n_series, N)
    % Generate likelihood for p given n_series world series with x sweeps
    if nargin < 3
        n_series = 44;
    end
    if nargin < 4
        N = 10000;
    end
    
    pdf = get_pdf(p, N, n_series);
    L = pdf(x + 1);  % +1 for MATLAB 1-indexing
end

function L = likelihood_analytical(p, x, n_series)
    % Analytical likelihood calculation
    if nargin < 3
        n_series = 44;
    end
    
    % probability of sweep (losing team winning 0 games) is p^2 + (1-p)^2
    % probability of non-sweep (losing team winning 1 game) is 2*p*(1-p)
    p1 = p^2 + (1-p)^2;
    p2 = 2*p*(1-p);
    
    % nchoosek is MATLAB's "n choose k" function
    L = nchoosek(n_series, x) * (p1^x) * (p2^(n_series - x));
end

function plot_world_series_histogram(p, N, n_series)
    % Plot histogram of number of sweeps in n_series world series
    if nargin < 2
        N = 10000;
    end
    if nargin < 3
        n_series = 44;
    end
    
    all_results = run_simulations(p, N, n_series);
    
    figure;
    histogram(all_results, 'BinEdges', 0.5:(n_series + 0.5), 'Normalization', 'probability');
    hold on;
    
    mode_value = mode(all_results);
    xline(mode_value, 'r--', 'LineWidth', 2);
    
    legend(sprintf('Mode = %.1f', mode_value));
    title(sprintf('Number of 0 games won by losing team in %d world series\nN=%d, p=%.2f', n_series, N, p));
    ylabel('Probability');
    xlabel(sprintf('x (number of 0 games won by losing team in %d world series)', n_series));
    hold off;
end

function plot_likelihood(x, n_series, N)
    % Plot likelihood of p given n_series world series with x sweeps
    if nargin < 2
        n_series = 44;
    end
    if nargin < 3
        N = 10000;
    end
    
    ps = linspace(0.5, 1, 51);
    likelihoods = zeros(size(ps));
    likelihoods_analytical = zeros(size(ps));
    
    tic;
    for i = 1:length(ps)
        likelihoods(i) = likelihood(ps(i), x, n_series, N);
        likelihoods_analytical(i) = likelihood_analytical(ps(i), x, n_series);
    end
    elapsed = toc;
    fprintf('Elapsed time: %.2f seconds\n', elapsed);
    
    figure;
    plot(ps, likelihoods, 'LineWidth', 1.5);
    hold on;
    
    % Plot analytical likelihood
    plot(ps, likelihoods_analytical, '--', 'LineWidth', 1.5, 'DisplayName', 'Analytical Likelihood');
    
    % Draw line where likelihood is maximized
    [~, max_idx] = max(likelihoods);
    p_mle = ps(max_idx);
    xline(p_mle, 'r--', 'LineWidth', 2);
    
    legend('MC Likelihood', 'Analytical Likelihood', sprintf('MLE from MC: p = %.2f', p_mle));
    title(sprintf('Likelihood: probability of world series with %d 0s (games won by losing team), given p', x));
    xlabel('p (probability better team wins game)');
    ylabel('Likelihood');
    hold off;
end