%This code gives an example of how to read in the csv data and a template
%for the exercise of modeling running
close all;clear all;
%change this to the path for your data
datapath='./';

%read in the data
Table=readtable([datapath 'carlson_yeast_data.xls']);
time=Table.Hours;
amount=Table.Amount;

time=time(2:end);
amount=amount(2:end);
%nonlinear curve fit. The default option is least squares
beta0=[1;1]; %initial guess of the parameters. 
             %We have normalized the parameters so they are of order 1
[beta,R,J,CovB,MSE] = nlinfit(time,amount,@ode45_logistic,beta0);
%Output: 
%beta is the estimated optimal valued for the parameters
%R is residue, 
%J is the Jacobian at the optimal point
%CovB is the covariance matrix for the parameters
%MSE is the mean-square-error

%plot the fitted model and compare with data
yfit=ode45_logistic(beta,time);
figure(1)
clf
plot(time,amount,'o');
hold on;
plot(time,yfit)
display('Our work is not done!');
display('Need to test whether the residual is consistent with our assumptions')
display('use chi-square goodness of fit');
pause

%If we know the measurement precision, we can compare MSE to the expected 
%MSE to test the goodness of fit. While don't know the measurement precision here,
%we can still test if the residuals is consistent with a normal distribution with 
%the mean and standard deviation estimated from the residuals.
[h, p]=chi2gof(R,'Emin',0) %Since we don't have many data points, 
                            %set 'Emin' to zero to prevent pooling of the
                            %bins. Default of chi2gof is to use 10 bins
%

%If you know the mean (m) and standard deviation (s), use
%[h, p]=chi2gof(R,'cdf',{@normcdf,m,s},'Emin',0);
display('A more visual way with quantile quantile plot')
figure(2)
qqplot(R);
pause
display('Now look at confidence intervals')
%compute the confidence intervals for the parameters
beta
ci = nlparci(beta,R,'covar',CovB)
pause

display('There is more to the parameter uncertainties')
pause
%This is for visualizing the errors 
[b1 b2]=meshgrid((0.99:0.001:1.01),(0.99:0.001:1.01));
for i=1:size(b1,1)
    for j=1:size(b1,2)
        rmse(i,j)=norm(amount-ode45_logistic([beta(1)*b1(i,j);beta(2)*b2(i,j)],time));
    end
end
normalized_mse=rmse.^2/MSE/(numel(time)-2); 
%numel(time)-2 is the number of data points minus the number of parameters
figure(3)
clf
contourf(b1-1,b2-1,normalized_mse);colorbar;
xlabel('relative change in r');
ylabel('relative change in K');

%This information is contained in the eigenvalues and 
%eigenvectors of the covariance matrix CovB
[v d]=eig(CovB)

%-------------------------------------------------
%define the curve to be fitted as 
%a function of parameters and indepenent variable 
%-------------------------------------------------
function yfit=ode45_logistic(beta,t)
%unpack parameters
y0=9.6;     %initial yeast population, assumed to be known to simplify the plots
r=beta(1)*0.5;      %growth rate, normalized so beta is of order 1
K=beta(2)*600;      %carrying capacity, normalized so beta is of order 1
t0=0;    %initial time

%call matlab function ode45
[tout,yout]=ode45(@(t,y) f(t,y,K,r),[t0 max(t)],y0);
%interpolate data onto the measurement times
yfit=interp1(tout,yout,t);
end

%---------------------------
%define the ODE to be solved
%---------------------------
function ydot=f(t,y,K,r)
ydot=r*y*(1-y/K); %the logistic equation
end