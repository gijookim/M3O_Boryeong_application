function [JJ, PS] = run_emodps(policy_class, moea_param)
%RUN_EMODPS calculate an approximate pareto front using Evolutionary
%           Multi-Objective Direct Policy Search.
%
% function [JJ, PS] = RUN_EMODPS(policy_class, moea)
%
% Designs a Pareto approximate set of operating policies via Evolutionary
% Multi-Objective Direct Policy Search (Giuliani et al., 2016), where the
% policy is assumed to be of a certain function faimly 'policy_class' (e.g,
% piecewise linear) and shall be parameterized accordingly, where the
% state-of the art multi-objective evolutionary algorithm (i.e.,
% NSGAII) can be used to find the optimal parameter sets that best describe 
% the Pareto Optimal solutions. In principle, the performance of EMODPS is
% subjected to the 'shape' of policy class and the MOEA algorithm. See 
% < M. Giuliani,et al 2016 > for more information.
%
% Output:
%       JJ - values of the objective in the best Pareto front approximation
%       PS - values of the parameter of the policies in the Pareto front
%
% Input:
%  policy_class - type of policy. Currently, possible values are:
%                'stdOP': Standard Operating Policy, see
%                 std_operating_policy.m for references and other 
%                 information.
%          moea - configuration of evolutionary algorithm. Currently, 
%                 possible values are:
% 
%             		'NSGAII': Non Sorting Genetic Algorithm II, see
%                           lib/NSGA2/nsga_2.m for additional details.
%
% See also EVALUATE_OBJECTIVE

global sys_param;

% -- POLICY SETTING --
if strcmp(policy_class,'stdOP')
  sys_param.algorithm.policy_class = policy_class ;
else
  error(['Policy class not defined. Please check or modify',...
    ' this function to use a different class of parameterized functions']);
end

% % -- OPTIMIZATION SETTING -- piecewise linear RBF
% M = 2 ;     % objective number
% V = 4 ;     % decision variables number (policy parameters)
% min_range = [ -10 -10 10*pi -10*pi ] ;
% max_range = [ 10 10 -10*pi -10*pi ] ;

% % -- OPTIMIZATION SETTING -- root RBF
% M = 2 ;     % objective number
% V = 5 ;     % decision variables number (policy parameters)
% min_range = [ 0 -10 -10 0 0 ] ;
% max_range = [ 1  10  10 10 10 ] ;

% -- OPTIMIZATION SETTING -- gaussian RBF
M = 2 ;     % objective number
V = 3 ;     % decision variables number (policy parameters)
min_range = [ -10 0 -1] ;
max_range = [  10 10 1] ;


% -- RUN OPTIMIZATION --
if strcmp(moea_param.name, 'NSGAII')
  % The algorithm returns the initial (ch0) and the final population (chF)
  [ch0, chF] = nsga_2(moea_param.pop,moea_param.gen,M,V,min_range,max_range);
  
  % Save Pareto approximate set (PS) and front (JJ)
  PS = chF(:, 1:V);
  JJ = chF(:, V+1:V+M);
else
  error(['MOEA not defined. Please check or modify this function',...
    'to run a different optimization algorithm.']);
end

end

% This code has been written by Matteo Giuliani (matteo.giuliani@polimi.it)
