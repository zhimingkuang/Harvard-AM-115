%This code gives an example of how to read in the csv data and a template
%for the workshop

%change this to the path for your data
datapath='./';

%read in the state ID and state population
PopulationTable=readtable([datapath 'US_states_population.csv']);

%choose a state
stateid=544

rowindex=find(PopulationTable.LocationID==stateid); %find the corresponding row
PopulationTable.StateName(rowindex) %state name
N=PopulationTable.Population(rowindex); %total state population

%Read in daily infection, mobility and mask use
%using a function at the end of this file.
%You could choose to copy and paste that function into a separate file
dailyinfection=read_covid_data([datapath 'daily_infections.csv'],stateid);
mobility=read_covid_data([datapath 'mobility.csv'],stateid);
mask=read_covid_data([datapath 'mask_use.csv'],stateid);

%synchronize the timetables so they line up in time
data=synchronize(dailyinfection,mobility, mask);

%select the time range for the analysis
%the datasets contain data after 2020-09-21 but those are projections at
%the time the paper was written.
TR = timerange('2020-02-01','2020-09-21');
data=data(TR,:);
ft=data.Var2_dailyinfection; %This is the f(t) in Eq. 2 in the handout
%---------get your ODE solution of S, I1 etc. then compute beta----

%-----------------------------------------------------------------------
%At this point, you should have estimate beta as a function of
%time. You can check your values against mine in betas_zhiming.csv
%-----------------------------------------------------------------------
%-----start the fit from March 11, 2020
%beta estimated very early in the pandemic may be subject to 
%large uncertainties, as imported cases may be important compared to
%community spread
mask=data.Var2_mask(40:end);
mobility=data.Var2_mobility(40:end);

%Read the data for a given state
function data=read_covid_data(filename,stateid)
%read in the data as a table
T=readtable(filename);
rows=T.location_id==stateid;
stateT=table(T.date(rows,:), T.mean(rows,:));
%Turn into a time table
data = table2timetable( stateT, 'RowTimes','Var1');
return, data
end
