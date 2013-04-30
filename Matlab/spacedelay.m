function [ out ] = spacedelay( in, space )
%spacedelay Adds and increasing amount of zeros to each col
%   First col gets no zeros added. The second col gets 'space' number of
%   zeros added to it. The third col, space*2 zeros added. Zeros are added
%   to the end of each col to fix the matrix dimensions. If no argument for
%   space is input, default space is 1.
if (nargin < 2)  ||  isempty(space)
        space = 1;
end

in = in';
[m,n] = size(in);
z = m * space;
out = [in zeros(m,z)];
out = reshape(out',1,(n+z)*m);
out = out(1:m*(z+n-space));
out = reshape(out,n+z-space,m);
end

