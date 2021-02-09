function [ H , idx_u ] = Bellman_ddp( H_ , s_curr , q_curr, t )
%BELLMAN_DDP Update future value function and optimal decisions for
%            Deterministic Dynamic Programming
%
%  [ H , idx_u ] = BELLMAN_DDP( H_ , s_curr , q_curr ) update the estimated
%  future value function given the previous one H_, the current state s_curr
%  and the current value of disturbance.
%
% Output:
%       H - update future value function.
%   idx_u - index of optimal decision
%
% Input:
%          H_ - future value function from previous estimation
%      s_curr - value of state variable at current stage
%      q_curr - observed trajectory of the disturbance at current stage
%
% See also OPT_SDP, BELLMAN_SDP, BELLMAN_DDP

global sys_param;

%-- Initialization --
discr_s = sys_param.algorithm.discr_s ;
discr_u = sys_param.algorithm.discr_u ;
weights = sys_param.algorithm.weights ;

VV = sys_param.simulation.VV; % max release
vv = sys_param.simulation.vv; % min release

delta = sys_param.simulation.delta;

%-- Calculate actual release contrained by min/max release rate --
R = min( VV , max( vv , discr_u ) ) ;

%==========================================================================
% Calculate the state transition; TO BE ADAPTAED ACCORDING TO
% YOUR OWN CASE STUDY
s_next = s_curr + delta* ( q_curr - R );
r_act = (1/delta) * (s_curr - s_next) + q_curr;
s_act = s_curr + delta * (q_curr - r_act);

%==========================================================================
% Compute immediate costs and aggregated one; TO BE ADAPTAED ACCORDING TO
% YOUR OWN CASE STUDY
[g1, g2] = immediate_costs( s_act, r_act, t ) ;
G = (g1*weights(1) + g2*weights(2))';

%-- Compute cost-to-go given by Bellman function --
% apply linear interpolation to update the Bellman value H_
H_ = interp1qr( discr_s , H_ , s_next );

%-- Compute resolution of Bellman value function --
Q     = G + H_;
H     = min(Q);
sens  = eps;
idx_u = find( Q <= H + sens );

end
