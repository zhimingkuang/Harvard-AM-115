function [s,i,r]=census1D(pop)
%counts the number of s, i and r cells in pop
s=0;
i=0;
r=0;
n=length(pop(1,:));  %pop is a 1 by n array 
for j=1:n
    if pop(j)=='s'
        s=s+1;
    elseif pop(j)=='i'
        i=i+1;
    elseif pop(j)=='r'
        r=r+1;
    end
end