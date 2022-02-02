%compute the temperature tendency of the planet in Kelvin/seconds
%given the solar constant S0 (in Watts per meter^2), global mean surface temperature T (in Kelvin),
%and an assumed heat capacity defined within the function
function F=climate_temperature_tendency(T,S0)

%define other parameters in the function, 
sigma=5.67e-8; %Stephan-Boltzmann constant
H=1.e8; %use a heat capacity of 10^8 Joules/Kelvin
%using loop to define albedo for an array of T
%for i=1:numel(T)
%    if(T(i)>273)
%        albedo(i)=0.3;
%    elseif(T(i)>=263)
%        albedo(i)=0.3*(1+(273.-T(i))/10);
%    else
%        albedo(i)=0.6;
%    end
%end
%alternative, shorter way to define the albedo
albedo=max(min(0.6,0.3*(1+(273-T)/10)),0.3);
F=((1-albedo)*S0/4-sigma*T.^4)/H;
end