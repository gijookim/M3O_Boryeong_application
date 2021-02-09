function [ H , idx_u ] = Bellman_sdp( H_ , s_curr )
%BELLMAN_SDP Update future value function and optimal decisions for
%            Stochastic Dynamic Programming
%
%  [ H , idx_u ] = BELLMAN_SDP( H_ , s_curr ) update the estimated future
%  value function given the previous one H_ and the current state s_curr.
%
% Output:
%       H - update future value function.
%   idx_u - index of optimal decision
%
% Input:
%       H_ - future value function from previous estimation
%   s_curr - value of state variable at current step
%
% See also OPT_SDP, BELLMAN_SDP, BELLMAN_DDP


global sys_param;

%-- Initialization --
discr_s = sys_param.algorithm.discr_s;
discr_u = sys_param.algorithm.discr_u;
discr_q = sys_param.algorithm.discr_q;

n_u = length(sys_param.algorithm.discr_u);
n_q = length(sys_param.algorithm.discr_q);

weights = sys_param.algorithm.weights;
gamma   = sys_param.algorithm.gamma;

VV = repmat(sys_param.simulation.VV', 1 , n_u);
vv = repmat(sys_param.simulation.vv', 1 , n_u);

delta = sys_param.simulation.delta;

mi_q    = sys_param.algorithm.q_stat(1); % mean of log(disturbance)
sigma_q = sys_param.algorithm.q_stat(2); % std of log(disturbance)

%-- Calculate actual release contrained by min/max release rate --
discr_u = repmat(discr_u, n_q, 1);
R = min( VV , max( vv , discr_u ) );

%==========================================================================
% Calculate the state transition; TO BE ADAPTAED ACCORDING TO
% YOUR OWN CASE STUDY

qq = repmat( discr_q', 1, n_u );
%s_next = s_curr + delta*( qq - R );

s_next = min(discr_s(55)-0.01, max(s_curr + delta* ( qq - R ), discr_s(1)));
r_act = (1/delta) * (s_curr - s_next) + qq;
s_act = min(discr_s(55)-0.01, max(s_curr + delta * (qq - r_act), discr_s(1)));

%==========================================================================
% Compute immediate costs and aggregated one; TO BE ADAPTAED ACCORDING TO
% YOUR OWN CASE STUDY
%[g1, g2] = immediate_costs( s_next, R, t ) ;
[g1, g2] = immediate_costs_sdp( s_act, r_act ) ;

G = g1*weights(1) + g2*weights(2);

%-- Compute cost-to-go given by Bellman function --
H_ = interp1qr( discr_s , H_ , s_act(:) ) ;
H_ = reshape( H_, n_q, n_u )         ;

%-- Compute resolution of Bellman value function --
% compute the probability of occourence of inflow that falls within the
% each bin of descritized inflow level
cdf_q      = logncdf( discr_q , mi_q , sigma_q );  
p_q        = diff(cdf_q);                          
p_diff_ini = 1-sum(p_q);                           
p_diff     = [ p_diff_ini ; p_q'];                 

Q     = (G + gamma.*H_)'*p_diff ;
H     = min(Q)                  ;
sens  = eps                     ;
idx_u = find( Q <= H + sens )   ;

end