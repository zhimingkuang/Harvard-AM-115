 %AM115 solve the vertex cover example of policing the city    
% Create an undirected graph with 9 nodes

    DG = sparse([1 1 1 2 3 3 4  5 5 6 7 9],[2 8 9 3 9 4 5 6 9 7 8 7],ones(1,12),9,9)
    UG = tril(DG + DG')
    view(biograph(UG,[],'ShowArrows','off','ShowWeights','on'))
    % solve the vertex cover problem as an integer programming problem.
    N=9; %size of the problem
    f=ones(N,1); %objective function is f*x, i.e. the sum of x
    
    %add inequality constraints
    A=0;
    k=0;
    for i=1:N
        for j=1:i-1
            if(UG(i,j)==1)
                k=k+1; %add an inequality constraint
                A(k,i)=-1;
                A(k,j)=-1;
                b(k)=-1;
            end
        end
    end
    %add binary constraints.
    intcon=1:N; %all variables must be integer
    lb=zeros(N,1);
    ub=ones(N,1); %constrain all variables to be binary
    
    %solve
    [x,fval,exitflag,output] = intlinprog(f,intcon,A,b,[],[],lb,ub)
    
    
