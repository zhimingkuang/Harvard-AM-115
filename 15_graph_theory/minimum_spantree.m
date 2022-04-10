%from Matlab    
% Create an undirected graph with 6 nodes
    W = [.41 .29 .51 .32 .50 .45 .38 .32 .36 .29 .21];
    DG = sparse([1 1 2 2 3 4 4 5 5 6 6],[2 6 3 5 4 1 6 3 4 2 5],W, 6,6)
    %the last two arguments make sure the matrix is square
    
    UG = tril(DG + DG')
    view(biograph(UG,[],'ShowArrows','off','ShowWeights','on'))
    % Find the minimum spanning tree of UG
    [ST,pred] = graphminspantree(UG)
    view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'))
