%Truncated Poisson distribution

clf

NVec                     = 1:1:25;

lambda=[1 4 10];
linecolor=['b' 'k' 'r'];
for i=1:numel(lambda)
    pi_N = (lambda(i).^(NVec))./(factorial(NVec))./(exp(lambda(i))-1);
    
    plot(NVec, pi_N/sum(pi_N), ['-o' linecolor(i)], 'LineWidth', 3);
    grid on
    hold on;
end
xlabel('N');ylabel('P(x=N)');
title('Truncated Poisson Distributions');
legend('\lambda/\mu=1','\lambda/\mu=4','\lambda/\mu=10');
