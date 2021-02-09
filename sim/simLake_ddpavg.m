function [Jflo_avg, Jirr_avg, h, u, r, g_flo, g_irr] = simLake_ddpavg( q, s_in, rr )
% SIMLAKE Simulation routine that return the final performance of flooding
%         and irrigation, as well as the a number of time-series variables
%         related to the lake dynamics. 
%
% [Jflo, Jirr, h, u, r, g_flo, g_irr] = SIMLAKE( q, h_in, policy )
% 
% Output:
%       Jflo - final performance for flooding objective. ([cm])
%       Jirr - final performance for irrigation objective. ([m3/s])
%          h - time-series of lake level. ([cm])
%          u - time-series of release decision. ([m3/s])
%          r - time-series of actual release. ([m3/s])
%      g_flo - time-series of step cost of flooding. ([cm])
%      g_irr - time-series of step cost of irrigation. ([cm3/s])
% 
% Input:
%          q - inflow time series. ([m3/s])
%       h_in - initial lake level. ([m])
%     policy - structure variable containing the policy related parameters.
%
% See also LEVELTOSTORAGE, EXTRACTOR_REF, INTERP_LIN_SCALAR, HOURLY_INTEG,
%     STORAGETOLEVEL, IMMEDIATE_COSTS, STD_OPERATING_POLICY, BELLMAN_DDP,
%     BELLMAN_SDP, PREDICTWITHANENSEMBLE_R, READQ, REOPT_SSDP

% Simulation setting
q_sim = [q];
H = length(q_sim) - 1;

% Initialization
[h,r,u] = deal(nan(size(q_sim)));
[s] = [ deal(nan(size(q_sim)));nan ];

% Start simulation
s(1) = s_in;

for t = 1: H
  
u(t) = rr(t);

  % Hourly integration of mass-balance equation
  [s(t+1), r(t)] = massBalance( s(t), u(t), q_sim(t) );
 % h(t+1) = storageToLevel(s(t+1));
end

% Calculate objectives (daily average of immediate costs)
%[g_flo, g_irr] = immediate_costs(s(2:end), r(2:end), t);
g_flo = deal(nan(size(q_sim)));
g_irr = deal(nan(size(q_sim)));
 
for tt = 1:size(q_sim)
    [g_flo(tt), g_irr(tt)] = immediate_costs(s(tt+1), r(tt), tt);
end

Jflo_avg = mean(g_flo(1:end));
Jirr_avg = mean(g_irr(1:end));
