function r = std_operating_policy(s, policy, t)
%STD_OPERATING_POLICY evaluates the release decision for the current level.
%
% function r = STD_OPERATING_POLICY(h, policy)
%
% Evaluates the release decision for the current level according to the
% Standard Operating Policy (Maass et al., 1962) and value contained in the
% parameter vector. 
% 
% For the demonstration, the Standard Operating Policy
% here is a three-piecewise linear function of the level with a constant,
% fixed central piece corresponding to the delivery target, in this case
% taken equal to ''sys_param.simulation.w''. User shall define their own
% policy class, e.g., non-linear function such as radial basis functions, 
% by following the same structure of this function.
%
% Output:
%       r - release decision. Same dimension as h.
%
% Input:
%        h - scalar or vector of reservoir levels.
%   policy - a struct with a field theta that is a vector of four parameter 
%            values. Specifically:
% 
%            policy.theta(1): level at which water supply edging is stopped
%            policy.theta(2): level at which release > demand for flood
%                             protection
%            policy.theta(3): angle of the water supply edging segment
%            policy.theta(4): angle of the flood protection segment
%
% See also RUN_EMODPS

global sys_param;
w = sys_param.simulation.w;

% % -- OPTIMIZATION SETTING -- piecewise linear RBF 
% % -- Get policy parameters --
% h1 = policy.theta(1);
% h2 = policy.theta(2);
% m1 = policy.theta(3);
% m2 = policy.theta(4);
% 
% % -- Construct the policy using piecewise linear functions --
% L1 =  tan(m1) * ( s - h1 );
% L2 =  tan(m2) * ( s - h2 );
% r  = max( [ min( L1 , w(t) ) ; L2 ] );
% r( r < 0 ) = 0;

% % 
% % -- OPTIMIZATION SETTING -- root RBF 
% % -- Get policy parameters --
% w1 = policy.theta(1);
% c1 = policy.theta(2);
% c2 = policy.theta(3);
% r1 = policy.theta(4);
% r2 = policy.theta(5);
% 
% % -- Construct the policy using piecewise linear functions --
% r  = min( max( w1*abs(w(t)-(s-c1)/r1)^.5+(1-w1)*abs(w(t)-(s-c2)/r2)^.5, 0.01),1500 );
% r( r < 0 ) = 0;


%-- OPTIMIZATION SETTING -- gaussian RBF
c1 = policy.theta(1);
r1 = policy.theta(2);
w1 = policy.theta(3);

%-- Construct the policy using piecewise linear functions --
r  = min( max( w(t) - exp(-w1*((s-c1)/r1)), 0.01),1500 );
r( r < 0 ) = 0;

end