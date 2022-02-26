

%Harvard20
[U,G]=surfer('https://www.fas.harvard.edu',20)

spy(G);%visualize sparsity pattern
G=full(G);%convert from sparse matrix to full matrix
pause
pagerank(U,G);


