function s = levelToStorage(h)
% LEVELTOSTORAGE convert the water level [cm] to lake storage [m3] assuming
%                a cylindrical lake.
%
% v = LEVELTOSTORAGE(s)
%
% Output:
%       s - water storage. ([m3])
% 
% Input:
%       h - water level. ([cm])
%
% See also STORAGETOLEVEL

if (h < 50)
    s = 8.18; 
else if (h > 73.5)
        s = 106.4;
    else s = 0.1127*h^2 - 9.8795*h + 220.64;
    end
end
end