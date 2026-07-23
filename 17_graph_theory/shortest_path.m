   % Create a directed graph with 6 nodes and 11 edges
    s=[6 1 2 2 3 4 4 5 5 6 1];
    t=[2 6 3 5 4 1 6 3 4 3 5];
    W = [.41 .99 .51 .32 .15 .45 .38 .32 .36 .29 .21];
    %The weights need to positive
    
    DG = digraph(s,t,W);
    %the last two arguments make sure the matrix is square
    figure(1)
    H = plot(DG,'EdgeLabel',DG.Edges.Weight); 
    set(H,'EdgeFontSize',30,'EdgeLabelColor','g','LineWidth',2)
    set(H,'NodeFontSize',30)
    set(H,'ArrowSize',20)
    % Find shortest path from 1 to 6
    [path,dist] = shortestpath(DG,1,6)
    % Mark the nodes and edges of the shortest path
    highlight(H,path,'EdgeColor','r')
    
    % Solving the previous problem for an undirected graph
    G = graph(s,t,W);
    %the last two arguments make sure the matrix is square
    figure(2)
    H = plot(G,'EdgeLabel',G.Edges.Weight); 
    set(H,'EdgeFontSize',30,'EdgeLabelColor','g','LineWidth',2)
    set(H,'NodeFontSize',30)
    % Find shortest path from 1 to 6
    [path,dist] = shortestpath(G,1,6)
    % Mark the nodes and edges of the shortest path
    highlight(H,path,'EdgeColor','r')
    
    