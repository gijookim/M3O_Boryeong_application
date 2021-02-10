%% Multi-Objective Optimal Operation (M3O) Toolbox: Boryeong Reservoir Application TEST CASE
%
% This toolbox purpose is to design the optimal operations of multipurpose 
% water reservoir system, in an attempt to close the gap between research 
% studies and real-world applications. The toolbox, called Multi-Objective 
% Optimal Operations (M3O), allows users to design Pareto optimal (or 
% approximate) operating policies through several alternative state-of-the-art
% methods. The application of all these techniques on the same case study 
% contributes a step-forward with respect to traditional literature review 
% papers as the availability of the source code, along with the possibility 
% of cross-comparing the results on the same problem, allows a better 
% understanding of pros and cons of each approach. At the same time, the
% modular structure of M3O allows experienced users to easily customize, and
% possibly further develop, the implemented code according to their specific
% requirements.

clear all;
clc

global sys_param;

addpath(genpath('sim'))
addpath(genpath('lib'))

%% Configure general system parameters--for ALL periods (1998-2019)

sys_param.simulation.q     = load('monthly_inflow_9819.txt','-ascii') ;      % Actual Inflow (Oct-98 to Sep-19, 21Yrs)
sys_param.simulation.q_mavg= load('monthly_avg_inflow_9819.txt','-ascii') ;  % Monthly Avg Inflow (OctAvg to SepAvg replicated 21 times)
sys_param.simulation.q_aavg= load('avg_inflow_9819.txt','-ascii') ;          % ALL Avg Inflow (Annual Avg replicated for 252 Months)
sys_param.simulation.s_in  = 82.601 ;                                        % 1998-09-30 storage in 10^6 m3
sys_param.simulation.w     = load('monthly_avg_demand_9819.txt','-ascii') ;    % demand in AVG (m3/s)
sys_param.simulation.hFLO  = load('monthly_avg_zone2_9819.txt','-ascii') ;     % Target Storage in AVG (10^6 m3)
sys_param.simulation.r_min = 0;
sys_param.simulation.r_max = 1500;
sys_param.simulation.s_min = 8.18;
sys_param.simulation.s_max = 106.4;

sys_param.simulation.delta = 60*60*24*30/10^6; %for monthly optimization & simulation

[sys_param.simulation.vv, sys_param.simulation.VV] = deal(0); 

%% For K-fold Cross Validation (K=1,2,3,4)
q_ALL = load('monthly_inflow_9919.txt','-ascii');
w_ALL = load('monthly_avg_demand_9919.txt','-ascii') ;    % demand in AVG (m3/s)
star_ALL = load('monthly_avg_zone2_9919.txt','-ascii') ;     % Target Storage in AVG (10^6 m3)

% Should only run one of the 'k's (k=1,2,3,or4)
% k=1
sys_param.simulation.q     = q_ALL(61:240);
sys_param.simulation.q_aavg= repelem(mean(q_ALL(61:240)),60)' ;
sys_param.simulation.q_mavg= load('monthly_avg_k1.txt','-ascii') ; 
sys_param.simulation.q_evl = q_ALL(1:60);
sys_param.simulation.s_in  = 99.597 ;  
sys_param.simulation.w     = w_ALL(61:240);
sys_param.simulation.hFLO  = star_ALL(61:240); 
sys_param.simulation.r_min = 0;
sys_param.simulation.r_max = 1500;
sys_param.simulation.s_min = 8.18;
sys_param.simulation.s_max = 106.4;

sys_param.simulation.delta = 60*60*24*30/10^6; %for monthly optimization & simulation
[sys_param.simulation.vv, sys_param.simulation.VV] = deal(0); 

% k=2
sys_param.simulation.q     = [q_ALL(1:60);q_ALL(121:240)];
sys_param.simulation.q_aavg= repelem(mean(sys_param.simulation.q),60)' ; 
sys_param.simulation.q_mavg= load('monthly_avg_k2.txt','-ascii') ; 
sys_param.simulation.q_evl = q_ALL(61:120);
sys_param.simulation.s_in  = 89.978 ;  
sys_param.simulation.w     = [w_ALL(1:60);w_ALL(121:240)];
sys_param.simulation.hFLO  = [star_ALL(1:60);star_ALL(121:240)]; 
sys_param.simulation.r_min = 0;
sys_param.simulation.r_max = 1500;
sys_param.simulation.s_min = 8.18;
sys_param.simulation.s_max = 106.4;

sys_param.simulation.delta = 60*60*24*30/10^6; %for monthly optimization & simulation
[sys_param.simulation.vv, sys_param.simulation.VV] = deal(0); 

% k=3
sys_param.simulation.q     = [q_ALL(1:120);q_ALL(181:240)];
sys_param.simulation.q_aavg= repelem(mean(sys_param.simulation.q),60)' ; 
sys_param.simulation.q_mavg= load('monthly_avg_k3.txt','-ascii') ; 
sys_param.simulation.q_evl = q_ALL(121:180);
sys_param.simulation.s_in  = 64.365 ;  
sys_param.simulation.w     = [w_ALL(1:120);w_ALL(181:240)];
sys_param.simulation.hFLO  = [star_ALL(1:120);star_ALL(181:240)]; 
sys_param.simulation.r_min = 0;
sys_param.simulation.r_max = 1500;
sys_param.simulation.s_min = 8.18;
sys_param.simulation.s_max = 106.4;

sys_param.simulation.delta = 60*60*24*30/10^6; %for monthly optimization & simulation
[sys_param.simulation.vv, sys_param.simulation.VV] = deal(0); 

% k=4
sys_param.simulation.q     = q_ALL(1:180);
sys_param.simulation.q_aavg= repelem(mean(sys_param.simulation.q),60)' ; 
sys_param.simulation.q_mavg= load('monthly_avg_k4.txt','-ascii') ; 
sys_param.simulation.q_evl = q_ALL(181:240);
sys_param.simulation.s_in  = 47.364 ;  
sys_param.simulation.w     = w_ALL(1:180);
sys_param.simulation.hFLO  = star_ALL(1:180); 
sys_param.simulation.r_min = 0;
sys_param.simulation.r_max = 1500;
sys_param.simulation.s_min = 8.18;
sys_param.simulation.s_max = 106.4;

%For hedging in K=4:
sys_param.simulation.z1  = load('monthly_zone1_9813.txt','-ascii') ; 
sys_param.simulation.z2  = load('monthly_zone2_9813.txt','-ascii') ;
sys_param.simulation.z3  = load('monthly_zone3_9813.txt','-ascii') ;
sys_param.simulation.z4  = load('monthly_zone4_9813.txt','-ascii') ;

sys_param.simulation.delta = 60*60*24*30/10^6; %for monthly optimization & simulation
[sys_param.simulation.vv, sys_param.simulation.VV] = deal(0); 

%% --- Run DDP (Deterministic Dynamic Programming) ---
clc
addpath('./DDP')

% Configure the parameters 
load 'grids_br.mat';

sys_param.algorithm = grids;
sys_param.algorithm.name = 'ddp';
sys_param.algorithm.Hend = 0 ; % penalty set to 0

[vv, VV] = construct_rel_matrices(grids); % compute daily minimum/maximum release matrixes
sys_param.algorithm.min_rel = vv;
sys_param.algorithm.max_rel = VV;

% weights for aggregation of objectives
%  lambda(:,1) = 1:-0.05:0;
%  lambda(:,2) = 0:0.05:1;
lambda = [1 0; .75 .25; .5 .5 ; .35 .65; .2 .8; .1 .9;  0 1];
Nalt   = size(lambda,1);
JJ_ddp = nan(Nalt,2);
Hddp   = cell(Nalt,1);

for i = 1: Nalt
  sys_param.algorithm.weights = lambda(i,:);
  [JJ_ddp(i,:), Hddp{i}] = run_ddp() ;
end

figure; plot( JJ_ddp(:,1), JJ_ddp(:,2), 'o' );
xlabel('starget-st'); ylabel('dt-rt');

%% --- Run SDP (Stochastic Dynamic Programming) ---
clc
addpath('./SDP')

% Configure the parameters 
load 'grids_br.mat';

sys_param.algorithm = grids;
sys_param.algorithm.name = 'sdp';
sys_param.algorithm.Hend = 0 ; % penalty set to 0
sys_param.algorithm.T = 1 ;    % the period is equal 1 as we assume stationary conditions

[vv, VV] = construct_rel_matrices(grids); % compute daily minimum/maximum release matrixes
sys_param.algorithm.min_rel = vv;
sys_param.algorithm.max_rel = VV;

% Estimate inflow probability density function assuming log-normal
% distribution fitting
sys_param.algorithm.q_stat = lognfit(sys_param.simulation.q);
sys_param.algorithm.gamma = 1; % set future discount factor

lambda = [1 0; .75 .25; .5 .5 ; .35 .65; .2 .8; .1 .9;  0 1];
% lambda(:,1) = 1:-0.05:0;
% lambda(:,2) = 0:0.05:1;
Nalt   = size(lambda,1);
JJ_sdp = nan(Nalt,2);
Hsdp   = cell(Nalt, 1);

for i = 1: Nalt
  sys_param.algorithm.weights = lambda(i,:);
  [JJ_sdp(i,:), Hsdp{i}] = run_sdp();
end

figure; plot( JJ_sdp(:,1), JJ_sdp(:,2), 'o' );
xlabel('starget-st'); ylabel('dt-rt'); 

%% --- Run EMODPS (Evolutionary Multi-Objective Direct Policy Search) ---
clc
addpath('./EMODPS')

% Define the parameterized class for the policy (i.e., standard operating policy)
sys_param.algorithm.name = 'emodps' ;
pClass = 'stdOP'; 

% Define MOEA and its setting (i.e., NSGAII)
moea_param.name = 'NSGAII';
moea_param.pop  = 50; % number of individuals
moea_param.gen  = 100; % number of generation

[JJ_emodps, Popt] = run_emodps(pClass, moea_param) ;

figure; plot( JJ_emodps(:,1), JJ_emodps(:,2), 'o' );
xlabel('starget-st'); ylabel('dt-rt');

%% K-fold Cross Validation for EMODPS MODELS

% --------------------------------------
% insert here your function f = f(x):
global sys_param;

q_evl= sys_param.simulation.q_evl;
s_in = sys_param.simulation.s_in;

% -- Get policy parameters --
for i = 1: 50
    policy.theta = Popt(i,:);
    [ J1(i), J2(i) ] = simLake( q_evl, s_in, policy );
end

figure; plot( J1, J2, 'o' );
JJ_emodps_evl(:,1) = J1' ; JJ_emodps_evl(:,2) = J2' ;

%% For RRV Calculation: BOTH SUPPLY & DEMAND
global sys_param;

q_evl= sys_param.simulation.q_evl;
s_in = sys_param.simulation.s_in;

for i = 1: 50
    policy.theta = Popt(i,:);
    [ Jflo_Rel(i), Jflo_Res(i), Jflo_Vul(i), Jirr_Rel(i), Jirr_Res(i), Jirr_Vul(i) ] = simLake_RRV( q_evl, s_in, policy );
end

RRV = [Jflo_Rel', Jflo_Res',Jflo_Vul', Jirr_Rel', Jirr_Res', Jirr_Vul' ];

%% For RRV Calculation: ONLY DEMAND by different water uses
global sys_param;

q_evl= sys_param.simulation.q_evl;
s_in = sys_param.simulation.s_in;

for i = 1: 50
    policy.theta = Popt(i,:);
    [ Jenv_Rel(i), Jenv_Res(i), Jenv_Vul(i), Jagr_Rel(i), Jagr_Res(i), Jagr_Vul(i), Jmni_Rel(i), Jmni_Res(i), Jmni_Vul(i) ] = simLake_RRV_demand( q_evl, s_in, policy );
end

RRV_demand = [Jenv_Rel', Jenv_Res', Jenv_Vul', Jagr_Rel', Jagr_Res', Jagr_Vul', Jmni_Rel', Jmni_Res', Jmni_Vul'];
