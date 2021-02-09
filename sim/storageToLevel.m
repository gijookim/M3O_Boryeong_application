function h = storageToLevel(s)
% STORAGETOLEVEL convert the lake storage [m3] to the water level [cm].
%
% h = STORAGETOLEVEL(s)
%
% Output:
%       h - simulated water level. Same dimensions as s. ([cm])
% 
% Input:
%       s - value of storage. Vector. ([m3])
%
% See also LEVELTOSTORAGE

if (s < 8.18)
    h = 50; 
else if (s > 106.4) 
        h = 74;
    else
        h = -0.0015*s^2 + 0.4003*s + 47.877;
    end
end
end