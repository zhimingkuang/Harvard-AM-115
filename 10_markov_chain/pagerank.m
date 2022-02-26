function x = pagerank(U,G,p)
% pagerank.m--Google's PageRank
% pagerank(U,G,p) uses the URLs and connectivity matrix produced by
% surfer.m, together with a damping factor p, (default is .85), to compute
% and plot a bar graph of page rank, and print the dominant URLs in page
% rank order. x = pagerank(U,G,p) returns the page ranks instead of
% printing. See also surfer.m, spy.m.

if nargin < 3, p = .85; end

% Stochasticity adjustment
c = sum(G,1);
k = find(c==0);
G(:,k) = 1;

% Eliminate any self-referential links
G = G - diag(diag(G));
  
% c = out-degree, r = in-degree
[n,n] = size(G);
c = sum(G,1);
r = sum(G,2);

% Scale column sums to be 1
k = find(c);
D = sparse(k,k,1./c(k),n,n);

% Solve (I - p*G*D)*x = e
e = ones(n,1);
I = speye(n,n);
x = (I - p*G*D)\(((1-p)/n)*e);

% Normalize so that sum(x) == 1.
x = x/sum(x);

% Bar graph of page rank
shg
figure(1)
bar(x)
title('Page Rank')
axis([0 35 0 .09])

% Print URLs in page rank order.
if nargout < 1
   [ignore,q] = sort(-x);
   disp('     page-rank  in  out  url')
   k = 1;
   while (k <= n) && (x(q(k)) >= .005)
      j = q(k);
      disp(sprintf(' %3.0f %8.4f %4.0f %4.0f  %s', ...
         j,x(j),r(j),c(j),U{j}))
      k = k+1;
   end
end
