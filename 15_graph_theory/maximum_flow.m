%maximum flow example from Matlab

% Create a directed graph with 6 nodes
% The first vector defines the originating vertex
% The second vector defines the end vertex
% So that each pair defines an directed edge
% And the third vector defines the maximum flow through that edge
cm = sparse([1 1 2 2 3 3 4 5],[2 3 4 5 4 5 6 6],[2 3 3 1 1 1 2 3],6,6)

% View graph with original flows
h = view(biograph(cm,[],'ShowWeights','on'))
   
% Call the maximum flow algorithm between 1 and 6
[M,F,K] = graphmaxflow(cm,1,6)
% View graph with actual flows
view(biograph(F,[],'ShowWeights','on'))

