%% COVID Workshop Template
%% This code gives an example of how to read in the csv data 
%% and serves as a template for the workshop

% Set path to data folder. Change as appropriate
datapath = './';

% Read state ID and population data
PopulationTable = readtable([datapath 'US_states_population.csv']);

% Select a state by LocationID
state_id = 544;

% Find the corresponding row
row_index = find(PopulationTable.LocationID == state_id);

% Error handling: make sure state_id exists
if isempty(row_index)
    error('State ID %d not found in the population table.', state_id);
end

% Display state name and get population
state_name = PopulationTable.StateName{row_index};
fprintf('Selected State: %s\n', state_name);

N = PopulationTable.Population(row_index); % Total state population

%% Read COVID-Related Data
% Uses helper function defined at the bottom

infection = read_covid_data([datapath 'daily_infections.csv'], state_id);
mobility  = read_covid_data([datapath 'mobility.csv'], state_id);
mask_use  = read_covid_data([datapath 'mask_use.csv'], state_id);

%% Synchronize all timetables by date
data = synchronize(infection, mobility, mask_use);

%% Filter time range for analysis
% Only include data up to 2020-09-21 (after that it's projections)

analysis_range = timerange('2020-02-01', '2020-09-21');
data = data(analysis_range, :);

% Extract f(t) (from daily infections)
ft = data.Daily_mean_infection; % This corresponds to f(t) in Eq. 2 of the handout

%---------get your ODE solution of S, I1 etc. then compute beta----

%-----------------------------------------------------------------------
%At this point, you should have estimate beta as a function of
%time. You can check your values against mine in betas_zhiming.csv
%-----------------------------------------------------------------------
%-----start the fit from March 11, 2020
%beta estimated very early in the pandemic may be subject to 
%large uncertainties, as imported cases may be important compared to
%community spread
mask=data.Daily_mean_mask_use(40:end);
mobility=data.Daily_mean_mobility(40:end);

% Read the data for a given state
function data = read_covid_data(filename, state_id)
    % Read the CSV file into a table
    T = readtable(filename);
    
    % Filter rows for the given state_id
    rows = T.location_id == state_id;
    
    % Error handling in case state_id is not found
    if ~any(rows)
        error('State ID %d not found in file %s.', state_id, filename);
    end

    % Create a new table with date and mean values
    stateT = table(T.date(rows), T.mean(rows), 'VariableNames', {'Date', 'Daily_mean'});
    
    % Convert the table to a timetable using the Date column
    data = table2timetable(stateT, 'RowTimes', 'Date');
end

