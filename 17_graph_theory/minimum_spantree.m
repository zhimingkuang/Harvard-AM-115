%from Matlab    
% Create an undirected graph with 6 nodes
s=[1 1 2 2 3 4 4 5 5 6 6];
t=[2 6 3 5 4 1 6 3 4 2 5];
W = [.41 .29 .51 .32 .50 .45 .38 .32 .36 .29 .21];
G=graph(s,t,W); %undirected graph
H = plot(G,'EdgeLabel',G.Edges.Weight); 
set(H,'EdgeFontSize',30,'EdgeLabelColor','g','LineWidth',2)
set(H,'NodeFontSize',30)
   
[ST,pred] = minspantree(G) %pred(i) is the predecessor node of node i
highlight(H,ST,'EdgeColor','r')
    