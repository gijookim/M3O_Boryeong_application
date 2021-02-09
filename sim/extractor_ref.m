function [ u, idx_u ] = extractor_ref( idx_U , discr_u , w )
% EXTRACTOR_REF retrieve a single optimal decision value.
%
% [ u, idx_u ] = EXTRACTOR_REF( idx_U , discr_u , w )
%
% EXTRACTOR_REF retrieve a single optimal decision value and the
% corresponding index from a set of potential good decisions, by choosing
% the one that minimizes the most the irrigation deficit.
%
% Output:
%         u - a singular value of optimal decision ([m3/s])
%     idx_u - index of the optimal decision within the discretized space of
%             all decision values
%
% Input:
%     idx_U - indices of equivalent optimal decisions
%   discr_u - vector of discretized decision values
%         w - reference value of water demand

u = discr_u( idx_U );

if length( idx_U ) == 1
  idx_u = idx_U;
else
  def = u - w ;
  if sum( def >= 0 )
    def( def < 0 ) = Inf; % penalize decisions that produce deficit
  end
  [ ~, idx ] = min( abs( def ) ); % find decision closest to the water demand
  u     = u( idx )   ;
  idx_u = idx_U(idx) ;
end