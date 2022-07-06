function [ data,ffmax,ffmin ] = minmax(data,varargin)
if nargin==2||nargin>3
    ME = MException('QVDVQA:minmax', ...
        'undefined input num');
    throw(ME)
end

if nargin <2 
ffmax=zeros(1,size(data,2));
ffmin=zeros(1,size(data,2));
else
    ffmax=varargin{1};
    ffmin=varargin{2};
end

for j=1:size(data,2)
    if nargin <2 
    ffmax(j)=max(data(:,j));
    ffmin(j)=min(data(:,j));
    end
    data(:,j)=(data(:,j)-ffmin(j))/(ffmax(j)-ffmin(j));
end


end

