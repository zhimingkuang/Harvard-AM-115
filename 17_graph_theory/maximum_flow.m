%maximum flow example from Matlab

% Create a directed graph with 6 nodes
% The first vector defines the originating vertex
% The second vector defines the end vertex
% So that each pair defines an directed edge
% And the third vector defines the maximum flow through that edge
s=[1 1 2 2 3 3 4 5]; 
t=[2 3 4 5 4 5 6 6]; 
weights=[2 3 3 1 1 1 2 3];
G=digraph(s,t,weights);
% View graph with original flows
figure(1)
H = plot(G,'EdgeLabel',G.Edges.Weight); 
set(H,'EdgeFontSize',30,'EdgeLabelColor','g')
set(H,'NodeFontSize',30)
set(H,'ArrowSize',20)

% Call the maximum flow algorithm between 1 and 6
[M,GF] = maxflow(G,1,6)
% View graph with actual flows
%H.EdgeLabel = {};
figure(2)
H = plot(G,'EdgeLabel',G.Edges.Weight); 
highlight(H,GF,'EdgeColor','r','LineWidth',2);
st = GF.Edges.EndNodes;
labeledge(H,st(:,1),st(:,2),GF.Edges.Weight);
set(H,'EdgeFontSize',30,'EdgeLabelColor','g')
set(H,'NodeFontSize',30)
set(H,'ArrowSize',20)

