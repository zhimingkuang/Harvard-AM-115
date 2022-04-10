   % Create a directed graph with 6 nodes and 11 edges
    
    W = [.41 .99 .51 .32 .15 .45 .38 .32 .36 .29 .21];
    %The weights need to positive
    
    DG = sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],W,6,6)
    %the last two arguments make sure the matrix is square
    h = view(biograph(DG,[],'ShowWeights','on'))
    % Find shortest path from 1 to 6
    [dist,path,pred] = graphshortestpath(DG,1,6)
    % Mark the nodes and edges of the shortest path
    set(h.Nodes(path),'Color',[1 0.4 0.4])
    edges = getedgesbynodeid(h,get(h.Nodes(path),'ID'));
    set(edges,'LineColor',[1 0 0])
    set(edges,'LineWidth',1.5)

    % Solving the previous problem for an undirected graph
    UG = tril(DG + DG') %lower triagular part of DG+DG'
    h = view(biograph(UG,[],'ShowArrows','off','ShowWeights','on'))
    % Find the shortest path between node 1 and 6
    [dist,path,pred] = graphshortestpath(UG,1,6,'directed',false)
    % Mark the nodes and edges of the shortest path
    set(h.Nodes(path),'Color',[1 0.4 0.4])
    fowEdges = getedgesbynodeid(h,get(h.Nodes(path),'ID'));
    revEdges = getedgesbynodeid(h,get(h.Nodes(fliplr(path)),'ID'));
    edges = [fowEdges;revEdges];
    set(edges,'LineColor',[1 0 0])
    set(edges,'LineWidth',1.5)
