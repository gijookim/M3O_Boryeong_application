function [g_flo, g_irr] = immediate_costs(st, rt, t)
% IMMEDIATE_COSTS calculate the step costs for flooding and irrigation 
%                 objectives, respectively.
%
% [g_flo, g_irr] = IMMEDIATE_COSTS(ht, rt)
%
% Output:
%       g_flo - step cost for flood. ([cm])
%       g_irr - step cost for irrigation. ([m3/s])
% 
% Input:
%       ht - lake level at time step t. ([m])
%       rt - water release at time step t. ([m3/s])

global sys_param;

hFLO = sys_param.simulation.hFLO;
w = sys_param.simulation.w;

g_flo = max( ((hFLO(t) - st)/hFLO(t)) , 0 ); % exceedance of water level above the flooding threshold
g_irr = max( ((w(t) - rt)/w(t)) , 0 ); % deficit between the demand and supply