function [s1,r1] = massBalance( s, u, q )
% MASSBALANCE simulate the reservoir dynamics over 24 hours interval.
%
% v = MASSBALANCE( s, u, q )
%
% Decision and inflow are considered constant over all the simulation steps,
% although actual release is calculated dynamically following the lake
% evolution.
%
% Output:
%      s1 - final storage. ([m3])
%      r1 - average release over the 24 hours. ([m3/s])
%
% Input:
%       s - initial storage. ([m3])
%       u - release decision ([m3/s])
%       q - inflow rate ([m3/s])
%
% See also MIN_RELEASE, MAX_RELEASE

global sys_param;

delta = sys_param.simulation.delta;
s_min = sys_param.simulation.s_min;
s_max = sys_param.simulation.s_max;

s1_the = min(s_max, max(s + delta * (q - min(max_release() , max(min_release() , u))), s_min ));
r1 = (1/delta) * (s - s1_the) + q; 

%Actual s1
s1 = s + delta * (q - r1);

% HH = 24;
% delta = 3600;
% s_ = nan(HH+1,1);
% r_ = nan(HH+1,1);
% 
% s_(1) = s;
% for i=1:HH
%   qm = min_release(s_(i));
%   qM = max_release(s_(i));
%   r_(i+1) = min( qM , max( qm , u ) );
%   s_(i+1) = s_(i) + delta*( q - r_(i+1) );
% end
% 
% s1 = s_(HH);
% r1 = mean(r_(2:end));
