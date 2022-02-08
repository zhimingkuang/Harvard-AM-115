%------------------------------------------------------------------------
%This code fits the yeast data to the logistic equation.
%It gives an example of how to read in the csv data 
%and provides a template for the exercise of modeling running
%------------------------------------------------------------------------
close all;clear all;
%change this to the path for your data
datapath='./';

%read in the data from the Carlson 1913 paper
Table=readtable([datapath 'carlson_yeast_data.xls']);
time=Table.Hours;
amount=Table.Amount;

%For simplicity, we shall assume the initial yeast amount is precisely
%known (it is hard-coded in ode45_logistic as the initial condition).
%Therefore, the actual data to be fitted are the second point and beyond.
time=time(2:end);
amount=amount(2:end);

%Nonlinear curve fit. Use the default option, which is unweighted least squares
beta0=[1;1]; %initial guess of the parameters r and K. 
             %We have normalized the parameters so they are of order 1
[beta,R,J,CovB,MSE] = nlinfit(time,amount,@ode45_logistic,beta0);
%Outputs: 
%beta is the estimated optimal values for the parameters
%R is the residual, 
%J is the Jacobian at the optimal point
%CovB is the covariance matrix for the parameters
%MSE is the mean-squared-error

%plot the fitted model and compare with data
yfit=ode45_logistic(beta,time);
figure(1)
clf
plot(time,amount,'o');
hold on;
plot(time,yfit)
xlabel('hours');
ylabel('Yeast amount');

disp('Our work is not done!');
disp('Need to test whether the residual is consistent with our assumptions')
pause

disp('Residual Analysis');
disp('First, plot the residue');
figure(2)
clf
plot(time,R,'-o');xlabel('hours');ylabel('Residual');
pause

disp('Next, check autocorrelation');
figure(3)
clf
autocorr(R)
pause

disp('Now, test for heteroscedasticity');
%use the ARCH test by R. F. Engle
%It assumes no autocorrelation
[hARCH, pARCH]=archtest(R)
%hARCH=0 means we cannot reject the null hypothesis 
%that there is no heteroscedasticity.
%pARCH is the p-value. A smaller p-value indicates greater confidence in
%rejecting the null hypothesis.

%--------Extra note----------------------------------------------
%If the residual has significant autocorrelation or heteroscedasticity,
%the parameter estimates are still unbiased 
%but the uncertainty estimates are unreliable. 
%In this case, try generalized least squares, which accounts for the noise 
%(or innovation) covariance matrix, which is no longer just the identity matrix
%multiplied by a scalar. It is however not easy to get an accurate estimate
%of the noise covariance.
%----------------------------------------------------------------

disp('Now, test the assumption of normal distribution');
disp('A visual way with quantile-quantile plot')
figure(4)
qqplot(R);
pause


disp('A more quantitative way with chi-square goodness of fit test');
%If we know the measurement precision, we can compare MSE to the expected 
%MSE to test the goodness of fit. While we don't know the measurement precision here,
%we can still test if the residuals are consistent with a normal distribution with 
%the mean and standard deviation estimated from the residuals.
[h, p]=chi2gof(R,'Emin',0) %Since we don't have many data points, 
                            %set 'Emin' to zero to prevent pooling of the
                            %bins. Default of chi2gof is to use 10 bins
%h=0 means we cannot reject the null hypothesis 
%that R is drawn from a normal distribution with 
%the mean and standard deviation estimated from the residuals.
%p is the p-value. A smaller p-value indicates greater confidence in
%rejecting the null hypothesis.
%If you know the mean (m) and standard deviation (s), use
%[h, p]=chi2gof(R,'cdf',{@normcdf,m,s},'Emin',0);
pause

%--------Extra note----------------------------------------------
%Our dataset is quite small, and it is probably better to use
%the Lilliefors test, designed for small datasets disp('A more quantitative way with lillietest')
%[hNorm,pNorm] = lillietest(R)
%Lilliefors, H. W. “On the Kolmogorov-Smirnov test for normality with mean and variance unknown.” 
%Journal of the American Statistical Association. Vol. 62, 1967, pp. 399–402.lillietest is designed for small datasets. 
%-----------------------------------------------------------
disp('Now look at confidence intervals:')
disp('Optimal values');
beta
%compute the confidence intervals for the parameters
%Nonlinear regression parameter confidence intervals
disp('95% confidence intervals');
ci = nlparci(beta,R,'covar',CovB)
pause

disp('There is more to the parameter uncertainties')
%----------------------------------------
disp('More information is contained in the eigenvalues and eigenvectors of the covariance matrix CovB');
[v d]=eig(CovB)
pause

%---Code to visualize the errors-------
[b1 b2]=meshgrid((0.99:0.001:1.01),(0.99:0.001:1.01));
for i=1:size(b1,1)
    for j=1:size(b1,2)
        rmse(i,j)=norm(amount-ode45_logistic([beta(1)*b1(i,j);beta(2)*b2(i,j)],time));
    end
end
normalized_mse=rmse.^2/MSE/(numel(time)-2); 
%numel(time)-2 is the number of data points minus the number of parameters
figure(5)
clf
contourf(b1-1,b2-1,normalized_mse);colorbar;
xlabel('relative change in r');
ylabel('relative change in K');
title('Normalized Root Mean Square Error');
pause

disp('The Jacobian describes how the parameters affect data (linearized around the optimal values');
%In this case, we can reason a priori that noise shouldn't be
%corrected with the effect of r or K on the yeast population, but we can
%nontheless confirm that this is indeed the case.
figure(6)
plot(time,J,'-o');
xlabel('hours'),ylabel('yeast amount')
legend('Effect of r','Effect of K');
title('The Jacobian');
disp('Examine the multicollinearity')
corr(J)

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