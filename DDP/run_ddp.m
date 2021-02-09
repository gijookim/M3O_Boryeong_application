function [JJ, HH] = run_ddp()
%RUN_DDP  Run Deterministic Dynamic programming algorithm using the
%         supplied test case
%
% [JJ, HH] = RUN_DDP()
% Deterministic dynamic programming (DDP) formulate the operating policy
% design problem as a sequential decision-making process. Specifically, the
% long-term cost of an operating policy is computed for each state by means
% of the value function:
%
%     H(x) = min G(x, u, e) + H(x1)
%
% where H() is the optimal cost-to-go function defined over a discrete grid
% of states and G() is the immediate (time separable) cost function
% associated to the transition from state x to state x1 under the decision
% u and the known disturbance value e.
%
% Output:
%       JJ - performance of multi-objective 
%       HH - optimized control policy
%
%
% See also OPT_DDP, SIMLAKE

global sys_param;

%-- Initialization --
% disturbance_opt   = sys_param.simulation.q;
disturbance_evl   = sys_param.simulation.q_evl;

% disturbance_mavg = sys_param.simulation.q_mavg;
disturbance_aavg = sys_param.simulation.q_aavg;
initial_storage = sys_param.simulation.s_in;

% %-- Run optimization --
% % For ALL Average DDP Optimization
 policy.H = opt_ddp( disturbance_aavg );
 HH = policy.H;
 [Jflo, Jirr, h, u, r, g_flo, g_irr] = simLake( disturbance_aavg, initial_storage, policy );
 [Jflo_avg, Jirr_avg] = simLake_ddpavg( disturbance_evl, initial_storage, r );
JJ(1) = Jflo_avg;
JJ(2) = Jirr_avg;

% % % % For Monthly Average DDP Optimization
%  policy.H = opt_ddp( disturbance_mavg );
%  HH = policy.H;
%  [Jflo, Jirr, h, u, r, g_flo, g_irr] = simLake( disturbance_mavg, initial_storage, policy );
%  [Jflo_avg, Jirr_avg] = simLake_ddpavg( disturbance_evl, initial_storage, r );
% JJ(1) = Jflo_avg;
% JJ(2) = Jirr_avg;

% % For Perfect Forecast DDP Optimization
% policy.H = opt_ddp( disturbance_evl );
% HH = policy.H;

% %-- Run simulation --
% [Jflo, Jirr] = simLake( disturbance_evl, initial_storage, policy );
% %[Jflo, Jirr, h, u, r, g_flo, g_irr] = simLake( disturbance_evl, initial_storage, policy );
% JJ(1) = Jflo;
% JJ(2) = Jirr;

end
