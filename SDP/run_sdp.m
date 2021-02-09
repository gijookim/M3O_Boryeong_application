function [JJ, HH] = run_sdp()
%RUN_SDP  Run Stochastic Dynamic Programming algorithm using the supplied
% test case
%
% [JJ, HH] = RUN_SDP()
% Stochastic dynamic programming (DDP) formulate the operating policy design
% problem as a sequential decision-making process. Specifically, the expected 
% long-term cost of an operating policy is computed for each state by means of
% the value function:
%
%     H(x) = min E[G(x, u, e) + gamma*H(x1)]
%
% where H() is the optimal cost-to-go function defined over a discrete grid of
% states and G() is the immediate (time separable) cost function associated to
% the transition from state x to state x1 under the decision u and E[] 
% represents the expected value over the stochastic disturbances e. 
%
% Output:
%       JJ - performance of multi-objective 
%       HH - optimized control policy
%
%
% See also OPT_SDP, SIMLAKE


global sys_param;

%-- Initialization --
q_evl    = sys_param.simulation.q_evl;
s_in = sys_param.simulation.s_in;

tol = -1;    % accuracy level for termination 
max_it = 100; % maximum iteration for termination 

%-- Run optimization --
policy.H = opt_sdp( tol, max_it );
HH = policy.H;

%-- Run simulation --
[Jflo, Jirr] = simLake( q_evl, s_in, policy );
JJ(1) = Jflo;
JJ(2) = Jirr;

end