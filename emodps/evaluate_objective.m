function f = evaluate_objective(x, M, V)
%EVALUATE_OBJECTIVE evaluate the objective functions values
%
% function f = EVALUATE_OBJECTIVE(x, M, V)
%
% Function to evaluate the objective functions for the given input vector
% x. x is an array of decision variables and f(1), f(2), etc are the
% objective functions. The algorithm always minimizes the objective
% function hence if you would like to maximize the function then multiply
% the function by negative one. M is the numebr of objective functions and
% V is the number of decision variables.
%
% This function has basically to be written by the user who defines his/her
% own objective function. Make sure that the M and V matches your initial
% user input.
%
% Outputs:
%     f - array containing the performance of each objective ;
%
% Inputs:
%     x - parameters to be optimzied. The length of x shall equal to V.
%     M - the number of objective
%     V - the number of input variable
%
% See also RUN_EMODPS

x = x(1:V);
x = x(:);
if ( length(x) ~= V )
  error(['The number of decision variables does not match' ,...
    ' you previous input. Kindly check your objective function'])
end

% --------------------------------------
% insert here your function f = f(x):
global sys_param;

q    = sys_param.simulation.q;
s_in = sys_param.simulation.s_in;

% -- Get policy parameters --
policy.theta = x;

% -- Run simulation to collect the results --
[ J1, J2 ] = simLake( q, s_in, policy );
f = [J1, J2];
% --------------------------------------

% Check for error
if ( length(f) ~= M )
  error(['Incorrect number of outptu objectives. Expecting to solve' ,...
    ' %d objectives formulation. Please check your objective function again'],...
    M );
end