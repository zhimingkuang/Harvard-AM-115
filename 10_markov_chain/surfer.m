function [U,G] = surfer(root,n)
% SURFER  Create the adjacency graph of a portion of the Web.
%    [U,G] = surfer(root,n) starts at the URL root and follows
%    Web links until it forms an adjacency graph with n nodes.
%    U = a cell array of n strings, the URLs of the nodes.
%    G = an n-by-n sparse matrix with G(i,j)=1 if node j is linked to node i.
%
%    Example:  [U,G] = surfer('http://www.harvard.edu',500);
%    See also PAGERANK.
%
%    This function currently has two defects.  (1) The algorithm for
%    finding links is naive.  We just look for the string 'http:'.
%    (2) An attempt to read from a URL that is accessible, but very slow,
%    might take an unacceptably long time to complete.  In some cases,
%    it may be necessary to have the operating system terminate MATLAB.
%    Key words from such URLs can be added to the skip list in surfer.m.

% Initialize

U = cell(n,1);
hash = zeros(n,1);
G = logical(sparse(n,n));
m = 1;
U{m} = root;
hash(m) = hashfun(root);

for j = 1:n
   
   % Try to open a page.

   try
      disp(['open ' num2str(j) ' ' U{j}])
      page = urlread(U{j});
   catch
      disp(['fail ' num2str(j) ' ' U{j}])
      continue
   end

   % Follow the links from the open page.

   for f = findstr('http:',page);

      % A link starts with 'http:' and ends with the next double quote.

      e = min(findstr('"',page(f:end)));
      if isempty(e), continue, end
      url = deblank(page(f:f+e-2));
      url(url<' ') = '!';   % Nonprintable characters
      if url(end) == '/', url(end) = []; end

      % Look for links that should be skipped.

      skips = {'.gif','.jpg','.pdf','.css','lmscadsi','cybernet', ...
               'search.cgi','.ram','www.w3.org', ...
               'scripts','netscape','shockwave','webex','fansonly'};
      skip = any(url=='!') | any(url=='?');
      k = 0;
      while ~skip & (k < length(skips))
         k = k+1;
         skip = ~isempty(findstr(url,skips{k}));
      end
      if skip
         if isempty(findstr(url,'.gif')) & isempty(findstr(url,'.jpg'))
            disp(['     skip ' url])
         end
         continue
      end

      % Check if page is already in url list.

      i = 0;
      for k = find(hash(1:m) == hashfun(url))';
         if isequal(U{k},url)
            i = k;
            break
         end
      end

      % Add a new url to the graph there if are fewer than n.

      if (i == 0) & (m < n)
         m = m+1;
         U{m} = url;
         hash(m) = hashfun(url);
         i = m;
      end

      % Add a new link.

      if i > 0
         disp(['     link ' int2str(i) ' ' url])
         G(i,j) = 1;
      end
   end
end


%------------------------

function h = hashfun(url)
% Almost unique numeric hash code for pages already visited.
h = length(url) + 1024*sum(url);
