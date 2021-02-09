function v = min_release()
% MIN_RELEASE calculate the minimum release rate [m3/s]
%
% v = MIN_RELEASE(s)
%
% Output:
%       v - minimum release rate. ([m3/s])
% 
% Input:
%       s - value of storage. ([m3])
%
% See also MAX_RELEASE, STORAGETOLEVEL


% h = storageToLevel(s);
% 
% if (h <= 1.25)
%   q = 0.0;
% else
%   q = 33.37*(h + 2.5).^2.015;
% end

v = 0;