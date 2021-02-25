function [Jflo, Jirr, h, u, r, g_flo, g_irr] = simLake( q, s_in, policy )
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


global sys_param;

% % % % For ZBH
z1 = sys_param.simulation.z1;
z2 = sys_param.simulation.z2;
z3 = sys_param.simulation.z3;
z4 = sys_param.simulation.z4;

alpha = sys_param.simulation.alpha;
beta = sys_param.simulation.beta;
gamma = sys_param.simulation.gamma;

% Simulation setting
q_sim = [q];
H = length(q_sim) - 1;

% Initialization
[h,r,u] = deal(nan(size(q_sim)));
[s] = [ deal(nan(size(q_sim)));nan ];

% Start simulation
s(1) = s_in;

for t = 1: H
  
  % Compute release decision
  
  switch (sys_param.algorithm.name)
      
    case 'ddp'      
      discr_s = sys_param.algorithm.discr_s;
      discr_q = sys_param.algorithm.discr_q;
      discr_u = sys_param.algorithm.discr_u;
      
      min_rel = sys_param.algorithm.min_rel;
      max_rel = sys_param.algorithm.max_rel;
      
      w = sys_param.simulation.w;
     
      [ ~ , idx_q ] = min( abs( discr_q - q_sim(t) ) );
      
      % Minimum and maximum release for current storage and inflow:
      sys_param.simulation.vv = interp1qr( discr_s , min_rel(: , idx_q) , s(t) );
      sys_param.simulation.VV = interp1qr( discr_s , max_rel(: , idx_q) , s(t) );
      
      [ ~ , idx_u ] = Bellman_ddp( policy.H(:,t+1) , s(t) , q_sim(t), t );
      
      % Choose one decision value (idx_u can return multiple equivalent
      % decisions)
      uu = extractor_ref( idx_u , discr_u , w(t) );
      
    case 'sdp'
      discr_s = sys_param.algorithm.discr_s;
      discr_q = sys_param.algorithm.discr_q;
      discr_u = sys_param.algorithm.discr_u;
      
      min_rel = sys_param.algorithm.min_rel;
      max_rel = sys_param.algorithm.max_rel;
      
      w = sys_param.simulation.w;
      
      % Minimum and maximum release for current storage and inflow:
      [ ~ , idx_q ] = min( abs( discr_q - q_sim(t) ) );
      
      v =interp1qr( discr_s , min_rel( : , idx_q ) , s(t) );
      sys_param.simulation.vv = repmat( v, 1, length(discr_q) );
      
      V = interp1qr( discr_s , max_rel( : , idx_q ) , s(t) );
      sys_param.simulation.VV = repmat( V, 1, length(discr_q) );
      [ ~, idx_u ] = Bellman_sdp( policy.H , s(t) );

      % Choose one decision value (idx_u can return multiple equivalent
      % decisions)
      uu = extractor_ref( idx_u , discr_u , w(t) );
      
    case 'emodps'
      policy_class = sys_param.algorithm.policy_class;
      
      if strcmp(policy_class, 'stdOP')
        uu = std_operating_policy(s(t), policy, t);
      else
        error(['Policy class not defined.',...
          ' Please check or modify this function to use a different',...
          ' class of parameterized functions']);
      end

    otherwise
      uu = nan;
      
  end
% u(t) = uu;

%%% FOR ZBH use the following lines instead of the above line in line 117
 if s(t)< z4(t)
      u(t) = gamma(t)*uu;
  else if s(t) < z3(t)
          u(t) = beta(t)*uu;
      else if s(t) < z2(t)
              u(t) = alpha(t)*uu;
          else if s(t) < z1(t)
                  u(t) = uu;
              else u(t) = uu;
              end
          end
      end
  end

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

Jflo = mean(g_flo(1:end));
Jirr = mean(g_irr(1:end));
