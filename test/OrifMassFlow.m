function [m] = OrifMassFlow(OrifEqArea,FldDens,PresDiff)
%OrifMassFlow Mass flow through an orifice of given eq. area, pressure
%difference and fluid density.
%   Detailed explanation goes here

m = OrifEqArea.*sqrt(2.0*FldDens.*PresDiff).*abs(PresDiff)./PresDiff;

end

