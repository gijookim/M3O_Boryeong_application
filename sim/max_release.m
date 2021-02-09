function V = max_release()
% MAX_RELEASE calculate the maximum release rate [m3/s]
%
% v = MAX_RELEASE(s)
%
% Output:
%       v - maximum release rate. ([m3/s])
% 
% Input:
%       s - value of storage. ([m3])
%
% See also MIN_RELEASE, STORAGETOLEVEL


%h = storageToLevel(s);
% if (h <= -0.5)
%   q = 0.0;
% elseif (h <= -0.40)
%   q = 1488.1*h + 744.05;
% else
%   q = 33.37*(h + 2.5).^2.015;
% end

V = 1500;