%Buffon's needle 

N=1.e7;
hit=0;
for i=1:N
D=rand/2;
theta=rand*pi; %we cheat when doing this with a computer 
               %but you don't need to know pi when you drop an actual needle
if(D<=0.5*sin(theta))
    hit=hit+1;
end
end
2*N/hit
